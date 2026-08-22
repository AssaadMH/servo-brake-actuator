// ==============================================================
//   SERVO BRAKE-CABLE DRUM  —  MINI  (TD-8130MG, small cross horn)
//   Pulls TWO bicycle brake cables equally.
//   Ø28 cable centreline (outer Ø30.8). ~44 mm stroke / 180 deg.
//
//   Smaller sibling of servo_brake_drum.scad. Same proven Rev-B
//   anchor scheme (vertical nipple pocket inboard of the groove,
//   two stacked grooves 180 deg apart so the two 66 N pulls form
//   a couple, not a 132 N side-load), just rescaled for the
//   trimmed 25T cross horn shown in the 2026-07-23 photos.
//
//   WHY NOT Ø20:  below ~Ø28 the revolved groove undercuts the
//   material the nipple must seat against — the shoulder becomes
//   a <1 mm PLA sliver right where the 66 N pull lands. Ø28 is the
//   smallest diameter that still has a solid nipple anchor.
// ==============================================================

PART = "drum";      // "drum" = real part
                    // "fit"  = short coupon, just the horn pocket
                    // "cut"  = half cut away, to look inside

/* ---------------------------------------------------------------
   CROSS HORN — measured 2026-07-23 (TD-8130MG will use this horn,
   trimmed).  Arm LENGTH is set by HORN_TIP = the trim target;
   cut the arms so the cross is HORN_TIP mm tip-to-tip.
   --------------------------------------------------------------- */
HORN_TIP   = 27.0;   // TRIM TARGET: arm tip-to-tip after you cut them
HORN_ARM_W =  6.5;   // arm slot width (widened from measured 5.0 so the horn drops in)
HORN_T     =  4.0;   // measured horn thickness
HORN_BOSS  =  9.0;   // measured centre-boss (hub) diameter

/* ---------------- drive geometry ---------------- */
STROKE   = 44;       // cable travel, mm  -> D_EFF = 28.0
SWEEP    = 180;      // servo rotation used, deg
CABLE_D  = 1.6;      // brake inner wire diameter
V_DEPTH  = 2.2;      // sheave depth = half-width of the V mouth (45 deg walls)

/* ---------------- brake cable nipple ------------
   6.6 x 8.0 = flat-bar / MTB barrel nipple        */
NIP_D = 6.6;
NIP_H = 8.0;

/* ---------------- fit & fasteners ---------------- */
CLR        = 0.50;   // pocket clearance per side (0.25->0.5: horn wouldn't start in, elephant-foot at the down-facing mouth)
POCKET_CLR = 0.40;   // extra pocket depth
SCREW_D    = 3.4;    // M3 clearance, retaining screws into horn holes
SHOW_SLOTS = true;   // radial retaining slots on top

$fn = 180;

/* ================= derived ================= */
D_EFF   = STROKE*360/(SWEEP*PI);   // cable centreline diameter
R_EFF   = D_EFF/2;
R_FLOOR = R_EFF - CABLE_D/2;       // V apex radius (cable seats at R_EFF)
R_OUT   = R_FLOOR + V_DEPTH;       // outer radius

ZC1     = 9.5;                     // lower groove centre
ZC2     = 15.5;                    // upper groove centre
H_TOT   = 19.5;

Z_POCK  = HORN_T + POCKET_CLR;     // pocket ceiling
BORE_D  = HORN_BOSS + 2*CLR;       // centre bore == boss clearance, straight through
SLOT_W  = CABLE_D + 0.6;           // wire escape slot width
SLOT_H  = 2.6;                     // ...and height. Keep != 2*V_DEPTH (CGAL coincidence trap)
R_NIP   = 9.2;                     // nipple pocket centre radius (inboard of groove floor)
HORN_ROT= 45;                      // arms at 45/135/... so they miss the 0/180 nipples

echo(str(">> cable centreline dia = ", D_EFF, " mm"));
echo(str(">> outer dia            = ", 2*R_OUT, " mm"));
echo(str(">> total height         = ", H_TOT, " mm"));
echo(str(">> nipple pocket r      = ", R_NIP, "  bore r = ", BORE_D/2,
         "  groove floor r = ", R_FLOOR));
echo(str(">> wall nipple->bore    = ", (R_NIP-NIP_D/2)-(BORE_D/2), " mm"));
echo(str(">> wall nipple->floor   = ", R_FLOOR-(R_NIP+NIP_D/2), " mm"));

/* ================= modules ================= */

// 4 arms of the cross pocket. Centre handled by the through bore,
// so no floating boss-pocket ceiling.
module horn_arms(extra=0){
    w = HORN_ARM_W + 2*CLR + extra;
    l = HORN_TIP   + 2*CLR + extra;
    rotate([0,0,HORN_ROT])
        for(a=[0,90]) rotate([0,0,a])
            translate([-l/2,-w/2,-0.01]) cube([l,w,Z_POCK+0.01]);
}

// 90 deg V sheave, revolved triangle -> self-supporting, no support
module v_groove(zc){
    translate([0,0,zc])
    rotate_extrude(convexity=6)
        polygon([[R_FLOOR, 0],
                 [R_OUT+2,  V_DEPTH+2],
                 [R_OUT+2, -V_DEPTH-2]]);
}

// nipple pocket (drops in from the top) + radial wire escape slot
module cable_anchor(zc, ang){
    rotate([0,0,ang]){
        translate([R_NIP,0,zc-NIP_H/2])
            cylinder(d=NIP_D, h=H_TOT);              // open to top face
        // slot half-height != V_DEPTH so its top edge doesn't land on
        // the groove mouth rim (CGAL coincident-face trap)
        translate([R_NIP-1, -SLOT_W/2, zc-SLOT_H/2])
            cube([R_OUT-R_NIP+3, SLOT_W, SLOT_H]);
    }
}

module drum(){
    difference(){
        cylinder(r=R_OUT, h=H_TOT);

        v_groove(ZC1);
        v_groove(ZC2);

        cable_anchor(ZC1,   0);
        cable_anchor(ZC2, 180);

        horn_arms();

        translate([0,0,-1]) cylinder(d=BORE_D, h=H_TOT+2);

        // retaining slots: M3 from top into whichever horn hole lines up
        if(SHOW_SLOTS)
            for(a=[0,90,180,270]) rotate([0,0,HORN_ROT+a])
                hull(){
                    translate([ 6,0,Z_POCK]) cylinder(d=SCREW_D, h=H_TOT);
                    translate([12,0,Z_POCK]) cylinder(d=SCREW_D, h=H_TOT);
                }
    }
}

// coupon to test the trimmed-horn fit before printing the whole drum
module fitcheck(){
    h = Z_POCK + 2.0;
    difference(){
        cylinder(r = HORN_TIP/2 + 3, h = h);
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
