// =====================================================================
//  gear60.scad  --  involute gear, 7 mm bore, split clamping hub
//  Replacement for the white worm-wheel in the Bosch window-lift motor.
//
//  Original: 72 teeth (counted by DFT off the photos), tip dia 59.2 mm
//  measured -> module = 59.2 / 74 = 0.800 CONFIRMED.
//
//  DEFAULTS reproduce the original:
//      tip (outside) diameter = 59.20 mm
//      whole tooth height     =  2.00 mm
//      bore                   =  7.00 mm (+clearance)
//
//  Set z=73 for a literal 60.00 mm tip -- but that shifts the worm
//  centre distance by 0.4 mm and will bind in the stock housing.
//
//  Worm: single start, 10.00 mm outside dia -> pitch dia 8.40 mm
//        lead angle = atan(starts * m_x / d1) = 5.4403 deg
//        => wheel helix angle = 5.4403 deg, RIGHT hand (assumed)
// =====================================================================

/* [Gear teeth] */
// AXIAL module of the worm = TRANSVERSE module of this wheel. This is the
// quantity that must match the worm, and it is the one that was measured
// (59.2 tip / 74 = 0.800). Do not confuse it with the normal module,
// which is derived below as m_x * cos(helix).
m_x            = 0.8;
// number of teeth (72 = original; 73 -> tip dia exactly 60.00 when spur)
z              = 72;
// normal pressure angle (deg)
alpha_n        = 20;
// addendum factor  (tooth height above pitch circle = add_f * m_x)
add_f          = 1.00;
// dedendum factor  (below pitch circle = ded_f * m_x)
// 1.5 -> whole depth = 2.5*0.8 = 2.00 mm exactly
ded_f          = 1.50;
// helix angle (deg) = worm lead angle. 0 = spur.
//   helix = atan(starts * m_x / (worm_OD - 2*m_x))
helix          = 5.4403;
// helix hand -- MUST match the worm. A right-hand worm looks like an
// ordinary screw: its thread rises to the right on the near side.
hand           = "right";
// backlash removed from tooth thickness, per flank (mm)
backlash       = 0.06;

/* [Hub style] */
// "clamp" = split hub + M3 pinch bolt  (grips a SMOOTH shaft, recommended)
// "grub"  = 2 radial M3 grub screws
// "plain" = bore only
hub_style      = "clamp";

/* [Body] */
face_width     = 10.0;   // toothed gear thickness
bore_d         = 7.0;    // nominal shaft bore
bore_clear     = 0.20;   // clearance in the gear body (non-gripping part)
hub_d          = 22.0;   // boss around the bore
hub_ext        = 12.0;   // hub sticking out above the gear face
rim_wall       = 3.0;    // solid material under the tooth roots
web_t          = 3.0;    // thickness of the central web
recess         = true;   // recess the web on both faces (saves material)
chamfer        = 0.4;    // tip chamfer on both faces (0 = off)

/* [Split clamping hub] */
// The clamp section grips, so it runs tighter than the body bore.
clamp_clear    = 0.10;   // clearance in the clamped section
slit_w         = 1.20;   // slit width -- must be able to close onto the shaft
slit_relief_d  = 3.00;   // stress-relief round at the root of the slit
ear_x          = 12.0;   // centre of the ear boss, from the axis
ear_w          = 13.0;   // ear width across the slit
pinch_d        = 3.40;   // M3 clearance, near jaw
pinch_head_d   = 6.40;   // socket-head counterbore
pinch_head_t   = 3.40;
// far jaw: "insert" = M3 heat-set, "nut" = hex trap, "tap" = threaded plastic
pinch_far      = "insert";

/* [Grub screw -- only used when hub_style = "grub"] */
grub_screw     = true;
// "insert" = M3 brass heat-set insert  (strongest, recommended)
// "tap"    = tap / thread-form M3 straight into the plastic
// "nut"    = hex pocket for a real M3 nut
grub_mode      = "insert";
grub_count     = 2;      // 2 screws grip a smooth shaft far better than 1
grub_spread    = 120;    // angle between screws (deg)
grub_angle0    = 0;      // rotate the whole screw group (deg)
thru_d         = 3.2;    // M3 clearance, runs from the seat down to the bore
insert_d       = 4.0;    // heat-set insert outside dia (typical M3: 4.0-4.2)
insert_depth   = 5.0;    // how deep the insert sits
tap_d          = 2.5;    // tap drill for M3 in plastic
nut_af         = 5.6;    // M3 nut across-flats + clearance
nut_t          = 2.6;    // M3 nut thickness + clearance

