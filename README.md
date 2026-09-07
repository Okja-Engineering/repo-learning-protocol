# rlp-architect

> **Agent sessions are builds. The repository is the source.**  
> `rlp-architect` compiles corrections to AI-agent work into durable repository improvements — checks, tests, scoped context, and skills — so the same mistake is never bought twice.

Read the research and protocol rationale at [`RLP.md`](RLP.md).

## Why RLP exists

Most agent failures are not model failures. They are **memory failures**: the agent did something wrong last week, you corrected it, and this week it does the same thing again. The correction lived in a chat thread, not in the repository.

RLP fixes four recurring failure modes:

| Failure mode | What happens | The fix |
|---|---|---|
| **The agent forgets what it learned.** | A correction is explained in chat and never written down. | Capture every correction as a one-line candidate in `docs/learnings/inbox.md`. Skill: [`scaffold`](skills/scaffold/SKILL.md) sets this up; [`triage`](skills/triage/SKILL.md) promotes it. |
| **The agent drowns in stale context.** | Every correction becomes a rule, a doc, a memory. Quality degrades. | Promote only at the strongest tier that can hold the fix: `check > test > scoped context > skill > discard`. Skill: [`triage`](skills/triage/SKILL.md) routes; [`audit`](skills/audit/SKILL.md) enforces a hard always-on budget. |
| **Fixes live in chat, not in code.** | A regression is fixed once, then rediscovered. | Every promoted artifact is attached to a native mechanism: CI, a test, a scoped rule, or a stage contract. One PR revert removes it. Skill: [`triage`](skills/triage/SKILL.md). |
| **Old rules never die.** | Legacy tips, ADRs, and lessons accumulate with no owner or expiry. | Every artifact carries provenance and a `verify_by` date. Skill: [`audit`](skills/audit/SKILL.md) prunes stale ones; [`migrate`](skills/migrate/SKILL.md) moves legacy learnings through the same triage gate. |

## The skills

Four focused skills, each doing one job:

| Skill | Invoke | What it does |
|---|---|---|
| [`scaffold`](skills/scaffold/SKILL.md) | `/rlp-architect:scaffold` | Add minimal project-specific wiring: inbox, decisions log, capture/health scripts, inert promotion templates. Never copies the generalized skill into the project. |
| [`triage`](skills/triage/SKILL.md) | `/rlp-architect:triage` | Route inbox candidates through the promotion ladder and draft up to three promotion PRs. Nothing becomes durable without human approval. |
| [`audit`](skills/audit/SKILL.md) | `/rlp-architect:audit` | Check promoted learnings against the five RLP invariants: repeat, provenance, deletion, budget, liveness. |
| [`migrate`](skills/migrate/SKILL.md) | `/rlp-architect:migrate` | Move one legacy learning system into RLP through normal triage, with durable evidence and commit-hash provenance. |

## Install

Two ways in, two philosophies.

### 1. Managed plugin (Devin) — recommended

Install the whole set as a Devin plugin. The `rlp-architect` namespace keeps the four skills grouped and avoids name collisions with other skills you may have installed.

```bash
devin plugins install Okja-Engineering/repo-learning-protocol
devin plugins info rlp-architect
```

Update with `devin plugins update rlp-architect`.

### 2. Standalone manual copy (any agent)

Copy only the skills you want into your agent's skill directory. You own the files and pull updates when you choose. Because the skill names (`scaffold`, `audit`, `triage`, `migrate`) are generic, this path works best when you control the skill namespace of the target agent.

```bash
cp -R skills/scaffold ~/.claude/skills/scaffold
cp -R skills/audit ~/.claude/skills/audit
cp -R skills/triage ~/.claude/skills/triage
cp -R skills/migrate ~/.claude/skills/migrate
```

The exact path depends on the agent (`~/.claude/skills/`, `.cursor/skills/`, `.codex/skills/`, etc.).

### Local checkout

```bash
devin plugins install .
```

## Use

With the Devin plugin:

```text
/rlp-architect:scaffold
/rlp-architect:audit
/rlp-architect:triage
/rlp-architect:migrate
```

If you copied a skill into your agent's skill directory, invoke it by skill name (`/scaffold`, `/audit`, `/triage`, `/migrate` — exact syntax depends on the agent).

## Getting started

1. **Scaffold** a target repository: `/rlp-architect:scaffold`. This creates `docs/learnings/inbox.md`, `docs/learnings/decisions.md`, capture/health scripts, and inert promotion templates — only the wiring, never the generalized skill.
2. **Capture** corrections as one-line candidates in the inbox, either by hand or with the copied `capture_learnings.sh` script.
3. **Triage** weekly: `/rlp-architect:triage`. Second occurrence is the signal; security or data-corruption issues route immediately.
4. **Audit** before releases or after promotions: `/rlp-architect:audit` checks the five invariants.
5. **Migrate** legacy lessons only when you have real evidence: `/rlp-architect:migrate`.

## What RLP does not do

See [`.out-of-scope.md`](.out-of-scope.md) for the deliberate boundaries.

## Layout

```text
rlp-architect/
├── .devin-plugin/plugin.json   # Devin plugin manifest
├── .out-of-scope.md             # deliberate boundaries
├── package.json                 # release metadata and test script
├── skills/
│   ├── scaffold/                # add project wiring
│   ├── audit/                   # verify the five invariants
│   ├── triage/                  # route inbox candidates
│   └── migrate/                 # move legacy learnings
├── tests/
│   ├── test_skill.sh             # manifest and layout validation
│   ├── test_walk.sh              # end-to-end plugin + scaffold + health tests
│   └── payload/                  # payload script unit tests
├── RLP.md                        # protocol rationale and design principles
├── CHANGELOG.md                  # version history
├── RELEASE_NOTES.md              # user-facing release summaries
└── LICENSE                       # MIT
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
