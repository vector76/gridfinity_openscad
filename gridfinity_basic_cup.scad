use <gridfinity_modules.scad>

render()
basic_cup(2, 1, 3);


module basic_cup(num_x=1, num_y=1, num_z=2, bottom_holes=0) {
  difference() {
    grid_block(num_x, num_y, num_z, bottom_holes ? 5 : 0);
    basic_cavity(num_x, num_y, num_z);
  }
}


module basic_cavity(num_x=2, num_y=1, num_z=2) {
  eps = 0.1;
  q = 1.65;
  q2 = 2.15;
  zpoint = 7*num_z-1.2;
  
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
        // create rounded bottom of bowl (8.3 is high enough to not expose gaps)
        translate([0, 0, 8.3]) sphere(d=2.3+2*q, $fn=32);
      }
    }
    
    // cut away from the negative to leave behind wall to make it easier to remove piece
    pivot_z = 11.6+2;
    pivot_y = -12+2;
    
    // rounded inside bottom
    for (a=[0, 15, 30, 45, 60, 75, 90]) translate([0, pivot_y, pivot_z])
      rotate([a, 0, 0]) translate([0, -pivot_y, -pivot_z])
      translate([-21, -50-17-1.15, 0]) cube([42*num_x, 50, 7*num_z]);
  }
}
