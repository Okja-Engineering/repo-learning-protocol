---
name: audit
description: Check a Repository Learning Protocol (RLP) installation against the five invariants. Use between triage sessions or before a release to verify that promoted learnings are repeat, proven, deletable, within budget, and live.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git.
metadata:
  version: "0.3.0"
---

# audit

Check promoted learnings against the five RLP invariants.

## Process

1. Locate the inbox, decisions log, health command, and real promoted artifacts.
2. Exclude everything under a `templates/` directory and anything explicitly marked `TEMPLATE`. Placeholders do not satisfy an invariant.
3. Pass only the always-on files to `learning_health.sh --always`: root routers (`AGENTS.md` or equivalent), editor pointers such as `CLAUDE.md`, and global/always-apply rules. ADRs, knowledge modules, Semgrep rules, tests, and skills are scoped and do not count toward the default 1,500-token budget.
4. Verify each real promotion:
   - **Repeat:** its check fires or its scoped context loads from the relevant contract/trigger.
   - **Provenance:** it carries `date`, `source`, `owner`, `scope`, and `verify_by`, or traces in one hop through the decisions log.
   - **Deletion:** reverting one promotion PR removes it.
   - **Budget:** the measured always-on set is within the declared budget.
   - **Liveness:** every deterministic artifact has a recorded firing by its first prune or an explicit re-justification.
5. For migrated artifacts, reject `source` values that contain only a removed file path. Require real evidence plus the migration commit hash and original path.
6. Report pass/fail per invariant, the measured always-on file list, stale promotions, and excluded template paths.

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
