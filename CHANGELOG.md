# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **First-launch onboarding** — three-step tutorial for app overview, starter recipe pack selection, and timer notifications
- **Starter recipe packs** — eleven collections with six recipes each; only selected packs are installed on first launch
- **Reset tutorial** — Settings option to replay onboarding without resetting recipe data
- **Meal planning diet picker** — choose Balanced, Vegetarian, Vegan, or High protein when enough matching recipes exist
- **Breakfast planning guidance** — warning when breakfast cannot be planned until a breakfast-tagged recipe exists

### Changed

- **Onboarding recipe packs** — grid of icon tiles with tap-to-select instead of list rows with descriptions
- **Edit categories** — unified checklist-style list with recipe counts (`Recipes: N`), back and pencil toolbar icons, and delete/reorder in edit mode
- **Categories** — all recipe tags sync into the categories list; deleting a category removes that tag from recipes (recipes are kept)
- **Onboarding categories** — selected collection categories are active in the filter bar; secondary recipe tags are added but inactive
- **Plan your meals** — back chevron and checkmark toolbar buttons; lunch and dinner on the same day use different recipes when possible
- **Meals planner access** — `+` is disabled when no meals can be planned; with only one lunch/dinner recipe, lunch and dinner are mutually exclusive
- **Factory reset** — no sample scheduled meals are created after reset or starter pack import

## [1.0.1] - 2026-09-12

### Added

- **Timer Live Activities** — tapping the Lock Screen or Dynamic Island timer opens the recipe and scrolls to the active step
- **Groceries edit mode** — empty lists show a starter ingredient row; delete-all trash icon
- **Meals edit mode** — trash icon to clear all scheduled meals in the current day, week, or month range

### Changed

- **Groceries** — new ingredient rows stay as drafts until named; blank lines are never saved to the list
- **Settings** — Privacy Policy and Source Code moved to their own section

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
