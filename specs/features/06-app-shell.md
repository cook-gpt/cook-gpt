---
type: Feature
title: App shell and navigation
description: Root navigation, tabs, and shared chrome for cook-gpt.
tags: [navigation, swiftui, ux]
timestamp: 2026-08-25T00:00:00Z
---

## Root structure

`CookGPTApp` owns the SwiftData `ModelContainer` and presents `ContentView` as the root.

`ContentView` hosts a **`TabView`** with three primary tabs:

| Tab | SF Symbol | Root view | Purpose |
|-----|-----------|-----------|---------|
| Recipes | `book.closed` | `RecipesRootView` | Browse and cook recipes |
| Diet | `heart.text.square` | `DietRootView` | Diet profile and daily nutrition |
| Groceries | `cart` | `GroceriesRootView` | Shopping lists and pantry |

Each tab wraps its root in a `NavigationStack` for drill-in flows.

## Visual design (v1)

- Use system accent color from `AccentColor` asset
- Prefer **large navigation titles** on list roots
- Use semantic system backgrounds (`.background`, grouped lists)
- Empty states: icon + short title + one-line subtitle

## Cooking mode (overlay)

Recipe cooking mode is a **full-screen cover** (`fullScreenCover`) launched from recipe detail, not a fourth tab. It shows one step at a time with Previous / Next controls and a progress indicator.

## Future

- Settings tab (units, diet defaults, data export)
- macOS sidebar navigation when a Mac target is added
