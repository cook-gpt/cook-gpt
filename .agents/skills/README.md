# CookGPT — Agent Skills Index

Cursor skill packs and module guides for **CookGPT**.

## Skill packs

| Skill | When to use |
|-------|-------------|
| [xcode-tools](xcode-tools/SKILL.md) | Build, test, diagnostics, Apple docs via Xcode MCP |
| [spec-first](spec-first/SKILL.md) | Spec-driven feature workflow |
| [swiftdata](swiftdata/SKILL.md) | `@Model` types and schema versioning |
| [live-activity](live-activity/SKILL.md) | Cooking timer Live Activity + widget extension |
| [marketing-website](marketing-website/SKILL.md) | React marketing site in `website/` |

## Layers

| Layer | Path |
|-------|------|
| Feature contracts | [`index.md`](../../index.md) (repo root) |
| Skills index | [`index.md`](index.md) |
| Cursor rules | [`.cursor/rules.md`](../../.cursor/rules.md) |
| Local modules | [`modules/`](modules/) — optional deep-dive guides |

## Xcode MCP

Configured in Cursor as **xcode-tools** (`xcrun mcpbridge`). Requires Xcode running with `src/CookGPT.xcodeproj` open. Start with the [xcode-tools](xcode-tools/SKILL.md) skill.

## Extension order

1. Read **INSTRUCTIONS.md**, **docs/README.md**, and **`.cursor/rules.md`**
2. Pick the relevant skill pack(s) from the table above
3. Add application code under `src/`
4. Document features in `specs/features/` and link from root `index.md`
