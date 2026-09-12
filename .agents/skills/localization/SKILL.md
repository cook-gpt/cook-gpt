---
name: localization
description: >-
  iOS localization workflow for CookGPT. Use when adding UI strings, translating
  the app, updating supported languages, or working with Localizable.xcstrings.
---

# Localization — CookGPT

CookGPT ships eleven languages and supports per-app language selection in **Settings → CookGPT → Preferred Language → Language**.

## Before changing strings

1. Read [specs/features/12-localization.md](../../../specs/features/12-localization.md).
2. Confirm the English key does not already exist in `scripts/translation_data.py`.

## Adding or updating a string

1. Add the English key and all ten locale translations to `scripts/translation_data.py`:

   ```python
   "My new label": t("…", "…", "…", "…", "…", "…", "…", "…", "…", "…"),
   ```

   Locales in order: `es`, `ca`, `fr`, `nl`, `de`, `zh-Hans`, `ja`, `it`, `pt`, `ru`.

2. Regenerate catalogs:

   ```bash
   python3 scripts/generate_localizations.py
   ```

3. Use the string in Swift:
   - **SwiftUI** — `Text("My new label")` (auto-localized when key matches catalog).
   - **Enums / logic** — `String(localized: "My new label")`.
   - **Format strings** — catalog key `"Count: %lld"` + `String(format: String(localized: "Count: %lld"), value)`.

4. Update [CHANGELOG.md](../../../CHANGELOG.md) for user-visible additions.

## Do not

- Edit `Localizable.xcstrings` by hand (regenerate from `translation_data.py`).
- Add a new locale without updating `knownRegions` in `project.pbxproj` and all entries in `translation_data.py`.
- Localize user-entered recipe text or custom category names.
- Commit partial translations (every key needs all ten non-English locales).

## Key files

| File | Role |
|------|------|
| `scripts/translation_data.py` | Source of truth for translations |
| `scripts/generate_localizations.py` | Builds `.xcstrings` files |
| `src/CookGPT/Localizable.xcstrings` | Generated UI string catalog |
| `src/CookGPT/InfoPlist.xcstrings` | Generated display name catalog |
| `src/CookGPT/App/AppSettingsStore.swift` | `label(forCategoryID:)` localizes default categories |
| `src/CookGPT/Features/Onboarding/RecipePackCatalog.swift` | `localizedLabel` / `localizedSummary` |

## Verify

After changes, build the app and confirm `.lproj` folders exist in the bundle (`es.lproj`, `ca.lproj`, etc.). On device, check **Settings → CookGPT → Preferred Language** lists all supported languages.
