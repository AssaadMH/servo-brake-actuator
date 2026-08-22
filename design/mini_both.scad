// Combined print plate: full drum + fit coupon, side by side, one STL.
// Self-contained (no import booleans) so CGAL exports cleanly.

/* ---- horn (measured 2026-07-23, cross widened +0.5) ---- */
HORN_TIP   = 27.0;
HORN_ARM_W =  6.5;   // widened from 5.0 so the horn drops in
HORN_T     =  4.0;
HORN_BOSS  =  9.0;

/* ---- drive geometry ---- */
STROKE   = 44;
SWEEP    = 180;
CABLE_D  = 1.6;
V_DEPTH  = 2.2;
NIP_D = 6.6;
NIP_H = 8.0;

/* ---- fit & fasteners ---- */
CLR        = 0.25;
POCKET_CLR = 0.40;
SCREW_D    = 3.4;
SHOW_SLOTS = true;

$fn = 180;

/* ---- derived ---- */
D_EFF   = STROKE*360/(SWEEP*PI);
R_EFF   = D_EFF/2;
R_FLOOR = R_EFF - CABLE_D/2;
R_OUT   = R_FLOOR + V_DEPTH;
ZC1     = 9.5;
ZC2     = 15.5;
H_TOT   = 19.5;
Z_POCK  = HORN_T + POCKET_CLR;
BORE_D  = HORN_BOSS + 2*CLR;
SLOT_W  = CABLE_D + 0.6;
SLOT_H  = 2.6;
R_NIP   = 9.2;
HORN_ROT= 45;

module horn_arms(extra=0){
    w = HORN_ARM_W + 2*CLR + extra;
    l = HORN_TIP   + 2*CLR + extra;
    rotate([0,0,HORN_ROT])
        for(a=[0,90]) rotate([0,0,a])
            translate([-l/2,-w/2,-0.01]) cube([l,w,Z_POCK+0.01]);
}
module v_groove(zc){
    translate([0,0,zc])
    rotate_extrude(convexity=6)
        polygon([[R_FLOOR, 0],[R_OUT+2, V_DEPTH+2],[R_OUT+2,-V_DEPTH-2]]);
}
module cable_anchor(zc, ang){
    rotate([0,0,ang]){
        translate([R_NIP,0,zc-NIP_H/2]) cylinder(d=NIP_D, h=H_TOT);
        translate([R_NIP-1, -SLOT_W/2, zc-SLOT_H/2])
            cube([R_OUT-R_NIP+3, SLOT_W, SLOT_H]);
    }
}
module drum(){
    difference(){
        cylinder(r=R_OUT, h=H_TOT);
        v_groove(ZC1); v_groove(ZC2);
        cable_anchor(ZC1, 0); cable_anchor(ZC2, 180);
        horn_arms();
        translate([0,0,-1]) cylinder(d=BORE_D, h=H_TOT+2);
        if(SHOW_SLOTS)
            for(a=[0,90,180,270]) rotate([0,0,HORN_ROT+a])
                hull(){
                    translate([ 6,0,Z_POCK]) cylinder(d=SCREW_D, h=H_TOT);
                    translate([12,0,Z_POCK]) cylinder(d=SCREW_D, h=H_TOT);
                }
    }
}
module fitcheck(){
    h = Z_POCK + 2.0;
    difference(){
        cylinder(r = HORN_TIP/2 + 3, h = h);
        horn_arms();
        translate([0,0,-1]) cylinder(d=BORE_D, h=h+2);
    }
}

// --- layout: drum left, coupon right, ~14 mm gap so the brims don't merge ---
translate([-22,0,0]) drum();
translate([ 24,0,0]) fitcheck();
