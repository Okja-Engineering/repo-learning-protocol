# Stage 03: Skill (the product)

Change `skill/rlp-architect/SKILL.md` and `payload/` only here, only to match the spec or a stage 04 decision.

## Inputs

| Source | File/Location | Section/Scope | Why |
|--------|--------------|---------------|-----|
| Reference | `stages/02-protocol/references/` | Full files | The spec the skill must implement |
| Previous stage | `stages/02-protocol/output/` | Latest spec draft | Spec changes that require skill updates |
| Previous stage | `stages/04-field/output/` | Latest triage notes | Field-triaged promotions targeting the skill/payload |
| Reference | `docs/history/construction-playbook.md` | Skill and payload blocks | The original skill and payload design |

## Process

1. Read the current spec and any field decisions.
2. Identify what needs to change in the skill or payload.
3. Make the change. `tests/test_skill.sh` and `tests/test_walk.sh` must report `0 failed` before any PR.
4. Payload script changes require a matching test change in the same PR.
5. Never "fix" an installed copy in some other repo — the fix lands here and re-ships.

## Outputs

| Artifact | Location | Format |
|----------|----------|--------|
| Skill changes | `skill/rlp-architect/` | SKILL.md + payload |
| Test changes | `tests/` | Python tests |

Release = tag.
