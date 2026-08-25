# github-repo-template — Agent Skills Index

OKF module guides and Cursor skill packs for this stack-agnostic repository shell.

## OKF layers

| Layer | Path |
|-------|------|
| Feature contracts | [`index.md`](../../index.md) (repo root) |
| OKF skills index | [`index.md`](index.md) |
| Shared concepts | [`shared/`](shared/) (synced from workspace `.agents/skills/`) |
| Local modules | [`modules/`](modules/) |

## Local modules (OKF)

| Module | Use when |
|--------|----------|
| [init-from-template](modules/init-from-template.md) | Running `./scripts/init-from-template.sh` or extending the init manifest |

## Shared concepts (synced)

Optional cross-template references — useful when this repo later gains a stack:

* [auth/shared/](shared/auth/) — session, JWT, route guards
* [supabase/shared/](shared/supabase/) — OAuth setup, worker clients

## Cursor SKILL.md packs

None shipped by default for this shell template. Add `.agents/skills/<pack>/SKILL.md` when you adopt a stack, then list it here.

## Extension order

1. Read **`INSTRUCTIONS.md`** and **`index.md`**
2. Run init from `templates/` when personalizing
3. Add application code for your stack
4. Document features in `specs/features/` and link from root `index.md`
5. Add `.agents/skills/modules/` guides for non-obvious patterns
