---
type: Feature
title: Diet and nutrition
description: Diet profile, daily goals, and meal logging.
tags: [diet, nutrition, health]
timestamp: 2026-08-25T00:00:00Z
---

## User stories

1. As a health-conscious user, I see my active diet profile and daily macro targets.
2. As a user, I log meals and see today's calorie progress toward my goal.
3. As a user, I can link a logged meal to a recipe when applicable.

## Screens

### Diet dashboard (`DietRootView`)

1. **Active profile card** — name, calorie goal, protein / carbs / fat targets
2. **Today's progress** — calories logged vs goal (progress bar)
3. **Today's meals** — list of `MealLogEntry` for current calendar day
4. **Log meal** — toolbar `+` opens `LogMealSheet`

### Log meal sheet (`LogMealSheet`)

Fields:

- Meal type (picker)
- Calories (number)
- Optional recipe (picker from existing recipes)
- Optional note

Save inserts `MealLogEntry` with `date = now`.

## v1 scope

- Single active `DietProfile` (no multi-profile UI)
- Manual calorie entry (no auto-calculation from recipe macros yet)
- No HealthKit integration (future spec)

## Acceptance criteria

- [ ] Dashboard shows active profile from seed data
- [ ] User can log a meal and see it in today's list
- [ ] Progress bar reflects sum of today's logged calories vs goal
