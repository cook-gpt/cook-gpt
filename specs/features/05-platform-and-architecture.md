---
type: Feature
title: Platform and architecture
description: Target platforms, toolchain, and code organization for cook-gpt.
tags: [ios, swiftui, swiftdata, architecture]
timestamp: 2026-08-25T00:00:00Z
---

## Target platforms

| Platform | Minimum version | Notes |
|----------|-----------------|-------|
| iOS | **26.5** | Primary client; iPhone and iPad (`TARGETED_DEVICE_FAMILY = 1,2`). Matches Xcode 26.6 SDK simulator runtime. |
| macOS | **26.5** | Catalyst or native Mac target deferred; architecture must not block a future Mac app |

Xcode project: `src/CookGPT.xcodeproj` (inner `CookGPT/` source folder).

Toolchain: **Xcode 26.6** (Swift 5, `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`).

## Technology choices

| Layer | Choice | Rationale |
|-------|--------|-----------|
| UI | SwiftUI | Native, preview-friendly, matches project template |
| Persistence | SwiftData (`@Model`) | First-party, integrates with SwiftUI `@Query` |
| Concurrency | Swift concurrency + `@MainActor` views | Matches project build settings |
| Navigation | `TabView` + `NavigationStack` | Three primary domains map cleanly to tabs |
| Localization | String catalogs (`STRING_CATALOG_GENERATE_SYMBOLS`) | Enabled in project |

## Source layout

```
src/CookGPT/
├── App/                 # @main, model container, seeding
├── Models/              # SwiftData @Model types
├── Features/
│   ├── Recipes/
│   ├── Diet/
│   └── Groceries/
├── Shared/              # Reusable UI components, extensions
└── Resources/           # Assets (existing Assets.xcassets)
```

New files are picked up automatically via `PBXFileSystemSynchronizedRootGroup`.

## Non-goals (v1)

- Backend sync or user accounts
- Third-party AI API keys in the client
- watchOS / tvOS targets

## Dependencies

- Apple system frameworks only for v1 (SwiftUI, SwiftData, Foundation)
