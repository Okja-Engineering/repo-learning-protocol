---
name: migrate
description: Move one legacy learning system into the Repository Learning Protocol (RLP) through normal triage. Use when a repository has old `.vault/`, lessons, or decision logs that should become durable, proven, revertible RLP artifacts.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git.
metadata:
  version: "0.4.0"
---

# migrate

Move a legacy learning system through normal triage.

## Process

1. Identify one legacy learning with recoverable evidence (a commit, PR, issue, or conversation that earned it, not just an old file path).
2. Create a candidate in the inbox that references the legacy system and the real evidence.
3. Run normal triage; do not assume promotion.
4. If promoted, use `scripts/record_migration.sh` to construct a `source` value containing real evidence, the resolved migration commit hash, and the original legacy path.
5. Attach the artifact to the existing native mechanism that consumes it and verify that reverting the promotion PR removes it completely.

Migration never bypasses triage.

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
