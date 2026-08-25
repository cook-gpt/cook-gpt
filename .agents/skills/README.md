# cook-gpt — Agent Skills Index

OKF module guides and Cursor skill packs for the cook-gpt iOS app.

## OKF layers

| Layer | Path |
|-------|------|
| Feature contracts | [`index.md`](../../index.md) (repo root) |
| OKF skills index | [`index.md`](index.md) |
| Shared concepts | [`shared/`](shared/) (synced from workspace `.agents/skills/`) |
| Local modules | [`modules/`](modules/) |

## Local modules (OKF)

See [modules/](modules/) — add guides when you document reusable patterns.

## Shared concepts (synced)

Optional cross-template references — useful when this repo later gains backend services:

* [auth/shared/](shared/auth/) — session, JWT, route guards
* [supabase/shared/](shared/supabase/) — OAuth setup, worker clients

## Cursor SKILL.md packs

None shipped yet. Add `.agents/skills/<pack>/SKILL.md` when you adopt a stack, then list it here.

## Extension order

1. Read **`INSTRUCTIONS.md`** and **`index.md`**
2. Add application code under `Cook GPT/`
3. Document features in `specs/features/` and link from root `index.md`
4. Add `.agents/skills/modules/` guides for non-obvious patterns
