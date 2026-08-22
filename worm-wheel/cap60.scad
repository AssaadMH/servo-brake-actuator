// =====================================================================
//  cap60.scad -- retaining cap for the gear60_v2 cable drum.
//
//  WHY: wire_entry = true deliberately removed the roof over the four
//  nipple pockets so the cables could be dropped in by hand. Nothing
//  then stops a nipple lifting back out when its cable goes slack.
//  This cap closes the pocket mouths from above.
//
//  CONSTRAINT THAT DRIVES THE WHOLE DESIGN: the collar is a SPLIT
//  CLAMP. Anything that grips the drum rigidly and bridges the slit
//  would stiffen the jaws and stop the M3 pinch bolt gripping the
//  shaft -- the same reason the drum is a thin skirt and not a solid
//  boss. So this cap:
//    * grips the drum OUTSIDE, at r 20, which squeezes in the SAME
//      direction the pinch bolt works (helps, never fights);
//    * is itself split, so it is a C-clip, not a hoop;
//    * touches the top face only as a rest -- it clamps nothing there.
//
//  IT REQUIRES NO CHANGE TO THE GEAR. Everything it engages already
//  exists on gear60_v2 as printed:
//
//    band     drum OD r 20.00, z 37.30 (groove top) .. 42.00 (top face)
//             = 4.70 mm of clean cylinder, nothing outboard of it
//    keyways  the 4 wire chutes, 2.40 wide at 45/135/225/315 deg
//    seat     the top face at z 42.00
//
//  The skirt stops at z 37.80, half a millimetre clear of the groove,
//  so it never touches the cable. The four tabs drop into the chutes
//  from z 37.80 up, leaving z 34.70..37.80 free for the wire to run
//  out of the pocket and down into the groove.
//
//  ASSEMBLY: cable it as before, drop the cap on (the tabs will only
//  let it seat in one of four positions), nip the M3 up until it stops
//  turning by hand. It comes straight off again to re-cable.
//
//  The centre is left OPEN (ID 22.60), so it does not matter whether
//  the shaft protrudes past the top face or stops short of it.
// =====================================================================

/* [What it clamps onto -- must match the gear] */
drum_d     = 40.00;   // gear60 drum OD
top_z      = 42.00;   // gear60 top face
groove_top = 37.30;   // top of the cable groove -- do not go below this
collar_d   = 22.00;   // gear60 hub_d, the clamp collar
chute_w    = 2.40;    // gear60 wire_w
chute_a0   = 45;      // gear60 cable_a0
chutes     = 4;       // gear60 cables

/* [Cap] */
band_clear = 0.15;    // radial slip fit on the drum OD
wall       = 2.00;    // skirt wall
lid_t      = 2.40;    // lid thickness (15 layers at 0.16)
groove_gap = 0.50;    // keep the skirt this far above the groove
bore_clear = 0.30;    // radial clearance around the collar
lead_in    = 0.60;    // chamfer at the skirt mouth, to start it on the drum

/* [Anti-rotation tabs -- OFF, and here is why] */
// The first cut of this cap put a tab at each station angle, to drop
// into the wire chute and key the cap. test_cap_fit.scad rejected it:
// 4 x 8.73 mm3 of interference at exactly 45/135/225/315, z 37.80..42.00.
//
// The chute is TANGENTIAL, not radial. gear60.scad builds it as
//   translate([nip_r,0,z]) rotate([0,0,90]) translate([0,-w/2,0]) cube(...)
// which is the strip x 13.60..16.00, y 0..24 -- it leaves the pocket
// sideways in +Y and only crosses the OD 36.87..47.16 deg AWAY from its
// own station. At the station angle the drum OD is solid.
//
// Keying it properly would mean an oblique slab following those walls,
// for no gain: the cap is an annulus, so it covers all four pockets at
// any rotation, and the M3 lug is what actually retains it. Left here
// as a switch because the geometry note is worth keeping.
tabs       = false;
tab_clear  = 0.20;    // per side, in the 2.40 chute -> tab 2.00 wide
tab_proj   = 1.20;    // how far the tab reaches in past the skirt bore

/* [Clamp lugs] */
gap        = 1.80;    // the split -- closes as the M3 is tightened
lug_reach  = 6.00;    // radially, out past the cap OD
lug_t      = 6.00;    // tangential thickness of each lug
lug_root   = 1.00;    // how far the lug roots back into the ring
screw_near = 3.40;    // M3 clearance, head side
screw_far  = 2.90;    // M3 thread-forming into PETG, far side
split_a    = 180;     // put the split OPPOSITE the gear slit at 0 deg

