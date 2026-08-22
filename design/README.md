# Servo brake-cable drum — TD-8130MG  (rev B)

Pulls **two bicycle brake cables equally**, 70 mm of cable travel over 180° of servo rotation.
Ø47.36 × 19.50 mm. Sliced and ready to print.

## Print these

| File | Profile | Time | PLA |
|---|---|---|---|
| `horn_fitcheck.gcode` | gauge — 0.25 mm, 3 walls, 15 % | 31 m | 6.6 g |
| `servo_brake_drum.gcode` | structural — 0.15 mm, 5 walls, 55 % | 3 h 35 m | 26.0 g |

**Print `horn_fitcheck.gcode` first.** It is only the horn pocket. Push your black star horn into
it — snug, no rotational play. Slop there becomes brake slop later.

If it doesn't fit, measure the horn and edit these four lines at the top of the `.scad`, then
re-render and re-slice:

```
HORN_TIP   = 40.0;   // tip-to-tip across one pair of arms
HORN_ARM_W =  7.0;   // arm width, near the tip
HORN_T     =  4.0;   // arm thickness
HORN_BOSS  = 14.0;   // centre boss diameter
```

`CLR = 0.25` is the per-side clearance — 0.15 if your printer runs loose, 0.35 if it won't go on.

## Everything else in the folder

| File | What |
|---|---|
| `servo_brake_drum.scad` | parametric source, all knobs at the top |
| `servo_brake_drum.stl` / `horn_fitcheck.stl` | meshes — watertight, 1 shell, 0 non-manifold |
| `n2_pla_structural.ini` / `n2_pla_gauge.ini` | PrusaSlicer configs for the N2 |
| `check_stl.py` / `check_gcode.py` | verifiers (manifold + bed extents / E mode / G29) |
| `render_stl.py` / `make_sheet.py` | software renderer → `DRUM_overview.png` |
| `design.html` | the full illustrated spec sheet |

## Rebuilding after a change

```
set PART = "drum" (or "fit" / "cut") in the .scad, then:

C:\Users\HP\lidar_box\tools\openscad-2021.01\openscad.exe -o servo_brake_drum.stl servo_brake_drum.scad
prusa-slicer-console.exe --export-gcode --load n2_pla_structural.ini -o servo_brake_drum.gcode servo_brake_drum.stl
python check_stl.py servo_brake_drum.stl
python check_gcode.py servo_brake_drum.gcode
```

Three traps, all of which bit me here:

- Don't pass `-D` on the PowerShell command line — edit the knob in the file instead. If you script
  a temp copy, write it with `Set-Content -Encoding ascii`; `utf8` adds a BOM and OpenSCAD dies with
  *"Parser error: syntax error, line 1"*.
- **OpenSCAD's STL lands on disk seconds after the process exits.** Verify too quickly and you read
  the *previous* file and get a false confirmation. Check the timestamp.
- CGAL saying `Simple: yes` does not guarantee a clean STL. Run `check_stl.py`.

## What goes together, in order

1. Print the coupon, check the fit on your horn.
2. Screw the **stock star horn onto the servo** with its factory centre screw. That joint carries all
   30 kg·cm — the printed part never touches the spline.
3. Drop the drum over the horn. The star pocket underneath swallows it, rotated 45° from the nipples.
4. Retain with 2–4 M3 screws through the top slots, down into whichever horn holes line up.
   The slots run r = 8…19 mm so any hole pattern works.
5. Load the cables: nipple down its Ø6.6 hole from the top face, wire out sideways into its V.
   Defaults suit **flat-bar / MTB** barrels (6.6 × 8.0). For road pear nipples: `NIP_D = 7.6; NIP_H = 5.0`.

## Why it's shaped like this

- **V-sheaves, not square grooves.** A square groove leaves the flange above it hanging as a 3 mm
  cantilever ring in mid-air — the slicer flagged it as a collapsing overhang. 45° walls hold
  themselves up. Bonus: with the V apex at `R_EFF − CABLE_D/2`, the cable wedges itself at exactly
  the design radius.
- **Ø14.5 bore straight through**, same as the horn boss. A smaller bore leaves an unsupported ring
  at the pocket ceiling with nothing under it to print onto.
- **Nipples 180° apart** so the two ~66 N cable tensions form a couple that cancels, instead of
  adding into a 132 N side load on the servo's output bearing.

## Force budget — read this

| | |
|---|---|
| Servo torque | ~30 kg·cm |
| Cable centreline radius | 22.28 mm |
| Total pull | ~13.5 kg |
| **Per cable** | **~6.7 kg (66 N)** |

6.7 kg is a firm hand squeeze — **enough to pull a brake lever at the handlebar**, which is what a
70 mm stroke implies. **Not** enough to drive a caliper directly (a caliper wants 15–25 kg but only
~15 mm of travel).

If it's weak, shorten the stroke: `STROKE = 35` halves the drum and doubles the pull to ~13 kg per
cable. Every other dimension derives from that one number.

## You still need cable housing stops

This part only pulls the inner wire. The outer housing must be anchored to the aluminum plate at a
fixed point, aimed tangentially at each groove level. Without those two stops the housing just
compresses and nothing moves. **Not designed yet.**

## PLA caveat

PLA creeps under sustained load and softens near 55 °C. If this holds the brake applied for long
stretches, or lives in a closed enclosure, re-slice in PETG — same geometry, no changes.
