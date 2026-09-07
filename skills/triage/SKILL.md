---
name: triage
description: Route Repository Learning Protocol (RLP) inbox candidates through the promotion ladder and draft up to three promotion PRs. Use during the weekly triage ritual; nothing becomes durable without human approval.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git.
metadata:
  version: "0.5.0"
---

# triage

Route inbox candidates through the RLP promotion ladder and draft promotion PRs.

## When to use

Use during the weekly triage ritual, or when:

- A promotion PR needs to be drafted from recurring inbox entries.
- A safety-class or data-corruption candidate needs immediate promotion.
- The maintainer asks to discard, hold, or promote a specific slug.

Do not use this skill to triage issue-tracker tickets or project-management backlogs.

## Deterministic actions (60%)

### Files and commands

- Read: `docs/learnings/inbox.md`
- Read: `docs/learnings/decisions.md`
- Run: `scripts/learning_health.sh --always`

### Recurrence rule

A learning needs **2+ occurrences of the same `<slug>`** before promotion. Security and data-corruption classes bypass this rule.

### Layer picker

For recurring or expensive candidates, answer in order:

1. **Can a machine check it?**
   - YES → deterministic check: CI workflow, pre-commit hook, Semgrep rule, linter/type-checker config, or custom verification script.
2. **Can a test prove it?**
   - YES → regression test: unit, integration, snapshot, or property-based.
3. **Is it a stable convention or a "why"?**
   - YES → scoped context: editor rule, stage contract, ADR, knowledge module, or API conventions doc.
4. **Is it a reusable procedure?**
   - YES → skill or command note.
5. **Uncertain.**
   - Hold with a `verify_by` date. Default outcome is discard.

### Required provenance fields

Every promoted artifact must carry:

```yaml
---
date: <YYYY-MM-DD>
source: "<PR / issue / conversation that earned this>"
owner: "<name>"
scope: "<glob or trigger>"
verify_by: <YYYY-MM-DD>
---
```

### Promotion mechanics

- One promotion per revertible PR.
- Reverting that PR removes the learning completely.
- Append the decision to `docs/learnings/decisions.md`.
- Draft at most three promotions per session.
- Nothing is durable until a human approves and merges it.

### Decision log format

```text
- YYYY-MM-DD · <slug> · PROMOTED → <tier> / <paths> (PR) | DISCARDED — <reason> | HELD — <reason, expiry>
```

## Orchestration (30%)

### Triage process

1. Run the health command and read `docs/learnings/inbox.md`; the inbox is never agent context.
2. Route each candidate in order:
   - security or data corruption → deterministic check plus a scoped explanation this week;
   - first occurrence → hold with expiry;
   - recurring or expensive → mechanical check, regression test, scoped convention/ADR/knowledge module, repo-specific skill/command note, or discard.
3. Attach scoped artifacts to the existing native mechanism that consumes them: `docs/adr/` for decisions, `docs/knowledge/<domain>/` for tool conventions, editor/plugin procedures for reusable work, and CI/pre-commit for mechanical checks.
4. Copy a bundled template only after choosing a promotion tier. Replace every placeholder, add evidence that it works, and keep one promotion per revertible PR.
5. Draft at most three promotions and append every decision to `docs/learnings/decisions.md`.
6. Nothing becomes durable until a human approves and merges it.

## Examples

### Worked triage

Inbox contains two entries with the same slug:

```text
- 2026-09-01 · #247 · api-error-leak · API handlers return raw DB errors to clients
- 2026-09-05 · review-14b · api-error-leak · Stack traces are returned in 500 responses
```

Health check:

```bash
scripts/learning_health.sh --always AGENTS.md CLAUDE.md
```

Layer-picker decision: the pattern is mechanically checkable → Semgrep rule plus a doc line.

Decision log line:

```text
- 2026-09-07 · api-error-leak · PROMOTED → deterministic check / semgrep/rules/api-error-leak.yml (PR #312)
```

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
