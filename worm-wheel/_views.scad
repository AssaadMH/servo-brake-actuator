use <cap60.scad>
view = 1;
seat = 37.80;
module asm(exp=0) {
    color("silver")   import("gear60_v2.stl", convexity=12);
    color("orangered") translate([0,0,seat+exp]) cap60();
}
if (view==1) color("orangered") translate([0,0,-3.3]) cap60();                 // cap alone
if (view==2) color("orangered") translate([0,0,3.3]) rotate([180,0,0]) cap60();// cap underside
if (view==3) asm(14);                                                          // exploded
if (view==4) difference() { asm(0); translate([-40,0,-1]) cube([80,40,60]); }  // section
