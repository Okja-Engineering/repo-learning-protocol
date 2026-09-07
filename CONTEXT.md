# Where do I go? (task routing — ICM Layer 1)

One stage per session. Read the stage's `CONTEXT.md` before acting; its Inputs table is the contract — load only what it lists.

| You want to… | Go to |
|---|---|
| Understand why RLP exists | `PREMISE.md`, then `stages/01-research/references/` |
| Write or revise the paper / evidence | `stages/01-research/` |
| Change the protocol itself (the spec) | `stages/02-protocol/` |
| Change the skill or its payload (the product) | `stages/03-skill/` |
| Triage feedback about RLP or this tool | `stages/04-field/` |
| See the research plan | `research/RESEARCH-PLAN.md` |
| See the construction playbook | `docs/rlp-architect-construction-playbook.md` |

Flow between stages: `01 evidence → 02 spec → 03 skill → (field use) → 04 triage → routes back to 01, 02, or 03`.

Stage 04 is ICM §6.3's edit-tracking loop made real: recurring corrections to this tool become changes to its source, by RLP's own router.

## Shared resources

| Resource | Location | Contents |
|----------|----------|----------|
| Research premise | `PREMISE.md` | The thesis, evidence, and citations |
| Construction playbook | `docs/rlp-architect-construction-playbook.md` | The full build playbook |
| Research plan | `research/RESEARCH-PLAN.md` | Open questions and validation methods |
| Citation pool | `stages/01-research/references/` | The annotated bibliography |
| RLP spec | `stages/02-protocol/references/` | The canonical protocol spec |
| Shipped skill | `skill/rlp-architect/` | Agent Skill bundle: `SKILL.md`, `scripts/`, `references/`, `assets/` |
| Skill installer | `scripts/install-skill.sh` | Copies/symlinks the skill into a target repo's `.agents/skills/` |