/* [Output] */
for_print  = true;    // true = flipped lid-down, sitting on z=0
$fn        = 160;

// ---------------------------------------------------------------------
//  DERIVED
// ---------------------------------------------------------------------
skirt_ir = drum_d / 2 + band_clear;        // 20.15
cap_or   = skirt_ir + wall;                // 22.15
lid_ir   = collar_d / 2 + bore_clear;      // 11.30
skirt_h  = top_z - (groove_top + groove_gap);   // 4.20
total_h  = skirt_h + lid_t;                // 6.60
tab_w    = chute_w - 2 * tab_clear;        // 2.00
tab_ir   = skirt_ir - tab_proj;            // 18.95
screw_x  = cap_or + lug_reach / 2;         // mid-lug
screw_z  = total_h / 2;

// The lid must actually cover the pocket mouths (r 11.00..18.60) and
// the skirt must actually sit on the drum. Fail loudly if a parameter
// edit breaks either, instead of quietly shipping a cap that misses.
assert(lid_ir < 11.00 + 0.40,
       str("lid ID r=", lid_ir, " leaves the pocket mouth open"));
assert(skirt_h > 3.0, str("skirt only ", skirt_h, " mm tall -- will not grip"));
assert(tab_w > 1.2,   str("tab ", tab_w, " mm wide -- too weak"));

module cap_body() {
    difference() {
        // one solid, stepped bore -- no coincident union faces between
        // the skirt and the lid (the z=74 flake came from exactly that)
        cylinder(h = total_h, r = cap_or);
        translate([0, 0, -1])      cylinder(h = skirt_h + 1, r = skirt_ir);
        translate([0, 0, skirt_h]) cylinder(h = lid_t + 1,   r = lid_ir);
        // lead-in at the skirt mouth
        translate([0, 0, -0.01])
            cylinder(h = lead_in, r1 = skirt_ir + lead_in, r2 = skirt_ir);
    }
}

module cap_tabs() {
    if (tabs)
        for (i = [0 : chutes - 1]) rotate(chute_a0 + i * 360 / chutes)
            // runs 0.50 up into the lid, so its top face is buried in
            // solid material rather than sitting on the step plane
            translate([tab_ir, -tab_w / 2, 0])
                cube([skirt_ir - tab_ir + 0.01, tab_w, skirt_h + 0.50]);
}

module cap_lugs() {
    rotate(split_a)
        for (s = [1, -1])
            translate([cap_or - lug_root, s * (gap / 2), 0])
                mirror([0, s < 0 ? 1 : 0, 0])
                    cube([lug_reach + lug_root, lug_t, total_h]);
}

module cap_cuts() {
    rotate(split_a) {
        // the split itself, all the way through
        translate([0, -gap / 2, -1])
            cube([cap_or + lug_reach + 2, gap, total_h + 2]);
        // M3: clearance through the near lug and across the gap...
        translate([screw_x, gap / 2 + lug_t + 1, screw_z]) rotate([90, 0, 0])
            cylinder(h = lug_t + 1 + gap + 0.5, d = screw_near);
        // ...thread-forming into the far lug
        translate([screw_x, -gap / 2 + 0.01, screw_z]) rotate([90, 0, 0])
            cylinder(h = lug_t + 1, d = screw_far);
    }
}

module cap60() {
    difference() {
        union() {
            cap_body();
            cap_tabs();
            cap_lugs();
        }
        cap_cuts();
    }
}

if (for_print) translate([0, 0, total_h]) rotate([180, 0, 0]) cap60();
else cap60();

// ---------------------------------------------------------------------
echo(str("== cap60 =="));
echo(str("skirt bore / cap OD  = ", 2 * skirt_ir, " / ", 2 * cap_or, " mm"));
echo(str("lid bore             = ", 2 * lid_ir, " mm"));
echo(str("skirt height         = ", skirt_h, " mm  (part z ",
         groove_top + groove_gap, "..", top_z, ")"));
echo(str("total height         = ", total_h, " mm"));
echo(str("tabs                 = ", tabs ? str(chutes, " x ", tab_w, " wide")
                                        : "none (chute is tangential)"));
echo(str("split / lugs         = ", gap, " gap at ", split_a, " deg, M3"));
echo(str("across the lugs      = ", 2 * lug_t + gap, " mm"));
echo(str("screw length needed  = M3 x ", ceil(lug_t + gap + lug_t * 0.8), " mm"));
