#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

pass=0
fail=0

assert() {
  local label="$1"
  shift
  if "$@"; then
    pass=$((pass + 1))
  else
    echo "FAIL: $label"
    fail=$((fail + 1))
  fi
}

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# The distributable unit is a plugin; project scaffolding contains wiring only.
test_plugin_layout() {
  python3 - <<'PY'
import json
with open('.devin-plugin/plugin.json') as f:
    manifest = json.load(f)
assert manifest['name'] == 'rlp-architect'
assert manifest['skills'] == 'skills'
PY
  assert "plugin points to canonical skill" true
  assert "no skill contains a plugin manifest" test ! -e skills/scaffold/.devin-plugin/plugin.json
}

test_scaffold_assets() {
  local repo="$tmp/repo2"
  mkdir -p "$repo/scripts" "$repo/docs/learnings" "$repo/docs/rlp-architect/templates"
  cp skills/scaffold/scripts/capture_learnings.sh skills/scaffold/scripts/learning_health.sh "$repo/scripts/"
  cp skills/scaffold/assets/inbox.md skills/scaffold/assets/decisions.md "$repo/docs/learnings/"
  cp -R skills/scaffold/templates/. "$repo/docs/rlp-architect/templates/"
  chmod +x "$repo/scripts/"*.sh

  assert "scaffolded scripts executable" test -x "$repo/scripts/capture_learnings.sh"
  assert "scaffolded inbox exists" test -f "$repo/docs/learnings/inbox.md"
  assert "template remains inert" test -f "$repo/docs/rlp-architect/templates/semgrep/rules.yml"
  assert "active Semgrep path absent" test ! -e "$repo/semgrep/rules.yml"
  assert "active knowledge path absent" test ! -e "$repo/docs/knowledge/example-domain/example-rule.md"
}

test_capture_and_health() {
  local repo="$tmp/repo3"
  mkdir -p "$repo/scripts" "$repo/docs/learnings"
  cp skills/scaffold/scripts/capture_learnings.sh skills/scaffold/scripts/learning_health.sh "$repo/scripts/"
  cp skills/scaffold/assets/inbox.md "$repo/docs/learnings/"
  chmod +x "$repo/scripts/"*.sh

  "$repo/scripts/capture_learnings.sh" -i "$repo/docs/learnings/inbox.md" \
    -d 2026-09-06 -l https://example.com/pr/1 -s naive-datetime -t "Use UTC."
  "$repo/scripts/capture_learnings.sh" -i "$repo/docs/learnings/inbox.md" \
    -d 2026-09-07 -l https://example.com/pr/2 -s naive-datetime -t "Use UTC again."

  local out
  out="$("$repo/scripts/learning_health.sh" -i "$repo/docs/learnings/inbox.md")"
  echo "$out" | grep -q "naive-datetime: 2"
  assert "recurrence count is 2" true
}

test_budget_enforcement() {
  printf 'one two three four five six seven eight nine ten.\n' > "$tmp/agents.md"
  local out
  out="$(skills/scaffold/scripts/learning_health.sh -a "$tmp/agents.md" -b 5)"
  echo "$out" | grep -q "OVER BUDGET"
  assert "budget over reported" true

  local rc=0
  skills/scaffold/scripts/learning_health.sh -a "$tmp/agents.md" -b 5 -c >/dev/null 2>&1 || rc=$?
  assert "check-stubs exits 2 when over budget" test "$rc" -eq 2
}

test_quoted_stale_artifact() {
  cat > "$tmp/rule.md" <<'EOF'
---
verify_by: "2020-01-01"
---
some rule
EOF

  local out
  out="$(skills/scaffold/scripts/learning_health.sh -a "$tmp/rule.md")"
  echo "$out" | grep -q "verify_by 2020-01-01"
  assert "quoted stale artifact reported" true
}

test_semgrep_template_yaml_valid() {
  python3 - <<'PY'
import yaml
with open('skills/scaffold/templates/semgrep/rules.yml') as f:
    yaml.safe_load(f)
PY
  assert "Semgrep template parses" true
}

test_current_snapshot_passes_tests() {
  local snapshot="$tmp/snapshot"
  mkdir -p "$snapshot"
  cp -R . "$snapshot/"

  local out
  out="$(cd "$snapshot" && tests/test_skill.sh)"
  echo "$out" | grep -q "0 failed"
  assert "current snapshot tests pass" true
}

test_plugin_layout
test_scaffold_assets
test_capture_and_health
test_budget_enforcement
test_quoted_stale_artifact
test_semgrep_template_yaml_valid
test_current_snapshot_passes_tests

echo
echo "$pass passed, $fail failed"
if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
