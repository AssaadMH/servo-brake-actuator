// =====================================================================
//  gear60_v2.scad  --  the 2026-08-08 revision of the d608 part.
//
//  Four changes, all requested together:
//
//  1. TIP DIA 60.80 -> 60.60
//     Tooth count STAYS at 74. m_x = 0.8 cannot move (it is the worm's
//     axial module), and z only comes in 1.60 mm steps, so 60.60 is not
//     reachable by adding teeth. It is reached by TRUNCATING THE
//     ADDENDUM instead: add_f 1.000 -> 0.875 takes 0.10 mm off each
//     tooth tip.
//         tip dia   60.80 -> 60.60
//         pitch dia 59.20 -> 59.20   (UNCHANGED)
//         root dia  56.80 -> 56.80   (UNCHANGED)
//         tooth ht   2.00 ->  1.90
//     Because the pitch circle does not move, the worm centre distance
//     does not move either -- it stays at (8.40 + 59.20)/2 = 33.80, the
//     same +0.80 mm housing shift the d608 version already needed. This
//     change does not make that better OR worse; it only shaves the tips,
//     which if anything relieves tip interference slightly.
//
//  2. BORE 7 -> 8 mm
//     bore_d is the NOMINAL SHAFT size. The part comes out 8.20 through
//     the gear body and 8.10 in the clamp section, which then pinches
//     down onto a true 8.00 shaft. Jaw wall at the bore is still 6.95 mm.
//
//  3. CABLE STATIONS 20 mm HIGHER
//     The whole collar/drum grows: hub_ext 12 -> 32, so the part is
//     10 + 32 = 42 mm tall instead of 22. The groove goes with it,
//     groove_z 16 -> 36, and the nipple pockets stay 9 mm down from the
//     top face (z 33..42). The M3 pinch bolt rides at mid-collar, z = 26,
//     which now also clears the groove it used to share a height with.
//
//  4. AN ACTUAL WAY IN FOR THE CABLE
//     wire_entry = true (new in gear60.scad). The tangential wire slot no
//     longer stops at the groove -- it runs on up to the top face as an
//     open 2.4 mm chute. Drop the nipple down its pocket, let the wire
//     fall sideways into the notch, and it seats itself in the groove.
//     No more threading a free cable end through a blind tunnel.
//
//  WATCH: 4 cables x ~66 N now pull 36 mm above the gear face instead of
//  16 mm. That is a ~2.2x bigger overturning moment on an 8 mm shaft and
//  on the single pinch bolt. If the collar ever walks or cocks on the
//  shaft, that is why -- a second pinch bolt higher up is the fix.
// =====================================================================

include <gear60.scad>

z          = 74;      // unchanged from d608 -- pitch dia 59.20
add_f      = 0.875;   // 1.000 -> tip dia 60.60 instead of 60.80
bore_d     = 8.0;     // was 7.0
hub_ext    = 32.0;    // was 12.0  -> total height 42, cable stations +20
groove_z   = 36.0;    // was 16.0  -> follows the collar up
wire_entry = true;    // open the loading chute to the top face
