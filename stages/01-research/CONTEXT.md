# Stage 01: Research (paper & evidence)

Produce or revise the research that grounds RLP — the paper, evidence summaries, citation pool, and open questions.

## Inputs

| Source | File/Location | Section/Scope | Why |
|--------|--------------|---------------|-----|
| Reference | `PREMISE.md` | Full file | The research premise |
| Reference | `stages/01-research/references/REFERENCES.md` | Full file | The citation pool (109 entries) |
| Reference | `stages/01-research/references/RESEARCH-PLAN.md` | Full file | Open questions and validation methods |
| Reference | `docs/history/construction-playbook.md` | PREMISE.md block | The original premise with citations |
| Previous stage | `stages/04-field/output/` | Latest triage notes | Field feedback that raises evidence gaps |

## Process

1. Read the current premise and citation pool.
2. Identify what evidence is missing or needs updating.
3. For each claim, assign or verify its confidence classification: PROVEN / SUPPORTED / EMERGING / PLAUSIBLE / SPECULATIVE / CONTRADICTED.
4. Cite only entries in REFERENCES.md by their keys (e.g. [P33], [D19]). A claim without a source is tagged [UNSOURCED] and left visible.
5. Proposing a new source = a PR adding it to REFERENCES.md with URL, date, type, and strength.
6. Write or revise research outputs in `output/`.

## Outputs

| Artifact | Location | Format |
|----------|----------|--------|
| Research brief | `output/research-brief.md` | Markdown with citations |
| Evidence updates | `output/evidence-updates.md` | Markdown with claim + classification + citation |
| New citations | `references/REFERENCES.md` | Annotated bibliography entries |

Findings that should change the protocol feed stage 02.
