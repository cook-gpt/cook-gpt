# Documentation issue template

**Source:** [`.github/ISSUE_TEMPLATE/documentation.yml`](../.github/ISSUE_TEMPLATE/documentation.yml)

## Purpose

Reports gaps or errors in documentation with location, suggested fix, and doc type classification.

## GitHub metadata

| Field | Value |
|-------|--------|
| Form name | Documentation Issue |
| Default title | `[Docs]: ` (user completes) |
| Labels | `documentation`, `triage` |

## Form fields

| Field ID | Type | Required | Description |
|----------|------|----------|-------------|
| *(intro)* | markdown | — | Thank-you message |
| `doc-type` | dropdown | yes | README, setup, API, examples, contributing, comments, other |
| `issue` | textarea | yes | What is wrong |
| `location` | textarea | yes | File, section, line references |
| `suggestion` | textarea | yes | Proposed improvement |
| `additional` | textarea | no | Extra context |
| `terms` | checkboxes | yes | No duplicates, specific details provided |

## Customize after using the template

- Extend `doc-type` options (e.g. add `docs/` paths or `INSTRUCTIONS.md`).
- Point `location` placeholder at your real doc layout.
- Link reporters to [docs/README.md](README.md) in the intro markdown if helpful.

---

[← Docs index](README.md)
