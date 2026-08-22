TWIN-CABLE BRAKE DRUM  -  TD-8130MG servo
=========================================
Everything here is ready for the Raise3D N2 in PLA.
Copy the .gcode files to the printer. No slicing needed.


STEP 1  ->  horn_fitcheck.gcode        31 min      6.6 g
            (picture: horn_fitcheck.png)

   A small disc with a star-shaped hole. Print it, then push
   your BLACK SERVO HORN into the star pocket.

     snug, no wobble   -> good, go to step 2
     loose or tight    -> STOP. Tell Claude. The pocket size
                          is the one dimension that was guessed
                          (typical 25T horn: 40 mm tip-to-tip,
                          7 mm arms, 4 mm thick, 14 mm boss).

   Do not print the drum until this fits. It is 3.5 hours.


STEP 2  ->  servo_brake_drum.gcode     3 h 35 m    26.0 g
            (picture: servo_brake_drum.png)

   The real part. O 47.36 x 19.50 mm.


ASSEMBLY
--------
1. Screw the stock star horn onto the servo, factory centre
   screw. That joint carries all 30 kg.cm - the printed part
   never touches the spline.
2. Drop the drum over the horn. The star pocket underneath
   swallows it (rotated 45 deg from the nipple holes).
3. Retain with 2-4 M3 screws through the slots in the top face,
   down into whichever horn holes line up.
4. Load the cables: barrel nipple down its 6.6 mm hole from the
   top face, wire out sideways into its V groove.
   Wind both the same direction.


STEP 3  ->  cable_stops_plate.gcode    4 h 07 m   36.2 g
            (pictures: cable_stops_plate.png
                       MOUNTING_LAYOUT.png)

   The cable housing stops. Without these the outer housing
   just squashes and the drum does nothing.

   One bed = everything for BOTH cables:
     2x POST   bolts to the aluminum plate
     2x BLOCK  the stop itself, slides up/down the post

   BEFORE YOU PRINT: measure your aluminum plate.
   You need at least 123 x 80 mm of plate around the
   servo shaft. If you have less, say so and the design
   can be made more compact.

   Hardware needed:
     4x M4 screws  -> tapped into the plate
     2x M4 x 30 bolt + nut + washers -> the height clamp

   Drill the plate per MOUNTING_LAYOUT.png. The two stops sit
   diagonally opposite each other, not mirrored - that is
   deliberate, it is what makes both cables pull together.

   Setting the height: slide each block until its cable lines
   up with its own V groove, then tighten the M4. Lower groove
   uses one stop, upper groove the other. They are 6 mm apart.


WATCH THE FIRST LAYER
---------------------
The start G-code is generic Marlin, not Raise3D's own profile.
It homes, heats, then draws a prime line along the front edge
of the bed before starting the part. Stay with it the first
time you run these.


ALSO HERE
---------
horn_fitcheck.stl / servo_brake_drum.stl
   the raw models, only if you would rather slice them
   yourself in ideaMaker

DRUM_overview.png
   all four views of the drum on one sheet

Full notes and the parametric source are one level up, in
C:\Users\HP\Desktop\01 - 3D PRINT\servo_brake_drum\   (README.md, design.html)
