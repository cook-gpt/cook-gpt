---
type: Playbook
title: MVP implementation (v0.2.0)
description: First development slice after specs — local-only iOS app with three tabs.
tags: [mvp, implementation]
timestamp: 2026-08-25T00:00:00Z
---

## Goal

Ship a **local-first MVP** on iOS 26.6 that demonstrates all three product pillars with seeded data and core interactions from specs 05–10.

## In scope

| Area | Deliverable |
|------|-------------|
| Platform | Deployment target iOS 26.6; folder layout per spec 05 |
| Shell | TabView with Recipes, Diet, Groceries (spec 06) |
| Data | All SwiftData models + `SampleDataSeeder` (spec 07) |
| Recipes | List, detail, cooking mode (spec 08) |
| Diet | Dashboard, log meal sheet (spec 09) |
| Groceries | Shopping + pantry segments, add items (spec 10) |

## Out of scope

- Recipe editor, AI assistant, cloud sync, HealthKit
- macOS target (architecture allows later)

## Verification

1. Build and run on iOS 26.6 simulator (Xcode 26.6)
2. Fresh install shows seeded recipes, diet profile, grocery list
3. Complete cooking mode for a sample recipe
4. Log a meal and see calorie progress update
5. Check off a grocery item and add a pantry item

## Follow-up specs (post-MVP)

- `12` — Recipe creation and editing
- `13` — Add recipe ingredients to grocery list
- `14` — AI cooking assistant (on-device or API)
- `15` — HealthKit nutrition sync