/* [Brake cable drum] */
// 4 road brake cables, pear nipples, pulled together, ~10 mm stroke.
// The drum is a thin SKIRT tied to the slim clamp collar by a web -- a
// solid dia-40 boss would be 10.8x stiffer to close (wall 7.45 -> 16.45,
// bending goes as t^3) and the M3 pinch bolt could never grip.
drum           = true;
drum_d         = 40.0;   // cable drum outside dia
drum_wall      = 3.5;    // skirt wall thickness
drum_web_t     = 3.0;    // web tying the skirt to the clamp collar
groove_w       = 2.6;    // cable groove width
groove_dp      = 1.0;    // cable groove depth  -> floor at r 19.0
groove_z       = 16.0;   // groove centre height
cables         = 4;      // number of anchor stations
cable_a0       = 45;     // first station angle -- keeps them off the slit at 0
nip_d          = 7.6;    // pear nipple pocket dia (7.0 head + clearance)
nip_r          = 14.8;   // pocket centre radius; leaves 1.40 mm wall at the OD
nip_depth      = 9.0;    // pocket depth down from the top face
wire_w         = 2.4;    // wire slot width (1.6 wire + clearance)
boss_wall      = 2.6;    // material around each nipple pocket
// LOADING ROUTE. false = the wire slot is a closed tunnel at groove level,
// so the only way in is to thread the free end of the cable through it from
// the outside and pull the nipple down the pocket -- which is why the first
// build could not be cabled by hand. true = the same slot runs on up to the
// top face, making an open chute: drop the nipple in, let the wire fall
// sideways into the notch, done. The nipple still cannot escape -- it is
// Ø7 against a 2.4 mm gap -- and the load is still taken by the two lands
// either side of the slot, which is where it was taken before.
wire_entry     = true;

/* [Optional] */
lighten_holes  = 0;      // number of lightening holes in the web (0 = none)
lighten_d      = 7.0;

/* [Quality] */
flank_steps    = 14;     // involute points per flank
$fn            = 160;

// ---------------------------------------------------------------------
//  DERIVED
// ---------------------------------------------------------------------
alpha_t = atan(tan(alpha_n) / cos(helix));      // transverse pressure angle
m_t     = m_x;                                  // transverse == worm axial
m_n     = m_x * cos(helix);                     // normal module (derived)
r_p     = z * m_t / 2;                          // pitch radius
r_b     = r_p * cos(alpha_t);                   // base radius
// Worm-gearing convention: tooth depth is referenced to the AXIAL module,
// not the normal one. At helix = 0 the two coincide, so this is a no-op
// for the spur variant.
r_a     = r_p + add_f * m_x;                    // tip radius
r_f     = r_p - ded_f * m_x;                    // root radius
depth   = r_a - r_f;                            // whole tooth height

// involute polar angle at radius r, in DEGREES
function inv_deg(a) = tan(a) * 180 / PI - a;
function theta(r)   = inv_deg(acos(min(1, r_b / r)));

// half tooth angular width referenced through the involute
bl_ang  = backlash / r_p * 180 / PI;            // backlash as an angle
beta    = 90 / z + inv_deg(alpha_t) - bl_ang;

function flank(r) = beta - theta(r);

r_start = max(r_b, r_f) + 0.001;                // involute is undefined below r_b
r_in    = r_f * 0.90;                           // tuck inside the root disc

function fr(i) = r_start + (r_a - r_start) * i / flank_steps;

tooth_pts = concat(
    [ [ r_in * cos(-flank(r_start)), r_in * sin(-flank(r_start)) ] ],
    [ for (i = [0 : flank_steps]) let (r = fr(i), a = -flank(r))
        [ r * cos(a), r * sin(a) ] ],
    [ for (i = [flank_steps : -1 : 0]) let (r = fr(i), a = flank(r))
        [ r * cos(a), r * sin(a) ] ],
    [ [ r_in * cos(flank(r_start)), r_in * sin(flank(r_start)) ] ]
);

