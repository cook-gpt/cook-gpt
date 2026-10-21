---
type: Feature
title: iPhone Duo and iOS 27
description: Adaptive layout for foldable iPhone Duo without new product features.
tags: [ios, iphone-duo, layout]
timestamp: 2026-10-21T00:00:00Z
---

## Requirements

* **Deployment target:** iOS **27.0** (build with **Xcode 27** SDK).
* **Devices:** iPhone, iPad, and **iPhone Duo** (`TARGETED_DEVICE_FAMILY = 1,2`).
* No new features — existing tabs and flows only.

## Layout rules

* Do **not** use `UIScreen.main`, fixed screen sizes, `UIDevice` orientation, or `userInterfaceIdiom` for layout.
* Use **size classes** and available width (e.g. `RecipeCookingToolsBadgeRow` overflow rules).
* **Recipes** tab uses `NavigationSplitView` (list + detail) so wide layouts (iPad, Duo inner display) match system guidance.
* Root `TabView` applies `cookGPTDivisionSafeContent()` to inset content away from an **active** Duo division (partial fold; requires **iOS 27.1** runtime for `reservedRegions`).
* Onboarding card width scales with container width (capped at 420 pt).

## Code

* `Shared/CookGPTAdaptiveLayout.swift` — division safe area + modifier
* `Features/Recipes/RecipesRootView.swift` — split navigation
* `ContentView.swift` — division modifier on tab shell

## References

* [Prepare for iPhone Duo](https://developer.apple.com/iphone-duo/prepare/)
* [Reserved regions (fold)](https://developer.apple.com/documentation/swiftui/reservedregion)
