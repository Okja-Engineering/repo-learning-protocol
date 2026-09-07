# /promote-learning

Walks the RLP router on the current inbox entry and drafts the promotion PR.

## Usage

1. Read `docs/learnings/inbox.md`.
2. Run `scripts/learning_health.sh -c` to check budget and staleness before adding context.
3. Pick the highest recurring or security-class candidate.
4. Apply the router:
   - security / data-corruption → deterministic check + doc line, this week
   - recurring / expensive:
     1. mechanically checkable? → lint / Semgrep / CI check
     2. verifiable by execution? → regression test
     3. stable convention or "why"? → scoped rule / ADR / knowledge module
     4. reusable procedure? → skill / command note
     5. still uncertain? → stay in inbox with expiry; default outcome is deletion
5. Create the artifact with provenance frontmatter (`date`, `source`, `owner`, `scope`, `verify_by`).
6. Append the decision to `docs/learnings/decisions.md`.
7. If the learning came from a review/CI artifact, capture it with `scripts/capture_learnings.sh`.
8. Open the promotion PR with the artifact, its test, and a budget check.

## Output

A PR that adds exactly one durable artifact and the evidence that it fires.