module gear_2d() {
    union() {
        circle(r = r_f);
        for (i = [0 : z - 1]) rotate(i * 360 / z) polygon(tooth_pts);
    }
}

// Twist needed to realise the helix over the face width. OpenSCAD's twist
// is CLOCKWISE-positive seen from +Z, so a right-hand helix needs a
// negative value.
hand_sign = (hand == "left") ? 1 : -1;
twist = hand_sign * face_width * tan(helix) / r_p * 180 / PI;

// A small twist angle would otherwise bottom out at 2 slices, leaving the
// helical flank as two straight bands. Drive the slice count off the face
// width instead, so the flank stays smooth at any helix angle.
n_slices = (helix == 0) ? 1 : max(8, ceil(face_width / 0.5));

module gear_body() {
    linear_extrude(height = face_width, twist = twist,
                   slices = n_slices, convexity = 12)
        gear_2d();
}

// ---------------------------------------------------------------------
//  CUTS
// ---------------------------------------------------------------------
module web_recess() {
    // annular pocket between hub and rim, on both faces. With the drum
    // fitted the pocket has to start OUTSIDE the skirt, otherwise the
    // skirt would be bridging over a void on the top face.
    r_out = r_f - rim_wall;
    r_ins = drum ? drum_d / 2 : hub_d / 2;
    if (recess && r_out > r_ins + 1) {
        pocket = (face_width - web_t) / 2;
        for (zz = [-0.01, face_width - pocket + 0.01])
            translate([0, 0, zz])
                difference() {
                    cylinder(h = pocket, r = r_out);
                    translate([0, 0, -1]) cylinder(h = pocket + 2, r = r_ins);
                }
    }
}

module tip_chamfers() {
    if (chamfer > 0) {
        // conical cut at both faces, starting just below the root circle
        translate([0, 0, -0.01])
            difference() {
                cylinder(h = chamfer + 0.02, r = r_a + 1);
                cylinder(h = chamfer + 0.02, r1 = r_a - chamfer, r2 = r_a + 0.5);
            }
        translate([0, 0, face_width - chamfer - 0.01])
            difference() {
                cylinder(h = chamfer + 0.02, r = r_a + 1);
                cylinder(h = chamfer + 0.02, r1 = r_a + 0.5, r2 = r_a - chamfer);
            }
    }
}

// Radial screws go through the EXTENDED part of the hub, above the gear
// face. That keeps them clear of the web and the teeth, and the seat is
// reachable with a hex key once the gear is on the shaft.
module grub_holes() {
    r_hub = hub_d / 2;
    zc    = (hub_ext > 0) ? face_width + hub_ext / 2 : face_width / 2;
    for (i = [0 : grub_count - 1])
        rotate(grub_angle0 + i * grub_spread)
            translate([0, 0, zc]) rotate([0, 90, 0]) {
                // shank hole, from the axis out through the hub wall
                cylinder(h = r_hub + 0.5,
                         d = (grub_mode == "tap") ? tap_d : thru_d);
                // seat for the insert / nut, opening at the hub surface
                if (grub_mode == "insert")
                    translate([0, 0, r_hub - insert_depth])
                        cylinder(h = insert_depth + 0.5, d = insert_d);
                if (grub_mode == "nut")
                    translate([0, 0, r_hub - nut_t])
                        cylinder(h = nut_t + 0.5, d = nut_af / cos(30), $fn = 6);
            }
}

// --- split clamping hub -------------------------------------------------
// The hub is a C in cross-section, opening towards +X. A radial slit at
// y = 0 lets the two jaws close onto the shaft when the M3 pinch bolt is
// tightened. The slit stops at the gear face and ends in a round relief
// so there is no sharp crack starter at its root.
ear_reach = ear_x + ear_w / 2;

// Stadium-shaped pad so the bolt head and the insert both land on FLAT,
// parallel faces at exactly y = +/- ear_w/2. A plain hull() onto the hub
// would still be on its tangent line at x = ear_x and leave a skin over
// the counterbore.
module clamp_ear_2d() {
    union() {
        circle(d = hub_d);
        hull() {
            translate([ear_x,      0]) circle(d = ear_w);
            translate([hub_d / 4,  0]) circle(d = ear_w);
        }
    }
}

