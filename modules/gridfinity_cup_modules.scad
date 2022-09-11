include <gridfinity_modules.scad>

// X dimension subdivisions
default_chambers = 1;
// Include overhang for labeling
default_withLabel = false;
// Width of the label in number of units
// positive numbers are measured from the 0 end
// negative numbers are measured from the far end
default_labelWidth = "full";
// Include larger corner fillet
default_fingerslide = true;
// Set magnet diameter and depth to 0 to print without magnet holes
// (Zack's design uses magnet diameter of 6.5)
default_magnet_diameter = 6.5;  // .1
// (Zack's design uses depth of 6)
default_screw_depth = 6;
// Minimum thickness above cutouts in base (Zack's design is effectively 1.2)
default_floor_thickness = 1.2;
// Thickness of outer walls (Zack's design is 0.95 mm)
default_wall_thickness = 0.95;


basic_cup(
  num_x=2,
  num_y=1,
  num_z=3,
  chambers=default_chambers,
  withLabel=default_withLabel,
  labelWidth=default_labelWidth,
  magnet_diameter=default_magnet_diameter,
  screw_depth=default_screw_depth,
  floor_thickness=default_floor_thickness,
  wall_thickness=default_wall_thickness
);


// It's recommended that all parameters other than x, y, z size should be specified by keyword 
// and not by position.  The number of parameters makes positional parameters error prone, and
// additional parameters may be added over time and break things.
module basic_cup(
  num_x,
  num_y,
  num_z,
  chambers=default_chambers,
  withLabel=default_withLabel,
  labelWidth=default_labelWidth,
  fingerslide=default_fingerslide,
  magnet_diameter=default_magnet_diameter,
  screw_depth=default_screw_depth,
  floor_thickness=default_floor_thickness,
  wall_thickness=default_wall_thickness
  ) {
  difference() {
    grid_block(num_x, num_y, num_z, magnet_diameter, screw_depth);
    color("red") partitioned_cavity(num_x, num_y, num_z, chambers=chambers, withLabel=withLabel,
    labelWidth=labelWidth, fingerslide=fingerslide, magnet_diameter=magnet_diameter, 
    screw_depth=screw_depth, floor_thickness=floor_thickness, wall_thickness=wall_thickness);
  }
}


module partitioned_cavity(num_x, num_y, num_z, chambers=default_chambers, withLabel=default_withLabel, 
    labelWidth=default_labelWidth, fingerslide=default_fingerslide, 
    magnet_diameter=default_magnet_diameter, screw_depth=default_screw_depth, 
    floor_thickness=default_floor_thickness, wall_thickness=default_wall_thickness) {
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
    basic_cavity(num_x, num_y, num_z, fingerslide=fingerslide, magnet_diameter=magnet_diameter,
    screw_depth=screw_depth, floor_thickness=floor_thickness, wall_thickness=wall_thickness);
    
    if (chambers >= 2) {
      for (i=[1:chambers-1]) {
        translate([-gp/2+outer_wall_th-inner_wall_th+i*chamber_pitch, -gp/2, 0])
        cube([inner_wall_th, gp*num_y, gridfinity_zpitch*(num_z+1)]);
      }
    }
    // this is the label
    if (withLabel) {
      label_num_x = labelWidth == "full" ? num_x : labelWidth;
      label_pos_x = label_num_x >= 0 ? 0 : num_x + label_num_x;
      hull() for (i=[0,1, 2])
      translate([(-gridfinity_pitch/2) + (label_pos_x * gridfinity_pitch), yz[i][0], yz[i][1]])
      #rotate([0, 90, 0]) cylinder(d=bar_d, h=abs(label_num_x)*gridfinity_pitch, $fn=24);
    }
  }
}


module basic_cavity(num_x, num_y, num_z, fingerslide=default_fingerslide, 
    magnet_diameter=default_magnet_diameter, screw_depth=default_screw_depth, 
    floor_thickness=default_floor_thickness, wall_thickness=default_wall_thickness) {
  eps = 0.1;
  // I couldn't think of a good name for this ('q') but effectively it's the
  // size of the overhang that produces a wall thickness that's less than the lip
  // arount the top inside edge.
  q = 1.65-wall_thickness+0.95;  // default 1.65 corresponds to wall thickness of 0.95
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
        translate([0, 0, zpoint-eps]) cylinder(d=2.3, h=1.2+2*eps, $fn=24); // lip
      }
      
      hull() cornercopy(17, num_x, num_y) {
        // create bevels below the lip
        translate([0, 0, zpoint-0.1]) cylinder(d=2.3, h=0.1, $fn=24);       // transition from lip ...
        translate([0, 0, zpoint-q-q2]) cylinder(d=2.3+2*q, h=q2, $fn=32);   // ... to top of thin wall ...
        // create rounded bottom of bowl (8.5 is high enough to not expose gaps)
        translate([0, 0, 2.3/2+q+floorht]) sphere(d=2.3+2*q, $fn=32);       // .. to bottom of thin wall and floor
      }
    }
    
    // cut away from the negative to leave behind wall to make it easier to remove piece
    pivot_z = 13.6-0.45+floorht-5;
    pivot_y = -12+2;
    
    // rounded inside bottom
    if(fingerslide){
      for (ai=[0:facets-1]) translate([0, pivot_y, pivot_z])
        rotate([90*ai/(facets-1), 0, 0])
        translate([0, -pivot_y, -pivot_z])
        translate([-gridfinity_pitch/2, -10-17-1.15, 0]) 
        cube([gridfinity_pitch*num_x, 10, gridfinity_zpitch*num_z+5]);
    }
  }
}
