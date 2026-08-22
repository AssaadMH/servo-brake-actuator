// Cutaway views of the finished part, for illustration only.
use <gear60.scad>

SECT = 1;

// 1: horizontal cut at the pinch-bolt axis (z = 16), seen from above.
//    Shows bore, slit, bolt shank, head counterbore and insert seat.
if (SECT == 1)
    difference() {
        gear60();
        translate([-60, -60, 16]) cube([120, 120, 40]);
    }

// 2: vertical quarter cut. Shows the web recess, rim wall under the
//    tooth roots, and the full height of the clamping hub.
if (SECT == 2)
    difference() {
        gear60();
        translate([0, 0, -1]) cube([60, 60, 40]);
    }

// 3: horizontal cut at the cable groove (z = 16), seen from above.
//    Shows all four nipple pockets, their wire slots, the groove and
//    the bolt access window in one plan.
if (SECT == 3)
    difference() {
        gear60();
        translate([-60, -60, 15.3]) cube([120, 120, 40]);
    }
