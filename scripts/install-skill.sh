#!/usr/bin/env bash
set -euo pipefail

# Install rlp-architect as a Devin plugin, not as a project-local skill copy.
#
# Usage:
#   scripts/install-skill.sh
#
# Published installs should use:
#   devin plugins install owner/repo

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v devin >/dev/null 2>&1; then
  echo "Devin CLI not found. Install the published plugin with: devin plugins install owner/repo" >&2
  exit 1
fi

devin plugins install "$repo_root"
