# Bug report issue template

**Source:** [`.github/ISSUE_TEMPLATE/bug_report.yml`](../.github/ISSUE_TEMPLATE/bug_report.yml)

## Purpose

Guides reporters through a consistent bug report with reproduction steps, environment details, and a short checklist.

## GitHub metadata

| Field | Value |
|-------|--------|
| Form name | Bug Report |
| Default title | `[Bug]: ` (user completes) |
| Labels | `bug`, `triage` |

## Form fields

| Field ID | Type | Required | Description |
|----------|------|----------|-------------|
| *(intro)* | markdown | — | Thank-you message |
| `description` | textarea | yes | What the bug is |
| `reproduction` | textarea | yes | Steps to reproduce |
| `expected` | textarea | yes | Expected behavior |
| `actual` | textarea | yes | Actual behavior |
| `environment` | textarea | yes | OS, runtime versions, app version/commit |
| `additional` | textarea | no | Logs, screenshots, extra context |
| `terms` | checkboxes | yes | Duplicate search, completeness, latest version tested |

## Customize after using the template

- Change `description` (subtitle under form name) from “Template” to your project name.
- Adjust `environment` placeholder for your stack (remove Bun/Node if unused).
- Add or remove labels in the `labels:` array.
- Tweak checklist items under `terms` if your support process differs.

---

[← Docs index](README.md)
