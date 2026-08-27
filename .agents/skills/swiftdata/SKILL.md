---
name: swiftdata
description: >-
  SwiftData model and schema changes for CookGPT. Use when adding or modifying
  @Model types, migrations, @Query usage, or ModelContainer configuration.
---

# SwiftData — CookGPT

All persistence is on-device SwiftData. Entry point: `Cook GPT/Cook GPT/Models/ModelContainer+CookGPT.swift`.

## Schema versioning

When `@Model` types change **incompatibly** (new required fields, renamed properties, relationship changes):

1. Increment `schemaVersion` in `ModelContainer+CookGPT.swift`.
2. The container uses a versioned store path (`CookGPT-schema-v{N}.store`) — existing users get a fresh store on bump.
3. Document the change in the feature spec and CHANGELOG.

Do **not** bump `schemaVersion` for additive optional fields that SwiftData can migrate automatically.

## Model conventions

- Models live in `Cook GPT/Cook GPT/Models/`
- Shared enums used by models stay alongside models or in dedicated files in the same folder
- Views use `@Query` with explicit sort/filter; avoid fetching entire tables when a predicate suffices
- User preferences **do not** belong in SwiftData — use `AppSettingsStore` (UserDefaults)

## Testing changes

1. Build with [xcode-tools](../xcode-tools/SKILL.md).
2. Run the app and verify seed data, factory reset (**Settings**), and affected tabs.
3. If schema bumped, confirm first launch creates the new store without crash.

## See also

- [docs/architecture.md](../../docs/architecture.md)
- [specs/features/07-data-models.md](../../specs/features/07-data-models.md)
