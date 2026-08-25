---
type: Playbook
title: JWT API passthrough
description: Attach Supabase access tokens to worker API calls and validate them in Hono middleware.
tags: [auth, jwt, api, hono, cloudflare]
timestamp: 2026-07-15T00:00:00Z
---

# Frontend (`apiFetch`)

1. Read `localStorage.getItem('x-auth-token')`.
2. Set `Authorization: Bearer <token>` on requests to `VITE_API_BASE_URL`.
3. On `401`, call `supabase.auth.refreshSession()`, update `x-auth-token`, retry once.

Module: `src/api/api.ts` in React templates.

# Backend (`authMiddleware`)

1. Skip auth for `GET /health`.
2. Extract Bearer token from `Authorization` header.
3. Reject missing/invalid tokens with `401` and `{ success: false, error: { code: "UNAUTHORIZED" } }`.
4. Attach JWT `sub` to request context for route handlers.

Module: `src/middleware/auth.ts` in Hono worker templates.

# User-scoped Supabase reads

Handlers call `getSupabaseClientWithJWT(env, token)` then `auth.getUser()` (e.g. `GET /me`).

# See also

* [Supabase session flow](supabase-session-flow.md)
* [Worker client helpers](../supabase/worker-client-helpers.md)
