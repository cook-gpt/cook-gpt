---
type: Feature
title: Data models
description: SwiftData domain models and relationships for recipes, diet, and groceries.
tags: [swiftdata, models]
timestamp: 2026-08-25T00:00:00Z
---

## Model overview

```
Recipe ──< RecipeIngredient >── Ingredient
Recipe ──< RecipeStep
DietProfile
MealLogEntry ──> Recipe? (optional)
GroceryList ──< GroceryItem
PantryItem ──> Ingredient? (optional)
```

## Entities

### `Ingredient`

Canonical ingredient catalog entry.

| Field | Type | Notes |
|-------|------|-------|
| `id` | `UUID` | Unique |
| `name` | `String` | Display name, e.g. "Tomato" |
| `category` | `IngredientCategory` | produce, dairy, protein, grain, spice, other |

### `Recipe`

| Field | Type | Notes |
|-------|------|-------|
| `id` | `UUID` | |
| `title` | `String` | |
| `summary` | `String` | One-line description |
| `servings` | `Int` | Default portions |
| `prepMinutes` | `Int` | |
| `cookMinutes` | `Int` | |
| `difficulty` | `RecipeDifficulty` | easy, medium, hard |
| `tags` | `[String]` | e.g. "vegetarian", "quick" |
| `ingredients` | `[RecipeIngredient]` | Cascade delete |
| `steps` | `[RecipeStep]` | Cascade delete, ordered by `order` |

### `RecipeIngredient`

Join between recipe and ingredient with quantity.

| Field | Type | Notes |
|-------|------|-------|
| `quantity` | `Double` | |
| `unit` | `String` | e.g. "g", "cup", "tbsp" |
| `ingredient` | `Ingredient?` | |
| `recipe` | `Recipe?` | Inverse |

### `RecipeStep`

| Field | Type | Notes |
|-------|------|-------|
| `id` | `UUID` | Stable identity for timers |
| `order` | `Int` | 0-based sequence |
| `instruction` | `String` | Step text |
| `timerSeconds` | `Int?` | Optional step timer |
| `recipe` | `Recipe?` | Inverse |

### `DietProfile`

User's active diet preferences (single active profile in v1).

| Field | Type | Notes |
|-------|------|-------|
| `name` | `String` | e.g. "Balanced", "High protein" |
| `dailyCalorieGoal` | `Int` | |
| `proteinGrams` | `Int` | Daily target |
| `carbGrams` | `Int` | |
| `fatGrams` | `Int` | |
| `isActive` | `Bool` | Only one active in v1 |

### `MealLogEntry`

| Field | Type | Notes |
|-------|------|-------|
| `date` | `Date` | Meal day |
| `mealType` | `MealType` | breakfast, lunch, dinner, snack |
| `calories` | `Int` | |
| `recipe` | `Recipe?` | Optional link |
| `note` | `String` | Free text |

### `GroceryList`

| Field | Type | Notes |
|-------|------|-------|
| `name` | `String` | e.g. "Weekly shop" |
| `items` | `[GroceryItem]` | Cascade delete |

### `GroceryItem`

| Field | Type | Notes |
|-------|------|-------|
| `name` | `String` | |
| `quantity` | `Double` | |
| `unit` | `String` | |
| `isChecked` | `Bool` | Shopping progress |
| `list` | `GroceryList?` | Inverse |

### `PantryItem`

| Field | Type | Notes |
|-------|------|-------|
| `name` | `String` | |
| `quantity` | `Double` | |
| `unit` | `String` | |
| `expiresOn` | `Date?` | Optional expiry |
| `ingredient` | `Ingredient?` | Optional link |

## Enums

All stored as `String` raw values for SwiftData compatibility:

- `IngredientCategory`, `RecipeDifficulty`, `MealType`

## Seeding

On first launch (empty store), `SampleDataSeeder` inserts:

- 8+ ingredients
- 2 sample recipes with steps and ingredients
- 1 active `DietProfile`
- 1 grocery list with items
- 2 pantry items

Seeding runs once per install (`UserDefaults` flag `didSeedSampleData`).
