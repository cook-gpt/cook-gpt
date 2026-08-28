# Architecture

CookGPT is a native **SwiftUI** iOS app for recipes, meal planning, and grocery lists. All user data stays on device via **SwiftData**.

## Layers

### Features (`src/CookGPT/Features/`)

Tab-based UI organized by domain:

| Tab | Path | Responsibility |
|-----|------|----------------|
| Recipes | `Features/Recipes/` | Browse, favorite, filter, scale, share, and edit recipes |
| Meals | `Features/Diet/` | Day / week / month schedule, manual scheduling, auto meal planning |
| Groceries | `Features/Groceries/` | Shopping list, import from schedule or recipes, checklist |
| Settings | `Features/Settings/` | Theme, categories, units, week start, data reset |

### Models (`src/CookGPT/Models/`)

SwiftData `@Model` types and shared enums. Schema versioning lives in `ModelContainer+CookGPT.swift` — bump `schemaVersion` when models change incompatibly.

### Shared (`src/CookGPT/Shared/`)

Cross-feature utilities: calendar/week boundaries (`MealScheduleCalendar`), timer audio, formatting, and reusable SwiftUI components.

### App (`src/CookGPT/App/`)

Entry point, `AppSettingsStore` (UserDefaults preferences), sample data seeding, and factory reset.

### Live Activity (`src/CookGPT/LiveActivity/` + `src/CookGPTTimerLiveActivity/`)

Per-step cooking timers surface on the Lock Screen and Dynamic Island. `CookingTimerAttributes.swift` is duplicated in the main app and widget extension targets — keep both files in sync.

## Data flow

```
SwiftUI Views → @Query / AppSettingsStore → SwiftData (on device)
Cooking timers → Live Activity manager → Widget extension
```

No backend or account is required. Recipes, meals, and grocery data never leave the device.

## Website

Marketing site in `website/` (React + Vite). App Store links and listing copy are centralized in `website/src/utils/releases.ts`.

See `specs/features/` for detailed requirements per feature.

---

[← Docs index](README.md)
