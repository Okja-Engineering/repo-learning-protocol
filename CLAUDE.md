# Repo Learning Protocol

You are in **repo-learning-protocol**: an ICM-structured workspace that develops, documents, and ships the **Repository Learning Protocol (RLP)** — the loop that turns corrections to AI-agent work into durable repository improvements.

Two methodologies are layered here: **ICM** (folder structure as agent architecture) shapes this workspace; **RLP** (corrections compile into the source at the strongest tier) governs how it improves. The factory is ICM-shaped; the factory's improvement process is RLP.

## Folder map

| Path | Purpose |
|------|---------|
| `PREMISE.md` | Why RLP exists (the research premise, cited) |
| `CONTEXT.md` | Task routing (Layer 1). Read it next. |
| `stages/01-research/` | Paper, evidence, citation pool |
| `stages/02-protocol/` | The RLP spec |
| `stages/03-skill/` | Stage contract for the `rlp-architect` product |
| `.devin-plugin/plugin.json` + `skills/rlp/` | Shipped Devin plugin and `rlp` Agent Skill bundle |
| `scripts/install-skill.sh` | Install the local checkout through `devin plugins install` |
| `stages/04-field/` | RLP applied to RLP: triage of field feedback |
| `docs/learnings/` | This repo's own learning loop (stage 04 reads it) |
| `docs/history/construction-playbook.md` | The construction playbook |
| `stages/01-research/references/RESEARCH-PLAN.md` | Open questions and validation methods |
| `references/` | Supporting evidence and citation pool |
| `tests/` | Proof suite (skill manifest + payload tests) |

## Routing

| You want to… | Go to |
|---|---|
| Understand why RLP exists | `PREMISE.md`, then `stages/01-research/` |
| Write or revise the research | `stages/01-research/CONTEXT.md` |
| Change the protocol itself | `stages/02-protocol/CONTEXT.md` |
| Change the skill or its payload | `stages/03-skill/CONTEXT.md` |
| Triage feedback about RLP | `stages/04-field/CONTEXT.md` |
| See the construction playbook | `docs/history/construction-playbook.md` |
| See the research plan | `stages/01-research/references/RESEARCH-PLAN.md` |

## Working rule

Read the selected stage's `CONTEXT.md` and only its named inputs. Work one stage per session. Humans gate every promotion. Determinism first. Always-on context stays under budget. No memory tier — no vector stores, knowledge graphs, or ungated auto-memory.

Stage artifacts are immutable revisions (`r1`, `r2`, ...). Never overwrite a prior revision. `output/` is the only cross-stage handoff surface.
