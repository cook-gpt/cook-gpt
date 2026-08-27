# Contributing

Thanks for contributing to **cook-gpt**.

## Setup

```bash
git clone https://github.com/cook-gpt/cook-gpt.git
cd cook-gpt
```

Open `Cook GPT/Cook GPT.xcodeproj` in **Xcode 26** (iOS **26.5** deployment target) to build and run the iOS app.

## Code structure

The iOS app lives under `Cook GPT/`. Each Swift source file starts with a short header comment describing its role; core types also use `///` documentation where helpful.

| Path | Responsibility |
|------|----------------|
| `Cook GPT/Cook GPT/App/` | App entry, `AppSettingsStore`, sample data seeding, factory reset |
| `Cook GPT/Cook GPT/Features/Recipes/` | Recipe list, detail, editor, step timers, sharing |
| `Cook GPT/Cook GPT/Features/Diet/` | Meals tab: schedule views, manual scheduling, auto planning |
| `Cook GPT/Cook GPT/Features/Groceries/` | Shopping list UI, import from schedule/recipe, aggregation |
| `Cook GPT/Cook GPT/Features/Settings/` | Theme, planner options, categories/units, about |
| `Cook GPT/Cook GPT/Models/` | SwiftData `@Model` types and shared enums |
| `Cook GPT/Cook GPT/Shared/` | Calendar helpers, timer audio, formatting, reusable UI |
| `Cook GPT/Cook GPT/LiveActivity/` | Timer Live Activity manager (main app) |
| `Cook GPT/CookGPTTimerLiveActivity/` | Widget extension for Lock Screen / Dynamic Island |

**Conventions**

- **Persistence** — SwiftData via `CookGPTModelContainer`; bump `schemaVersion` in `ModelContainer+CookGPT.swift` when models change incompatibly.
- **Settings** — User preferences go through `AppSettingsStore` (UserDefaults), not scattered keys.
- **Meal weeks** — Week boundaries use `MealScheduleCalendar`, which reads the week-start day from settings.
- **Live Activity** — `CookingTimerAttributes.swift` is duplicated in the main app and widget extension targets; keep both files in sync.
- **Website** — Marketing site is in `website/` (React + Vite); run `bun run build` from that folder to verify changes.

Feature specs and architecture notes live in `specs/features/`. Prefer matching existing naming, file layout, and SwiftUI patterns when adding code.

## Pull requests

1. Branch from `main`.
2. Open a PR using the repository template.

## License

By contributing, you agree your changes are licensed under MIT.

---

## Repository documents

[README](README.md) | [INSTRUCTIONS](INSTRUCTIONS.md) | [CHANGELOG](CHANGELOG.md) | **CONTRIBUTING** | [SECURITY](SECURITY.md) | [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
