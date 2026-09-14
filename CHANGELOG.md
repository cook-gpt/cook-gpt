# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-09-14

### Added

- **Custom diets (Settings → Advanced → Diets)** — add, edit, and delete diet profiles with mandatory and forbidden recipe categories; optional per-meal overrides for breakfast, lunch, and dinner (e.g. low-carb dinners on a keto plan)
- **General meal rules** — global forbidden categories (default: dessert) and per-slot mandatory/forbidden rules for breakfast, lunch, and dinner (default: breakfast requires Breakfast tag; lunch and dinner forbid Breakfast)
- **Default diet from list** — swipe right on a diet in Settings to make it the default
- **Essential categories** — Breakfast and Dessert always exist after reset or first launch for diet rules, but stay hidden from the Recipes filter bar until enabled

### Changed

- **Settings** — removed “Pro features coming soon”; meal planning now uses custom diet profiles and general meal rules instead of fixed diet types
- **Diet editor** — “Active diet” renamed to “Default diet”; tab bar hidden while editing a diet or picking its categories
- **Category rules UI** — mandatory/forbidden pickers use the checklist layout with `Recipes: N` counts; single selections show the category name; ✓ saves changes and back discards
- **Edit categories** — visibility toggles use a blue eye (visible) and red crossed-out eye (hidden) instead of checkmarks
- **Recipe category sheet** — ✕ and ✓ toolbar icons instead of Cancel/Save labels
- **Meal overrides** — empty per-meal custom rules are turned off automatically when saving a diet

## [1.0.1] - 2026-09-13

### Added

- **Localization** — Spanish (Spain), Catalan, French, Dutch, German, Chinese (Simplified), Japanese, Italian, Portuguese, English, and Russian; per-app language picker in **Settings → CookGPT → Preferred Language → Language**; UI strings in `<locale>.lproj/Localizable.strings` (generated from `scripts/translation_data.py`)
- **Recipe ratings** — replace favorites with optional 1–5 star ratings; stars appear between title and summary on recipe rows
- **Rating sort** — new Recipes sort option; rated recipes always appear before unrated ones, then sort by star count
- **Rating sheet** — swipe right on a recipe to open an App Store–style star picker
- **Rating editor** — set or clear a rating from the recipe editor via a picker menu (No rating, ★ … ★★★★★)
- **Ingredient unit pluralization** — singular/plural labels for cups, pieces, and units based on quantity in recipes, groceries, and share text
- **Localized starter recipes** — onboarding collection recipes (titles, summaries, ingredients, and steps) seed in the app’s active language
- **Recipe delete confirmation** — confirm before deleting a recipe from the list; message states how many planned meals will also be removed
- **Meal delete confirmation** — confirm before removing a planned meal via swipe on the Meals tab
- **First-launch onboarding** — three-step tutorial for app overview, starter recipe pack selection, and timer notifications
- **Starter recipe packs** — eleven collections with six recipes each; only selected packs are installed on first launch
- **Reset tutorial** — Settings option to replay onboarding without resetting recipe data
- **Meal planning diet picker** — choose Balanced, Vegetarian, Vegan, or High protein when enough matching recipes exist
- **Breakfast planning guidance** — warning when breakfast cannot be planned until a breakfast-tagged recipe exists
- **Timer Live Activities** — tapping the Lock Screen or Dynamic Island timer opens the recipe and scrolls to the active step
- **Groceries edit mode** — empty lists show a starter ingredient row; delete-all trash icon
- **Meals edit mode** — trash icon to clear all scheduled meals in the current day, week, or month range

### Changed

- **Onboarding recipe packs** — grid of icon tiles with tap-to-select instead of list rows with descriptions
- **Edit categories** — unified checklist-style list with recipe counts (`Recipes: N`), back and pencil toolbar icons, and delete/reorder in edit mode
- **Categories** — all recipe tags sync into the categories list; deleting a category removes that tag from recipes (recipes are kept)
- **Onboarding categories** — selected collection categories are active in the filter bar; secondary recipe tags are added but inactive
- **Plan your meals** — back chevron and checkmark toolbar buttons; lunch and dinner on the same day use different recipes when possible; opening from the toolbar or a day’s “+ Plan meals” uses the correct start date on first open and when reopening the same day
- **Meals planner access** — `+` is disabled when no meals can be planned; with only one lunch/dinner recipe, lunch and dinner are mutually exclusive
- **Factory reset** — no sample scheduled meals are created after reset or starter pack import
- **Groceries** — new ingredient rows stay as drafts until named; blank lines are never saved to the list
- **Settings** — Privacy Policy and Source Code moved to their own section
- **Meal planning** — prioritize recipes using a mix of star rating and difficulty instead of favorites
- **Recipe editor & rating sheet** — Cancel/Save and Cancel/Done toolbar labels replaced with ✕ and ✓ icons
- **Localization pipeline** — migrate from String Catalogs to classic `.lproj` files to avoid Xcode memory issues; add missing strings for empty states, onboarding, recipe editor, and measurement units
- **Onboarding copy** — “favorite” wording updated to “rate” recipes

### Fixed

- **Recipe swipe-delete** — prevent SwiftData crashes when deleting recipes, including those with planned meals and consecutive deletes, while the Meals tab still holds stale schedule rows
- **Plan meals start date** — sheet no longer defaults to today when opened from the selected day, week, or month

## [1.0.0] - 2026-08-27

First App Store release of **CookGPT - Gourmet Plan & Taste**.

### Added

- **Recipes** — browse, favorite, filter by category, scale servings, share, and create or edit custom recipes with timed steps
- **Meals** — day, week, and month schedule views; manual scheduling; auto meal planning by diet
- **Groceries** — shopping list with check-off; import from schedule or one recipe at a time; optional merge with existing items
- **Cooking timers** — per-step timers with Lock Screen Live Activities, Dynamic Island, and Clock-style alarm sounds on device
- **Settings** — theme, meal planner options, custom categories and units, configurable week start day, and full data reset
- **Marketing website** — [cook-gpt.pages.dev](https://cook-gpt.pages.dev) with localized landing, docs, and privacy pages

### Changed

- App Store name: **CookGPT - Gourmet Plan & Taste**
- Open-source documentation: file headers and contributor code-structure guide

## [0.1.0] - 2026-08-25

### Added

- Initial **cook-gpt** rebrand from [@open-templates](https://github.com/open-templates) repository template
- SwiftUI iOS app scaffold (`src/`)
- Repository docs, Dependabot, CODEOWNERS, and issue/PR templates

---

## Repository documents

[1.0.1]: https://github.com/cook-gpt/cook-gpt/compare/v1.0.0...v1.0.1

[README](README.md) | [INSTRUCTIONS](INSTRUCTIONS.md) | **CHANGELOG** | [CONTRIBUTING](CONTRIBUTING.md) | [SECURITY](SECURITY.md) | [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
