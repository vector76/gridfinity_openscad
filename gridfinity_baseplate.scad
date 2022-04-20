// include instead of use, so we get the pitch
include <gridfinity_modules.scad>

if (0) {
  %translate([-21, -21, 0])
  import("../_proj/3rd_party/gridfinity-baseplates-model_files/frame-3x5.stl");
  
  frame_plain(5, 3);
}

if (1) {
  %translate([-21, -21, 0])
  import("../_proj/3rd_party/gridfinity-baseplates-model_files/weighted-baseplate-3x5.stl");
  
  weighted_baseplate(5, 3);
}

module weighted_baseplate(num_x, num_y) {
  magnet_position = 13;
  magnet_od = 6.5;
  magnet_thickness = 2.4;
  eps = 0.1;
  
  difference() {
    frame_plain(num_x, num_y, 6.4);
    
    gridcopy(num_x, num_y) {
      cornercopy(magnet_position) {
        translate([0, 0, -magnet_thickness])
        cylinder(d=magnet_od, h=magnet_thickness+eps, $fn=48);
        
        translate([0, 0, -6.4]) cylinder(d=3.5, h=6.4, $fn=24);
        
        // counter-sunk holes in the bottom
        translate([0, 0, -6.41]) cylinder(d1=8.5, d2=3.5, h=2.5, $fn=24);
      }
      
      translate([-10.7, -10.7, -6.41]) cube([21.4, 21.4, 4.01]);
      
      for (a2=[0,90]) rotate([0, 0, a2])
      hull() for (a=[0, 180]) rotate([0, 0, a])
      translate([-14.9519, 0, -6.41]) cylinder(d=8.5, h=2.01, $fn=24);
    }
  }
}


module frame_plain(num_x, num_y, extra_down=0) {
  ht = extra_down > 0 ? 4.4 : 5;
  corner_radius = 3.75;
  corner_position = gridfinity_pitch/2-corner_radius;
  difference() {
    hull() cornercopy(corner_position, num_x, num_y) 
    translate([0, 0, -extra_down]) cylinder(r=corner_radius, h=ht+extra_down);
    
    render() gridcopy(num_x, num_y) pad_oversize(margins=1);
  }
}