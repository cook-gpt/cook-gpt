---
type: Playbook
title: Init from template
description: Run init-from-template.sh to copy templates/ into repo root.
tags: [init]
timestamp: 2026-07-15T00:00:00Z
---

```bash
./scripts/init-from-template.sh
```

Resolves `owner-username`, `repo-name`, and related placeholders via `scripts/lib/template-init/`.

See [specs/features/02-init-workflow.md](../../specs/features/02-init-workflow.md).
