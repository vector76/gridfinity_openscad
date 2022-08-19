include <modules/gridfinity_modules.scad>

// X dimension in grid units
default_length = 2;
// Y dimension in grid units
default_width = 1;
// Z dimension (multiples of 7mm)
default_height = 3;// [2, 3, 4, 5, 6, 7]
// X dimension subdivisions
default_chambers = 1;

// Include overhang for labeling
default_withLabel = false;
// Include larger corner fillet
default_fingerslide = true;

// Set magnet diameter and depth to 0 to print without magnet holes
// (Zack's design uses magnet diameter of 6.5)
default_magnet_diameter = 0;  // .1
// (Zack's design uses depth of 6)
default_screw_depth = 0;

// Minimum thickness above cutouts in base (Zack's design is effectively 1.2)
default_floor_thickness = 0.7;


basic_cup(
  num_x=default_length,
  num_y=default_width,
  num_z=default_height,
  chambers=default_chambers,
  withLabel=default_withLabel,
  magnet_diameter=default_magnet_diameter,
  screw_depth=default_screw_depth,
  floor_thickness=default_floor_thickness
);


module basic_cup(
  num_x=2,
  num_y=1,
  num_z=2,
  chambers=1,
  withLabel=false,
  fingerslide=true,
  magnet_diameter=0,
  screw_depth=0,
  floor_thickness=0.7
  ) {
  difference() {
    grid_block(num_x, num_y, num_z, magnet_diameter, screw_depth);
    color("red") partitioned_cavity(num_x, num_y, num_z, chambers, withLabel, fingerslide, magnet_diameter, screw_depth, floor_thickness);
  }
}


module partitioned_cavity(num_x=2, num_y=1, num_z=2, chambers=2, withLabel=false, fingerslide=true, magnet_diameter=0, screw_depth=0, floor_thickness=0.7) {
  // cavity with removed segments so that we leave dividing walls behind
  gp = gridfinity_pitch;
  outer_wall_th = 1.8;  // cavity is this far away from the 42mm 'ideal' block
  inner_wall_th =1.2;
    
  bar_d = 1.2;
  zpoint = gridfinity_zpitch*num_z;
  
  yz = [[ (num_y-0.5)*gridfinity_pitch-14, zpoint-bar_d/2 ],
    [ (num_y-0.5)*gridfinity_pitch, zpoint-bar_d/2 ],
    [ (num_y-0.5)*gridfinity_pitch, zpoint-bar_d/2-10.18 ]
  ];
  
  cavity_xsize = gp*num_x-2*outer_wall_th;
  chamber_pitch = (cavity_xsize+inner_wall_th)/chambers;  // period of repeating walls

  difference() {
    basic_cavity(num_x, num_y, num_z, fingerslide, magnet_diameter, screw_depth, floor_thickness);
    
    if (chambers >= 2) {
      for (i=[1:chambers-1]) {
        translate([-gp/2+outer_wall_th-inner_wall_th+i*chamber_pitch, -gp/2, 0])
        cube([inner_wall_th, gp*num_y, gridfinity_zpitch*(num_z+1)]);
      }
    }
    // this is the label
    if (withLabel) {
      hull() for (i=[0,1, 2])
      translate([-gridfinity_pitch/2, yz[i][0], yz[i][1]])
      rotate([0, 90, 0]) cylinder(d=bar_d, h=num_x*gridfinity_pitch, $fn=24);
    }
  }
}


module basic_cavity(num_x=2, num_y=1, num_z=2, fingerslide=true, magnet_diameter=0, screw_depth=0, floor_thickness=0.7) {
  eps = 0.1;
  q = 1.65;
  q2 = 2.15;
  zpoint = gridfinity_zpitch*num_z-1.2;
  facets = 13;
  mag_ht = magnet_diameter > 0 ? 2.4: 0;
  m3_ht = screw_depth;
  part_ht = 5;  // height of partition between cells
  
  floorht = max(mag_ht, m3_ht, part_ht) + floor_thickness;
  
  difference() {
    union() {
      // cut downward from base
      hull() cornercopy(17, num_x, num_y) {
        translate([0, 0, zpoint-eps]) cylinder(d=2.3, h=1.2+2*eps, $fn=24);
      }
      
      hull() cornercopy(17, num_x, num_y) {
        // create bevels below the lip
        translate([0, 0, zpoint-0.1]) cylinder(d=2.3, h=0.1, $fn=24);
        translate([0, 0, zpoint-q-q2]) cylinder(d=2.3+2*q, h=q2, $fn=32);
        // create rounded bottom of bowl (8.5 is high enough to not expose gaps)
        translate([0, 0, 2.3/2+q+floorht]) sphere(d=2.3+2*q, $fn=32);
      }
    }
    
    // cut away from the negative to leave behind wall to make it easier to remove piece
    pivot_z = 13.6-0.45+floorht-5;
    pivot_y = -12+2;
    
    // rounded inside bottom
    if(fingerslide){
    for (ai=[0:facets-1]) translate([0, pivot_y, pivot_z])
      rotate([90*ai/(facets-1), 0, 0]) translate([0, -pivot_y, -pivot_z])
      translate([-gridfinity_pitch/2, -10-17-1.15, 0]) 
      cube([gridfinity_pitch*num_x, 10, gridfinity_zpitch*num_z+5]);
    }
  }
}