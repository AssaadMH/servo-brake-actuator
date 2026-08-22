// Thin-slab sections of the real gear60_v3 mesh, tilted so the holes read.
zlo = 38.0; th = 4.0;
intersection() {
    import("gear60_v3.stl", convexity = 12);
    translate([-60, -60, zlo]) cube([120, 120, th]);
}
