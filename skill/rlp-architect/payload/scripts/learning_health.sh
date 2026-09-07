#!/usr/bin/env bash
set -eo pipefail

inbox="docs/learnings/inbox.md"
budget_limit=1500
check_stubs=0
always_on=()

usage() {
  cat <<EOF
Usage: learning_health.sh [-i inbox] [-b budget] [-a file] [-c]

Options:
  -i, --inbox    Inbox path (default: docs/learnings/inbox.md)
  -b, --budget   Always-on token budget (default: 1500)
  -a, --always   Always-on context file (may be given multiple times)
  -c, --check    Exit non-zero if budget is exceeded or stale artifacts exist
  -h, --help     Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--inbox)
      inbox="$2"; shift 2 ;;
    -b|--budget)
      budget_limit="$2"; shift 2 ;;
    -a|--always)
      always_on+=("$2"); shift 2 ;;
    -c|--check)
      check_stubs=1; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

# Count recurrence per slug from inbox lines.
echo "Inbox recurrence:"
if [[ -f "$inbox" ]] && grep -q '^- ' "$inbox"; then
  grep '^- ' "$inbox" | awk -F' · ' '{ if (NF >= 3) print $3 }' | sort | uniq -c | sed 's/^ *//' | while read -r count slug; do
    echo "  $slug: $count"
  done
else
  echo "  (none)"
fi

# Estimate tokens from always-on files (words * 1.3, rounded up).
total_words=0
for f in "${always_on[@]}"; do
  [[ -f "$f" ]] || continue
  words="$(wc -w < "$f" | tr -d '[:space:]')"
  total_words=$((total_words + words))
done
budget_used="$(awk "BEGIN { print int($total_words * 1.3 + 0.999) }")"

budget_status="OK"
if [[ "$budget_used" -gt "$budget_limit" ]]; then
  budget_status="OVER BUDGET"
fi

echo "Budget: $budget_used / $budget_limit tokens ($budget_status)"

# Find stale artifacts past their verify_by date.
now="$(date +%Y-%m-%d)"
now_epoch="$(date -j -f "%Y-%m-%d" "$now" +%s 2>/dev/null || date -d "$now" +%s)"

stale=0
for f in "${always_on[@]}"; do
  [[ -f "$f" ]] || continue
  verify_by="$(awk '
    /^---$/ { in_frontmatter = !in_frontmatter; next }
    in_frontmatter && /^verify_by:[[:space:]]*/ { sub(/^verify_by:[[:space:]]*/, ""); print; exit }
  ' "$f")"
  [[ -z "$verify_by" ]] && continue
  verify_epoch="$(date -j -f "%Y-%m-%d" "$verify_by" +%s 2>/dev/null || date -d "$verify_by" +%s)"
  if [[ "$verify_epoch" -le "$now_epoch" ]]; then
    if [[ "$stale" -eq 0 ]]; then
      echo "Stale artifacts:"
    fi
    echo "  $f (verify_by $verify_by)"
    stale=$((stale + 1))
  fi
done
if [[ "$stale" -eq 0 ]]; then
  echo "Stale artifacts: 0"
fi

if [[ "$check_stubs" -eq 1 && ( "$budget_used" -gt "$budget_limit" || "$stale" -gt 0 ) ]]; then
  exit 2
fi
