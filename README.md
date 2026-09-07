# rlp-architect

A Devin plugin that ships Agent Skills for running the **Repository Learning Protocol (RLP)** in any repository.

RLP turns corrections to AI-agent work into durable repository improvements — checks, tests, scoped context, and skills — so the same mistake is never bought twice. Read the protocol rationale at [`RLP.md`](RLP.md).

## What it does

Four skills, one per mode:

- `scaffold` — add minimal, project-specific RLP wiring.
- `audit` — check promoted learnings against the five RLP invariants.
- `triage` — route candidates through the RLP promotion ladder.
- `migrate` — move a legacy learning system through normal triage.

Each skill is generalized; none copies itself into a project's configuration. Only project-specific wiring lands in the target repository.

## Install

```bash
devin plugins install Okja-Engineering/repo-learning-protocol
devin plugins info rlp-architect
```

For local development, run `scripts/install-skill.sh`. Update a published install with `devin plugins update rlp-architect`.

## Use

Devin plugin commands use the form `/plugin-name:skill-name`:

```text
/rlp-architect:scaffold
/rlp-architect:audit
/rlp-architect:triage
/rlp-architect:migrate
```

## Layout

```text
rlp-architect/
├── .devin-plugin/plugin.json   # Devin plugin manifest
├── skills/
│   ├── scaffold/              # add project wiring
│   ├── audit/                 # verify the five invariants
│   ├── triage/                # route inbox candidates
│   └── migrate/               # move legacy learnings
├── scripts/install-skill.sh   # install this checkout as a Devin plugin
├── tests/
│   ├── test_skill.sh           # manifest and layout validation
│   └── test_walk.sh            # end-to-end plugin + scaffold + health tests
├── RLP.md                      # protocol rationale and design principles
└── LICENSE                     # MIT
```

## Tests

```bash
tests/test_skill.sh   # manifest / layout validation
tests/test_walk.sh    # install, scaffold, capture/health, fresh clone
```

Both must report `0 failed`.

## Status

**v0.3.0** — ships as a Devin plugin with Agent Skills in the open [`agentskills.io`](https://agentskills.io) format.

## Lineage

Modeled on [icm-architect](https://github.com/RinDig/icm-architect) (Van Clief & McDermott, MIT), which packages the Interpretable Context Methodology as a buildable skill. RLP does the same for repository-level learning, implementing the "systems that get better with use" loop ICM's paper (arXiv:2603.16021, §6.3) names as future work.

## License

MIT. See [`LICENSE`](LICENSE).
