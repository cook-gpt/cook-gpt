---
type: Feature
title: Localization
description: Supported languages, string catalogs, and per-app language selection on iOS.
tags: [ios, localization, i18n, settings]
timestamp: 2026-09-13T00:00:00Z
---

## Supported languages

| Locale | Language |
|--------|----------|
| `en` | English (source) |
| `es` | Spanish (Spain) |
| `ca` | Catalan |
| `fr` | French |
| `nl` | Dutch |
| `de` | German |
| `zh-Hans` | Chinese (Simplified) |
| `ja` | Japanese |
| `it` | Italian |
| `pt` | Portuguese |
| `ru` | Russian |

All locales are declared in `src/CookGPT.xcodeproj` `knownRegions`.

## User-facing behavior

- **Per-app language** — Users change language in **Settings → CookGPT → Preferred Language → Language**. This section appears because the app bundle ships multiple localizations (same pattern as Google Drive and other official apps).
- **In-app hint** — Settings → Language row shows the active locale; footer text directs users to the system language picker.
- **Scope** — All app UI strings (tabs, settings, onboarding, categories, meal planning, groceries, alerts, accessibility labels) are localized. Sample recipe content (titles, ingredients, instructions in seed data) remains in English.

## Implementation

| Asset | Path | Purpose |
|-------|------|---------|
| UI strings | `src/CookGPT/<locale>.lproj/Localizable.strings` | Per-locale UI strings (~230 keys) |
| App name | `src/CookGPT/<locale>.lproj/InfoPlist.strings` | `CFBundleDisplayName` |
| Translation source | `scripts/translation_data.py` | English key → locale map |
| Generator | `scripts/generate_localizations.py` | Regenerates all `.lproj` files |

### Build settings

- `LOCALIZATION_PREFERS_STRING_CATALOGS = NO` — uses classic `.strings` files, not `.xcstrings`.
- `STRING_CATALOG_GENERATE_SYMBOLS = NO` — symbol generation disabled.
- `SWIFT_EMIT_LOC_STRINGS = YES` — SwiftUI literals resolve from `Localizable.strings` at runtime.
- **Do not use `Localizable.xcstrings`** — Xcode merges auto-extracted junk keys on Run (`%@ %@`, empty keys) which caused extreme Xcode memory use (~180 GB). The generator deletes legacy `.xcstrings` files if present.

### Adding or updating strings

1. Add the English key and translations to `scripts/translation_data.py` (use the `t(es, ca, fr, nl, de, zh, ja, it, pt, ru)` helper).
2. Run `python3 scripts/generate_localizations.py` from the repo root.
3. In Swift:
   - SwiftUI `Text("…")` literals auto-resolve from the catalog when `SWIFT_EMIT_LOC_STRINGS = YES`.
   - Enum `.label` properties and non-view strings use `String(localized: "…")`.
   - Default category labels use `AppSettingsStore.label(forCategoryID:)` which localizes known category IDs.
   - Recipe pack tiles use `RecipePackDefinition.localizedLabel` / `localizedSummary`.

### Format strings

Use `%lld` / `%@` in the catalog and `String(format: String(localized: "…"), …)` in code (e.g. `"Default servings: %lld"`, `"Recipes: %lld"`).

### Plural units

`cup`/`cups`, `piece`/`pieces`, and `unit`/`units` use static catalog keys (`unit_cup.one`, `unit_cup.other`, …) selected via `switch` — never build localization keys dynamically. Read-only views call `localizedLabel(for:quantity:)` (**one** when quantity is `1`, otherwise **other**). Edit-mode pickers call `localizedPickerLabel(for:)` with combined forms like `cup(s)` / `taza(s)` / `unidad(es)`.

## Non-goals

- Localizing user-created recipe text or custom category names
- Localizing iPhone Clock alarm sound names (brand names; kept as in Clock app)
- Live Activity extension strings (minimal; extension has separate bundle)

## Related

- [05 — Platform and architecture](05-platform-and-architecture.md) — toolchain and `knownRegions`
- [06 — App shell](06-app-shell.md) — tab labels
- `.agents/skills/localization/SKILL.md` — agent workflow for i18n changes
