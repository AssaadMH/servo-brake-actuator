// ==============================================================
//   CABLE HOUSING STOP  —  for the twin-cable brake drum
//
//   Anchors the outer brake housing to the aluminum plate so the
//   inner wire can actually be pulled. Without these the housing
//   just compresses and the drum does nothing.
//
//   TWO PIECES, printed TWICE each (one pair per cable):
//     POST  - bolts to the plate, vertical groove + clamp slot
//     BLOCK - the cable stop itself, slides up/down the post
//
//   The housing pushes the stop TOWARDS the drum with ~66 N.
//   That load goes into the tongue bearing on the groove wall,
//   NOT into the clamp bolt — so a single M4 is enough.
// ==============================================================

PART = "post";     // "post" | "block" | "assembly" (preview only)

/* ---------------- cable ---------------- */
HOUSING_D = 6.4;   // ferrule / housing end OD  (5 mm housing + cap)
WIRE_D    = 2.8;   // inner wire clearance
SEAT_L    = 11;    // how deep the ferrule sits

/* ---------------- hardware ---------------- */
M4        = 4.4;   // clamp bolt clearance
M4_HEAD   = 7.6;   // socket head counterbore
PLATE_M4  = 4.5;   // slots for the two screws into the plate

/* ---------------- post ---------------- */
POST_T    = 10;    // slab thickness
POST_H    = 46;    // total height
BASE_Y    = 32;    // depth at the foot
TOP_Y     = 10;    // depth at the top
FOOT_T    = 5;
FOOT_X0   = -3;
FOOT_X1   = 31;
FOOT_Y    = 36;
SCREW_X   = 21;    // plate screws, clear of the post and of a M4 washer

GROOVE_W  = 14;    // anti-rotation groove, width (Y)
GROOVE_D  = 3;     // ...and depth (X)
SLOT_Z0   = 13;    // clamp slot travel
SLOT_Z1   = 37;

/* ---------------- block ---------------- */
BLK_X     = 16;
BLK_Y     = 16;
BLK_Z     = 20;
CABLE_X   = -8;    // cable axis, out from the post face
CABLE_Z   =  3;    // ...and up from the block centre
BOLT_Z    = -5;    // clamp bolt, safely below the cable channel
TONGUE_CL = 0.3;   // sliding clearance

$fn = 96;

/* ================= derived ================= */
// cable height above the plate = FOOT_T + bolt position + (CABLE_Z - BOLT_Z)
CAB_MIN = FOOT_T + SLOT_Z0 + (CABLE_Z-BOLT_Z) - FOOT_T;
echo(str(">> cable height adjustable from ", SLOT_Z0 + (CABLE_Z-BOLT_Z),
         " to ", SLOT_Z1 + (CABLE_Z-BOLT_Z), " mm above the plate"));
echo(str(">> post footprint ", FOOT_X1-FOOT_X0, " x ", FOOT_Y, " mm"));

/* ================= POST ================= */
module post(){
    difference(){
        union(){
            // foot
            translate([FOOT_X0, -FOOT_Y/2, 0]) cube([FOOT_X1-FOOT_X0, FOOT_Y, FOOT_T]);
            // tapered slab. Constant 10 mm in X, so the BACK face stays
            // flat and vertical — the clamp nut needs somewhere square to sit.
            hull(){
                translate([0, -BASE_Y/2, FOOT_T-1]) cube([POST_T, BASE_Y, 1]);
                translate([0, -TOP_Y/2,  POST_H-1]) cube([POST_T, TOP_Y,  1]);
            }
        }

        // anti-rotation groove, open at the top so the block slides in
        translate([-1, -GROOVE_W/2, FOOT_T+3])
            cube([GROOVE_D+1, GROOVE_W, POST_H]);

        // clamp slot
        hull(){
            translate([GROOVE_D-1, 0, SLOT_Z0]) rotate([0,90,0]) cylinder(d=M4, h=POST_T+2);
            translate([GROOVE_D-1, 0, SLOT_Z1]) rotate([0,90,0]) cylinder(d=M4, h=POST_T+2);
        }

        // plate screw slots — slotted along Y so you can slide the whole
        // bracket toward or away from the drum to set cable tension
        for(s=[-1,1])
            hull(){
                translate([SCREW_X, s*15, -1]) cylinder(d=PLATE_M4, h=FOOT_T+2);
                translate([SCREW_X, s*5,  -1]) cylinder(d=PLATE_M4, h=FOOT_T+2);
            }
    }
}

/* ================= BLOCK ================= */
module block(){
    difference(){
        union(){
            translate([-BLK_X, -BLK_Y/2, -BLK_Z/2]) cube([BLK_X, BLK_Y, BLK_Z]);
            // tongue — this is what actually carries the 66 N
            translate([0, -(GROOVE_W-2*TONGUE_CL)/2, -BLK_Z/2])
                cube([GROOVE_D-TONGUE_CL, GROOVE_W-2*TONGUE_CL, 15]);
        }

        // --- cable channel, along Y ---
        // wire side (faces the drum)
        translate([CABLE_X, -BLK_Y/2-1, CABLE_Z]) rotate([-90,0,0])
            cylinder(d=WIRE_D, h=BLK_Y/2+1-(SEAT_L-BLK_Y/2)+0.01);
        // ferrule seat (housing butts on the shoulder)
        translate([CABLE_X, BLK_Y/2-SEAT_L, CABLE_Z]) rotate([-90,0,0])
            cylinder(d=HOUSING_D, h=SEAT_L+1);

        // open the whole channel upward so the cable drops in from above
        translate([CABLE_X-WIRE_D/2, -BLK_Y/2-1, CABLE_Z])
            cube([WIRE_D, BLK_Y-SEAT_L+1, BLK_Z]);
        translate([CABLE_X-HOUSING_D/2, BLK_Y/2-SEAT_L, CABLE_Z])
            cube([HOUSING_D, SEAT_L+1, BLK_Z]);

        // --- clamp bolt, below the cable ---
        translate([-BLK_X-1, 0, BOLT_Z]) rotate([0,90,0]) cylinder(d=M4, h=BLK_X+GROOVE_D+2);
        translate([-BLK_X-1, 0, BOLT_Z]) rotate([0,90,0]) cylinder(d=M4_HEAD, h=5);
    }
}

/* ================= preview ================= */
module assembly(){
    post();
    translate([0,0,25]) block();
}

// everything you need for BOTH cables, on one bed
module plate(){
    translate([  0,  0, 0]) post();
    translate([ 52,  0, 0]) post();
    translate([  6, 48, BLK_Z/2]) block();
    translate([ 34, 48, BLK_Z/2]) block();
}

if     (PART == "post")  post();
else if(PART == "block") block();
else if(PART == "plate") plate();
else                     assembly();
