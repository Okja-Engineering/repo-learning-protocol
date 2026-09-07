---
name: audit
description: Check a Repository Learning Protocol (RLP) installation against the five invariants. Use between triage sessions or before a release to verify that promoted learnings are repeat, proven, deletable, within budget, and live.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git.
metadata:
  version: "0.5.0"
---

# audit

Check promoted learnings against the five RLP invariants.

## When to use

Run an audit between triage sessions, before a release, or after any promotion is merged. Use it to verify that promoted learnings remain repeat, proven, deletable, within budget, and live.

## Deterministic actions (60%)

### Files and commands

```bash
# Read current state
cat docs/learnings/inbox.md
cat docs/learnings/decisions.md

# Check always-on budget and staleness
scripts/learning_health.sh --always AGENTS.md CLAUDE.md -c
```

### Exclusion rule

Exclude everything under a `templates/` directory and anything explicitly marked `TEMPLATE`. Placeholders do not satisfy an invariant.

### Always-on budget check

Pass only these file types to `learning_health.sh --always`:

- root routers (`AGENTS.md` or equivalent)
- editor pointers such as `CLAUDE.md`
- global/always-apply rules

ADRs, knowledge modules, Semgrep rules, tests, and skills are scoped and do not count toward the default 1,500-token budget.

### Invariant checklist

For every real promotion, verify:

| Invariant | Pass criterion |
|---|---|
| **Repeat** | Its check fires or its scoped context loads from the relevant contract/trigger. |
| **Provenance** | It carries `date`, `source`, `owner`, `scope`, and `verify_by`, or traces in one hop through the decisions log. |
| **Deletion** | Reverting one promotion PR removes it. |
| **Budget** | The measured always-on set is within the declared budget. |
| **Liveness** | Every deterministic artifact has a recorded firing by its first prune or an explicit re-justification. |

### Migrated artifacts rule

For migrated artifacts, reject `source` values that contain only a removed file path. Require real evidence plus the migration commit hash and original path.

### Report format

Report per-invariant pass/fail, the measured always-on file list, stale promotions, and excluded template paths.

## Orchestration (30%)

### Audit process

1. Locate the inbox, decisions log, health command, and real promoted artifacts.
2. Exclude templates and placeholder content.
3. Build the always-on file list and run the health command.
4. Run the invariant checklist against every real promotion.
5. Report results and flag stale artifacts.

## Examples

### Sample report

```text
Repeat:      PASS
Provenance:  PASS
Deletion:    PASS
Budget:      PASS (1,240 / 1,500 tokens)
Liveness:    PASS

Always-on files:
  - AGENTS.md
  - CLAUDE.md

Stale artifacts: 0
Excluded templates:
  - docs/rlp-architect/templates/
```

### Commands

```bash
# Audit a repo whose always-on context is AGENTS.md and CLAUDE.md
scripts/learning_health.sh --always AGENTS.md CLAUDE.md -c
```

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
