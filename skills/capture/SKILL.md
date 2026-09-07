---
name: capture
description: Capture a correction to AI-agent work as a one-line candidate in the Repository Learning Protocol (RLP) inbox. Use immediately after a correction to make the learning discoverable at the next triage ritual; nothing is promoted without human review.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git.
metadata:
  version: "0.4.0"
---

# capture

Add a one-line learning candidate to the RLP inbox. Capture is cheap; triage is expensive. Default outcome for any inbox line is discard, so do not overthink it — write one sentence and move on.

## When to use

Capture after any of these:

- The agent produced output you had to correct.
- You notice a recurring mistake, anti-pattern, or non-obvious convention.
- A review, CI failure, or issue surfaces a correction that might happen again.
- A teammate says something like “the agent keeps doing X.”

Do not use this skill to promote a learning; use `triage` for promotion.

## Deterministic actions (60%)

### Required format

```text
- YYYY-MM-DD · <source> · <slug> · <one sentence>
```

Examples:

```text
- 2026-09-07 · #247 · api-error-leak · API handlers return raw DB errors to clients
- 2026-09-07 · claude-6f3a9 · jwt-expiry · Middleware does not reject expired JWT tokens
- 2026-09-07 · review-14b · naive-datetime · Datetimes are stored without timezone information
```

### Capture command

Use the repo script if it exists:

```bash
scripts/capture_learnings.sh -l <source> -s <slug> -t "<sentence>"
```

If the script does not exist, append the formatted line directly to `docs/learnings/inbox.md`.

### Validation

After writing, confirm the line exists:

```bash
tail -n 3 docs/learnings/inbox.md
```

Validation checklist:

- [ ] Inbox line matches `- YYYY-MM-DD · <source> · <slug> · <sentence>`.
- [ ] Slug is kebab-case and groups recurrences.
- [ ] Sentence describes the failure, not the fix.
- [ ] `tail -n 3 docs/learnings/inbox.md` shows the new line.

## Examples

```text
- 2026-09-07 · #247 · api-error-leak · API handlers return raw DB errors to clients
- 2026-09-07 · claude-6f3a9 · jwt-expiry · Middleware does not reject expired JWT tokens
- 2026-09-07 · review-14b · naive-datetime · Datetimes are stored without timezone information
```

Full invocation:

```bash
scripts/capture_learnings.sh -l "#247" -s "api-error-leak" -t "API handlers return raw DB errors to clients"
tail -n 3 docs/learnings/inbox.md
```

## Orchestration (30%)

### Capture process

1. Identify the source of the correction: a PR, issue, chat link, commit, or conversation.
2. Choose a short slug that groups recurrences (e.g., `api-error-leak`, `jwt-expiry`, `naive-datetime`).
3. Write one sentence describing the failure, not the fix.
4. Run the capture command.
5. Validate the line was appended.
6. Do not promote the learning now. Do not add context to an always-on router. Let triage handle promotion.
7. Report the result.

## AI judgment (10%)

### Parsing a natural-language request

If the user gives a bare sentence like:

```text
/rlp-architect:capture API handlers leak raw DB errors from #247
```

extract or ask for:

- **source:** `#247`
- **slug:** `api-error-leak`
- **sentence:** `API handlers return raw DB errors to clients`

Ask once if source or slug is missing. Do not guess the slug; it is the recurrence key that triage will count.

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry; capture is just the raw material.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
