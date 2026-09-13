# CookGPT Cursor Rules

Guidance for AI assistants working in this repository.

## Architecture

- Native **SwiftUI** iOS app; all user data stays on device via **SwiftData**
- Feature code lives under `src/CookGPT/Features/` (Recipes, Diet/Meals, Groceries, Settings)
- User preferences go through `AppSettingsStore` — not scattered `UserDefaults` keys
- Bump `schemaVersion` in `ModelContainer+CookGPT.swift` when SwiftData models change incompatibly
- `CookingTimerAttributes.swift` is duplicated in the main app and widget extension — keep both copies in sync
- Marketing site changes belong in `website/` (React + Vite)
- **Localization**: UI strings live in `src/CookGPT/<locale>.lproj/Localizable.strings` (generated from `scripts/translation_data.py`). Do **not** use `Localizable.xcstrings` — Xcode pollutes it on Run and can exhaust RAM. Run `python3 scripts/generate_localizations.py` after editing translations. See [specs/features/12-localization.md](../specs/features/12-localization.md).

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
