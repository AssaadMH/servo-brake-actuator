// =====================================================================
//  gear60_v3.scad  --  2026-08-14.  76 TEETH, full-height addendum.
//
//  User asked for "wider, teeth a little bigger, around 60.8 mm, 76 teeth".
//  With m_x = 0.8 locked by the worm, 60.8 is the PITCH diameter of a
//  76-tooth wheel -- the part measures 62.40 mm across the tooth tips.
//  (A 60.80 mm TIP diameter would be z=74; see gear60_d608.scad.)
//
//      z 74 -> 76      pitch dia 59.20 -> 60.80 mm   <- the "60.8"
//                      tip   dia 60.60 -> 62.40 mm   (add_f back to 1.00)
//                      root  dia 56.80 -> 58.40 mm   (ded_f 1.5)
//                      tooth ht   1.90 ->  2.00 mm   <- "a bit bigger"
//                      ratio     74:1  -> 76:1
//
//  *** WORM CENTRE DISTANCE MOVES +1.60 mm ***
//  Stock: (8.40 + 57.60)/2 = 33.00 mm.  Here: (8.40 + 60.80)/2 = 34.60 mm.
//  That is DOUBLE the +0.80 the v2 part needed.  Centre distance follows
//  the PITCH circle only, so truncating the tips does not buy any of it
//  back -- the housing (or the wheel shaft) has to move 1.60 mm.  This is
//  a deliberate housing modification, chosen with the numbers in hand.
//
//  Everything above the gear is UNCHANGED from gear60_v2, so cap60 still
//  fits: bore 8, hub_ext 32 (42 mm tall), groove_z 36, wire_entry open to
//  the top face, drum_d 40 clamped by the cap over z 37.80..42.00.
//
//  Inherited from gear60.scad: 20 deg normal pressure angle, 5.4403 deg
//  RIGHT-hand helix (re-derived automatically from the new pitch radius),
//  split clamp hub + M3 pinch bolt, 4-cable drum.
// =====================================================================

include <gear60.scad>

z          = 76;      // was 74  -> pitch dia 60.80, tip dia 62.40
add_f      = 1.000;   // was 0.875 on v2 -- full 2.00 mm tooth height again
bore_d     = 8.0;     // v2
hub_ext    = 32.0;    // v2 -> total height 42, cable stations +20
groove_z   = 36.0;    // v2
wire_entry = true;    // v2
