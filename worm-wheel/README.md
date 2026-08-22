# gear60 — 60 mm gear, Ø7 mm bore, 2.0 mm tooth height

Replacement for the white worm-wheel out of the Bosch window-lift motor
(`0130821xxx`) in the photos.

## Files

| File | What it is |
|---|---|
| `gear60.scad` | The parametric source — change everything here |
| `gear60_v2.scad` / `.stl` | ★ **CURRENT** — tip 60.60, bore 8, cable stations 20 mm higher, open cable chute. See [v2](#v2--gear60_v2scad). Print file `gear60_v2.gcode`. **Still needs the worm moved 0.8 mm.** |
| `cap60.scad` / `.stl` | ★ **Retaining cap** for the v2 drum — closes the open nipple pockets. Clamps on, needs no gear change. See [the cap](#the-retaining-cap--cap60scad). Print file `cap60.gcode` + one M3×14. |
| `test_cap_fit.scad` | Clash-checks the cap against the real exported gear mesh |
| `v2_profile.ini` | The PETG profile dumped out of the shipped v2 gcode — slice everything with this |
| `test_cable_route.scad` | Proves a cable can actually be fitted (needs a generated `_v2_sandbox.scad` — see [Re-generating](#re-generating)) |
| `gear60_drum4.stl` | Helical RH + 4-cable brake drum, the original 22 mm-tall part |
| `gear60_d608.scad` / `.stl` | Superseded by v2. Tip dia grown to 60.80 mm (z 74) — see [Bigger-OD variant](#bigger-od-variant--gear60_d608scad) |
| `gear60_d62.scad` | Superseded first pass at the above (z 76, tip 62.40). No STL. |
| `gear60_z72_m0.8_helical_RH.stl` | Plain wheel, helical 5.44° RH, no drum |
| `gear60_z72_m0.8_helical_LH.stl` | Same, left hand — if the worm turns out left-handed |
| `gear60_z72_m0.8_spur.stl` | Straight-cut fallback (helix 0) |
| `gear60_z72_m0.8_helical_RH_grub.stl` | Grub-screw hub instead of the clamp |
| `test_clamp.scad` | Geometric self-tests for the clamp (see below) |
| `preview_top/iso.png` | Renders |

Shaft is smooth, so the hub is a **split clamp with an M3 pinch bolt**.
See [The split clamping hub](#the-split-clamping-hub).

## What was measured from the photos

The rim was unwrapped into polar coordinates and the tooth frequency
extracted by DFT. The peak is unambiguous at **k = 72** across three
different sample radii (r = 840, 855, 870 px), so:

> **the original gear has 72 teeth.**

Teeth are fine-pitch, driven by the worm on the armature shaft. The
photos give no absolute scale, so the module was inferred from the tooth
count and then **confirmed by caliper** — see
[Module: CONFIRMED](#module-confirmed).

## The numbers — `gear60_z72_m0.8_helical_RH.stl`

Verified by re-reading the exported mesh, not from the script's own echo:

```
tip (outside) diameter   59.200 mm     <- matches the measured original
root diameter            55.200 mm
tooth height (whole)      2.000 mm
pitch diameter           57.600 mm
teeth                    72
axial module   m_x       0.80000       <- confirmed, 59.2 / 74
normal module  m_n       0.79640       <- derived, m_x * cos(helix)
helix angle              5.4403 deg    <- from the measured worm
helix hand               right (assumed - CHECK)
pressure angle           20°
circular pitch            2.513 mm
body bore                 7.20 mm  (7.0 + 0.20, non-gripping section)
clamp bore                7.10 mm  (7.0 + 0.10, this is what grips)
face width               10.00 mm
hub diameter             22.00 mm
total height             22.00 mm  (10 gear + 12 clamping hub)
slit                      1.20 mm wide, out to r = 18.5
jaw wall at the bore      7.45 mm
```

`ded_f = 1.5` is what buys the 2.00 mm depth — a standard 1.25 dedendum
would give 1.80 mm. On a worm drive a deeper root only adds tip
clearance, so this is safe either way.

Rebuild a z = 73 / Ø60.00 variant with `-D 'z=73'` if you ever want the
literal 60 mm for something else.

---

## The split clamping hub

The hub is a **C in cross-section**, 22 mm tall overall with 12 mm
projecting above the gear face. A 1.2 mm radial slit runs from the bore
out through the side, and an M3 socket-head pinch bolt pulls the two jaws
together. Friction round the whole shaft, no shaft modification needed.

```
   top view of the hub                side view
   ─────────────────────              ──────────
        ╭───────╮                     ┌────────┐  ← clamp hub, 12 mm
      ╭─┤ Ø7.1  ├─╮  ╔══╗       ══════┤        ├══════   z = 10..22
      │ │ bore  │ │══╣▓▓║ ear   teeth ▐└───┬──┘▌         z = 0..10
      ╰─┤       ├─╯  ╚══╝                Ø7.2 bore
        ╰───────╯     ↑
         ← slit →   M3 pinch bolt
         (1.2 mm)   crosses the slit
```

- Slit reaches **r = 18.5 mm**; the tooth roots start at r = 28 mm, so it
  never touches a tooth. The gear stays a full, unbroken 72-tooth ring —
  which is why the slit stops at the hub instead of running out through
  the rim the way a split pulley usually does.
- The slit root ends in a **Ø3 rounded relief** rather than a sharp
  corner. That is the crack starter on a printed part, so it gets a
  radius instead of an edge.
- The bolt seats land on **flat, parallel pads** (the stadium-shaped ear),
  not on the curved hub — Ø6.4 counterbore for the head on one side,
  Ø4.0 × 5 mm heat-set insert seat on the other.
- The clamp bore is **7.10 mm** while the gear body bore is 7.20 mm. The
  body section is deliberately looser so the clamp does the gripping and
  the gear still slides on easily.

### Why this beats the grub screws

Grub screws point-load two spots and dent the shaft; a clamp grips the
full circumference by friction. On a smooth shaft that is worth several
times the holding torque, and it does not chew up the shaft — so you can
still take it apart and reposition it.

### Fitting

1. Set the M3 insert in the ear (soldering iron ~200 °C for PETG, in
   slowly and straight).
2. Slide the gear on **with the bolt loose** — it should be a light slip
   fit. Do not force it; if it is tight, ream the bore rather than
   hammering, or raise `clamp_clear`.
3. Tighten the M3 gradually to roughly **1–1.5 Nm**. It will feel solid
   well before the 1.2 mm gap closes — the gap is *supposed* to stay
   partly open. If it bottoms out metal-to-metal before it grips, your
   bore printed oversize; drop `clamp_clear` to 0.05 and reprint.
4. Threadlock it. Car doors vibrate.

**Print it teeth-down, hub up.** That is not just about supports: the
C-section flexes circumferentially, so the bending stress runs *along*
the layers rather than trying to peel them apart. Printed on its side
this joint would delaminate at the back of the C.

### Verification

`test_clamp.scad` checks the things that are easy to get silently wrong,
each paired with a control probe that must give the opposite answer — a
probe that misses the part entirely would otherwise read as a pass:

| Test | Checks | Expect | Control | Expect |
|---|---|---|---|---|
| 1 | slit fully separates the jaws | empty | 2 | solid |
| 3 | head counterbore breaks through the flat | empty | 33 | solid |
| 4 | insert seat breaks through the far flat | empty | 44 | solid |
| 5 | ear stays clear of the tooth roots | empty | 55 | solid |

```bash
for T in 1 2 3 33 4 44 5 55; do "$OS" -D "TEST=$T" -o t.stl test_clamp.scad; done
```

All eight pass on the shipped geometry.

### Still want grub screws?

`hub_style = "grub"` gives 2 × M3 radial screws at 120° instead
(`gear60_z72_m0.8_helical_RH_grub.stl`). If you go that route, file two small flats
on the shaft where the tips land — otherwise it will spin under a stalled
worm.

---

## Module: CONFIRMED

Measured original tip diameter: **59.2 mm**, over the 72 teeth counted
from the photos.

```
m_n = OD / (z + 2) = 59.2 / 74 = 0.800   exactly
```

`m_n = 0.8` was an inference; it is now a measurement, and the two agree
to three decimal places. Tooth size is settled — **use the z = 72 file**.

That also means your "60 mm" was a rounded read of a 59.2 mm gear, and
"2 mm tooth height" of a standard 1.8 mm one (2.25 × 0.8). The shipped
`ded_f = 1.5` cuts the root 0.2 mm deeper than standard. That is
deliberate and safe on a worm drive — a deeper root only adds tip
clearance, it cannot cause interference. The addendum, which is what
actually sets the mesh, is fixed by the 59.2 mm tip diameter.

Derived, all now confirmed:

```
teeth            72        module      0.80
tip diameter     59.20     pitch dia   57.60
root diameter    55.20     base dia    54.13
circular pitch    2.513    ratio       72:1 with a single-start worm
```

## Helix: RESOLVED

Worm measured: **single start, 10.00 mm outside diameter.**

The lead angle is defined on the worm's **pitch** diameter, not its
outside diameter, and it uses the **axial** module:

```
d1    = worm_OD - 2*m_x       = 10.00 - 1.60      = 8.40 mm
helix = atan(starts * m_x / d1) = atan(0.8 / 8.4) = 5.4403 deg
```

> ### Correction
> An earlier version of this file gave 4.6 deg for a 10 mm single-start
> worm. That was wrong: it used the worm's **outside** diameter in place
> of its pitch diameter, and the normal module in place of the axial one.
> Both errors bias the angle low. The correct value is **5.4403 deg** —
> 0.87 deg higher. The table it came from is removed rather than
> corrected: the real worm is measured now, so the table is moot.

### What changed in the model

The tooth is now cut about the **axial / transverse** module, which is
the quantity that has to match the worm:

```
m_x  (axial = transverse)   0.80000   <- measured, must match the worm
m_n  (normal, derived)      0.79640   = m_x * cos(helix)
helix                       5.4403 deg, right hand (assumed)
twist over the 10 mm face   1.8947 deg
```

`m_x` is now the input and `m_n` is derived — the file previously had
that the wrong way round, which would have thrown the tip diameter
0.18 mm out as soon as a helix was applied. All three targets still land
exactly: tip 59.200, root 55.200, tooth height 2.000.

`slices` also no longer bottoms out at 2 for a small twist, which had
been leaving the helical flank as two straight bands. It is driven off
the face width now (351 z-levels in the mesh instead of 3).

### Verified in the mesh

The tooth phase was measured at the bottom face and again at the top,
as a circular mean folded into one 5 deg tooth pitch:

| Build | Measured twist, bottom -> top |
|---|---|
| helical RH | +1.8947 deg (counter-clockwise rising = right hand) |
| helical LH | -1.8947 deg (exact mirror) |
| spur | +0.0000 deg |

Predicted 1.8947 deg. Magnitude matches to four decimals, the hand
mirrors, and the spur control sits at zero.

### WARNING — hand is the one thing left to check

**A right-hand wheel will not mesh with a left-hand worm.** The hand is
not visible in your photos, so both are built.

Look at the worm from the side: if the threads climb left-to-right like
an ordinary screw or bolt, it is **right hand** -> use
`gear60_z72_m0.8_helical_RH.stl`. If they climb right-to-left, use the
`_LH` file. Most automotive worms are right-hand, which is why RH is the
default — but check, do not assume.

If you would rather not gamble, print `gear60_z72_m0.8_spur.stl` first as
a test fit. It will turn against either hand, just noisily.

### Honest limitation

This is a **cylindrical helical wheel, not a throated (globoid) one**. A
proper worm wheel is hollowed to wrap around the worm, giving line
contact along the thread. This one meets the worm on a short contact
patch instead. That matches what the original appears to be — its rim
looked flat in your photos, not throated — and a throated form is not
realistically printable at 0.8 module. It is the reason to expect a
service life below the moulded original's.


### Which STL?

**`gear60_z72_m0.8_helical_RH.stl`** — dimensional match to the original
(same 72 teeth, same module, same tip diameter, so ratio and centre
distance are unchanged) plus the 5.4403 deg helix the measured worm
calls for. Right hand.

Swap to `_LH` if the worm turns out left-handed, or `_spur` for a
hand-agnostic test fit.

A 73-tooth / 60.00 mm variant is no longer shipped — it only made sense
while 60 mm was believed to be the target. Rebuild it with
`-D 'z=73'` if you ever want it; note the extra tooth pushes the pitch
radius out 0.4 mm and will bind in the stock housing.

---

## Brake cable drum — 4 cables

Turns the wheel into a parking-brake actuator. The worm drive is
self-locking, so it holds cable tension with the power off.

```
                    stations at 45 / 135 / 225 / 315 deg
              nipple pocket d7.6              cable groove
                     |                             |
        z=22  _______v_____________________________v____
             |   o       o                              |  <- drum skirt
             |         COLLAR d22 (clamp)               |     d40, wall 3.5
   groove -> |=========================================||     
        z=13 |______   web 3.0   ______________________|
   gear face |################ GEAR BODY ##############|  z=10
        z=0  |#########################################|
```

| | |
|---|---|
| Drum outside dia | 40.00 mm |
| Skirt wall | 3.50 mm |
| Cable groove | 2.60 wide x 1.00 deep, floor at r 19.0 |
| Effective wrap radius | 19.8 mm |
| Nipple pocket | d7.6 x 9 deep, centre r 14.8, opens at the top face |
| Wire slot | 2.4 wide, tangential, at groove level |
| Stations | 4, at 45 / 135 / 225 / 315 deg |
| Rotation for 10 mm pull | 28.9 deg |
| Overall height | 22.00 mm — unchanged |

Stations sit at 45 deg so they stay clear of the slit and the bolt
access window, both at 0 deg. At 28.9 deg of travel and 90 deg spacing,
no cable ever reaches its neighbour's station.

### Two things the geometry forced

**The drum is a skirt, not a solid boss.** Growing the hub to a solid
d40 would take the clamp jaw wall from 7.45 to 16.45 mm. Closing
stiffness goes as t^3, so that is **10.8x stiffer** — the M3 pinch bolt
would never move it. The clamp collar stays at d22 and the drum is a
3.5 mm skirt tied to it by a 3 mm web, so the part that has to flex is
still the slim one.

**Each station needs a boss.** Above the web, the space between the d22
collar and the d33 skirt bore is open air. A pocket cut there would not
be a socket at all — the nipple would sit loose in a gap. Each station
gets a local boss spanning collar to skirt, which also ties the skirt
back in.

The slit and the bolt counterbore both run out through the skirt. They
have to: a slit that stops at the collar would leave the skirt welding
the jaws shut, and a bolt with no window would be unreachable.

### Force and stroke

Cable tension is torque / 19.8 mm, shared over 4 cables:

| Gear torque | Total pull | Per cable |
|---|---|---|
| 2 Nm | 101 N | 25 N (2.6 kgf) |
| 4 Nm | 202 N | 51 N (5.1 kgf) |
| 6 Nm | 303 N | 77 N (7.7 kgf) |
| 8 Nm | 404 N | 101 N (10.3 kgf) |

Shrink `drum_d` for more force and less stroke; the two trade directly.

### Self-locking margin — check this

The brake holds with the power off only while the worm cannot be
back-driven. That needs friction coefficient > `tan(5.44 deg)` = **0.095**:

| mu | Friction angle | |
|---|---|---|
| 0.05 well-greased steel/steel | 2.9 deg | **BACK-DRIVES** |
| 0.10 greased steel/plastic | 5.7 deg | holds, barely |
| 0.15 lightly oiled | 8.5 deg | holds |
| 0.25 dry steel/plastic | 14.0 deg | holds |

**The margin is thin.** A 5.44 deg lead sits right on the boundary, so do
not over-grease the worm. A plastic wheel on a steel worm runs at
mu 0.2-0.3 dry and holds comfortably; flood it with low-friction grease
and it can creep. Test it loaded before trusting it as a parking brake.

### Cable tensioning

The pear nipple seats in a fixed pocket, so tension is not adjusted at
the drum. That is normal and correct — set it at the caliper end, where
the bare wire is clamped, and use a standard **inline barrel adjuster**
per cable for fine independent trim. Roughly 10 mm of adjustment each,
which matches the stroke.

Stepped seats in the drum were considered and rejected: a d7.0 nipple
needs seats 8 mm apart to stay distinct, and 8 mm steps are useless
against a 10 mm stroke. A printed threaded adjuster was rejected too —
it would put the full brake load on a plastic thread.

### Assembly

Feed each wire in through the slot from the drum surface, then drop the
nipple into its pocket from the top. The slot is a buried channel at
groove level, so the wire stays captive once seated.

### Verification

| Probe | Checks | Expect | Control | Expect |
|---|---|---|---|---|
| 10 | Nipple pocket is a real socket | empty | 100 | solid |
| 11 | Wire slot reaches the drum surface | empty | 110 | solid |
| 12 | Skirt sits on solid material | solid | 120 | empty |
| 13 | Hex key reaches the pinch bolt | empty | 130 | solid |

All pass, alongside the original 8 clamp probes.

---

## Bigger-OD variant — `gear60_d608.scad`

Tip dia **60.80 mm**, up from 59.20. At `m_x = 0.8` the tip diameter only
moves in **1.60 mm steps** (one whole tooth adds `2*m_x`), and the module
is the one number that must stay 0.8 to match the worm — so 60.80 is not
an approximation, it is exactly `z = 74`:

| | stock `gear60_drum4` | `gear60_d608` |
|---|---|---|
| teeth | 72 | **74** |
| tip dia | 59.20 mm | **60.80 mm** (+1.60) |
| pitch dia | 57.60 mm | 59.20 mm |
| root dia | 55.20 mm | 56.80 mm |
| module / pressure angle | 0.8 / 20° | unchanged |
| helix | 5.4403° RH | unchanged (twist re-derived, −1.84°) |
| tooth height | 2.00 mm | unchanged |
| bore, hub, clamp, drum | — | all unchanged |
| overall height | 22.00 mm | 22.00 mm |
| ratio with a 1-start worm | 72:1 | 74:1 |
| slice (same PETG profile) | 3 h 29 m, 9756 mm | 3 h 33 m, 9958 mm |

**This still breaks the stock mesh.** Worm centre distance is
`(d_worm_pitch + d_wheel_pitch)/2` = `(8.40 + 57.60)/2` = **33.00 mm**
stock, but **33.80 mm** here. The worm must move **0.80 mm** further from
the wheel axis (or the wheel shaft moves the same amount). That is half
the shift of the abandoned 62.40 version, but 0.80 mm of interference
against a 2.00 mm tooth height is still a jam, not a tight mesh. No
amount of gear geometry absorbs it — it is a housing change.

The variant is a 3-line file that `include`s `gear60.scad` and overrides
`z`, so the base design stays the reference part.

### The z=74 degeneracy — fixed in `gear60.scad`

z=74 originally rendered at **genus 12** where 72, 73, 75 and 76 all gave
13. `stlcheck` found why: a **second shell — 6 triangles, zero volume, at
z=10.00, x=16.50**, i.e. exactly on the gear top face at the drum skirt's
inner wall. The drum lands *on* the gear face, so the skirt, web and boss
bottoms were all coplanar with the gear top: three coincident faces in one
union, and at that particular tooth count the tessellation threw off a
flake.

`drum_body()` now sinks the drum `eps = 0.01` into the gear (heights carry
the same `+eps`, so the top face stays at exactly 22.00). The overlap is
buried in solid material — **volume is unchanged at 31185.94 mm³ for the
stock part** — and 72/73/74/75/76 now all render as one shell, genus 13.
Another instance of the rule from the drum project: *keep derived
dimensions from coinciding exactly.*

All 16 probes in `test_clamp.scad` return identical results for z=72 and
z=74, controls included. The "long bridging extrusions" slicer notice is
the drum web and appears on the stock part too.

**Note on probe 4.** It reports *solid* where the table below says empty —
on the stock gear as well. Not a defect: the probe runs outward from the
ear flat at x=12 and clips the **315° cable boss**, which was added after
these 8 clamp probes were written. With `drum=false` probe 4 is empty, so
the insert seat is open as designed.

---

## v2 — `gear60_v2.scad`  (2026-08-08, current print file)

Four changes on top of `d608`. Print file: **`gear60_v2.gcode`**, 5 h 32 m,
38.36 cm³ (~49 g PETG), 42 mm tall.

| | `gear60_d608` | **`gear60_v2`** |
|---|---|---|
| teeth | 74 | 74 (unchanged) |
| **tip dia** | 60.80 mm | **60.60 mm** |
| addendum factor | 1.000 | **0.875** |
| pitch dia | 59.20 mm | 59.20 mm (unchanged) |
| root dia | 56.80 mm | 56.80 mm (unchanged) |
| tooth height | 2.00 mm | 1.90 mm |
| **bore (nominal shaft)** | 7.0 | **8.0** → 8.20 body / 8.10 clamp |
| jaw wall at bore | 7.45 mm | 6.95 mm |
| **hub_ext / total height** | 12 / **22 mm** | 32 / **42 mm** |
| **groove (cable) height** | z = 16 | **z = 36** (+20) |
| nipple pockets | z 13…22 | z 33…42 |
| pinch bolt | z = 16 | z = 26 |
| **cable loading** | closed tunnel | **open chute to the top face** |
| slice | 3 h 33 m | **5 h 32 m** |

### 1. Why 60.60 is an addendum change, not a tooth change

`m_x = 0.8` is the worm's axial module and cannot move; tooth count moves
the tip dia in 1.60 mm steps, so **60.60 is unreachable by adding teeth**.
It is reached by truncating the addendum instead — `add_f 1.000 → 0.875`
takes 0.10 mm off every tooth tip:

```
tip   60.80 → 60.60      pitch 59.20 → 59.20 (UNCHANGED)
root  56.80 → 56.80      tooth ht 2.00 → 1.90
```

**Consequence to be clear about: this does not fix the mesh problem.**
The pitch circle is what sets centre distance, and it did not move — the
worm still has to sit at **33.80 mm** instead of the stock 33.00 mm. The
0.80 mm housing shift from the d608 version is still outstanding. Shorter
tips relieve *tip* interference very slightly and nothing else.

### 2. Bore 8 mm

`bore_d` is the **nominal shaft** size, so the part comes out 8.20 through
the gear body and 8.10 in the clamp section, which then pinches down onto
a true 8.00 shaft. Same convention the 7 mm version used (7.20 / 7.10).
If the requirement is instead that the *hole measure* 8.00, set
`bore_d = 7.9`.

### 3. Cable stations 20 mm higher

The whole collar grows — `hub_ext 12 → 32` — so the skirt, the ear, the
slit and the four bosses all travel up together and the part is 42 mm
tall. The groove follows (`groove_z 16 → 36`) and the nipple pockets stay
9 mm down from the top face. The pinch bolt lands at z = 26, which also
gets it out of the groove it used to share a height with.

**Watch the overturning moment.** 4 × ~66 N now pulls 36 mm above the gear
face instead of 16 mm — roughly **2.2× the tilting moment** on an 8 mm
shaft and on a single M3 pinch bolt. If the collar ever cocks or walks on
the shaft, that is the reason, and a second pinch bolt higher up the
collar is the fix.

### 4. A route the cable can actually get in by — `wire_entry`

The first build could not be cabled by hand: the nipple pocket was blind
from the top and the wire slot was a **closed tunnel** at groove level, so
the only way in was to thread the free end of the cable in from outside
and pull the nipple down the pocket.

`wire_entry = true` (new in `gear60.scad`, now the default) runs that same
tangential slot on up to the top face as an open 2.4 mm chute. Drop the
nipple down its pocket, let the wire fall sideways into the notch, and it
seats itself in the groove.

The anchor is not weakened where it matters: the nipple is Ø7.0 against a
2.4 mm gap, so it still cannot escape sideways, and the load is still
carried by the two 2.6 mm lands either side of the slot — which is where
it was carried before. Only the material *above* the slot is gone, and it
was never in the load path (the pull is horizontal).

### Verification

- **1 shell, solid, 51 355.13 mm³**, bbox exactly 60.60 × 60.60 × 42.00
  (`stlcheck.py`).
- **Genus 3 at z = 73, 74 and 75** — stable across neighbours, so no
  repeat of the z=74 flake. (13 → 3 is expected: 8 handles disappear when
  the four wire tunnels become open notches, and 2 more when the groove
  moves away from the pinch-bolt counterbore.)
- `test_cable_route.scad` sweeps both loading motions — the Ø7.0 nipple
  falling down its pocket and the 1.6 mm wire falling down the chute —
  and intersects them with the part. **Empty = the route is clear.**
  It is proven sensitive: re-render the sandbox with `wire_entry=false`
  and it returns **4 × ~66 mm³ of obstruction at z 37.30…42.00**, exactly
  the roof the chute removes.
- Slicer profile is the one dumped out of `gear60_drum4_d608.gcode`;
  re-slicing the d608 STL with it reproduced the shipped **3 h 33 m 12 s**
  exactly, so it is a faithful control. v2 gcode verified on-bed
  (113–187 mm of a 300 mm bed), absolute E, no G29, top layer at 42.00.

---

## The retaining cap — `cap60.scad`  (2026-08-11)

`wire_entry = true` deliberately took the roof off the four nipple pockets
so the cables could be dropped in by hand. Nothing then stops a nipple
lifting back out when its cable goes slack. `cap60` closes them.

**It needs no change to the gear.** It clamps onto features that already
exist on `gear60_v2` as printed. Print file: **`cap60.gcode`**, 32 m 28 s,
4180.72 mm³, plus one **M3 × 14** screw.

| | |
|---|---|
| lid | OD 44.30, ID 22.60, 2.40 thick — sits on the top face at z 42.00 |
| skirt | bore 40.30 (0.15 radial slip on the Ø40 drum), 4.20 tall |
| skirt occupies | part z **37.80…42.00** — 0.50 clear of the groove top |
| split | 1.80 gap at **180°**, deliberately not at the gear slit's 0° |
| lugs | 6.00 × 6.00, 13.80 across the pair, M3 Ø3.40 / Ø2.90 thread-forming |
| lead-in | 0.60 chamfer at the skirt mouth |

### Why it clamps from outside

The collar is a **split clamp**. Anything gripping the drum rigidly and
bridging the slit stiffens the jaws and stops the M3 pinch bolt gripping
the shaft — the same reason the drum is a thin skirt and not a solid boss.
Clamping the *outside* squeezes in the **same direction the pinch bolt
works**, so it assists rather than fights, and the cap is itself split, so
it is a C-clip and not a hoop.

The centre is left open (ID 22.60), so it does not matter whether the
shaft protrudes past the top face or stops short of it.

There are only 4.70 mm of clean drum OD to grip — z 37.30 (groove top) to
42.00 — and nothing at all lives outboard of r 20 in that band. The
pinch-bolt counterbore does exit at y = 22, but at z = 26, eleven
millimetres below.

### ★ The wire chute is TANGENTIAL, not radial

The first cut of this cap keyed itself with a tab at each station angle,
dropping into the wire chute. `test_cap_fit.scad` rejected it —
**4 × 8.73 mm³ of interference at exactly 45/135/225/315, z 37.80…42.00.**

`gear60.scad` builds the chute as

```
translate([nip_r,0,z]) rotate([0,0,90]) translate([0,-w/2,0]) cube([r_o+4,w,h])
```

which is the strip **x 13.60…16.00, y 0…24** — it leaves the pocket
*sideways* in +Y and only crosses the OD **36.87°…47.16° away from its own
station**. At the station angle the drum OD is solid material. "Leaves the
pocket tangentially" in the source comment meant exactly that.

Tabs are off (`tabs = false`). Keying it properly would need an oblique
slab following those walls, for no gain: the cap is an annulus, so it
covers all four pockets at any rotation, and the M3 lug is what retains it.

### Verification

- Cap mesh: **1 shell, solid, 4180.72 mm³**, bbox 6.60 tall (`stlcheck.py`).
- `test_cap_fit.scad` intersects the cap, at its seat, with the **real
  exported gear mesh** — not with a re-derived model. **Empty**: every
  component comes back at 0.00 mm³, which is the lid underside resting
  coplanar on the top face at z = 42.00, as intended.
- **Proven sensitive**: `-D drop=1.5` sinks the cap into the cable groove
  and it returns **636 mm³ across 9 bodies**. Without that control an
  "empty" result would mean nothing.
- Sliced from `v2_profile.ini`, the profile dumped out of the shipped v2
  gcode, so the cap prints on the same settings as the gear.

### Assembly

Cable the drum as before, drop the cap on, and nip the M3 up until it
stops turning by hand. It lifts straight off again to re-cable. Do not
overtighten — the drum skirt is only 3.5 mm thick and the job is retaining
a slack nipple, not carrying load.

---

## Re-generating

```bash
OS="/c/Users/HP/Tools/openscad-nightly/OpenSCAD-2026.07.20-x86-64/openscad.exe"
"$OS" --backend=Manifold -D 'm_n=0.82' -D 'z=72' -D 'helix=8' \
      -o gear_custom.stl gear60.scad
```

Every parameter is overridable with `-D`. The script echoes the resulting
pitch/tip/root diameters and tooth height so you can check them before
slicing.

## Printing

- Print **flat on the toothed face**, no supports. The web recess and the
  bore are the only overhangs and both are vertical.
- 0.12–0.16 mm layers. At 2.51 mm circular pitch the teeth are small —
  a 0.4 mm nozzle is the practical floor, 0.3 mm is better.
- 4+ perimeters, ≥40 % infill. The rim wants to be solid: `rim_wall = 3`
  already forces ~3 mm of solid material under the tooth roots.
- **PETG or ABS/ASA, not PLA** — this lives next to a motor in a car door.
  PLA will creep under the worm's tooth load and soften in summer heat.
  Nylon would be better still if you can print it.
- `bore_clear = 0.20` suits a well-tuned printer. If your holes come out
  tight, raise it; if the shaft is loose, drop it to 0.10 and ream.
- The pinch-bolt hole is **horizontal**, so its top surface will sag a
  little. Run a 3.4 mm drill through by hand before assembly — a few
  seconds, and the bolt then pulls square instead of cocked.
- Do **not** print the slit with a brim or blob bridging it. Check it is
  actually open before you fit the gear; a slit fused shut by a stray
  first-layer skirt turns the clamp into a solid hub.
- `clamp_clear = 0.10` is tight by design. Print the gear body first if
  you want to test-fit, or raise it to 0.15 if your holes run small.
