// basic block with cutout in top to be stackable, optional holes in bottom
// start with this and begin 'carving'
module grid_block(num_x=1, num_y=1, num_z=2, bot_hole_depth=6) {
  totalht=7*num_z+3.75;
  difference() {
    intersection() {
      union() {
        // grid of pads
        gridcopy(num_x, num_y) pad_oversize();
        // main body will be cut down afterward
        translate([-21, -21, 5]) cube([42*num_x, 42*num_y, totalht-5]);
      }
      
      // crop with outer cylinders
      translate([0, 0, -0.1])
      hull() cornercopy(17, num_x, num_y) cylinder(d=7.5, h=totalht+0.2, $fn=44);
    }
    
    // remove top so XxY can fit on top
    translate([0, 0, 7*num_z]) pad_oversize(num_x, num_y, 1);
    
    // add holes in bottom pads if requested
    if (bot_hole_depth > 0) {
      gridcopy(num_x, num_y) bottomholes(bot_hole_depth);
    }
  }
}


// holes in the bottom of the pads (slightly short to allow deeper
module bottomholes(depth=6) {
  if (depth > 0) {
    cornercopy(13) {
      // actually 2.4 mm deep but offset by 0.1
      translate([0, 0, -0.1]) cylinder(d=6.5, h=2.5, $fn=41);
      cylinder(d=3, h=depth, $fn=28);
    }
  }
}


// unit pad slightly oversize at the top to be trimmed or joined with other feet or the rest of the model
// also useful as cutouts
module pad_oversize(num_x=1, num_y=1, margins=0) {
  totalht = 5.1;
  
  radialgap = margins ? 0.25 : 0;  // oversize cylinders for a bit of clearance between part and hole
  axialdown = margins ? 0.1 : 0;  // a tiny bit of axial clearance for whole multiples of 7mm
  cut_up = margins ? 3 : 0;  // cut upward
  
  translate([0, 0, -axialdown])
  difference() {
    union() {
      hull() cornercopy(17, num_x, num_y) {
        cylinder(d=1.6+2*radialgap, h=1, $fn=24);
        translate([0, 0, 0.8]) cylinder(d=3.2+2*radialgap, h=1.9, $fn=32);
      }
      
      hull() cornercopy(17, num_x, num_y) {
        translate([0, 0, 2.6]) cylinder(d=3.2+2*radialgap, h=2.15, $fn=32);
        translate([0, 0, 4.75+0.25]) 
        cylinder(d=7.5+0.5+2*radialgap, h=totalht-4.75-0.25+axialdown, $fn=44);
      }
    }
  }
}

// similar to quadtranslate but expands to extremities of a block
module cornercopy(r, num_x=1, num_y=1) {
  for (xx=[-r, 42*(num_x-1)+r]) for (yy=[-r, 42*(num_y-1)+r]) 
    translate([xx, yy, 0]) children();
}


// make repeated copies of something(s) at the gridfinity spacing of 42mm
module gridcopy(num_x, num_y) {
  for (xi=[1:num_x]) for (yi=[1:num_y]) translate([42*(xi-1), 42*(yi-1), 0]) children();
}


