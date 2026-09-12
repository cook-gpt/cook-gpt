# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
