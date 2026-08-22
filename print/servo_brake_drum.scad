// ==============================================================
//   SERVO BRAKE-CABLE DRUM   —   TD-8130MG standard servo
//   Pulls TWO bicycle brake cables equally.
//   Stroke 70 mm per cable over 180 deg of servo rotation.
//
//   The stock 4-arm star horn is CAPTURED in a pocket underneath,
//   so the factory-moulded spline takes the torque, not printed PLA.
//
//   Rev B — printability fixes after slicing rev A:
//     * grooves are now 90 deg V-sheaves, not square channels.
//       A square groove left a 3 mm cantilever ring hanging in
//       mid-air above each groove ("collapsing overhang").
//       45 deg walls are self-supporting, and the cable seats
//       itself at exactly the design radius.
//     * the centre bore is now the same diameter as the horn
//       boss and runs right through. Before, the step between
//       the Ø9 bore and the Ø14.5 boss pocket left an
//       unsupported ring at the pocket ceiling
//       ("floating bridge anchors").
// ==============================================================

PART = "drum";      // "drum"  = the real part
                    // "fit"   = 6 mm test coupon, just the horn pocket
                    // "cut"   = half cut away, for looking inside

/* ---------------------------------------------------------------
   MEASURE THESE FOUR ON YOUR BLACK STAR HORN WITH CALIPERS
   The defaults are typical for a 25T 4-arm horn — verify them.
   --------------------------------------------------------------- */
HORN_TIP   = 40.0;   // tip-to-tip across one pair of arms
HORN_ARM_W =  7.0;   // width of an arm, measured near the tip
HORN_T     =  4.0;   // thickness of the horn arms
HORN_BOSS  = 14.0;   // diameter of the round centre boss

/* ---------------- drive geometry ---------------- */
STROKE   = 70;       // cable travel wanted, mm
SWEEP    = 180;      // servo rotation used, deg
CABLE_D  = 1.6;      // brake inner wire diameter
V_DEPTH  = 2.2;      // sheave depth. 45 deg walls, so this is also
                     // the half-width of the groove mouth.

/* ---------------- brake cable nipple ------------
   6.6 x 8.0  = flat-bar / MTB barrel nipple
   7.6 x 5.0  = drop-bar / road pear nipple        */
NIP_D = 6.6;
NIP_H = 8.0;

/* ---------------- fit & fasteners ---------------- */
CLR        = 0.25;   // pocket clearance on the horn (per side)
POCKET_CLR = 0.40;   // extra pocket depth
SCREW_D    = 3.4;    // M3 clearance, retaining screws into the horn holes
SHOW_SLOTS = true;   // radial retaining slots on top

$fn = 180;

/* ================= derived ================= */
D_EFF   = STROKE*360/(SWEEP*PI);   // cable centreline diameter
R_EFF   = D_EFF/2;
R_FLOOR = R_EFF - CABLE_D/2;       // V apex radius — the cable seats
                                   // where the V is CABLE_D wide, which
                                   // is exactly R_EFF. That is the point.
R_OUT   = R_FLOOR + V_DEPTH;       // outer radius

ZC1     = 9.5;                     // lower groove centre
ZC2     = 15.5;                    // upper groove centre
H_TOT   = 19.5;

Z_POCK  = HORN_T + POCKET_CLR;     // pocket ceiling
BORE_D  = HORN_BOSS + 2*CLR;       // centre bore == boss pocket, straight through
SLOT_W  = CABLE_D + 0.6;           // wire escape slot, width
SLOT_H  = 2.6;                     // ...and height. Keep != 2*V_DEPTH.
R_NIP   = 15.0;                    // nipple pocket centre radius
HORN_ROT= 45;                      // arms at 45/135/... so they miss the nipples

echo(str(">> cable centreline dia = ", D_EFF, " mm"));
echo(str(">> outer dia            = ", 2*R_OUT, " mm"));
echo(str(">> total height         = ", H_TOT, " mm"));
echo(str(">> rim between grooves  = ", (ZC2-V_DEPTH)-(ZC1+V_DEPTH), " mm"));

/* ================= modules ================= */

// The 4 arms of the star pocket. The centre is handled by the
// through bore, so there is no boss pocket to leave a floating ring.
module horn_arms(extra=0){
    w = HORN_ARM_W + 2*CLR + extra;
    l = HORN_TIP   + 2*CLR + extra;
    rotate([0,0,HORN_ROT])
        for(a=[0,90]) rotate([0,0,a])
            translate([-l/2,-w/2,-0.01]) cube([l,w,Z_POCK+0.01]);
}

// 90 deg V sheave, cut as a revolved triangle. Both faces sit at
// 45 deg, so nothing overhangs and no support is needed.
module v_groove(zc){
    translate([0,0,zc])
    rotate_extrude(convexity=6)
        polygon([[R_FLOOR, 0],
                 [R_OUT+2,  V_DEPTH+2],
                 [R_OUT+2, -V_DEPTH-2]]);
}

// nipple pocket + the side slot the wire escapes through
module cable_anchor(zc, ang){
    rotate([0,0,ang]){
        translate([R_NIP,0,zc-NIP_H/2])
            cylinder(d=NIP_D, h=H_TOT);              // open to the top face
        // slot half-height must NOT equal V_DEPTH, or its top edge lands
        // exactly on the groove mouth rim and CGAL emits coincident faces
        translate([R_NIP-1, -SLOT_W/2, zc-SLOT_H/2])
            cube([R_OUT-R_NIP+3, SLOT_W, SLOT_H]);
    }
}

module drum(){
    difference(){
        cylinder(r=R_OUT, h=H_TOT);

        v_groove(ZC1);
        v_groove(ZC2);

        // nipples 180 deg apart, so the two cable tensions form a
        // couple that cancels instead of a 132 N side load on the
        // servo bearing
        cable_anchor(ZC1,   0);
        cable_anchor(ZC2, 180);

        horn_arms();

        translate([0,0,-1]) cylinder(d=BORE_D, h=H_TOT+2);

        // retaining slots: M3 from the top into whichever hole of the
        // horn arm lines up. Slotted, so any hole pattern works.
        if(SHOW_SLOTS)
            for(a=[0,90,180,270]) rotate([0,0,HORN_ROT+a])
                hull(){
                    translate([ 8,0,Z_POCK]) cylinder(d=SCREW_D, h=H_TOT);
                    translate([19,0,Z_POCK]) cylinder(d=SCREW_D, h=H_TOT);
                }
    }
}

// quick coupon to test the horn fit before printing the real thing
module fitcheck(){
    h = Z_POCK + 2.0;
    difference(){
        cylinder(r = HORN_TIP/2 + 4, h = h);
        horn_arms();
        translate([0,0,-1]) cylinder(d=BORE_D, h=h+2);
    }
}

module cutaway(){
    difference(){
        drum();
        translate([-60,0,-1]) cube([120,60,H_TOT+2]);
    }
}

if     (PART == "drum") drum();
else if(PART == "cut" ) cutaway();
else                    fitcheck();
