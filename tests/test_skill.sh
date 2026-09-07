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
with open('.agents/skills/rlp-architect/SKILL.md') as f:
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
[[ -d .agents/skills/rlp-architect ]]
assert "skill directory exists" true

# Payload contains the expected templates and scripts.
file_count="$(find .agents/skills/rlp-architect/payload -type f | wc -l | tr -d '[:space:]')"
[[ "$file_count" -ge 12 ]]
assert "payload has at least 12 files" true

# Payload scripts are executable.
[[ -x .agents/skills/rlp-architect/payload/scripts/capture_learnings.sh ]]
assert "capture_learnings.sh executable" true
[[ -x .agents/skills/rlp-architect/payload/scripts/learning_health.sh ]]
assert "learning_health.sh executable" true

# Payload test suite passes.
.agents/skills/rlp-architect/payload/tests/test_payload.sh >/dev/null
assert "payload tests pass" true

echo
echo "$pass passed, $fail failed"
if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
