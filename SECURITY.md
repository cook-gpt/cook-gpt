# Security Policy

## Supported versions

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| older   | :x:                |

Update this table when you publish releases.

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Report them via:

1. **GitHub Security Advisory** — private vulnerability reporting on the repository
2. **Direct contact** — [@open-templates](https://github.com/open-templates)

### What to include

- Clear description of the issue
- Impact if exploited
- Steps to reproduce
- Affected versions and environment
- Minimal proof-of-concept if applicable

### Response timeline (targets)

- **Initial response:** 48 hours
- **Status update:** 7 days
- **Resolution:** 30 days for confirmed issues

## Security practices for adopters

When you build on this template:

1. **Secrets** — Never commit `.env`, keys, or credentials; use `.env.example` only.
2. **Dependencies** — Keep Dependabot enabled and review update PRs.
3. **Automation** — Restrict who can change `.github/workflows/` (CODEOWNERS helps).
4. **Errors** — Do not expose stack traces or secrets in user-facing output.

## Scope

This policy applies to code and configuration **in this repository** once you add application logic. It does not cover third-party services you integrate later.

## Recognition

With your permission, we may credit reporters in security advisories or [CHANGELOG.md](CHANGELOG.md).

Thank you for helping keep this project and its users safe.

---

## Repository documents

[README](README.md) | [INSTRUCTIONS](INSTRUCTIONS.md) | [CHANGELOG](CHANGELOG.md) | [CONTRIBUTING](CONTRIBUTING.md) | **SECURITY** | [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
