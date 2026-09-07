# Stage 04: Field (RLP applied to RLP)

Run the RLP router over this repo's own inbox. This is the meta-move: the protocol improves itself using its own mechanism.

## Inputs

| Source | File/Location | Section/Scope | Why |
|--------|--------------|---------------|-----|
| Working | `docs/learnings/inbox.md` | Full file | Candidates about the protocol or the tool |
| Reference | `stages/02-protocol/references/` | Router section | The router to apply |

Note: This stage contract is the ONE sanctioned pointer to the inbox. The inbox must never appear in Layer 0/1 or any rule — that is the protocol's own hard rule, applied to itself.

## Process

1. Read `docs/learnings/inbox.md`.
2. For each candidate, apply the router IN ORDER:
   - Evidence gap → stage 01
   - Protocol defect → stage 02
   - Skill/payload defect or missing check/test → stage 03
   - One-off → discard (the default)
3. Second occurrence is the signal. Security-class routes immediately.
4. Cap 3 promotions per session. Humans merge.
5. Log every fate in `docs/learnings/decisions.md`.

## Outputs

| Artifact | Location | Format |
|----------|----------|--------|
| Triage notes | `output/triage-NNN.md` | Markdown (candidates seen, routes chosen, PR links) |
| Decisions log entries | `docs/learnings/decisions.md` | One line per triaged candidate |
