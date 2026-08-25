# github-repo-template

A **minimal GitHub repository template** from [@open-templates](https://github.com/open-templates). Community docs, Dependabot, CODEOWNERS, and issue/PR scaffolding — no application code until you add it.

## Quick start

1. Click **Use this template** on GitHub.
2. Clone and copy personalized files from [`templates/`](templates/):

```bash
git clone https://github.com/open-templates/github-repo-template.git my-new-repo
cd my-new-repo
./scripts/init-from-template.sh
```

The hosted repo keeps **@open-templates** branding in root markdown until you run init. See [docs/init-from-template.md](docs/init-from-template.md).

### GitHub automation (included)

| File | Purpose |
|------|---------|
| [`.github/dependabot.yml`](.github/dependabot.yml) | Dependency update PRs |
| [`.github/workflows/dependabot-signature.yml`](.github/workflows/dependabot-signature.yml) | `Co-authored-by` via `github.repository_owner` at runtime |
| [`.github/CODEOWNERS`](.github/CODEOWNERS) | Review ownership |

Full reference: **[docs/README.md](docs/README.md)** · [INSTRUCTIONS.md](INSTRUCTIONS.md) · [index.md](index.md) · [.agents/skills/](.agents/skills/)

## License

MIT — see [LICENSE](LICENSE).

---

## Repository documents

**README** | [INSTRUCTIONS](INSTRUCTIONS.md) | [CHANGELOG](CHANGELOG.md) | [CONTRIBUTING](CONTRIBUTING.md) | [SECURITY](SECURITY.md) | [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)
