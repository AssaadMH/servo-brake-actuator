import re, sys, os

def check(path):
    x=y=z=None; e_mode=None
    xs=[]; ys=[]; zs=[]; layers=set()
    stats={}
    bad_e=0; last_e=0.0; g29=0
    with open(path, encoding='utf-8', errors='ignore') as f:
        for line in f:
            if line.startswith(';'):
                m=re.match(r'\s*([A-Za-z_][A-Za-z_ ()\[\]]*?)\s*=\s*(.+)', line[1:])
                if m: stats[m.group(1).strip()]=m.group(2).strip()
                continue
            c=line.split(';')[0].strip()
            if not c: continue
            if c.startswith('M82'): e_mode='abs'
            if c.startswith('M83'): e_mode='rel'
            if c.startswith('G29'): g29+=1
            if c.startswith('G92'):
                m=re.search(r'E(-?\d*\.?\d+)', c)      # legitimate counter reset
                if m: last_e=float(m.group(1)); continue
            if re.match(r'G0?[01]\b', c):
                for ax,val in re.findall(r'([XYZE])(-?\d*\.?\d+)', c):
                    v=float(val)
                    if ax=='X': x=v
                    elif ax=='Y': y=v
                    elif ax=='Z': z=v; layers.add(round(v,3))
                    elif ax=='E':
                        if e_mode=='abs' and v < last_e - 5: bad_e+=1
                        last_e=v
                # ignore the priming line laid down at Y<8 by start_gcode
                if 'E' in c and x is not None and y is not None and y > 8:
                    xs.append(x); ys.append(y); zs.append(z if z is not None else 0)

    ls=sorted(layers)
    print(f"--- {os.path.basename(path)}")
    print(f"    time          : {stats.get('estimated printing time (normal mode)','?')}")
    used=stats.get('filament used [mm]')
    if used:
        mm=float(used); grams=mm/10*3.14159*(0.175/2)**2*1.24
        print(f"    filament      : {mm/1000:.2f} m   ~{grams:.1f} g")
    print(f"    extrusion bbox: X {min(xs):6.2f}..{max(xs):6.2f}   Y {min(ys):6.2f}..{max(ys):6.2f}")
    print(f"    on 300x300 bed: {'OK' if min(xs)>0 and min(ys)>0 and max(xs)<300 and max(ys)<300 else '*** OFF BED ***'}")
    print(f"    Z range       : {min(zs):.2f} .. {max(zs):.2f}   ({len(ls)} distinct Z)")
    print(f"    E mode        : {e_mode}  (abs expected, matches M82)")
    print(f"    E resets      : {'OK' if bad_e==0 else f'*** {bad_e} unexplained rewinds ***'}")
    print(f"    G29 bed probe : {g29} (must be 0 - N2 is manually levelled)")

for p in sys.argv[1:]:
    check(p)
