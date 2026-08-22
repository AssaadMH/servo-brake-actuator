import base64, io, os
from PIL import Image

D = os.path.dirname(os.path.abspath(__file__))

def datauri(name, w=920):
    p = os.path.join(D, name)
    im = Image.open(p).convert('RGB')
    if im.width > w:
        im = im.resize((w, round(im.height * w / im.width)), Image.LANCZOS)
    buf = io.BytesIO()
    im.save(buf, 'PNG', optimize=True)
    b = buf.getvalue()
    print(f"  {name:20s} {len(b)/1024:7.1f} KB")
    return 'data:image/png;base64,' + base64.b64encode(b).decode('ascii')

html = open(os.path.join(D, 'page_template.html'), encoding='utf-8').read()
for token, fn in [('__IMG_TOP__',     'view_top.png'),
                  ('__IMG_BOTTOM__',  'view_bottom.png'),
                  ('__IMG_SECTION__', 'view_section.png'),
                  ('__IMG_COUPON__',  'view_coupon.png')]:
    html = html.replace(token, datauri(fn))

assert '__IMG' not in html, 'a placeholder was left unfilled'
out = os.path.join(D, 'design.html')
open(out, 'w', encoding='utf-8').write(html)
print(f"\nwrote {out}  ({len(html)/1024:.0f} KB total)")
