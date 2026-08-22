// =====================================================================
//  gear60_d608.scad  --  gear60 with the TOOTHED diameter at 60.80 mm.
//
//  Supersedes the z=76 / 62.40 variant.  60.80 lands EXACTLY on a tooth
//  step, so no rounding is needed:
//
//      z 72 -> 74      tip dia 59.20 -> 60.80 mm   (+1.60, exact)
//                      pitch dia 57.60 -> 59.20 mm
//                      root dia  55.20 -> 56.80 mm  (ded_f 1.5)
//
//  *** WORM CENTRE DISTANCE MOVES +0.80 mm ***
//  Stock: (8.40 + 57.60)/2 = 33.00 mm.  Here: (8.40 + 59.20)/2 = 33.80 mm.
//  Half the shift of the 62.40 version, but still a housing change -- the
//  worm must move 0.80 mm away from the wheel axis (or the wheel shaft
//  moves the same amount).  0.80 mm of interference against a 2.00 mm
//  tooth height is still a jam, not just a tight mesh.
//
//  Everything else is inherited from gear60.scad: m_x 0.8, 20 deg normal
//  pressure angle, 5.4403 deg RIGHT-hand helix, clamp hub, 4-cable drum.
//  The helical twist is re-derived automatically from the new pitch radius.
// =====================================================================

include <gear60.scad>

z = 74;      // was 72 stock, 76 in the abandoned 62.40 variant
