# Stage 00: Learn (capture and triage)

Process incoming repository learnings so corrections become durable improvements.

## Inputs

- `docs/learnings/inbox.md` — candidate learnings from agent sessions
- `docs/learnings/decisions.md` — audit trail of triage decisions
- `scripts/learning_health.sh` — health report on promoted artifacts

## Process

1. Run `scripts/learning_health.sh` and read `docs/learnings/inbox.md`.
2. Route each candidate to the strongest durable tier: enforced check > regression test > scoped context > skill > discard.
3. Draft at most three promotions per session.
4. Append every decision to `docs/learnings/decisions.md`.
5. Nothing becomes durable until a human approves and merges it.

## Outputs

| Artifact | Location |
|---|---|
| Promoted check/contract/test/skill | Determined by tier and existing stage contracts |
| Triage record | `docs/learnings/decisions.md` |
