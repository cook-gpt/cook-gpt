# Dependabot commit signer workflow

**Source:** [`.github/workflows/dependabot-signature.yml`](../.github/workflows/dependabot-signature.yml)

## Purpose

When Dependabot opens a pull request, this workflow amends the latest commit message to append a `Co-authored-by` trailer for the **repository owner**. No manual `owner-username` edit is required.

## Runtime owner resolution

Uses GitHub Actions context (same pattern as [npm-package-template](https://github.com/open-templates/npm-package-template)):

- `github.repository_owner` — login name
- `github.event.repository.owner.id` — noreply email id

## Customize after using the template

Update [CODEOWNERS](../.github/CODEOWNERS) via [init-from-template.sh](../scripts/init-from-template.sh). The workflow picks up the repo owner automatically.

---

[← Docs index](README.md)
