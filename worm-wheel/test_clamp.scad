// Geometric self-tests for the split clamping hub.
// Each test renders a volume that MUST be empty (or must NOT be empty).
// Run with -D 'TEST=n'.  Empty result => OpenSCAD warns "top level object
// is empty" and writes a 0-facet STL.

use <gear60.scad>

TEST = 1;

// --- 1: the slit must fully separate the jaws ------------------------
// Everything in the slit plane, outboard of the bore, above the gear
// face, must be air. If ANY material shows up here the jaws are bridged
// and the clamp cannot close.
if (TEST == 1)
    intersection() {
        gear60();
        translate([3.0, -0.45, 10.05]) cube([40, 0.90, 30]);
    }

// --- 2: control for test 1 -------------------------------------------
// Same slab, but on the -X side where there is deliberately NO slit.
// This MUST be solid -- it proves test 1 can actually see material.
if (TEST == 2)
    intersection() {
        gear60();
        translate([-11, -0.45, 10.05]) cube([6, 0.90, 10]);
    }

// --- 3: bolt-head counterbore must break through the +Y flat ---------
// Air just outside the flat, at the counterbore diameter. If the
// counterbore stopped short, this slab would be blocked by a skin.
// Tests the 6.4 counterbore is open from y = 6.5 inward to y = 3.1.
if (TEST == 3)
    intersection() {
        gear60();
        translate([12, 3.2, 16]) rotate([-90, 0, 0])
            cylinder(h = 3.0, d = 6.0);
    }

// --- 4: insert seat must break through the -Y flat -------------------
if (TEST == 4)
    intersection() {
        gear60();
        translate([12, -6.4, 16]) rotate([90, 0, 0])
            cylinder(h = 4.5, d = 3.6);
    }

// --- 3c: CONTROL for test 3 ------------------------------------------
// Same probe, but shifted to y = 1.0..3.0 -- between the bottom of the
// counterbore (y=3.1) and the slit wall (y=0.6). That is solid jaw, so
// this MUST come back solid. If it does not, probe 3 was simply missing
// the part and its "EMPTY" meant nothing.
if (TEST == 33)
    intersection() {
        gear60();
        translate([12, 1.0, 16]) rotate([-90, 0, 0])
            cylinder(h = 2.0, d = 6.0);
    }

// --- 4c: CONTROL for test 4 ------------------------------------------
// Beyond the far end of the insert seat (y = -1.4 inward) must be solid.
if (TEST == 44)
    intersection() {
        gear60();
        translate([12, -1.3, 16]) rotate([90, 0, 0])
            cylinder(h = 0.6, d = 3.6);
    }

// --- 5: the ear must stay clear of the tooth roots -------------------
// Anything at r > 25 (rim_wall inboard of the root circle) and above
// the gear face must be air.
if (TEST == 5)
    intersection() {
        gear60();
        translate([0, 0, 10.05])
            difference() {
                cylinder(h = 30, r = 40);
                cylinder(h = 30, r = 25);
            }
    }

// --- 5c: CONTROL for test 5 ------------------------------------------
// The ear itself, r = 13..18 above the gear face, MUST be solid.
if (TEST == 55)
    intersection() {
        gear60();
        translate([0, 0, 10.05])
            difference() {
                cylinder(h = 5, r = 18);
                cylinder(h = 5, r = 13);
            }
    }

// =====================================================================
//  BRAKE CABLE DRUM
// =====================================================================

// --- 10: nipple pocket is a real socket, not open air ----------------
// Probe the inside of the station-1 pocket. Must be air.
if (TEST == 10)
    intersection() {
        gear60();
        rotate(45) translate([14.8, 0, 13.5]) cylinder(h = 8, d = 6.4);
    }

// --- 10c: CONTROL -- boss material beside the pocket -----------------
// Same radius and height, swung 16 deg round: still inside the boss but
// outside the pocket. MUST be solid, else probe 10 was just in the open
// annulus between collar and skirt and proved nothing.
if (TEST == 100)
    intersection() {
        gear60();
        rotate(45 + 16) translate([14.8, 0, 13.5]) cylinder(h = 8, d = 2.0);
    }

// --- 11: wire slot runs from the pocket out to the drum surface ------
if (TEST == 11)
    intersection() {
        gear60();
        rotate(45) translate([14.8, 9, 16]) rotate([-90, 0, 0])
            cylinder(h = 3, d = 1.6);
    }

// --- 11c: CONTROL -- same place with no station ----------------------
if (TEST == 110)
    intersection() {
        gear60();
        rotate(90) translate([14.8, 9, 16]) rotate([-90, 0, 0])
            cylinder(h = 3, d = 1.6);
    }

// --- 12: skirt sits on solid material, not bridging the web recess ---
if (TEST == 12)
    intersection() {
        gear60();
        translate([0, 0, 7])
            difference() { cylinder(h = 2.5, r = 19.5); cylinder(h = 2.5, r = 17); }
    }

// --- 12c: CONTROL -- the recess itself, just outboard, must be air ---
if (TEST == 120)
    intersection() {
        gear60();
        translate([0, 0, 7])
            difference() { cylinder(h = 2.5, r = 24); cylinder(h = 2.5, r = 21); }
    }

// --- 13: hex key can reach the pinch bolt through the skirt ----------
if (TEST == 13)
    intersection() {
        gear60();
        translate([12, 12, 16]) rotate([-90, 0, 0]) cylinder(h = 5, d = 5.0);
    }

// --- 13c: CONTROL -- opposite side, no access hole, must be solid ----
if (TEST == 130)
    intersection() {
        gear60();
        translate([-12, 12, 16]) rotate([-90, 0, 0]) cylinder(h = 5, d = 5.0);
    }
