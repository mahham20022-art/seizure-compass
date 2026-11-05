"""Build static, Latin-subset TTFs for Flutter from The Tract's variable WOFF2
fonts (Flutter cannot load WOFF2). Run in CI before `flutter build`:
    pip install fonttools brotli && python tool/build_fonts.py
"""
from pathlib import Path
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer
from fontTools import subset

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "fonts"
OUT.mkdir(parents=True, exist_ok=True)

# Basic Latin, Latin-1, Latin Extended-A, Greek (µ, α…), punctuation, arrows,
# math (≥ ≤ ± × −) and the few symbols the UI uses.
UNICODES = "U+0020-007E,U+00A0-017F,U+0370-03FF,U+2000-206F,U+2190-21FF,U+2200-22FF,U+2070-209F,U+20AC,U+2122,U+25CF,U+2713"

JOBS = [
    ("SourceSans3-VF.woff2", "SourceSans3", {"Regular": 400, "SemiBold": 600, "Bold": 700}),
    ("Newsreader-VF.woff2", "Newsreader", {"Medium": 500, "SemiBold": 600}),
    ("Newsreader-Italic-VF.woff2", "Newsreader", {"SemiBoldItalic": 600}),
]

for src, family, weights in JOBS:
    for style, wght in weights.items():
        font = TTFont(ROOT / "tool" / src)
        font.flavor = None
        axes = {a.axisTag: a for a in font["fvar"].axes}
        loc = {"wght": wght}
        if "opsz" in axes:
            loc["opsz"] = min(max(16, axes["opsz"].minValue), axes["opsz"].maxValue)
        static = instancer.instantiateVariableFont(font, loc)
        opts = subset.Options()
        opts.layout_features = ["kern", "liga", "calt", "lnum", "tnum", "frac", "case"]
        opts.name_IDs = ["*"]
        sub = subset.Subsetter(opts)
        sub.populate(unicodes=subset.parse_unicodes(UNICODES))
        sub.subset(static)
        dest = OUT / f"{family}-{style}.ttf"
        static.save(dest)
        print(dest.name, dest.stat().st_size // 1024, "KB")
