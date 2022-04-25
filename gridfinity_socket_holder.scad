include <gridfinity_modules.scad>

part = 3;

if (part == 1) {
	socket_holder(4, [12,12,12,13,14,16,16,17,21,22], "METRIC", stackable=false);
} else if (part == 2) {
	socket_holder(4, [12,13,14,14,16,16,17,18,20,22], "IMPERIAL", stackable=false);
} else if (part == 3) {
	socket_holder(4, [12,12,12,12,12,12,13,14,14,16,16], "Imperial < 1/2\"", stackable=true);
} else if (part == 4) {
	socket_holder(3, [17,18,20,22,24], "Imperial >= 1/2\"", stackable=true);
}


module socket_holder(num_x=1, widths=[], name="", stackable=false) {
	difference(){
		grid_block(num_x, 1, stackable ? 5 : 3);
		usable_w = 42*num_x - 6;
		rotate([-45,0,0])translate([-18,-5,0])
			sockets(widths*1.01, usable_w);
		rotate([-45,0,0])translate([-18,-23-6,4])
			cube([usable_w,18,26]);
		translate([-18,-20,10])rotate([90,0,0])
			linear_extrude(10)text(name);
		if(stackable){
			translate([-18,-18,22])cube([usable_w,42-6,14]);
		}
	}
}

function move(v, i=0, r=0, lo=0) = i > 0 ? move(v, i-1, r+(v[i-1]+v[i])/2, lo) + lo : r;
function sum(v, i=0, r=0) = i < len(v) ? sum(v, i+1, v[i] + r) : r;

module sockets(widths=[], width = 100) {
	leftover = width - sum(widths);
	echo(leftover=leftover, "(should be greater than 0)");
	for (i = [0:len(widths)-1]) {
		s = move(widths, i, 0, leftover/(len(widths)-1));
		translate([widths[0]/2,0,0])
		translate([s,-widths[i]/2,0])cylinder(h=26, d=widths[i]);
	}
}
