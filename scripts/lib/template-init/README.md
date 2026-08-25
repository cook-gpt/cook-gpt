# template-init

Portable init modules for Open Templates. Designed to be copied into each template repo today and published as `@open-templates/template-init` later.

## API

```js
import { initFromTemplate, detectGitContext } from './lib/template-init/index.js';
import { NPM_PACKAGE_MANIFEST } from './lib/template-init/manifests/npm-package.js';

await initFromTemplate({
  manifest: NPM_PACKAGE_MANIFEST,
  includePackageName: true,
  includeBundler: true,
  defaultBundler: 'npm',
  nextSteps: 'npm install && npm run dev',
});
```

## Modules

| Module | Role |
|--------|------|
| `git-context.js` | `git remote`, `git config`, `gh api user` |
| `github.js` | GitHub REST user id + noreply email |
| `bundlers.js` | Dependabot ecosystem mapping |
| `placeholders.js` | Token replacement |
| `copy.js` | Manifest copy |
| `cleanup.js` | Post-init script removal |
| `terminal.js` | Branded colors, arrow-key menus |
| `author.js` | Git author detection + accept/manual step |
| `prompts.js` | Step-by-step CLI |
| `manifests/*.js` | Per-template file lists |

## Per-template entry

Keep a thin `scripts/init-from-template.js` (or `.mjs`) that only wires manifest + options.
