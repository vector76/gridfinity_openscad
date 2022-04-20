use <gridfinity_modules.scad>

cup_height = 5;
stick_diameter = 30;
easement_z = 0.7; // a slightly large opening at the top for compliance while inserting.

render()
basic_cup(ceil(stick_diameter/34), ceil(stick_diameter/34), cup_height);


module basic_cup(num_x=1, num_y=1, num_z=2, bottom_holes=0) {
  difference() {
    grid_block(num_x, num_y, num_z, bottom_holes ? 5 : 0);
    glue_stick(num_z, stick_diameter);
  }
}

module glue_stick(num_z=5, diam) {
  translate([0,0,1.2]) cylinder(h=num_z *7, d=diam);
  translate([0,0,(num_z - easement_z) * 7 + 1.2]) cylinder(h=(easement_z)*7, d1=diam, d2=diam* 1.1);
}
