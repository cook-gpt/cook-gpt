---
type: Feature
title: Recipes
description: Browse recipes, view details, and follow step-by-step cooking mode.
tags: [recipes, cooking]
timestamp: 2026-08-25T00:00:00Z
---

## User stories

1. As a cook, I see a list of recipes with title, time, and difficulty so I can pick what to make.
2. As a cook, I open a recipe to see ingredients, steps, and timing before I start.
3. As a cook, I adjust **servings** and ingredient quantities scale automatically.
4. As a cook, I enter **cooking mode** to follow steps — including **nested substeps** — with independent timers that keep running while I navigate.

## Screens

### Recipes list (`RecipesRootView`)

- `@Query` all `Recipe`, sorted by `title`
- Row: title, summary, total time (`prepMinutes + cookMinutes`), difficulty badge
- Tap → `RecipeDetailView`
- Empty state when no recipes

### Recipe detail (`RecipeDetailView`)

Single screen for reading **and** cooking — no separate cooking mode.

Sections:

1. **Active timers bar** (when timers are running for this recipe)
2. **Header** — summary, **servings stepper**, prep/cook time, tags
3. **Ingredients** — quantities scaled by servings
4. **Steps** — flat numbered list with timer controls
5. No step navigator — progress is driven by timers and **Mark done**

### Step visual states

| State | Appearance |
|-------|------------|
| Timer active | Amber row highlight + live countdown with pause / cancel |
| Standard | Default list styling — start timer or **Mark done** |

Timer steps auto-mark **Done** when the countdown finishes.

### Persistence

`CookingSessionManager` (app-wide) persists:

- Current step and completed steps per recipe
- Running timers (survives tab switches and leaving the recipe)

Recipes in progress show an **In progress** badge on the list.

## v1 scope

- Local recipes only (SwiftData)
- No recipe creation UI (seed data + future editor)
- No AI-generated substitutions (future)

## Acceptance criteria

- [x] Recipe list renders seeded recipes
- [x] Detail shows ingredients and hierarchical steps
- [x] Servings stepper rescales ingredient quantities
- [x] Cooking mode advances through root steps without stopping other timers
- [x] Nested substeps render in detail and cooking mode
- [x] Timer button appears only when step has `timerSeconds`
