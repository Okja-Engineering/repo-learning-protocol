#!/usr/bin/env bash
set -eo pipefail

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

# SKILL.md frontmatter parses and required fields are present.
python3 - <<'PY'
import yaml, re, sys
with open('skill/rlp-architect/SKILL.md') as f:
    txt = f.read()
m = re.search(r'^---\n(.*?)\n---\n', txt, re.S)
if not m:
    print('FAIL: no frontmatter')
    sys.exit(1)
meta = yaml.safe_load(m.group(1))
assert meta.get('name') == 'rlp-architect', 'name mismatch'
assert 'description' in meta, 'missing description'
assert len(meta['description']) <= 1024, 'description too long'
assert 'license' in meta, 'missing license'
assert 'compatibility' in meta, 'missing compatibility'
PY
assert "SKILL.md frontmatter valid" true

# Directory name matches skill name.
[[ -d skill/rlp-architect ]]
assert "skill directory exists" true

# Follows Devin plugin and Agent Skills layouts.
[[ -f .devin-plugin/plugin.json ]]
assert "plugin manifest exists" true
python3 - <<'PY'
import json
with open('.devin-plugin/plugin.json') as f:
    manifest = json.load(f)
assert manifest['name'] == 'rlp-architect'
assert manifest['skills'] == 'skill'
PY
assert "plugin manifest valid" true
[[ -f skill/rlp-architect/SKILL.md ]]
assert "SKILL.md exists" true
[[ -d skill/rlp-architect/scripts ]]
assert "scripts/ directory exists" true
[[ -d skill/rlp-architect/references ]]
assert "references/ directory exists" true
[[ -d skill/rlp-architect/templates ]]
assert "templates/ directory exists" true
[[ -d skill/rlp-architect/assets ]]
assert "assets/ directory exists" true
[[ ! -d skill/rlp-architect/payload ]]
assert "old payload/ directory removed" true
[[ -f skill/rlp-architect/templates/example-rule.md ]]
assert "knowledge template isolated" true
[[ -f skill/rlp-architect/templates/api-conventions.md ]]
assert "rule template isolated" true
[[ -f skill/rlp-architect/templates/semgrep/rules.yml ]]
assert "Semgrep template isolated" true
[[ ! -e skill/rlp-architect/references/example-rule.md ]]
assert "knowledge template removed from references" true
[[ ! -e skill/rlp-architect/references/api-conventions.md ]]
assert "rule template removed from references" true
[[ ! -e skill/rlp-architect/assets/semgrep/rules.yml ]]
assert "Semgrep template removed from assets" true
[[ -f skill/rlp-architect/assets/stages/00-learn/CONTEXT.md ]]
assert "stage-00 learn contract asset exists" true
[[ -f skill/rlp-architect/references/migration-guide.md ]]
assert "migration guide exists" true
[[ -x skill/rlp-architect/scripts/record_migration.sh ]]
assert "migration helper executable" true

# Skill bundle contains the expected files.
file_count="$(find skill/rlp-architect -type f | wc -l | tr -d '[:space:]')"
[[ "$file_count" -ge 12 ]]
assert "skill bundle has at least 12 files" true

# Scripts are executable.
[[ -x skill/rlp-architect/scripts/capture_learnings.sh ]]
assert "capture_learnings.sh executable" true
[[ -x skill/rlp-architect/scripts/learning_health.sh ]]
assert "learning_health.sh executable" true
grep -q 'plugins install --local' scripts/install-skill.sh
assert "local installer uses --local" true

# Payload test suite passes.
skill/rlp-architect/assets/tests/test_payload.sh >/dev/null
assert "payload tests pass" true

echo
echo "$pass passed, $fail failed"
if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
