#!/bin/bash
# Installs the claude-seo plugin at the start of each cloud session, since the
# container is fresh every time and project-declared plugins are not installed.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

PLUGIN="claude-seo@agricidaniel-claude-seo"

if grep -q "\"${PLUGIN}\"" "${HOME}/.claude/plugins/installed_plugins.json" 2>/dev/null; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"
claude plugin marketplace add AgriciDaniel/claude-seo >&2
claude plugin install "${PLUGIN}" --scope project >&2
# The CLI may rewrite settings.json; keep the committed version.
git checkout -- .claude/settings.json 2>/dev/null || true
