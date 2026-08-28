---
name: live-activity
description: >-
  Cooking timer Live Activities and widget extension for CookGPT. Use when
  changing step timers, Lock Screen UI, Dynamic Island, ActivityKit attributes,
  or CookGPTTimerLiveActivity target code.
---

# Live Activity timers — CookGPT

Cooking step timers use **ActivityKit** with a widget extension target.

## Targets

| Target | Path |
|--------|------|
| Main app manager | `src/CookGPT/LiveActivity/` |
| Widget extension | `src/CookGPTTimerLiveActivity/` |

## Critical rule

`CookingTimerAttributes.swift` is **duplicated** in both targets. Any change to attributes, ContentState, or shared types must be applied to **both copies** identically.

## Workflow

1. Update the feature spec under `specs/features/` if timer behavior changes.
2. Edit manager code in the main app target.
3. Mirror attribute/widget UI changes in the extension target.
4. Test on a **physical device** — Live Activity and Dynamic Island do not fully behave in Simulator.
5. Use `DocumentationSearch` (via [xcode-tools](../xcode-tools/SKILL.md)) for ActivityKit API questions.

## Audio

Timer alarm sounds are handled in `src/CookGPT/Shared/` (see `TimerAlarmSoundInstaller`). Notification sounds require `.caf` in the Library Sounds directory.

## See also

- [docs/architecture.md](../../docs/architecture.md) — Live Activity layer
- [xcode-tools/SKILL.md](../xcode-tools/SKILL.md) — build both schemes if needed
