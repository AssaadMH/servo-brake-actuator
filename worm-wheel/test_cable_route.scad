// =====================================================================
//  test_cable_route.scad -- can the cable actually be fitted, or not?
//
//  Sweeps the two loading motions as solids and intersects them with the
//  part. Anything left over is material standing in the way.
//
//     A = the NIPPLE dropping straight down its pocket from above
//         (Ø7.0 pear head, from the top face down to the pocket floor)
//     B = the WIRE falling sideways into the chute
//         (1.6 mm wire, from the top face down to the groove, running
//          radially out past the drum OD)
//
//  Render it: an EMPTY result means the route is clear. Re-render the
//  sandbox with wire_entry=false and it must come back NON-empty -- that
//  control is what proves the probe can actually see a blockage, instead
//  of just reporting "clear" because it is looking at nothing.
//
//  SANDBOX: `use <>` does NOT let -D reach the used file's variables, so
//  the part under test is a generated copy of gear60.scad with the v2
//  overrides appended (last assignment wins at file scope). Regenerate:
//      cp gear60.scad _v2_sandbox.scad
//      then append the same 6 lines that gear60_v2.scad sets.
// =====================================================================

use <_v2_sandbox.scad>

// --- v2 constants, mirrored from gear60_v2.scad ----------------------
face_width = 10.0;
hub_ext    = 32.0;
top_z      = face_width + hub_ext;   // 42
groove_z   = 36.0;
nip_r      = 14.8;
nip_depth  = 9.0;
cables     = 4;
cable_a0   = 45;
drum_r     = 20.0;

nip_head_d = 7.0;    // real pear nipple, 0.6 smaller than its Ø7.6 pocket
wire_d     = 1.6;    // real wire, 0.8 smaller than its 2.4 slot

module route_swept() {
    for (i = [0 : cables - 1]) rotate(cable_a0 + i * 360 / cables) {
        // A -- nipple falls down the pocket
        translate([nip_r, 0, top_z - nip_depth])
            cylinder(h = nip_depth, d = nip_head_d, $fn = 48);
        // B -- wire falls down the chute, from the top face to the
        //      groove centreline, spanning the pocket out past the OD
        translate([nip_r, 0, groove_z]) rotate([0, 0, 90])
            translate([0, -wire_d / 2, 0])
                cube([drum_r + 6, wire_d, top_z - groove_z]);
    }
}

intersection() {
    gear60();
    route_swept();
}
