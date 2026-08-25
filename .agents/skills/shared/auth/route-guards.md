---
type: Playbook
title: Route guards
description: Protect or guest-lock React Router routes with AuthGuard.
tags: [auth, react-router, guards]
timestamp: 2026-07-15T00:00:00Z
resource: src/auth/AuthGuard.tsx
---

# AuthGuard

| `requireAuth` | Behavior |
|---------------|----------|
| `true` | Redirect guests to `/login` |
| `false` | Redirect authenticated users to `/` (guest-only auth pages) |

# Standard routes

| Path | Guard | Purpose |
|------|-------|---------|
| `/login` | guest | Sign in |
| `/signup` | guest | Register |
| `/recover-password` | guest | Email reset link |
| `/reset-password` | auth | Set new password |
| `/` | auth | Home (and `/chat` in AI template) |

# Adding a protected page

```tsx
{
  path: "/dashboard",
  element: (
    <AuthGuard requireAuth>
      <DashboardPage />
    </AuthGuard>
  ),
},
```

Register in `src/App.tsx` inside `AppLayout` after `AuthProvider` wraps the tree.

# See also

* [Supabase session flow](supabase-session-flow.md)
* Repo `specs/features/04-auth-routes.md`
