# Documentation — GitHub configuration

Reference for every **workflow**, **issue template**, and **pull request template** in **cook-gpt**.

Use this folder to understand what each file does and what to customize.

## Workflows

| Document | Source file | Summary |
|----------|-------------|---------|
| [Dependabot commit signer](dependabot-signature-workflow.md) | [`.github/workflows/dependabot-signature.yml`](../.github/workflows/dependabot-signature.yml) | Amends Dependabot PR commits with a `Co-authored-by` trailer |

The repository includes **no other** GitHub Actions workflows (no CI build/test until you add them).

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

## Related automation (not documented here)

These live outside `docs/` scope:

| File | Role |
|------|------|
| [`.github/dependabot.yml`](../.github/dependabot.yml) | Scheduled dependency update PRs |
| [`.github/CODEOWNERS`](../.github/CODEOWNERS) | Default code review ownership |

See the [repository README](../README.md) and [INSTRUCTIONS.md](../INSTRUCTIONS.md) for setup and customization.

---

## Docs index

**README** | [Dependabot commit signer](dependabot-signature-workflow.md) | [Bug report](bug-report-issue-template.md) | [Feature request](feature-request-issue-template.md) | [Documentation issue](documentation-issue-template.md) | [Pull request template](pull-request-template.md)
