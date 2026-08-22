# Tiny software STL renderer (painter's algorithm + flat shading).
# No OpenGL needed - the portable OpenSCAD build can't export PNG here.
import sys, math
from PIL import Image, ImageDraw, ImageFont

SS = 3  # supersample factor

def load(path):
    pts, tris = [], []
    with open(path, 'rb') as f:
        for line in f:
            s = line.split()
            if s and s[0] == b'vertex':
                pts.append(tuple(float(x) for x in s[1:4]))
                if len(pts) == 3:
                    tris.append(tuple(pts)); pts = []
    return tris

def rot(p, az, el):
    ca, sa = math.cos(az), math.sin(az)
    ce, se = math.cos(el), math.sin(el)
    x, y, z = p
    x1 =  x*ca - y*sa
    y1 =  x*sa + y*ca
    y2 =  y1*ce - z*se
    z2 =  y1*se + z*ce
    return (x1, y2, z2)          # screen-x, depth, screen-y(up)

def norm(a, b, c):
    u = (b[0]-a[0], b[1]-a[1], b[2]-a[2])
    v = (c[0]-a[0], c[1]-a[1], c[2]-a[2])
    n = (u[1]*v[2]-u[2]*v[1], u[2]*v[0]-u[0]*v[2], u[0]*v[1]-u[1]*v[0])
    m = math.sqrt(sum(t*t for t in n)) or 1.0
    return (n[0]/m, n[1]/m, n[2]/m)

def render(tris, az_deg, el_deg, W, H, out, title=None,
           bg=(18,21,25), base=(186,193,200), edge=None):
    az, el = math.radians(az_deg), math.radians(el_deg)
    view = [tuple(rot(v, az, el) for v in t) for t in tris]

    xs = [v[0] for t in view for v in t]
    zs = [v[2] for t in view for v in t]
    sx = (W*SS*0.86)/(max(xs)-min(xs))
    sz = (H*SS*0.86)/(max(zs)-min(zs))
    s  = min(sx, sz)
    cx = (max(xs)+min(xs))/2
    cz = (max(zs)+min(zs))/2

    img = Image.new('RGB', (W*SS, H*SS), bg)
    d = ImageDraw.Draw(img)

    def unit(v):
        m = math.sqrt(sum(t*t for t in v)) or 1.0
        return tuple(t/m for t in v)

    KEY  = unit((-0.45, -0.75, 0.55))              # key light, camera space
    FILL = unit(( 0.60, -0.55, -0.30))             # fill from the other side

    view.sort(key=lambda t: -(t[0][1]+t[1][1]+t[2][1])/3.0)   # far -> near

    for t in view:
        n = norm(*t)
        if n[1] > 0:                               # backface cull
            continue
        k = max(0.0, n[0]*KEY[0]  + n[1]*KEY[1]  + n[2]*KEY[2])
        f = max(0.0, n[0]*FILL[0] + n[1]*FILL[1] + n[2]*FILL[2])
        sh = 0.20 + 0.62*k + 0.26*f                # ambient + key + fill
        col = tuple(min(255, int(c*sh)) for c in base)
        poly = [((v[0]-cx)*s + W*SS/2, H*SS/2 - (v[2]-cz)*s) for v in t]
        d.polygon(poly, fill=col, outline=edge)

    img = img.resize((W, H), Image.LANCZOS)
    if title:
        d2 = ImageDraw.Draw(img)
        try:    fnt = ImageFont.truetype("arial.ttf", 20)
        except: fnt = ImageFont.load_default()
        d2.text((16, 12), title, fill=(235,235,235), font=fnt)
    img.save(out)
    print("wrote", out)

if __name__ == '__main__':
    stl, out, az, el = sys.argv[1], sys.argv[2], float(sys.argv[3]), float(sys.argv[4])
    title = sys.argv[5] if len(sys.argv) > 5 else None
    render(load(stl), az, el, 1000, 800, out, title)
