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

# Plugin manifests are valid.
python3 - <<'PY'
import json
for path, expected_skills in [
    ('.devin-plugin/plugin.json', 'skills'),
    ('.claude-plugin/plugin.json', './skills/'),
    ('.codex-plugin/plugin.json', './skills/'),
    ('.cursor-plugin/plugin.json', './skills/'),
]:
    with open(path) as f:
        manifest = json.load(f)
    assert manifest['name'] == 'rlp-architect', f'{path}: name mismatch'
    assert manifest['skills'] == expected_skills, f'{path}: skills dir mismatch: {manifest.get("skills")}'
    assert 'license' in manifest, f'{path}: missing license'
PY
assert "plugin manifests valid" true

# Each skill has a valid SKILL.md with frontmatter and name matching directory.
for skill in scaffold audit triage migrate; do
  dir="skills/$skill"
  [[ -d "$dir" ]]
  assert "skills/$skill directory exists" true

  [[ -f "$dir/SKILL.md" ]]
  assert "skills/$skill/SKILL.md exists" true

  python3 - "$skill" "$dir/SKILL.md" <<'PY'
import yaml, re, sys
skill = sys.argv[1]
path = sys.argv[2]
with open(path) as f:
    txt = f.read()
m = re.search(r'^---\n(.*?)\n---\n', txt, re.S)
assert m, 'no frontmatter'
meta = yaml.safe_load(m.group(1))
assert meta.get('name') == skill, f'name mismatch: {meta.get("name")} != {skill}'
assert 'description' in meta, 'missing description'
assert len(meta['description']) <= 1024, 'description too long'
assert 'license' in meta, 'missing license'
assert 'compatibility' in meta, 'missing compatibility'
PY
  assert "skills/$skill/SKILL.md frontmatter valid" true
done

# Scaffold skill carries copyable wiring and inert templates.
[[ -f skills/scaffold/assets/inbox.md ]]
assert "scaffold inbox asset exists" true
[[ -f skills/scaffold/assets/decisions.md ]]
assert "scaffold decisions asset exists" true
[[ -f skills/scaffold/assets/AGENTS.md.seed ]]
assert "scaffold AGENTS seed exists" true
[[ -f skills/scaffold/scripts/capture_learnings.sh ]]
assert "scaffold capture script exists" true
[[ -x skills/scaffold/scripts/capture_learnings.sh ]]
assert "scaffold capture script executable" true
[[ -f skills/scaffold/scripts/learning_health.sh ]]
assert "scaffold health script exists" true
[[ -x skills/scaffold/scripts/learning_health.sh ]]
assert "scaffold health script executable" true
[[ -f skills/scaffold/templates/example-rule.md ]]
assert "scaffold rule template exists" true
[[ -f skills/scaffold/templates/api-conventions.md ]]
assert "scaffold api-conventions template exists" true
[[ -f skills/scaffold/templates/semgrep/rules.yml ]]
assert "scaffold semgrep template exists" true
[[ -f skills/scaffold/templates/example-regression-test.sh ]]
assert "scaffold regression test template exists" true
[[ -f skills/scaffold/references/0001-adopt-rlp.md ]]
assert "scaffold adoption ADR exists" true

# Audit skill carries the health script and reference docs.
[[ -x skills/audit/scripts/learning_health.sh ]]
assert "audit health script executable" true
[[ -f skills/audit/references/promote-learning.md ]]
assert "audit promotion reference exists" true

# Triage skill carries capture + health scripts and promotion templates.
[[ -x skills/triage/scripts/capture_learnings.sh ]]
assert "triage capture script executable" true
[[ -x skills/triage/scripts/learning_health.sh ]]
assert "triage health script executable" true
[[ -f skills/triage/references/promote-learning.md ]]
assert "triage promotion reference exists" true
[[ -f skills/triage/templates/example-rule.md ]]
assert "triage rule template exists" true

# Migrate skill carries the migration script and guides.
[[ -x skills/migrate/scripts/record_migration.sh ]]
assert "migrate record script executable" true
[[ -x skills/migrate/scripts/learning_health.sh ]]
assert "migrate health script executable" true
[[ -f skills/migrate/references/migration-guide.md ]]
assert "migrate guide exists" true
[[ -f skills/migrate/references/promote-learning.md ]]
assert "migrate promotion reference exists" true

# Payload test suite still passes.
tests/payload/test_payload.sh >/dev/null
assert "payload tests pass" true

echo
echo "$pass passed, $fail failed"
if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
