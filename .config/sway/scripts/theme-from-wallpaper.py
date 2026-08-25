#!/usr/bin/env python3
"""Ryoku-style palette extractor: wallpaper -> desktop palette.
Outputs shell-exportable lines KEY=value (hex without #)."""
import sys, colorsys, warnings
from collections import Counter
from PIL import Image

def clamp(v): return max(0, min(255, v))
def hx(rgb): return "%02x%02x%02x" % tuple(int(clamp(c)) for c in rgb)

def sat_lightness(rgb):
    r, g, b = [c / 255 for c in rgb]
    h, l, s = colorsys.rgb_to_hls(r, g, b)
    return h, l, s

def main(path):
    img = Image.open(path).convert("RGB").resize((96, 54))
    q = img.quantize(colors=16, method=Image.Quantize.MEDIANCUT).convert("RGB")
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        counts = Counter(q.getdata())
    clusters = []
    for rgb, n in counts.most_common():
        h, l, s = sat_lightness(rgb)
        clusters.append({"rgb": rgb, "n": n, "h": h, "l": l, "s": s})

    darks  = sorted([c for c in clusters if c["l"] < 0.28], key=lambda c: c["l"])
    lights = sorted([c for c in clusters if c["l"] > 0.72], key=lambda c: -c["l"])
    vivid  = sorted([c for c in clusters if c["s"] > 0.30 and 0.15 < c["l"] < 0.75],
                    key=lambda c: -(c["s"] * (c["n"] ** 0.5)))

    bg     = (darks[0] if darks else min(clusters, key=lambda c: c["l"]))["rgb"]
    bg_rgb = list(bg)
    surf   = tuple(clamp(v * 0.45 + 42 * 0.55) for v in bg_rgb)
    base_text = (lights[0] if lights else max(clusters, key=lambda c: c["l"]))["rgb"]
    text   = tuple(clamp(t * 0.35 + 243 * 0.65) for t in base_text)
    muted  = tuple(clamp(t * 0.45 + (bg_rgb[i] + 60) * 0.55) for i, t in enumerate(text))

    acc1 = vivid[0]["rgb"] if vivid else (226, 52, 42)
    # Brighten accent jika terlalu gelap agar tetap "pop"
    ah, al, asat = sat_lightness(acc1)
    if al < 0.32 and asat > 0.05:
        acc1 = tuple(int(c * 255) for c in colorsys.hls_to_rgb(ah, 0.48, min(asat * 1.3, 1.0)))
    acc2 = None
    for v in vivid[1:]:
        h1, _, _ = sat_lightness(acc1); h2, _, _ = sat_lightness(v["rgb"])
        dh = min(abs(h1 - h2), 1 - abs(h1 - h2))
        if dh > 0.12 or True and dh > 0.06:
            acc2 = v["rgb"]; break
    if acc2 is None:
        acc2 = tuple(clamp(c * 1.35) for c in acc1)

    urgent = (217, 164, 65)

    print(f"BG={hx(bg)}")
    print(f"SURF={hx(surf)}")
    print(f"TXT={hx(text)}")
    print(f"MUT={hx(muted)}")
    print(f"ACC={hx(acc1)}")
    print(f"ACC2={hx(acc2)}")
    print(f"URG={hx(urgent)}")

if __name__ == "__main__":
    main(sys.argv[1])
