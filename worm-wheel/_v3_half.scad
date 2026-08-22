// Vertical half-section of the real gear60_v3 mesh, cut on the XZ plane.
// Shows: rim wall under the tooth roots, web recess, full clamp collar,
// cable groove at z 36, nipple pocket depth, bore.
difference() {
    import("gear60_v3.stl", convexity = 12);
    translate([-60, -60, -1]) cube([120, 60, 60]);
}
