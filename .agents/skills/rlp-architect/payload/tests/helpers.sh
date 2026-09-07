#!/usr/bin/env bash
set -euo pipefail

pass=0
fail=0

assert_contains() {
  local file="$1" needle="$2"
  if grep -q "$needle" "$file"; then
    pass=$((pass + 1))
  else
    echo "FAIL: '$needle' not found in $file"
    fail=$((fail + 1))
  fi
}

assert_not_contains() {
  local file="$1" needle="$2"
  if grep -q "$needle" "$file"; then
    echo "FAIL: unexpected '$needle' found in $file"
    fail=$((fail + 1))
  else
    pass=$((pass + 1))
  fi
}

assert_eq() {
  local got="$1" want="$2"
  if [[ "$got" == "$want" ]]; then
    pass=$((pass + 1))
  else
    echo "FAIL: got '$got', want '$want'"
    fail=$((fail + 1))
  fi
}

assert_rc() {
  local want="$1"
  shift
  local rc=0
  "$@" || rc=$?
  if [[ "$rc" -eq "$want" ]]; then
    pass=$((pass + 1))
  else
    echo "FAIL: expected exit code $want, got $rc for: $*"
    fail=$((fail + 1))
  fi
}

summary() {
  echo
  echo "$pass passed, $fail failed"
  if [[ "$fail" -gt 0 ]]; then
    exit 1
  fi
}
