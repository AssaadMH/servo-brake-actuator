# One image card per printable part, to sit next to its .gcode in PRINT\
import os
from PIL import Image, ImageDraw, ImageFont

D = os.path.dirname(os.path.abspath(__file__))
BG, FG, MUT, AC = (16, 19, 23), (232, 236, 240), (150, 161, 172), (232, 83, 93)

def font(sz, bold=False):
    for n in (("arialbd.ttf" if bold else "arial.ttf"), "segoeui.ttf"):
        try:
            return ImageFont.truetype(n, sz)
        except Exception:
            pass
    return ImageFont.load_default()

CW, CH, PAD, HDR = 700, 570, 16, 132

def card(out, title, meta, banner, views):
    W = CW * len(views) + PAD * (len(views) + 1)
    H = HDR + CH + PAD * 2
    im = Image.new("RGB", (W, H), BG)
    d = ImageDraw.Draw(im)

    d.text((PAD + 6, 22), title, font=font(34, True), fill=FG)
    d.text((PAD + 6, 68), meta, font=font(19), fill=MUT)
    if banner:
        tw = d.textlength(banner, font=font(17, True))
        bx = W - PAD - 6 - tw - 28
        d.rectangle([bx, 24, W - PAD - 6, 60], fill=AC)
        d.text((bx + 14, 32), banner, font=font(17, True), fill=(255, 255, 255))
    d.line([(PAD, HDR - 14), (W - PAD, HDR - 14)], fill=(46, 56, 65), width=2)

    for i, (fn, cap) in enumerate(views):
        cx = PAD + i * (CW + PAD)
        cy = HDR
        v = Image.open(os.path.join(D, fn)).convert("RGB")
        v = v.resize((CW, round(v.height * CW / v.width)), Image.LANCZOS)
        v = v.crop((0, 0, CW, min(v.height, CH - 44)))
        im.paste(v, (cx, cy))
        d.rectangle([cx, cy, cx + CW - 1, cy + CH - 1], outline=(46, 56, 65), width=1)
        ty = cy + CH - 36
        d.line([(cx, ty - 8), (cx + CW, ty - 8)], fill=(46, 56, 65), width=1)
        d.text((cx + 12, ty), cap, font=font(17), fill=MUT)

    im.save(os.path.join(D, out))
    print("wrote", out, im.size)

card("horn_fitcheck.png",
     "horn_fitcheck.gcode",
     "fit gauge  |  O 48.0 x 6.4 mm  |  31 min  |  6.6 g PLA",
     "PRINT THIS FIRST",
     [("view_coupon.png",     "underside - push your servo horn into this star pocket"),
      ("view_coupon_top.png", "top - should sit snug, with no rotational play")])

card("servo_brake_drum.png",
     "servo_brake_drum.gcode",
     "the drum  |  O 47.36 x 19.50 mm  |  3 h 35 m  |  26.0 g PLA",
     "ONLY AFTER THE GAUGE FITS",
     [("view_top.png",     "top - two V grooves, 4 retaining slots, 2 nipple holes"),
      ("view_section.png", "cut open - V sheaves and the nipple bore")])

card("cable_stops_plate.png",
     "cable_stops_plate.gcode",
     "2 posts + 2 blocks, one bed  |  4 h 07 m  |  36.2 g PLA",
     "CHECK YOUR PLATE FITS FIRST",
     [("view_stop_asm.png",   "assembled - block slides up the post, one M4 clamps it"),
      ("view_stop_block.png", "the block - housing seats in the wide U, wire in the narrow")])
