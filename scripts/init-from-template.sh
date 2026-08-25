#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v node >/dev/null 2>&1; then
  echo "❌ Node.js 18+ is required. Install Node or run: node scripts/init-from-template.mjs" >&2
  exit 1
fi

exec node "${ROOT}/scripts/init-from-template.mjs" "$@"
