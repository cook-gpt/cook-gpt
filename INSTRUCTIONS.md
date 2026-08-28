# Instructions — cook-gpt

Guide for maintainers and coding agents working on **cook-gpt/cook-gpt**.

## Project

**cook-gpt** is an app that guides you through cooking recipes, health diets, and groceries management. The iOS client lives under `src/`.

Maintained by [xarlizard](https://github.com/xarlizard).

## First steps

1. Open `src/CookGPT.xcodeproj` in Xcode and run the app.
2. Edit [`.github/dependabot.yml`](.github/dependabot.yml) when you add package ecosystems (e.g. Swift Package Manager).
3. Never commit secrets; use `.env.example` only when backend services are added.

## CHANGELOG workflow

Use `feat:`, `fix:`, `docs:` prefixes. Group changes per release — see [Keep a Changelog](https://keepachangelog.com/).

## Agent checklist

1. Read **INSTRUCTIONS.md** (this file), [docs/README.md](docs/README.md), and [.cursor/rules.md](.cursor/rules.md)
2. Read [.agents/skills/README.md](.agents/skills/README.md) and [.agents/skills/xcode-tools/SKILL.md](.agents/skills/xcode-tools/SKILL.md)
3. Add numbered concepts under `specs/features/` when adding user-visible behavior
4. Use conventional commits for features/fixes destined for CHANGELOG

---

## Repository documents

[README](README.md) | [Docs](docs/README.md) | **INSTRUCTIONS** | [CHANGELOG](CHANGELOG.md) | [CONTRIBUTING](CONTRIBUTING.md) | [SECURITY](SECURITY.md) | [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
