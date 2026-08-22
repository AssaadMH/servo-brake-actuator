// =====================================================================
//  _v3_views.scad -- illustration renders of the finished gear60_v3.
//  Reads the REAL exported mesh, not a re-derived model.
//      openscad --backend=manifold -D view=N --imgsize=1400,1000 \
//               --projection=o --viewall --autocenter -o vN.png _v3_views.scad
// =====================================================================

view = 1;
seat = 37.80;          // cap60 skirt bottom lands here
use <cap60.scad>

module part() import("gear60_v3.stl", convexity = 12);

// 1 -- the whole part, as printed
if (view == 1) color("silver") part();

// 2 -- vertical quarter cut: web recess, rim wall under the tooth roots,
//      full height of the clamp collar, cable groove at z 36
if (view == 2)
    color("silver") difference() {
        part();
        translate([0, 0, -1]) cube([60, 60, 60]);
    }

// 3 -- horizontal cut just under the top face: the 4 nipple pockets,
//      their tangential wire chutes, and the pinch-bolt window
if (view == 3)
    color("silver") difference() {
        part();
        translate([-60, -60, 39.0]) cube([120, 120, 40]);
    }

// 4 -- horizontal cut at the pinch-bolt axis (z 26): bore, slit,
//      bolt shank, head counterbore, insert seat
if (view == 4)
    color("silver") difference() {
        part();
        translate([-60, -60, 26]) cube([120, 120, 40]);
    }

// 5 -- exploded with the cap60 retaining clip
if (view == 5) {
    color("silver")    part();
    color("orangered") translate([0, 0, seat + 16]) cap60();
}

// 6 -- v2 vs v3 side by side: a 3 mm slab off the gear face, whole disc,
//      seen from above. Same scale, so the extra 2 teeth and the +0.90 mm
//      of tip radius read directly off the picture.
//      v2 red (tip 60.60, z 74) | v3 silver (tip 62.40, z 76)
module slab(f) intersection() {
    import(f, convexity = 12);
    translate([-40, -40, 3]) cube([80, 80, 3]);
}
if (view == 6) {
    color("red")    translate([-34, 0, 0]) slab("gear60_v2.stl");
    color("silver") translate([ 34, 0, 0]) slab("gear60_v3.stl");
}
