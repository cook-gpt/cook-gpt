---
name: spec-first
description: >-
  Spec-first development workflow for CookGPT. Use before adding or changing
  user-visible behavior, when implementing features from specs, or when the
  user asks to plan work from specifications.
---

# Spec-first — CookGPT

CookGPT is spec-driven. Do not implement user-visible behavior without an updated spec.

## Before coding

1. Read [INSTRUCTIONS.md](../../INSTRUCTIONS.md) and [docs/README.md](../../docs/README.md).
2. Find or create a spec under `specs/features/`.
3. Link the spec from [index.md](../../index.md) if it is new.
4. Confirm scope matches [specs/features/11-mvp-implementation.md](../../specs/features/11-mvp-implementation.md) when relevant.

## Spec file format

Use YAML frontmatter (see existing specs):

```yaml
---
type: Feature
title: Short title
description: One-line summary
tags: [ios, swiftui]
timestamp: 2026-08-25T00:00:00Z
---
```

## Implementation checklist

- [ ] Spec updated or added
- [ ] Code in the correct feature folder under `src/CookGPT/Features/`
- [ ] SwiftData changes include `schemaVersion` bump if needed
- [ ] `docs/` updated when setup or architecture changes
- [ ] [CHANGELOG.md](../../CHANGELOG.md) entry for user-facing changes
- [ ] Build and test via [xcode-tools](../xcode-tools/SKILL.md)

## After shipping

- Update [specs/log.md](../../specs/log.md) for significant milestones
- Add a recreation guide under `.agents/skills/modules/` only when a pattern is reusable
