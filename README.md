# Fail-Safe Servo Brake Actuator
> A printed drum that lets one servo pull two bicycle brake cables — the mechanical answer to an electrical failure.
`2026` · `OpenSCAD` · `Mechanism design` · `FDM` · `Force analysis`

![Fail-Safe Servo Brake Actuator](docs/img/brake-drum.png)

## Origin

Built at **IRIS Systems** during a 2026 engineering internship, as part of a team working on
the SHADOW autonomous vehicle programme. This repository covers the parts I worked on; the
wider programme is IRIS Systems' project. Published with their agreement.

## About

After the electrical hold-brake failure on SHADOW, the parking brake had to become purely mechanical. SHADOW was a team project and the failed electrical brake was the team’s work; the mechanical replacement described here is my contribution to it. The first working actuator uses a TD-8130MG servo to pull two bicycle brake cables simultaneously through a printed cable drum.

**The key design decision** is that the drum *captures the servo's stock metal horn* rather than reproducing its 25-tooth spline. A 25T spline printed in PLA strips under load — 30 kg·cm across 0.3 mm teeth on a 6 mm shaft is on the order of 100 kg of shear along the layer lines. A captured horn puts the torque into steel and reduces the plastic's job to holding it in place.

**Force analysis drove the geometry, and it has exactly one governing variable.** At a fixed sweep angle the drum diameter follows directly from the cable stroke, and the pull follows inversely from the diameter — so *stroke sets force, and nothing else does*. That makes the honest way to gain force counter-intuitive: shrink the drum. The current design uses a 44 mm stroke on a Ø30.8 drum for about 6.4 kg per cable in normal working conditions, roughly 10.7 kg at stall. An earlier, larger revision with a longer stroke was weaker for the same servo. Going smaller still is not free either — below about Ø28 the cable groove undercuts the very shoulder the cable nipple pulls against, leaving under a millimetre of plastic to carry the load.

**Both cable anchors sit 180° apart and wind the same way,** so the two pulls cancel as a couple instead of summing into a side load on the servo's output bearing. Cable housing stops and mounting blocks were designed alongside the drum — the pull is taken by a tongue bearing against a groove wall rather than by the clamp bolt — and laid out on a single print plate with a fit-test coupon beside the real part, so one print answers both questions.

**The slicer caught what the CAD did not.** Square cable grooves left the flange above them hanging as an unsupported ring, so they became 90° V-sheaves that self-support — and, as a bonus, seat the cable at exactly the design radius automatically. A second finding is worth keeping: the CAD kernel reported the solid as clean while the exported mesh carried ten non-manifold edges, because a derived dimension landed exactly on another feature's rim. **A kernel saying "simple: yes" does not mean the exported file is sound** — the STL itself has to be checked, which is why every part here goes through an STL sanity script and a G-code verification pass before it reaches the printer.


**The final drum is not servo-driven at all.** The servo version above proved the cable-pull principle, but the production part replaces the white worm wheel inside a Bosch window-lift motor (`0130821xxx`) with a printed wheel that carries the four-cable brake drum on the same hub — so the gearmotor’s own reduction does the pulling. The tooth count was recovered from photographs by unwrapping the rim into polar coordinates and taking a DFT of the tooth frequency: an unambiguous peak at 72. The live part, `gear60_v3`, runs 76 teeth on a 60.80 mm pitch diameter (62.40 mm across the tips), 2.00 mm tooth height and an 8 mm bore, on a split clamping hub with an M3 pinch bolt.

**One number decides whether it fits, and it is still open.** Centre distance follows the *pitch* circle alone, so growing the wheel to 60.80 mm moves the worm 1.60 mm further out — 33.00 mm stock becomes 34.60 mm. Shaving the tooth tips buys none of it back: an earlier revision truncated the addendum and the centre distance did not move at all. Against a 2.00 mm tooth height, 1.60 mm of interference is a jam rather than a tight mesh, so this wheel needs a deliberate housing modification and will not drop into a stock gearbox. That is a known, quantified constraint of the current design rather than a surprise waiting at assembly.

## Figures

![brake-printed.jpg](docs/img/brake-printed.jpg)

![brake-horn.png](docs/img/brake-horn.png)

![brake-generations.png](docs/img/brake-generations.png)

![brake-chain.png](docs/img/brake-chain.png)

## Contents

```
design/
docs/
print/
worm-wheel/
```

## Notes

Not included in this repository: 18 generated/binary file(s), 10 mesh/binary over 2 MB file(s) - build caches, generated toolpaths and oversized binaries are kept out on purpose. The source they are generated from is here.

## Third-party work used here

This work was done as part of a team, and it builds on the following, which are **not** ours and are used under their own licences:

- **OpenSCAD** by OpenSCAD project — <https://openscad.org>

## Author

Lassaad Mahmoudi — <contact@iris-systems.tn>  
https://linkedin.com/in/mahmoudiassaad
