#!/usr/bin/env bash
set -euo pipefail

# Install the rlp-architect skill into a target repository.
#
# Usage:
#   scripts/install-skill.sh [target-repo] [agent-skills-dir] [mode]
#
# Defaults:
#   target-repo      .            (current directory)
#   agent-skills-dir .agents/skills
#   mode             copy         (copy or symlink)
#
# Examples:
#   scripts/install-skill.sh /path/to/target-repo
#   scripts/install-skill.sh /path/to/target-repo .devin/skills copy
#   scripts/install-skill.sh /path/to/target-repo .agents/skills symlink

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
target="${1:-.}"
agent_dir="${2:-.agents/skills}"
mode="${3:-copy}"

mkdir -p "$target/$agent_dir"

src="$repo_root/skill/rlp-architect"
dest="$target/$agent_dir/rlp-architect"

if [[ -e "$dest" ]]; then
  rm -rf "$dest"
fi

case "$mode" in
  copy)
    cp -R "$src" "$dest"
    ;;
  symlink)
    ln -s "$src" "$dest"
    ;;
  *)
    echo "Unknown mode: $mode (use copy or symlink)" >&2
    exit 1
    ;;
esac

echo "rlp-architect installed to $dest"
