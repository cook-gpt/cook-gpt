# Release process

CookGPT uses [semantic versioning](https://semver.org/): `MAJOR.MINOR.PATCH`.

**Distribution:** App Store only (iOS and iPadOS). This repository is the open-source source tree — developers run from Xcode with **⌘R**; end users install from the App Store.

## Version locations

| Location | Field |
|----------|-------|
| `src/CookGPT.xcodeproj/project.pbxproj` | `MARKETING_VERSION` |
| `src/CookGPT.xcodeproj/project.pbxproj` | `CURRENT_PROJECT_VERSION` (build number) |
| `website/src/utils/releases.ts` | `APP_STORE_URL`, promotional text |

## Pre-release checklist

1. Update specs under `specs/features/` if behavior changed
2. Update [CHANGELOG.md](../CHANGELOG.md)
3. Run the app on a device or simulator and smoke-test all four tabs
4. Verify cooking timers and Live Activity on a physical device when timer behavior changed
5. Build the website: `cd website && bun run build`
6. Confirm [App Store Connect copy](app-store-connect.md) matches the release

## App Store release

1. Archive in Xcode (**Product → Archive**)
2. Upload to **App Store Connect** and submit for review
3. When approved, release on the App Store
4. Update [CHANGELOG.md](../CHANGELOG.md) if listing copy changed in `website/src/utils/releases.ts` or `docs/app-store-connect.md`

Tag the source revision for changelog traceability:

```bash
git tag -a v1.0.0 -m "CookGPT 1.0.0"
git push origin v1.0.0
```

Use git tags and [CHANGELOG.md](../CHANGELOG.md) for release history — not GitHub Releases artifacts.

---

[← Docs index](README.md)
