# Top-view mounting layout for the two cable housing stops.
# Origin = servo output shaft axis. All dimensions mm.
import os, math
from PIL import Image, ImageDraw, ImageFont

D = os.path.dirname(os.path.abspath(__file__))
BG, FG, MUT, AC, DIM = (16,19,23), (232,236,240), (150,161,172), (232,83,93), (96,110,122)

S = 5.2                      # px per mm
W, H = 1020, 760
CX, CY = W//2, H//2 + 10     # shaft centre on canvas

def P(x, y):                 # mm -> px  (+Y drawn upward)
    return (CX + x*S, CY - y*S)

def font(sz, bold=False):
    for n in (("arialbd.ttf" if bold else "arial.ttf"), "segoeui.ttf"):
        try: return ImageFont.truetype(n, sz)
        except Exception: pass
    return ImageFont.load_default()

im = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(im)

def dashed(p0, p1, col, dash=7, gap=5, wdt=1):
    x0,y0 = p0; x1,y1 = p1
    L = math.hypot(x1-x0, y1-y0)
    if L == 0: return
    ux, uy = (x1-x0)/L, (y1-y0)/L
    t = 0
    while t < L:
        e = min(t+dash, L)
        d.line([x0+ux*t, y0+uy*t, x0+ux*e, y0+uy*e], fill=col, width=wdt)
        t = e + gap

def dashed_circle(r, col, n=180):
    pts = [P(r*math.cos(2*math.pi*i/n), r*math.sin(2*math.pi*i/n)) for i in range(n+1)]
    for i in range(0, n, 2):
        d.line([pts[i], pts[i+1]], fill=col, width=1)

# ---- title
d.text((22, 20), "CABLE STOP MOUNTING LAYOUT", font=font(30, True), fill=FG)
d.text((22, 60), "top view  |  origin = servo output shaft  |  all dimensions mm",
       font=font(17), fill=MUT)
d.line([(22, 92), (W-22, 92)], fill=(46,56,65), width=2)

# ---- keep-out: servo body + mounting flanges
dashed_circle(24.75, DIM)
d.text(P(-24, -30.5), "servo + flanges", font=font(13), fill=DIM)
d.text(P(-24, -34.5), "keep clear", font=font(13), fill=DIM)

# ---- drum
n = 200
d.ellipse([P(-23.68, 23.68), P(23.68, -23.68)], outline=MUT, width=2)
d.ellipse([P(-22.28, 22.28), P(22.28, -22.28)], outline=AC, width=1)

# ---- centre marks
d.line([P(-32,0), P(32,0)], fill=(60,72,82), width=1)
d.line([P(0,-32), P(0,32)], fill=(60,72,82), width=1)

# ---- the two brackets
def bracket(sx):
    # sx = +1 for cable A, -1 for cable B (point symmetric about the shaft)
    fx0, fx1 = 27.28*sx, 61.28*sx
    fy0, fy1 = -40*sx, -4*sx
    d.rectangle([P(min(fx0,fx1), max(fy0,fy1)), P(max(fx0,fx1), min(fy0,fy1))],
                outline=(120,132,143), width=2)
    # post slab â€” bracket origin sits at y = -22*sx, slab is 32 deep
    d.rectangle([P(min(30.28*sx,40.28*sx), max(-38*sx,-6*sx)),
                 P(max(30.28*sx,40.28*sx), min(-38*sx,-6*sx))],
                outline=(90,102,113), width=1)
    # the stop block, where the housing lands
    d.rectangle([P(min(14.28*sx,30.28*sx), max(-30*sx,-14*sx)),
                 P(max(14.28*sx,30.28*sx), min(-30*sx,-14*sx))],
                outline=AC, width=1)
    # cable run, tangent to the drum
    d.line([P(22.28*sx, -30*sx), P(22.28*sx, 0)], fill=AC, width=3)
    # drill holes
    for hy in (-12, -32):
        c = P(51.28*sx, hy*sx)
        d.ellipse([c[0]-5, c[1]-5, c[0]+5, c[1]+5], outline=AC, width=2)
        d.line([c[0]-9, c[1], c[0]+9, c[1]], fill=AC, width=1)
        d.line([c[0], c[1]-9, c[0], c[1]+9], fill=AC, width=1)

bracket(+1)
bracket(-1)

# ---- callouts
lab = font(15)
d.text(P(2, -44),   "cable A  -  bare wire on tangent  x = +22.28", font=lab, fill=AC)
d.text(P(-46, 46),  "cable B  -  bare wire on tangent  x = -22.28", font=lab, fill=AC)
d.text(P(63, -10),  "M4 (+51.28, -12)", font=lab, fill=FG)
d.text(P(63, -30),  "M4 (+51.28, -32)", font=lab, fill=FG)
d.text(P(-88, 14),  "M4 (-51.28, +12)", font=lab, fill=FG)
d.text(P(-88, 34),  "M4 (-51.28, +32)", font=lab, fill=FG)
d.text(P(15, -20),  "stop block", font=font(13), fill=AC)
d.text(P(-4, 27),   "drum O47.36", font=lab, fill=MUT)


# ---- footprint note
d.line([(22, H-96), (W-22, H-96)], fill=(46,56,65), width=2)
d.text((22, H-84),
       "PLATE MUST BE AT LEAST  123 x 80 mm  around the shaft.",
       font=font(18, True), fill=AC)
d.text((22, H-56),
       "Both brackets sit outboard so they never touch the servo, whichever way it faces.",
       font=font(15), fill=MUT)
d.text((22, H-34),
       "Slots give +/-5 mm in Y. Height is set by sliding the block on the post (21-45 mm).",
       font=font(15), fill=MUT)

out = os.path.join(D, "MOUNTING_LAYOUT.png")
im.save(out)
print("wrote", out, im.size)
