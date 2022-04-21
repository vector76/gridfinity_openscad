// include instead of use, so we get the pitch
include <gridfinity_modules.scad>

module frame_plain(num_x, num_y, extra_down=0) {
  ht = extra_down > 0 ? 4.4 : 5;
  corner_radius = 3.75;
  corner_position = gridfinity_pitch/2-corner_radius;
  difference() {
    hull() cornercopy(corner_position, num_x, num_y) 
    translate([0, 0, -extra_down]) cylinder(r=corner_radius, h=ht+extra_down);
    translate([0, 0, -0.01]) render() gridcopy(num_x, num_y) pad_oversize(margins=1);
  }
}

translate([gridfinity_pitch/2, gridfinity_pitch/2, 0]) frame_plain(4, 1);
ear_hole_x = 182.5; // distance between existing screw holes on FLSUN q5.
ear_hole_y = 7; // distance of screw hole from the front panel.
from_ends = (ear_hole_x - gridfinity_pitch*4) / 2;
cube_z = 4.4; // ht from above.
M4_d = 4.2; // diameter needed for an M4 bolt.

for (i = [0,1]) {
    x = i * ear_hole_x - from_ends;
    difference() {
        hull() {
            translate([x, ear_hole_y, 0]) cylinder(h=cube_z, d=M4_d*2, $fn=20);
            translate([x - from_ends * i, ear_hole_y - M4_d, 0]) cube([from_ends, M4_d*2, cube_z]);
            }
        translate([x, ear_hole_y, -0.01]) cylinder(h=cube_z + 0.02, d=M4_d, $fn=20);
    }
}

