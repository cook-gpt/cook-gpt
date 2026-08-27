---
name: marketing-website
description: >-
  CookGPT marketing site (React + Vite + Cloudflare Pages). Use when editing
  landing pages, docs routes, i18n, App Store links, or website build/deploy.
---

# Marketing website — CookGPT

Site lives in `website/` (React 19 + Vite + Tailwind).

## Key files

| File | Role |
|------|------|
| `website/src/utils/releases.ts` | `APP_STORE_URL`, promotional text, repo links |
| `website/src/lib/i18n/locales/en.json` | Source locale — sync others from `en.json` |
| `website/src/pages/` | Route pages (Home, Docs, Privacy) |
| `docs/app-store-connect.md` | App Store listing copy source of truth |

## Workflow

1. Edit `en.json` first, then copy to other locale files if strings changed.
2. Keep App Store URL in sync: `https://apps.apple.com/app/id6805535867`.
3. Verify build:

```bash
cd website
bun install
bun run build
```

4. Do not add backend services — static site only.

## See also

- [docs/app-store-connect.md](../../docs/app-store-connect.md)