module clamp_ear() {
    translate([0, 0, face_width]) linear_extrude(hub_ext) clamp_ear_2d();
}

// --- brake cable drum ---------------------------------------------------
// Skirt + web, sitting on the gear face and topping out flush with the
// clamp collar, so overall height stays at 22.
module drum_body() {
    if (drum) {
        r_o = drum_d / 2;
        // The drum lands on the gear face, so the skirt/web/boss BOTTOMS
        // are coplanar with the gear TOP -- three coincident faces in one
        // union. That is a degeneracy waiting to happen: at z=74 it threw
        // off a 6-triangle zero-volume flake at z=10.00, x=16.50 (a second
        // shell, genus 12 instead of 13), while z=72/73/75/76 came out
        // clean. Sink the drum 0.01 into the gear -- buried inside solid
        // material, volume unchanged to 0.01 mm3 -- and every tooth count
        // renders as one shell. Heights carry the same +eps so the top
        // face stays at exactly face_width + hub_ext = 22.
        eps = 0.01;
        translate([0, 0, face_width - eps]) {
            difference() {                       // the skirt itself
                cylinder(h = hub_ext + eps, r = r_o);
                translate([0, 0, -1])
                    cylinder(h = hub_ext + 2, r = r_o - drum_wall);
            }
            cylinder(h = drum_web_t + eps, r = r_o);   // web out to the skirt

            // Local bosses at each cable station. Above the web the gap
            // between collar and skirt is open air, so without these the
            // nipple pocket would not be a socket at all -- just a slot
            // the nipple sits loose in. Each boss also ties the skirt
            // back to the collar.
            for (i = [0 : cables - 1]) rotate(cable_a0 + i * 360 / cables)
                intersection() {
                    cylinder(h = hub_ext + eps, r = r_o);
                    translate([nip_r, 0, 0])
                        cylinder(h = hub_ext + eps, d = nip_d + boss_wall * 2);
                }
        }
    }
}

module drum_cuts() {
    if (drum) {
        r_o = drum_d / 2;
        // cable groove all the way round
        translate([0, 0, groove_z - groove_w / 2])
            difference() {
                cylinder(h = groove_w, r = r_o + 1);
                cylinder(h = groove_w, r = r_o - groove_dp);
            }
        top_z  = face_width + hub_ext;
        slot_z = groove_z - groove_w / 2;        // floor of the wire notch
        slot_h = wire_entry ? (top_z - slot_z + 1) : groove_w;
        for (i = [0 : cables - 1]) rotate(cable_a0 + i * 360 / cables) {
            // pear-nipple pocket, loaded from the top face
            translate([nip_r, 0, top_z - nip_depth])
                cylinder(h = nip_depth + 1, d = nip_d);
            // wire slot: leaves the pocket tangentially at groove level,
            // and (wire_entry) carries on up to the top face as an open
            // chute so the cable can be dropped in from above.
            translate([nip_r, 0, slot_z]) rotate([0, 0, 90])
                translate([0, -wire_w / 2, 0])
                    cube([r_o + 4, wire_w, slot_h]);
        }
    }
}

module clamp_cuts() {
    y0 = ear_w / 2;                    // the flat bolt faces
    zc = face_width + hub_ext / 2;

    // The slit must break the SKIRT too, or the drum welds the jaws shut.
    reach = (drum ? max(ear_reach, drum_d / 2) : ear_reach) + 2;

    // the slit
    translate([0, -slit_w / 2, face_width])
        cube([reach, slit_w, hub_ext + 1]);
    // rounded stress relief along the root of the slit
    translate([0, 0, face_width]) rotate([0, 90, 0])
        cylinder(h = reach, d = slit_relief_d);

