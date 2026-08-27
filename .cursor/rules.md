# CookGPT Cursor Rules

Guidance for AI assistants working in this repository.

## Architecture

- Native **SwiftUI** iOS app; all user data stays on device via **SwiftData**
- Feature code lives under `Cook GPT/Cook GPT/Features/` (Recipes, Diet/Meals, Groceries, Settings)
- User preferences go through `AppSettingsStore` — not scattered `UserDefaults` keys
- Bump `schemaVersion` in `ModelContainer+CookGPT.swift` when SwiftData models change incompatibly
- `CookingTimerAttributes.swift` is duplicated in the main app and widget extension — keep both copies in sync
- Marketing site changes belong in `website/` (React + Vite)

## Workflow

- Read **INSTRUCTIONS.md**, **docs/README.md**, and **.agents/skills/xcode-tools/SKILL.md** before larger changes
- Update `specs/features/` before implementing user-visible behavior
- Keep diffs small and focused; match existing naming and file layout
- Update `docs/` when setup or architecture changes
- Prefer **Xcode MCP** (`xcode-tools`) for local builds and tests — see `.agents/skills/xcode-tools/SKILL.md`

## Constraints

- Never add a backend, account system, or cloud sync unless explicitly requested
- Never commit secrets or API keys
- Do not couple feature UI to infrastructure that does not exist yet
- Prefer extending existing SwiftUI patterns over new abstractions
