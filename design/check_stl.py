import struct, sys, collections

def load(path):
    with open(path,'rb') as f:
        head = f.read(5)
        f.seek(0)
        if head.lstrip()[:5].lower() == b'solid':      # ASCII
            pts = []
            tris = []
            for line in f:
                s = line.split()
                if s and s[0] == b'vertex':
                    pts.append(tuple(float(x) for x in s[1:4]))
                    if len(pts) == 3:
                        tris.append(tuple(pts)); pts = []
            return tris
        f.read(80)
        n = struct.unpack('<I', f.read(4))[0]
        tris = []
        for _ in range(n):
            d = struct.unpack('<12fH', f.read(50))
            tris.append((d[3:6], d[6:9], d[9:12]))
    return tris

def key(v, q=1e5):
    return (round(v[0]*q), round(v[1]*q), round(v[2]*q))

def report(path):
    tris = load(path)
    verts = {}
    edges = collections.Counter()
    adj = collections.defaultdict(set)
    xs=[];ys=[];zs=[]
    for t in tris:
        ks = [key(v) for v in t]
        for v in t:
            xs.append(v[0]); ys.append(v[1]); zs.append(v[2])
        for i in range(3):
            a,b = ks[i], ks[(i+1)%3]
            edges[tuple(sorted((a,b)))] += 1
            adj[a].add(b); adj[b].add(a)
    bad = sum(1 for c in edges.values() if c != 2)

    # connected components over vertices = shells
    seen=set(); shells=0
    for v in adj:
        if v in seen: continue
        shells += 1
        stack=[v]; seen.add(v)
        while stack:
            u=stack.pop()
            for w in adj[u]:
                if w not in seen:
                    seen.add(w); stack.append(w)

    print(f"--- {path.split(chr(92))[-1]}")
    print(f"    triangles      : {len(tris)}")
    print(f"    non-manifold e : {bad}   (0 = watertight)")
    print(f"    shells         : {shells}   (1 = one solid piece)")
    print(f"    bbox X {min(xs):8.2f} .. {max(xs):8.2f}   ({max(xs)-min(xs):.2f} mm)")
    print(f"    bbox Y {min(ys):8.2f} .. {max(ys):8.2f}   ({max(ys)-min(ys):.2f} mm)")
    print(f"    bbox Z {min(zs):8.2f} .. {max(zs):8.2f}   ({max(zs)-min(zs):.2f} mm)")

for p in sys.argv[1:]:
    report(p)
