# Pull request template

**Source:** [`.github/pull_request_template.md`](../.github/pull_request_template.md)

## Purpose

Pre-fills the PR description when contributors open a pull request on GitHub. Structures review around change type, testing, checklist, and maintainer sign-off.

## Sections

| Section | Intent |
|---------|--------|
| **Description** | Short summary of the change |
| **Type of Change** | Bug fix, feature, breaking change, docs, or maintenance |
| **Changes Made** | Bullet list of concrete edits |
| **Testing** | What was run or verified |
| **Checklist** | Author self-review and quality gates |
| **Related Issues** | `Closes #` / `Fixes #` links |
| **Screenshots** | UI evidence when relevant |
| **Additional Notes** | Context for reviewers |
| **Deployment Notes** | Release or ops considerations |
| **For Maintainers** | Review complete, CI, docs, merge readiness |

## Behavior on GitHub

- File path must be `.github/pull_request_template.md` (or `docs/pull_request_template.md` with config — this template uses the default location).
- Body appears automatically in the PR composer; contributors edit in place.
- Checkboxes render as GitHub task lists.

## Customize after using the template

- Remove sections that do not apply yet (e.g. unit tests before CI exists).
- Add links to [CONTRIBUTING.md](../CONTRIBUTING.md) or [docs/README.md](README.md).
- Require CHANGELOG updates in **Changes Made** or checklist when you adopt releases.
- Trim emoji in **Type of Change** if you prefer plain text.

---

[← Docs index](README.md)
