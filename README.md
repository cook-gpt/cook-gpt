# CookGPT

<p align="center">
  <img src=".github/icon-cropped.png" alt="CookGPT app icon" width="128">
</p>

**CookGPT - Gourmet Plan & Track** is a native **SwiftUI** iOS app for recipes, meal planning, and grocery lists — with step timers on the Lock Screen and Dynamic Island.

Built by [xarlizard](https://github.com/xarlizard). Open source under [MIT](LICENSE).

## Features

- **Recipes** — browse, favorite, filter, scale servings, share, and edit custom recipes
- **Meals** — day / week / month schedule, manual scheduling, and auto meal planning
- **Groceries** — import from schedule or recipes, merge with custom items, checklist UI
- **Timers** — per-step cooking timers with Live Activities and Clock-style alarm sounds
- **Settings** — theme, categories, units, week start day, and full data reset

Landing site: [cook-gpt.pages.dev](https://cook-gpt.pages.dev)

## Quick start

Requires **Xcode 26** and **iOS 26.5** (iPhone or iPad).

```bash
git clone https://github.com/cook-gpt/cook-gpt.git
cd cook-gpt
open "Cook GPT/Cook GPT.xcodeproj"
```

Select a simulator or device, then **Run** (⌘R).

## Repository layout

| Path | Purpose |
|------|---------|
| `Cook GPT/Cook GPT/App/` | Entry point, settings store, sample data, reset |
| `Cook GPT/Cook GPT/Features/` | Recipes, Meals (Diet), Groceries, Settings screens |
| `Cook GPT/Cook GPT/Models/` | SwiftData domain models and enums |
| `Cook GPT/Cook GPT/Shared/` | Calendar, timers, formatting, reusable UI |
| `Cook GPT/Cook GPT/LiveActivity/` | Timer Live Activity (main app side) |
| `Cook GPT/CookGPTTimerLiveActivity/` | Widget extension for Lock Screen / Dynamic Island |
| `website/` | Marketing site (React + Vite, Cloudflare Pages) |
| `specs/features/` | Numbered feature specs |

Each Swift source file includes a header comment describing its role. Key types use `///` documentation where helpful.

## Data & privacy

All recipes, meals, and grocery data stay **on device** (SwiftData). No account or backend required.

## License

MIT — see [LICENSE](LICENSE).

---

## Repository documents

**README** | [INSTRUCTIONS](INSTRUCTIONS.md) | [CHANGELOG](CHANGELOG.md) | [CONTRIBUTING](CONTRIBUTING.md) | [SECURITY](SECURITY.md) | [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
