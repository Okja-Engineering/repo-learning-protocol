# rlp-architect

A Devin plugin that ships an Agent Skill for running the **Repository Learning Protocol (RLP)** in any repository.

RLP turns corrections to AI-agent work into durable repository improvements — checks, tests, scoped context, and skills — so the same mistake is never bought twice. Read the protocol rationale at [`RLP.md`](RLP.md).

## What it does

Four modes:

- **scaffold** — discover a target repo and propose minimal project-specific RLP wiring.
- **audit** — check promoted learnings against the five RLP invariants.
- **triage** — route candidates through the RLP promotion ladder and draft promotion PRs.
- **migrate** — move a legacy learning system through normal triage.

The skill is generalized; it never copies itself into a project's configuration. Only project-specific wiring lands in the target repository.

## Install

```bash
devin plugins install Okja-Engineering/repo-learning-protocol
devin plugins info rlp-architect
```

For local development, run `scripts/install-skill.sh`. Update a published install with `devin plugins update rlp-architect`.

## Use

Devin plugin commands use the form `/plugin-name:skill-name mode`:

```text
/rlp-architect:rlp scaffold
/rlp-architect:rlp audit
/rlp-architect:rlp triage
/rlp-architect:rlp migrate
```

## Layout

```text
rlp-architect/
├── .devin-plugin/plugin.json   # Devin plugin manifest
├── skills/
│   └── rlp/
│       ├── SKILL.md            # the method: modes, constraints, invariants
│       ├── scripts/            # capture_learnings, learning_health, record_migration
│       ├── references/         # migration guide, promotion guide, ADR template
│       ├── templates/          # inert starters for promoted artifacts
│       └── assets/             # copyable project wiring (inbox, decisions, scripts)
├── scripts/install-skill.sh    # install this checkout as a Devin plugin
├── tests/
│   ├── test_skill.sh           # manifest and layout validation
│   └── test_walk.sh            # end-to-end plugin + scaffold + health tests
├── RLP.md                      # protocol rationale and design principles
├── PREMISE.md                  # full research premise with citations
└── docs/
    ├── history/construction-playbook.md
    └── rlp-plugin-release-runbook.md
```

## Tests

```bash
tests/test_skill.sh   # manifest / layout validation
tests/test_walk.sh    # install, scaffold, capture/health, fresh clone
```

Both must report `0 failed`.

## Status

**v0.3.0** — ships as a Devin plugin with an Agent Skill in the open [`agentskills.io`](https://agentskills.io) format.

## Lineage

Modeled on [icm-architect](https://github.com/RinDig/icm-architect) (Van Clief & McDermott, MIT), which packages the Interpretable Context Methodology as a buildable skill. RLP does the same for repository-level learning, implementing the "systems that get better with use" loop ICM's paper (arXiv:2603.16021, §6.3) names as future work.

## License

MIT. See [`LICENSE`](LICENSE).
