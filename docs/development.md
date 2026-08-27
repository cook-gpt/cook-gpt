# Development

## Getting started

End users install **CookGPT - Gourmet Plan & Track** from the App Store. To run from source:

1. Clone the repository and open `Cook GPT/Cook GPT.xcodeproj` in **Xcode 26**
2. Select an iOS simulator or device (deployment target **iOS 26.5**)
3. Build and run (**⌘R**)

## Project layout

| Directory | Responsibility |
|-----------|----------------|
| `Cook GPT/Cook GPT/App/` | App entry, settings store, sample data, factory reset |
| `Cook GPT/Cook GPT/Features/Recipes/` | Recipe list, detail, editor, step timers, sharing |
| `Cook GPT/Cook GPT/Features/Diet/` | Meals tab: schedule views, manual scheduling, auto planning |
| `Cook GPT/Cook GPT/Features/Groceries/` | Shopping list UI, import from schedule/recipe, aggregation |
| `Cook GPT/Cook GPT/Features/Settings/` | Theme, planner options, categories/units, about |
| `Cook GPT/Cook GPT/Models/` | SwiftData `@Model` types and shared enums |
| `Cook GPT/Cook GPT/Shared/` | Calendar helpers, timer audio, formatting, reusable UI |
| `Cook GPT/Cook GPT/LiveActivity/` | Timer Live Activity manager (main app) |
| `CookGPTTimerLiveActivity/` | Widget extension for Lock Screen / Dynamic Island |
| `website/` | Marketing site (React + Vite, Cloudflare Pages) |
| `specs/features/` | Numbered feature specifications |

## Workflow

1. Read [INSTRUCTIONS.md](../INSTRUCTIONS.md) and [CONTRIBUTING.md](../CONTRIBUTING.md)
2. Add or update specs under `specs/features/` for user-visible behavior
3. Implement in the appropriate feature folder; keep SwiftData schema changes in sync with `ModelContainer+CookGPT.swift`
4. Run the app locally and verify timers, meal planning, and grocery flows
5. Update `docs/` when setup or architecture changes

Significant architectural decisions may warrant an ADR in `docs/adr/`.

## Website

```bash
cd website
bun install
bun run build
```

---

[← Docs index](README.md)
