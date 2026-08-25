# Instructions — github-repo-template

Guide for maintainers and coding agents after creating a repository from this template.

## What this template is

A **blank GitHub repository shell**: documentation, Dependabot, CODEOWNERS, and one optional workflow to sign Dependabot commits. It is **not** tied to React, Node, Python, or any other stack until you add that code.

### Included automation (only these)

| Asset | Role |
|-------|------|
| `.github/dependabot.yml` | Opens dependency update PRs on a schedule |
| `.github/workflows/dependabot-signature.yml` | Amends Dependabot commits with `Co-authored-by` |
| `.github/CODEOWNERS` | Requests reviews from listed owners |

Add your own CI (build, test, lint, deploy) when the project has a stack.

Workflow and template details live under **[docs/README.md](docs/README.md)** (issue forms, PR template, dependabot-signature workflow).

### Included markdown (GitHub UI)

Root-level `.md` files are meant to be read on github.com. Each ends with a **Repository documents** footer: sibling files as horizontal links separated by ` | ` (the current page is plain text).

| File | When to read |
|------|----------------|
| [README.md](README.md) | First visit — scope and quick start |
| [docs/README.md](docs/README.md) | Workflows and GitHub issue/PR templates |
| **INSTRUCTIONS.md** | Fork setup, releases, CHANGELOG automation |
| [CHANGELOG.md](CHANGELOG.md) | Published version history |
| [CONTRIBUTING.md](CONTRIBUTING.md) | External contributors |
| [SECURITY.md](SECURITY.md) | Security reports |
| [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) | Community rules |

---

## First steps after “Use this template”

1. **Initialize** — `./scripts/init-from-template.sh` copies `templates/` → root (see [docs/init-from-template.md](docs/init-from-template.md)). Root keeps @open-templates branding until then.
2. **Dependabot** — Edit `.github/dependabot.yml` for your stack; uncomment assignees if needed.
3. **Dependabot signer** — Uses `github.repository_owner` at runtime.
4. **Secrets** — Never commit `.env`; use `.env.example` only.

---

## CHANGELOG: feature-based batches from commit history

[CHANGELOG.md](CHANGELOG.md) follows [Keep a Changelog](https://keepachangelog.com/). Maintain it in **batches per release** (or per merged feature group), not one line per commit.

### 1. Use conventional commits

Train contributors (see [CONTRIBUTING.md](CONTRIBUTING.md)) to write messages that map to changelog sections:

| Prefix | CHANGELOG section |
|--------|-------------------|
| `feat:` | Added |
| `fix:` | Fixed |
| `docs:` | (usually omit or “Documentation”) |
| `chore:` / `ci:` | (usually omit unless user-visible) |
| `refactor:` | Changed |
| `perf:` | Changed |
| `BREAKING CHANGE:` or `!` | Changed — breaking |

**Feature-based batching:** Squash or group PRs so one feature = one `feat:` (or one PR with a clear title). Release notes stay readable.

Example batch for version `0.2.0`:

```text
feat(auth): add Google OAuth login
feat(api): add GET /me endpoint
fix(cors): allow local dev origin
```

Becomes one CHANGELOG block:

```markdown
## [0.2.0] - 2026-07-04

### Added
- Google OAuth login
- `GET /me` API endpoint

### Fixed
- CORS for local development origin
```

### 2. Generate a draft from git (manual or scripted)

Between tags `v0.1.0` and `HEAD`, list commits and group by type:

```bash
git log v0.1.0..HEAD --pretty=format:"%s" --no-merges
```

Filter lines starting with `feat:`, `fix:`, etc., strip the prefix for bullet text, and paste under the right `###` heading in `CHANGELOG.md`.

Optional tools (add when you adopt a stack):

- **[git-cliff](https://git-cliff.org/)** — `git cliff --tag v0.2.0` from conventional commits
- **[conventional-changelog](https://github.com/conventional-changelog/conventional-changelog)** — npm CLI
- **GitHub Release** — Generate release notes from PR titles when merging to `main`

### 3. Release workflow (recommended)

1. Merge feature PRs to `main` using conventional titles.
2. When ready to release, choose a version ([SemVer](https://semver.org/)).
3. Run `git log <last-tag>..HEAD` (or git-cliff) and update `CHANGELOG.md` under `## [x.y.z] - YYYY-MM-DD`.
4. Commit: `docs: release v0.2.0` (or include changelog in the release PR).
5. Tag: `git tag v0.2.0 && git push origin v0.2.0`.
6. Create a GitHub Release from the tag; paste the same section from `CHANGELOG.md`.

### 4. Optional: automate later

This template does **not** ship a CHANGELOG GitHub Action. When you add CI, common choices:

- **release-please** — Opens release PRs with updated CHANGELOG from conventional commits
- **git-cliff-action** — Updates `CHANGELOG.md` on tag or manual dispatch
- **changesets** — Monorepo-friendly; human-written change summaries batched per package

Start manual; automate once commit discipline is stable.

---

## Dependabot workflow

1. Dependabot opens PRs per `.github/dependabot.yml`.
2. `dependabot-signature.yml` runs on `pull_request_target` and amends the commit message with `Co-authored-by`.
3. CODEOWNERS on `.github/workflows/*` requests your review on workflow changes.

Review dependency PRs like any other: changelog entry only if the upgrade is user-visible (e.g. security fix in `SECURITY.md` advisory, not every patch bump).

---

## Agent checklist

When extending a repo created from this template:

1. Read **`INSTRUCTIONS.md`** (this file) and [`index.md`](index.md)
2. Read **`.agents/skills/index.md`** and **`.agents/skills/README.md`**
3. Run `./scripts/init-from-template.sh` to copy `templates/` into the repo root
4. Do not commit secrets; respect `.gitignore`
5. Use conventional commits for features/fixes destined for CHANGELOG
6. Update [CHANGELOG.md](CHANGELOG.md) when cutting a release batch
7. Add numbered concepts under `specs/features/` when adding user-visible behavior
8. Add new automation in `.github/workflows/` and document it in README

---

## Agent workflow (OKF)

| Step | File |
|------|------|
| 1 | `INSTRUCTIONS.md` — setup and governance |
| 2 | `index.md` — feature contract index |
| 3 | `.agents/skills/index.md` — module recreation guides |
| 4 | `.agents/skills/README.md` — Cursor skill catalog |

Workspace convention: [open-templates specs OKF agent workflow](https://github.com/open-templates/specs/blob/main/concepts/okf-agent-workflow.md)

---

## Repository map

```
index.md              OKF bundle root
specs/features/       Numbered out-of-the-box specs
.agents/skills/       OKF modules + Cursor SKILL.md packs
templates/            Adopter files (init copies to root)
docs/                 GitHub workflow reference
```

---

## Repository documents

[README](README.md) | **INSTRUCTIONS** | [CHANGELOG](CHANGELOG.md) | [CONTRIBUTING](CONTRIBUTING.md) | [SECURITY](SECURITY.md) | [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
