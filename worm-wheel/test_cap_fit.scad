// =====================================================================
//  test_cap_fit.scad -- does cap60 actually fit gear60_v2, or not?
//
//  Intersects the cap, sitting at its seat, with the REAL exported gear
//  mesh. Anything left over is interference. An empty result means it
//  drops on.
//
//  `use <>` imports modules only, not top-level geometry, so cap60()
//  arrives in USE orientation regardless of cap60.scad's for_print.
//
//  CONTROL: -D drop=1.5 sinks the cap into the cable groove, which MUST
//  come back non-empty. Without that the probe could be reporting
//  "clear" simply because it is looking at nothing.
//
//      openscad --backend=Manifold -o fit.stl test_cap_fit.scad
//      openscad --backend=Manifold -D drop=1.5 -o ctl.stl test_cap_fit.scad
// =====================================================================

seat = 37.80;    // where the skirt bottom lands on the part
drop = 0;        // control: push the cap this far down into the groove

use <cap60.scad>

intersection() {
    import("gear60_v2.stl", convexity = 12);
    translate([0, 0, seat - drop]) cap60();
}
