---
type: Playbook
title: Dashboard OAuth setup
description: Configure Google OAuth in Supabase without frontend client secrets.
tags: [supabase, oauth, google]
timestamp: 2026-07-15T00:00:00Z
---

# Principles

* OAuth provider credentials live in the **Supabase dashboard**, not `VITE_*` env vars.
* Frontend calls `signInWithOAuth({ provider: 'google', options: { redirectTo: origin + '/' } })`.

# Google Cloud redirect URI

```
https://<project-ref>.supabase.co/auth/v1/callback
```

# Per-repo setup guide

See `docs/SUPABASE_SETUP.md` in React templates for step-by-step dashboard configuration.

# See also

* [Supabase session flow](../auth/supabase-session-flow.md)
