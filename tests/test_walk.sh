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

test_install_skill() {
  local repo="$tmp/repo1"
  mkdir -p "$repo"
  scripts/install-skill.sh "$repo"
  assert "SKILL.md installed" test -f "$repo/.agents/skills/rlp-architect/SKILL.md"
  assert "capture script installed" test -x "$repo/.agents/skills/rlp-architect/scripts/capture_learnings.sh"
  assert "health script installed" test -x "$repo/.agents/skills/rlp-architect/scripts/learning_health.sh"
}

test_scaffold() {
  local repo="$tmp/repo2"
  mkdir -p "$repo"
  scripts/install-skill.sh "$repo"
  local skill="$repo/.agents/skills/rlp-architect"

  # Simulate the skill's scaffold mode in a cross-tool-safe layout.
  mkdir -p "$repo/scripts" "$repo/docs/learnings" "$repo/docs/adr" "$repo/docs/knowledge/example-domain" "$repo/semgrep" "$repo/tests"
  cp "$skill/scripts/capture_learnings.sh" "$skill/scripts/learning_health.sh" "$repo/scripts/"
  cp "$skill/assets/inbox.md" "$skill/assets/decisions.md" "$repo/docs/learnings/"
  cp "$skill/references/0001-adopt-rlp.md" "$repo/docs/adr/"
  cp "$skill/references/example-rule.md" "$repo/docs/knowledge/example-domain/"
  cp "$skill/assets/semgrep/rules.yml" "$repo/semgrep/"
  cp "$skill/assets/tests/"* "$repo/tests/"
  chmod +x "$repo/scripts/"*.sh "$repo/tests/"*.sh

  assert "scaffolded scripts executable" test -x "$repo/scripts/capture_learnings.sh"
  assert "scaffolded inbox exists" test -f "$repo/docs/learnings/inbox.md"
  assert "scaffolded semgrep exists" test -f "$repo/semgrep/rules.yml"
  assert "scaffolded tests exist" test -f "$repo/tests/test_payload.sh"
}

test_capture_and_health() {
  local repo="$tmp/repo3"
  mkdir -p "$repo"
  scripts/install-skill.sh "$repo"
  local skill="$repo/.agents/skills/rlp-architect"

  mkdir -p "$repo/scripts" "$repo/docs/learnings"
  cp "$skill/scripts/capture_learnings.sh" "$skill/scripts/learning_health.sh" "$repo/scripts/"
  cp "$skill/assets/inbox.md" "$repo/docs/learnings/"
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
  local repo="$tmp/repo4"
  mkdir -p "$repo"
  scripts/install-skill.sh "$repo"
  local skill="$repo/.agents/skills/rlp-architect"

  mkdir -p "$repo/scripts"
  cp "$skill/scripts/learning_health.sh" "$repo/scripts/"
  chmod +x "$repo/scripts/learning_health.sh"

  printf 'one two three four five six seven eight nine ten.\n' > "$repo/agents.md"
  local out
  out="$("$repo/scripts/learning_health.sh" -a "$repo/agents.md" -b 5)"
  echo "$out" | grep -q "OVER BUDGET"
  assert "budget over reported" true

  local rc=0
  "$repo/scripts/learning_health.sh" -a "$repo/agents.md" -b 5 -c >/dev/null 2>&1 || rc=$?
  assert "check-stubs exits 2 when over budget" test "$rc" -eq 2
}

test_stale_artifact() {
  local repo="$tmp/repo5"
  mkdir -p "$repo"
  scripts/install-skill.sh "$repo"
  local skill="$repo/.agents/skills/rlp-architect"

  mkdir -p "$repo/scripts"
  cp "$skill/scripts/learning_health.sh" "$repo/scripts/"
  chmod +x "$repo/scripts/learning_health.sh"

  cat > "$repo/rule.md" <<'EOF'
---
verify_by: 2020-01-01
---
some rule
EOF

  local out
  out="$("$repo/scripts/learning_health.sh" -a "$repo/rule.md")"
  echo "$out" | grep -q "verify_by 2020-01-01"
  assert "stale artifact reported" true
}

test_semgrep_rules_yaml_valid() {
  python3 - <<'PY'
import yaml
with open('skill/rlp-architect/assets/semgrep/rules.yml') as f:
    yaml.safe_load(f)
PY
  assert "semgrep rules.yml parses" true
}

test_fresh_clone_passes_tests() {
  local clone="$tmp/clone"
  git clone --quiet --local . "$clone"
  assert "fresh clone created" test -d "$clone/.git"

  local out
  out="$(cd "$clone" && tests/test_skill.sh)"
  echo "$out" | grep -q "0 failed"
  assert "fresh clone tests pass" true
}

test_install_skill
test_scaffold
test_capture_and_health
test_budget_enforcement
test_stale_artifact
test_semgrep_rules_yaml_valid
test_fresh_clone_passes_tests

echo
echo "$pass passed, $fail failed"
if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