    // pinch bolt: axis along +Y, crossing the slit inside the ear.
    // local +z maps to global +y here, so all depths are from the flats.
    translate([ear_x, 0, zc]) rotate([-90, 0, 0]) {
        // shank through the near jaw and across the slit
        translate([0, 0, -0.001]) cylinder(h = y0 + 1, d = pinch_d);
        // socket-head counterbore, opening on the +Y flat. With the drum
        // fitted this has to keep going out through the skirt, or there
        // is no way to reach the bolt with a hex key.
        translate([0, 0, y0 - pinch_head_t])
            cylinder(h = drum ? (drum_d / 2 + 2 - y0 + pinch_head_t)
                              : (pinch_head_t + 1),
                     d = pinch_head_d);
        // far jaw
        if (pinch_far == "tap")
            translate([0, 0, -y0 - 1]) cylinder(h = y0 + 1.001, d = tap_d);
        else
            translate([0, 0, -y0 - 1]) cylinder(h = y0 + 1.001, d = pinch_d);
        if (pinch_far == "insert")
            translate([0, 0, -y0 - 0.5])
                cylinder(h = insert_depth + 0.5, d = insert_d);
        if (pinch_far == "nut")
            translate([0, 0, -y0 - 0.5])
                cylinder(h = nut_t + 0.5, d = nut_af / cos(30), $fn = 6);
    }
}

module cuts() {
    // bore -- looser through the gear body, tighter where the clamp grips
    if (hub_style == "clamp") {
        translate([0, 0, -1])
            cylinder(h = face_width + 1.001, d = bore_d + bore_clear);
        translate([0, 0, face_width])
            cylinder(h = hub_ext + 1, d = bore_d + clamp_clear);
    } else {
        translate([0, 0, -1])
            cylinder(h = face_width + hub_ext + 2, d = bore_d + bore_clear);
    }
    web_recess();
    tip_chamfers();
    drum_cuts();
    if (hub_style == "clamp") clamp_cuts();
    if (hub_style == "grub" && grub_screw) grub_holes();
    if (lighten_holes > 0) {
        r_ring = ((r_f - rim_wall) + hub_d / 2) / 2;
        for (i = [0 : lighten_holes - 1])
            rotate(i * 360 / lighten_holes)
                translate([r_ring, 0, -1])
                    cylinder(h = face_width + 2, d = lighten_d);
    }
}

// ---------------------------------------------------------------------
module gear60() {
    difference() {
        union() {
            gear_body();
            // hub boss: survives the web recess and carries the clamp
            cylinder(h = face_width + hub_ext, d = hub_d);
            if (hub_style == "clamp") clamp_ear();
            drum_body();
        }
        cuts();
    }
}

gear60();

// ---------------------------------------------------------------------
echo(str("== gear60 =="));
echo(str("teeth z           = ", z));
echo(str("axial/transv m_x  = ", m_x, "   <-- must match the worm"));
echo(str("normal module m_n = ", m_n, " (derived)"));
echo(str("helix angle       = ", helix, " deg, ", hand, " hand"));
echo(str("twist over face   = ", twist, " deg"));
echo(str("pitch  dia        = ", 2 * r_p, " mm"));
echo(str("TIP    dia        = ", 2 * r_a, " mm   <-- original measured 59.20"));
echo(str("root   dia        = ", 2 * r_f, " mm"));
echo(str("tooth height      = ", depth, " mm   <-- 2.00 (0.2 deeper root than std)"));
echo(str("base   dia        = ", 2 * r_b, " mm"));
echo(str("circular pitch    = ", PI * m_t, " mm"));
echo(str("bore              = ", bore_d + bore_clear, " mm"));
echo(str("hub dia / total h = ", hub_d, " / ", face_width + hub_ext, " mm"));
echo(str("hub style         = ", hub_style));
if (hub_style == "clamp") {
    echo(str("clamp bore        = ", bore_d + clamp_clear, " mm"));
    echo(str("slit              = ", slit_w, " mm wide, out to r=", ear_reach,
             " (root circle is r=", r_f, ")"));
    echo(str("pinch bolt        = M3 at x=", ear_x, ", z=", face_width + hub_ext / 2,
             ", far jaw = ", pinch_far));
    echo(str("jaw wall at bore  = ", (hub_d - bore_d - clamp_clear) / 2, " mm"));
}
if (hub_style == "grub")
    echo(str("grub screws       = ", grub_count, " x M3 (", grub_mode, ")"));
