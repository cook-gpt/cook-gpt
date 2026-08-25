# Initialize from template

Stack-agnostic — copies personalized files from `templates/` to the repository root. No `package.json` required.

## Two layers

| Location | Purpose |
|----------|---------|
| **Root** (hosted template) | Public face with `@open-templates` branding |
| **`templates/`** | Adopter files with `owner-username` placeholders |

`./scripts/init-from-template.sh` runs the `@open-templates` init wizard (Node.js).

## Run

Requires **Node.js 18+** only — no `npm install`.

```bash
chmod +x scripts/init-from-template.sh   # once
./scripts/init-from-template.sh
```

Or directly:

```bash
node scripts/init-from-template.mjs
```

The wizard uses **@open-templates** branded colors and **arrow keys** to navigate menus. It auto-detects your Git identity (git config, `gh` CLI) for maintainer name in **Step 1**, then repository owner/repo in **Step 2**.

```bash
./scripts/init-from-template.sh --yes
./scripts/init-from-template.sh --owner acme --repo my-app --bundler npm
node scripts/init-from-template.mjs --help
```

## After init

- Review `git diff`
- Uncomment `# assignees: # - owner-username` in `.github/dependabot.yml` if desired

`.github/workflows/dependabot-signature.yml` needs no edit (`github.repository_owner` at runtime).

The entire `scripts/` folder is removed after init (one-time wizard). Pass `--no-cleanup` to keep it for debugging.

---

[← Docs index](README.md)
