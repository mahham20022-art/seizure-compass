# Seizure Compass

**Navigate. Differentiate. Localize.**

Seizure Compass is a Flutter web PWA, built as a sister app to
[Najm ICUCalc](https://mahham20022-art.github.io/Najm-icucalc/), sharing the
same dark "monitor-blue" design language and card layout.

Live at: **https://mahham20022-art.github.io/seizure-compass/**

It helps clinicians reason through a paroxysmal event by estimating the
relative probability of:

- **Epileptic seizure**
- **Psychogenic Non-Epileptic Seizure (PNES)**
- **Syncope**
- **Other mimic** (TIA, migraine, cardiac arrhythmia, metabolic, etc.)

using a transparent, weighted-evidence model built from widely taught
seizure-semiology signs — not a black box, and not a diagnosis.

> ⚠️ **Medical disclaimer.** Seizure Compass is a clinical decision-support
> aid based on published seizure semiology literature. It estimates
> probabilities only — it does **not** diagnose epilepsy or any other
> condition. It does not replace clinical judgement, EEG, imaging or
> specialist referral. Always correlate with the full clinical picture.

---

## Modules

1. **Seizure Assessment** — a 5-step wizard (Patient → Aura → Semiology →
   Postictal → Investigations) that ends in a result dashboard showing:
   - Probability bars for each of the four categories
   - Supporting findings and findings against, per category
   - Suggested lobe of onset (localization)
   - Suggested next investigations
   - The medical disclaimer
2. **Localization** — interactive cards for Temporal, Frontal, Parietal,
   Occipital, Insular and Generalized onset, each with typical aura,
   semiology, EEG and MRI findings, and differentials.
3. **Seizure Atlas** — a searchable reference of 21 seizure types, reflex
   epilepsies and epilepsy syndromes (including PNES and convulsive syncope
   as mimics).
4. **Clinical Pearls** — short, evidence-based teaching notes grouped by
   theme (epilepsy vs PNES, localization, syndromes, mimics,
   investigations).

## How the scoring works

`lib/domain/scoring/seizure_scoring_engine.dart` adds up small, documented
"nudges" (`lib/domain/scoring/evidence_weights.dart`) toward each category
for every finding the user selects — e.g. a lateral tongue bite pushes
strongly toward *epileptic seizure*, forced eye closure pushes strongly
toward *PNES*, a presyncopal prodrome with immediate recovery pushes toward
*syncope*. The result is floored above zero and normalized so the four
categories sum to 100%. The same mechanism (`localizationWeights`) scores
the likely lobe of onset from aura and semiology alone.

This is intentionally a heuristic teaching tool, not a validated clinical
prediction rule — every weight and its one-line clinical rationale is
visible in the source and on the result screen itself.

## Design language

Seizure Compass deliberately reuses ICUCalc's palette and shapes rather
than introducing a new visual identity:

- Deep "ink" backgrounds (`#03080f` → `#0a1424`) with a soft cyan radial glow
- Cyan/teal brand accents (`#22d3ee`, `#0ea5e9`, `#38bdf8`)
- Rounded, bordered cards (12–22px radii) with soft shadows
- A category-color system (epileptic = cyan, PNES = violet, syncope =
  green, other mimic = amber) used consistently across bars, chips and tags
- A compass-and-brain logo: a compass dial with tick marks and a true-north
  marker, a stylized brain at its center, an ECG trace running through it,
  and a gradient needle swinging from white to cyan

See `lib/core/theme/` for the exact tokens and `lib/core/widgets/` for the
reusable card/chip/progress-bar components used throughout every screen.

## Folder structure

```
lib/
  app.dart                     MaterialApp + dark theme wiring
  main.dart                    Entry point
  core/
    theme/                     Colors, radii/spacing, ThemeData
    widgets/                   Shared cards, chips, bars, wizard chrome, logo
  data/
    models/                    Plain data classes + enums
    repositories/               Static reference content (atlas, localization, pearls)
  domain/
    scoring/                    Evidence weights + the scoring engine
  features/
    home/                       Home screen (2x2 navigation grid)
    assessment/                 5-step wizard, controller, result dashboard
      steps/
      result/
    localization/                Module 2
    library/                     Module 3 — Seizure Atlas
    pearls/                      Module 4
assets/fonts/                  Bundled Inter font (offline-safe, OFL licensed)
web/                            PWA manifest, icons, custom flutter_bootstrap.js
```

## Running locally

```bash
flutter pub get
flutter run -d chrome
```

## Building for the web

```bash
flutter build web --release --base-href /seizure-compass/
```

`web/flutter_bootstrap.js` is a custom (not auto-generated) bootstrap script
that points CanvasKit at the app's own bundled `canvaskit/` folder instead of
Google's CDN, and `assets/fonts/Inter.ttf` is bundled directly — both so the
installed PWA keeps working fully offline and on restricted hospital
networks, with no runtime dependency on an external CDN.

## Deployment (GitHub Pages)

Deployment is automated by
[`.github/workflows/deploy.yml`](.github/workflows/deploy.yml): on every push
to `main`, it runs `flutter analyze`, builds the release web bundle with the
`/seizure-compass/` base href, and publishes `build/web` to the `gh-pages`
branch via `peaceiris/actions-gh-pages`.

The app is served at:

```
https://mahham20022-art.github.io/seizure-compass/
```

To trigger a deploy manually, run the "Deploy to GitHub Pages" workflow from
the Actions tab (`workflow_dispatch`).

## Tech stack

- Flutter (stable) + Material 3, `useMaterial3: true`
- `provider` for the wizard's single `ChangeNotifier` controller — the only
  third-party dependency
- No backend, no login, no Firebase, no analytics
- Fully static, installable PWA (manifest + service worker generated by
  `flutter build web`)
