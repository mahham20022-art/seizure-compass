"""Copy index.html into a folder per app route so GitHub Pages answers deep
links with 200 (not the 404.html fallback), which search engines index.
Run after `flutter build web`: python tool/spa_routes.py build/web
Slugs must match AppRoutes.slug in lib/app_routes.dart."""
import re, sys
from pathlib import Path

web = Path(sys.argv[1])
root = Path(__file__).resolve().parent.parent

def slug(s):
    s = re.sub(r"[’'()]", "", s.lower())
    s = re.sub(r"[^a-z0-9]+", "-", s)
    return s.strip("-")

lib = (root / "lib/data/repositories/seizure_library_data.dart").read_text()
names = re.findall(r"^\s{4}name: '((?:[^'\\]|\\.)*)'", lib, re.M)
examples = re.findall(r"ExampleCase\('([a-z0-9-]+)'", (root / "lib/data/repositories/example_cases.dart").read_text())
regions = ["temporal", "frontal", "parietal", "occipital", "insular", "generalized"]

titles = {
    "assess": "Seizure assessment", "atlas": "Seizure Atlas", "history": "History of epilepsy",
    "figures": "Notable figures", "pearls": "Clinical pearls", "search": "Search", "about": "Methods and references",
    "localization": "Localization",
}
routes = list(titles)
for n in names:
    n = n.replace(chr(92), "")
    r = f"atlas/{slug(n)}"; routes.append(r); titles[r] = f"{n} — Seizure Atlas"
for e in examples:
    r = f"example/{e}"; routes.append(r); titles[r] = "Worked example: " + e.replace("-", " ")
for g in regions:
    r = f"localization/{g}"; routes.append(r); titles[r] = f"{g.capitalize()} onset — Localization"

base = "https://compass.thetract.org"
html = (web / "index.html").read_text()
for r in routes:
    d = web / r
    d.mkdir(parents=True, exist_ok=True)
    page = re.sub(r'(<link rel="canonical" href=")[^"]*', rf"\g<1>{base}/{r}/", html)
    page = re.sub(r'(<meta property="og:url" content=")[^"]*', rf"\g<1>{base}/{r}/", page)
    page = re.sub(r"<title>[^<]*</title>", f"<title>{titles[r]} · Seizure Compass</title>", page)
    (d / "index.html").write_text(page)
print(len(routes), "routes")

public = [""] + [r for r in routes if r != "search"]
(web / "sitemap.xml").write_text(
    '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
    + "".join(f"  <url><loc>{base}/{r + '/' if r else ''}</loc></url>\n" for r in public)
    + "</urlset>\n"
)
