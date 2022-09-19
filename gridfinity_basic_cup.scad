// include <gridfinity_modules.scad>
use <gridfinity_cup_modules.scad>

// X dimension in grid units
width = 2;
// Y dimension in grid units
depth = 1;
// Z dimension (multiples of 7mm)
height = 3;// [2, 3, 4, 5, 6, 7]
// X dimension subdivisions
chambers = 1;

// Include overhang for labeling
withLabel = false;
// Include larger corner fillet
fingerslide = true;
// Width of the label in number of units: positive numbers are measured from the 0 end, negative numbers are measured from the far end, value of zero means full width (as long as withLabel is true)
labelWidth = 0;  // .1

// Set magnet diameter and depth to 0 to print without magnet holes
// (Zack's design uses magnet diameter of 6.5)
magnet_diameter = 0;  // .1
// (Zack's design uses depth of 6)
screw_depth = 0;
// Minimum thickness above cutouts in base (Zack's design is effectively 1.2)
floor_thickness = 0.7;
// Wall thickness (Zack's design is 0.95)
wall_thickness = 0.95;  // .01
// Hole overhang remedy is active only when both screws and magnets are used (and option is selected)
hole_overhang_remedy = true;
// Efficient floor option saves material and time, but the floor is not smooth (only applies if no magnets, screws, or finger-slide used)
efficient_floor = false;

basic_cup(
  num_x=width,
  num_y=depth,
  num_z=height,
  chambers=chambers,
  withLabel=withLabel,
  labelWidth=labelWidth,
  fingerslide=fingerslide,
  magnet_diameter=magnet_diameter,
  screw_depth=screw_depth,
  floor_thickness=floor_thickness,
  wall_thickness=wall_thickness,
  hole_overhang_remedy=hole_overhang_remedy,
  efficient_floor=efficient_floor
);
