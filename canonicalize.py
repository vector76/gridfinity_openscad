# Parts copied from nophead's canonlicalizer
import sys
import struct

class Vertex:
    def __init__(self, x, y, z):
        self.x, self.y, self.z = x, y, z
        self.key = (float(x), float(y), float(z))

class Normal:
    def __init__(self, dx, dy, dz):
        self.dx, self.dy, self.dz = dx, dy, dz

class Facet:
    def __init__(self, normal, v1, v2, v3):
        self.normal = normal
        if v1.key < v2.key:
            if v1.key < v3.key:
                self.vertices = (v1, v2, v3)    #v1 is the smallest
            else:
                self.vertices = (v3, v1, v2)    #v3 is the smallest
        else:
            if v2.key < v3.key:
                self.vertices = (v2, v3, v1)    #v2 is the smallest
            else:
                self.vertices = (v3, v1, v2)    #v3 is the smallest

    def key(self):
        return (self.vertices[0].x, self.vertices[0].y, self.vertices[0].z,
                self.vertices[1].x, self.vertices[1].y, self.vertices[1].z,
                self.vertices[2].x, self.vertices[2].y, self.vertices[2].z)

    def pack(self):
        facet_format = '<ffffffffffffH'
        return struct.pack(facet_format, self.normal.dx, self.normal.dy, self.normal.dz,
                self.vertices[0].x, self.vertices[0].y, self.vertices[0].z,                    
                self.vertices[1].x, self.vertices[1].y, self.vertices[1].z,
                self.vertices[2].x, self.vertices[2].y, self.vertices[2].z, 0)

class BinSTL:
    def __init__(self, fname):
        self.facets = []
        with open(fname, mode='rb') as file: # b is important -> binary
            fileContent = file.read()

        self.header = fileContent[:80]
            
        # expected number of facets
        self.expected_facets = struct.unpack("<I", fileContent[80:84])

        # 
        facet_format = '<ffffffffffffH'
        for facet in struct.iter_unpack(facet_format, fileContent[84:]):
            # facet should be a 13-tuple
            norm = Normal(*facet[0:3])
            v1 = Vertex(*facet[3:6])
            v2 = Vertex(*facet[6:9])
            v3 = Vertex(*facet[9:12])
            self.facets.append(Facet(norm, v1, v2, v3))

        if len(self.facets) != self.expected_facets[0]:
            print("facets: ", len(self.facets))
            print("expected: ", self.expected_facets)
            raise Exception("not expected number of facets")
            
    def write(self, fname):
        with open(fname, mode='wb') as file:
            file.write(self.header)
            file.write(struct.pack('<I', len(self.facets)))
            for facet in self.facets:
                file.write(facet.pack())

def canonicalize(input, output):
    stl = BinSTL(input)
    stl.facets.sort(key = Facet.key)
    stl.write(output)

if __name__ == '__main__':
    if len(sys.argv) == 2:
        canonicalize(sys.argv[1], sys.argv[1])
    elif len(sys.argv) == 3:
        canonicalize(sys.argv[1], sys.argv[2])
    else:
        print("usage: canonicalize file [ output ]")
        sys.exit(1)