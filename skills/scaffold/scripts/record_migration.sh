#!/usr/bin/env bash
set -euo pipefail

original_path=""
migration_commit=""
evidence=""

usage() {
  cat <<EOF
Usage: record_migration.sh -p original-path -m migration-commit -s source

Print a provenance source value for a migrated learning. The migration commit
must resolve in the current git repository. Source must name a real commit,
PR, issue, or conversation; the original path alone is not sufficient.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--path) original_path="$2"; shift 2 ;;
    -m|--migration-commit) migration_commit="$2"; shift 2 ;;
    -s|--source) evidence="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -z "$original_path" || -z "$migration_commit" || -z "$evidence" ]]; then
  usage >&2
  exit 1
fi

if ! git cat-file -e "${migration_commit}^{commit}" 2>/dev/null; then
  echo "Migration commit does not resolve: $migration_commit" >&2
  exit 1
fi

resolved_commit="$(git rev-parse "$migration_commit^{commit}")"
printf 'source: "%s; migrated in commit %s from %s"\n' "$evidence" "$resolved_commit" "$original_path"
