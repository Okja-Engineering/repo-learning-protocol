#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/helpers.sh"
# This script lives at tests/payload/test_payload.sh; repo root is two levels up.
root="$(cd "$(dirname "$0")/../.." && pwd)"
scripts="$root/skills/scaffold/scripts"
cd "$root"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

test_manual_entry() {
  $scripts/capture_learnings.sh -i "$tmp/inbox.md" -d 2026-09-06 \
    -l https://example.com/pr/1 -s naive-datetime -t "Use timezone-aware datetimes."
  assert_contains "$tmp/inbox.md" \
    "2026-09-06 · https://example.com/pr/1 · naive-datetime · Use timezone-aware datetimes."
}

test_slug_recurrence() {
  $scripts/capture_learnings.sh -i "$tmp/inbox2.md" -d 2026-09-06 -l a -s naive-datetime -t "x"
  $scripts/capture_learnings.sh -i "$tmp/inbox2.md" -d 2026-09-07 -l b -s naive-datetime -t "y"
  $scripts/capture_learnings.sh -i "$tmp/inbox2.md" -d 2026-09-08 -l c -s escrow-rounding -t "z"
  $scripts/learning_health.sh -i "$tmp/inbox2.md" > "$tmp/health.txt"
  assert_contains "$tmp/health.txt" "naive-datetime: 2"
  assert_contains "$tmp/health.txt" "escrow-rounding: 1"
}

test_import_from_file() {
  cat > "$tmp/source.txt" <<'EOF'
2026-09-06 · https://example.com/pr/1 · naive-datetime · Use timezone-aware datetimes.
2026-09-07 · https://example.com/pr/2 · escrow-rounding · Round after scaling.
EOF
  $scripts/capture_learnings.sh -i "$tmp/inbox3.md" -f "$tmp/source.txt"
  assert_contains "$tmp/inbox3.md" "naive-datetime"
  assert_contains "$tmp/inbox3.md" "escrow-rounding"
}

test_budget_ok() {
  printf 'one two three four five six seven eight nine ten.\n' > "$tmp/agents.md"
  $scripts/learning_health.sh -a "$tmp/agents.md" -b 100 > "$tmp/budget.txt"
  assert_contains "$tmp/budget.txt" "OK"
}

test_budget_over() {
  printf 'one two three four five six seven eight nine ten.\n' > "$tmp/agents2.md"
  $scripts/learning_health.sh -a "$tmp/agents2.md" -b 5 > "$tmp/budget2.txt"
  assert_contains "$tmp/budget2.txt" "OVER BUDGET"
}

test_stale_artifact() {
  cat > "$tmp/rule.md" <<'EOF'
---
verify_by: 2026-01-01
---
some rule
EOF
  $scripts/learning_health.sh -a "$tmp/rule.md" > "$tmp/stale.txt"
  assert_contains "$tmp/stale.txt" "verify_by 2026-01-01"
}

test_quoted_verify_by() {
  cat > "$tmp/quoted-rule.md" <<'EOF'
---
verify_by: '2026-01-01'
---
some rule
EOF
  $scripts/learning_health.sh -a "$tmp/quoted-rule.md" > "$tmp/quoted-stale.txt"
  assert_contains "$tmp/quoted-stale.txt" "verify_by 2026-01-01"
}

test_check_stubs_fails() {
  printf 'one two three four five six seven eight nine ten.\n' > "$tmp/agents3.md"
  assert_rc 2 $scripts/learning_health.sh -a "$tmp/agents3.md" -b 5 -c
}

test_report_includes_recurrence() {
  $scripts/capture_learnings.sh -i "$tmp/inbox4.md" -d 2026-09-06 -l a -s naive-datetime -t "x"
  $scripts/capture_learnings.sh -i "$tmp/inbox4.md" -d 2026-09-07 -l b -s naive-datetime -t "y"
  printf 'one two three four five six seven eight nine ten.\n' > "$tmp/agents4.md"
  $scripts/learning_health.sh -i "$tmp/inbox4.md" -a "$tmp/agents4.md" -b 100 > "$tmp/report.txt"
  assert_contains "$tmp/report.txt" "naive-datetime: 2"
  assert_contains "$tmp/report.txt" "Budget:"
}

test_manual_entry
test_slug_recurrence
test_import_from_file
test_budget_ok
test_budget_over
test_stale_artifact
test_quoted_verify_by
test_check_stubs_fails
test_report_includes_recurrence

summary
