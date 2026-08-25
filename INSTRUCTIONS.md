# Instructions — cook-gpt

Guide for maintainers and coding agents working on **cook-gpt/cook-gpt**.

## Project

**cook-gpt** is an app that guides you through cooking recipes, health diets, and groceries management. The iOS client lives under `Cook GPT/`.

Maintained by [xarlizard](https://github.com/xarlizard).

## First steps

1. Open `Cook GPT/Cook GPT.xcodeproj` in Xcode and run the app.
2. Edit [`.github/dependabot.yml`](.github/dependabot.yml) when you add package ecosystems (e.g. Swift Package Manager).
3. Never commit secrets; use `.env.example` only when backend services are added.

## CHANGELOG workflow

Use `feat:`, `fix:`, `docs:` prefixes. Group changes per release — see [Keep a Changelog](https://keepachangelog.com/).

## Agent checklist

1. Read **INSTRUCTIONS.md** (this file) and [index.md](index.md)
2. Read [.agents/skills/index.md](.agents/skills/index.md) and [.agents/skills/README.md](.agents/skills/README.md)
3. Add numbered concepts under `specs/features/` when adding user-visible behavior
4. Use conventional commits for features/fixes destined for CHANGELOG

---

## Repository documents

[README](README.md) | **INSTRUCTIONS** | [CHANGELOG](CHANGELOG.md) | [CONTRIBUTING](CONTRIBUTING.md) | [SECURITY](SECURITY.md) | [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
