"""Konvertiert die Bilder aus dem iOS-Asset-Katalog in Web-Formate (einmalig ausführen).

Aufruf (aus dem Ordner web/):  python3 scripts/convert_assets.py
"""
import glob
import json
import os
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
XC = os.path.join(HERE, "..", "..", "weekleat", "weekleat", "Assets", "Assets.xcassets")
OUT = os.path.join(HERE, "..", "public", "img")
os.makedirs(os.path.join(OUT, "food"), exist_ok=True)
os.makedirs(os.path.join(OUT, "icons"), exist_ok=True)


def first_png(imageset):
    files = sorted(glob.glob(os.path.join(imageset, "*.png")), key=len)
    return files[0] if files else None


def corner_color(im):
    rgb = im.convert("RGB")
    w, h = rgb.size
    px = [rgb.getpixel((x, y)) for x, y in [(4, 4), (w - 5, 4), (4, h - 5), (w - 5, h - 5)]]
    r, g, b = (sum(p[i] for p in px) // len(px) for i in range(3))
    return "#%02x%02x%02x" % (r, g, b)


meta = {}
for folder in ["Images", "letter"]:
    for imageset in sorted(glob.glob(os.path.join(XC, folder, "*.imageset"))):
        name = os.path.basename(imageset)[: -len(".imageset")]
        src = first_png(imageset)
        if not src:
            continue
        im = Image.open(src)
        if name.endswith(".large"):
            base = name[: -len(".large")]
            if folder == "letter":
                continue  # Buchstaben-Banner im Original sind Platzhalter
            im.convert("RGB").resize((808, 274), Image.LANCZOS).save(
                os.path.join(OUT, "food", base + ".large.webp"), quality=72)
            meta.setdefault(base, {})["large"] = True
        else:
            im.convert("RGB").resize((240, 240), Image.LANCZOS).save(
                os.path.join(OUT, "food", name + ".webp"), quality=78)
            meta.setdefault(name, {})["bg"] = corner_color(im)

with open(os.path.join(HERE, "..", "src", "data", "images.json"), "w") as f:
    json.dump(meta, f, indent=1, sort_keys=True)

for imageset in glob.glob(os.path.join(XC, "icons_new", "*.imageset")):
    name = os.path.basename(imageset)[: -len(".imageset")].replace(".icon", "").replace(".", "-")
    Image.open(first_png(imageset)).save(os.path.join(OUT, "icons", name + ".png"), optimize=True)

app = Image.open(os.path.join(XC, "AppIcon.appiconset", "appstore.png")).convert("RGB")
for size in (192, 512, 180):
    app.resize((size, size), Image.LANCZOS).save(os.path.join(OUT, "app-%d.png" % size), optimize=True)
print(len(meta), "Bilder konvertiert")
