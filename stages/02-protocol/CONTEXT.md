# Stage 02: Protocol (the spec)

Revise the Repository Learning Protocol spec. Every change must trace to stage 01 evidence or a stage 04 decision.

## Inputs

| Source | File/Location | Section/Scope | Why |
|--------|--------------|---------------|-----|
| Previous stage | `stages/01-research/output/` | Full files | Evidence-driven proposals |
| Reference | `stages/02-protocol/references/` | Full files | The current spec (canonical copy) |
| Reference | `PREMISE.md` | Full file | The research premise |
| Previous stage | `stages/04-field/output/` | Latest triage notes | Field-triaged promotions targeting the protocol |

## Process

1. Read the current spec and the evidence proposals from stage 01.
2. For each proposed change, verify it traces to evidence or a field decision.
3. Revise the spec. Keep the honesty conventions: caveats live where claims are made, not only in threats-to-validity.
4. Version-bump on substantive change and note it in the spec's changelog section.
5. Write the revised spec draft in `output/`.

## Outputs

| Artifact | Location | Format |
|----------|----------|--------|
| Revised spec draft | `output/rlp-spec-vN.md` | Markdown |

On merge, the new version becomes the reference copy in `references/` and drives stage 03 (skill must match spec).
