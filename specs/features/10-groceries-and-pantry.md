---
type: Feature
title: Groceries and pantry
description: Shopping lists, check-off items, and pantry inventory.
tags: [groceries, pantry, shopping]
timestamp: 2026-08-25T00:00:00Z
---

## User stories

1. As a shopper, I see my grocery lists and check off items while shopping.
2. As a home cook, I see what's in my pantry and when items expire.
3. As a planner, I add grocery items quickly from the list screen.

## Screens

### Groceries root (`GroceriesRootView`)

Segmented control: **Shopping** | **Pantry**

#### Shopping segment

- Lists all `GroceryList` (v1: one default list from seed)
- Items: checkbox, name, quantity + unit
- Toggle `isChecked` on tap
- Toolbar `+` adds a new `GroceryItem` to the active list (name + quantity sheet)

#### Pantry segment

- `@Query` all `PantryItem`, sorted by `name`
- Row: name, quantity, unit, expiry (if set, relative date)
- Toolbar `+` adds pantry item via sheet

## Recipe → grocery (deferred)

Adding all recipe ingredients to a grocery list is specified for v2. v1 focuses on manual list management.

## Acceptance criteria

- [ ] Shopping items render with checkboxes
- [ ] Checking an item updates persistence
- [ ] Pantry list shows seeded and user-added items
- [ ] User can add a new grocery or pantry item
