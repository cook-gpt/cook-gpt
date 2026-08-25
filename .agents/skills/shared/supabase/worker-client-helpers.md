---
type: Reference
title: Worker client helpers
description: Three Supabase client factories for Cloudflare Worker templates.
tags: [supabase, hono, cloudflare, jwt]
timestamp: 2026-07-15T00:00:00Z
resource: src/lib/supabase.ts
---

# Helpers

| Function | When to use |
|----------|-------------|
| `getSupabaseClientWithJWT(env, token)` | User-scoped reads/writes (`/me`, RLS-backed tables) |
| `getSupabaseUserClient(env)` | Anonymous public reads |
| `getSupabaseAdminClient(env)` | Service-role operations (use sparingly) |

# `/me` pattern

```ts
const supabase = getSupabaseClientWithJWT(c.env, token);
const { data: { user }, error } = await supabase.auth.getUser();
```

Return standardized JSON via `src/utils/response.ts`.

# Security

Never expose `SUPABASE_SERVICE_ROLE_KEY` to the browser. Prefer JWT-scoped clients for user data.

# See also

* [JWT API passthrough](../auth/jwt-api-passthrough.md)
