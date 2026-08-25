---
type: Playbook
title: Supabase session flow
description: How the React templates keep Supabase sessions and mirror access tokens for API calls.
tags: [auth, supabase, react, session]
timestamp: 2026-07-15T00:00:00Z
resource: src/auth/AuthContext.tsx
---

# Flow

1. `supabase.auth.onAuthStateChange` runs on mount in `AuthProvider`.
2. When a session exists, set React state (`user`, `session`) and `localStorage.setItem('x-auth-token', session.access_token)`.
3. When session is cleared, remove `x-auth-token` and clear user state.
4. On intentional `signOut()`, call `clearAllChatState()` (AI chat template) then `supabase.auth.signOut()` and navigate to `/login`.

# Recreating AuthContext

| Method | Supabase API |
|--------|--------------|
| `signIn` | `signInWithPassword` |
| `signUp` | `signUp` |
| `loginWithGoogle` | `signInWithOAuth({ provider: 'google' })` |
| `resetPassword` | `resetPasswordForEmail` → `/reset-password` |
| `updatePassword` | `updateUser({ password })` |
| `signOut` | `signOut()` |
| `refreshToken` | `refreshSession()` |

`AuthProvider` must sit **inside** the router (uses `useNavigate`).

# See also

* [JWT API passthrough](jwt-api-passthrough.md)
* [Route guards](route-guards.md)
* Repo `specs/features/03-auth-session.md` (numbered feature spec)
