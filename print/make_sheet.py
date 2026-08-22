import os
from PIL import Image, ImageDraw, ImageFont

D = os.path.dirname(os.path.abspath(__file__))
BG = (16, 19, 23)
FG = (232, 236, 240)
AC = (232, 83, 93)

items = [
    ("view_top.png",     "TOP 3/4", "two cable grooves | 4 retaining slots | nipple holes"),
    ("view_bottom.png",  "UNDERSIDE", "4-arm star pocket - the servo horn sits in here"),
    ("view_section.png", "HALF SECTION", "cut open - groove depth and nipple bore"),
    ("view_coupon.png",  "FIT COUPON", "print this first, check it on your horn"),
]

CW, CH = 760, 620          # cell size
PAD, HDR = 18, 124

def font(sz, bold=False):
    for n in (("arialbd.ttf" if bold else "arial.ttf"), "segoeui.ttf"):
        try:
            return ImageFont.truetype(n, sz)
        except Exception:
            pass
    return ImageFont.load_default()

W = CW * 2 + PAD * 3
H = HDR + CH * 2 + PAD * 3
sheet = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(sheet)

d.text((PAD + 6, 24), "TWIN-CABLE BRAKE DRUM", font=font(38, True), fill=FG)
d.text((PAD + 6, 72), "TD-8130MG servo   |   O 48.96 x 21.20 mm   |   70 mm stroke @ 180 deg",
       font=font(19), fill=(140, 152, 163))
d.line([(PAD, HDR - 14), (W - PAD, HDR - 14)], fill=(46, 56, 65), width=2)

for i, (fn, title, sub) in enumerate(items):
    cx = PAD + (i % 2) * (CW + PAD)
    cy = HDR + (i // 2) * (CH + PAD)
    im = Image.open(os.path.join(D, fn)).convert("RGB")
    im = im.resize((CW, round(im.height * CW / im.width)), Image.LANCZOS)
    im = im.crop((0, 0, CW, min(im.height, CH - 62)))
    sheet.paste(im, (cx, cy))
    d.rectangle([cx, cy, cx + CW - 1, cy + CH - 1], outline=(46, 56, 65), width=1)
    ty = cy + CH - 54
    d.line([(cx, ty - 8), (cx + CW, ty - 8)], fill=(46, 56, 65), width=1)
    d.text((cx + 14, ty), title, font=font(21, True), fill=AC)
    d.text((cx + 14, ty + 27), sub, font=font(16), fill=(150, 161, 172))

out = os.path.join(D, "DRUM_overview.png")
sheet.save(out)
print("wrote", out, sheet.size)
