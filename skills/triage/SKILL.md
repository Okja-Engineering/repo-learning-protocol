---
name: triage
description: Route Repository Learning Protocol (RLP) inbox candidates through the promotion ladder and draft up to three promotion PRs. Use during the weekly triage ritual; nothing becomes durable without human approval.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git.
metadata:
  version: "0.4.0"
---

# triage

Route inbox candidates through the RLP promotion ladder and draft promotion PRs.

## Process

1. Run the health command and read `docs/learnings/inbox.md`; the inbox is never agent context.
2. Route each candidate in order:
   - security or data corruption → deterministic check plus a scoped explanation this week;
   - first occurrence → hold with expiry;
   - recurring or expensive → mechanical check, regression test, scoped convention/ADR/knowledge module, repo-specific skill/command note, or discard.
3. Attach scoped artifacts to the existing native mechanism that consumes them: `docs/adr/` for decisions, `docs/knowledge/<domain>/` for tool conventions, editor/plugin procedures for reusable work, and CI/pre-commit for mechanical checks.
4. Copy a bundled template only after choosing a promotion tier. Replace every placeholder, add evidence that it works, and keep one promotion per revertible PR.
5. Draft at most three promotions and append every decision to `docs/learnings/decisions.md`.
6. Nothing becomes durable until a human approves and merges it.

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
