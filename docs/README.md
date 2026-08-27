# Documentation — CookGPT

Reference for project guides, GitHub automation, and App Store listing.

Use this folder to understand setup, architecture, releases, and what each `.github` file does.

## Project guides

| Document | Summary |
|----------|---------|
| [Development](development.md) | Local setup, workflow, and contributor quick start |
| [Architecture](architecture.md) | App structure, data flow, and feature layout |
| [Release process](release-process.md) | Versioning and App Store releases |

## Workflows

| Document | Source file | Summary |
|----------|-------------|---------|
| [Dependabot commit signer](dependabot-signature-workflow.md) | [`.github/workflows/dependabot-signature.yml`](../.github/workflows/dependabot-signature.yml) | Amends Dependabot PR commits with a `Co-authored-by` trailer |

No CI workflow is configured yet. Add [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) and document it in `ci-workflow.md` when you adopt automated builds.

## Issue templates

Structured forms under [`.github/ISSUE_TEMPLATE/`](../.github/ISSUE_TEMPLATE/). GitHub shows them when contributors click **New issue**.

| Document | Source file | Default title prefix | Labels |
|----------|-------------|----------------------|--------|
| [Bug report](bug-report-issue-template.md) | [`bug_report.yml`](../.github/ISSUE_TEMPLATE/bug_report.yml) | `[Bug]:` | `bug`, `triage` |
| [Feature request](feature-request-issue-template.md) | [`feature_request.yml`](../.github/ISSUE_TEMPLATE/feature_request.yml) | `[Feature]:` | `enhancement`, `triage` |
| [Documentation issue](documentation-issue-template.md) | [`documentation.yml`](../.github/ISSUE_TEMPLATE/documentation.yml) | `[Docs]:` | `documentation`, `triage` |

## Pull request template

| Document | Source file | Summary |
|----------|-------------|---------|
| [Pull request template](pull-request-template.md) | [`.github/pull_request_template.md`](../.github/pull_request_template.md) | Default PR body scaffold for contributors and maintainers |

## App Store listing

| Document | Summary |
|----------|---------|
| [App Store Connect copy](app-store-connect.md) | Promotional text and full app description for App Store Connect |

## Architecture decision records

| Document | Summary |
|----------|---------|
| [ADR template](adr/000-template.md) | Starting point for architectural decision records |

## Related automation (not documented here)

| File | Role |
|------|------|
| [`.github/dependabot.yml`](../.github/dependabot.yml) | Scheduled dependency update PRs |
| [`.github/CODEOWNERS`](../.github/CODEOWNERS) | Default code review ownership |

See the [repository README](../README.md) and [INSTRUCTIONS.md](../INSTRUCTIONS.md) for maintainer setup.

## Agent configuration

| Path | Summary |
|------|---------|
| [`.cursor/rules.md`](../.cursor/rules.md) | Cursor AI editing rules |
| [`.agents/skills/README.md`](../.agents/skills/README.md) | Skill packs catalog |
| [`.agents/skills/xcode-tools/SKILL.md`](../.agents/skills/xcode-tools/SKILL.md) | Xcode MCP build, test, and Apple docs |

---

## Docs index

**README** | [Development](development.md) | [Architecture](architecture.md) | [Release process](release-process.md) | [App Store Connect copy](app-store-connect.md) | [ADR template](adr/000-template.md) | [Dependabot commit signer](dependabot-signature-workflow.md) | [Bug report](bug-report-issue-template.md) | [Feature request](feature-request-issue-template.md) | [Documentation issue](documentation-issue-template.md) | [Pull request template](pull-request-template.md)
