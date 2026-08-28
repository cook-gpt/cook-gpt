---
name: xcode-tools
description: >-
  Build, test, diagnose, and look up Apple APIs using the Xcode MCP server
  (xcrun mcpbridge) in Cursor. Use when compiling Swift, running tests,
  fixing build errors, rendering SwiftUI previews, or searching Apple
  documentation for CookGPT.
---

# Xcode MCP — CookGPT

Use the **xcode-tools** MCP server (`user-xcode-tools` in Cursor) instead of raw `xcodebuild` for local development. Xcode must be **running** with this project open.

## Project

| Setting | Value |
|---------|-------|
| Project | `src/CookGPT.xcodeproj` |
| Scheme | `CookGPT` |
| Platform | iOS 26.5+ (iPhone / iPad simulator or device) |
| Widget scheme | `CookGPTTimerLiveActivity` |

## When to use MCP vs shell

| Task | Tool |
|------|------|
| Local build / fix compile errors | `BuildProject` → `GetBuildLog` |
| Run tests | `RunAllTests` or `RunSomeTests` |
| Live diagnostics | `XcodeListNavigatorIssues`, `XcodeRefreshCodeIssuesInFile` |
| SwiftUI preview | `RenderPreview` |
| Apple API lookup | `DocumentationSearch` |
| CI / headless | `xcodebuild` in GitHub Actions only |

## Workflow

1. Open `src/CookGPT.xcodeproj` in Xcode and select the **CookGPT** scheme.
2. Call `BuildProject` after Swift changes.
3. On failure, call `GetBuildLog` and `XcodeListNavigatorIssues` before editing files.
4. Call `RunAllTests` (or `RunSomeTests`) before finishing a feature.
5. For unfamiliar APIs (SwiftData, ActivityKit, WidgetKit), call `DocumentationSearch` with optional `frameworks` filter.

## DocumentationSearch

May not appear in `tools/list` but works when called directly:

```
DocumentationSearch(query: "SwiftData ModelContainer migration", frameworks: ["SwiftData"])
```

Requires the Apple Developer Documentation asset downloaded in Xcode (**Settings → Components**).

## Common pitfalls

- **Live Activity** — `CookingTimerAttributes.swift` exists in both the main app and `CookGPTTimerLiveActivity` targets; keep copies identical.
- **SwiftData** — bump `schemaVersion` in `ModelContainer+CookGPT.swift` when models change incompatibly (see `swiftdata` skill).
- **Multiple Xcode windows** — pass `tabIdentifier` if more than one workspace tab is open.

## See also

- [docs/development.md](../../docs/development.md)
- [docs/architecture.md](../../docs/architecture.md)
- [spec-first/SKILL.md](../spec-first/SKILL.md)
