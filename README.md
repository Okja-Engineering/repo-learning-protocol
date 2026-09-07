# rlp-architect

> **Agent sessions are builds. The repository is the source.**  
> `rlp-architect` compiles corrections to AI-agent work into durable repository improvements — checks, tests, scoped context, and skills — so the same mistake is never bought twice.

Read the research and protocol rationale at [`RLP.md`](RLP.md).

## Why RLP exists

Most agent failures are not model failures. They are **memory failures**: the agent did something wrong last week, you corrected it, and this week it does the same thing again. The correction lived in a chat thread, not in the repository.

RLP fixes four recurring failure modes:

| Failure mode | What happens | The fix |
|---|---|---|
| **The agent forgets what it learned.** | A correction is explained in chat and never written down. | Capture every correction as a one-line candidate in `docs/learnings/inbox.md`. Skill: [`capture`](skills/capture/SKILL.md) writes the line; [`scaffold`](skills/scaffold/SKILL.md) sets up the inbox; [`triage`](skills/triage/SKILL.md) promotes it. |
| **The agent drowns in stale context.** | Every correction becomes a rule, a doc, a memory. Quality degrades. | Promote only at the strongest tier that can hold the fix: `check > test > scoped context > skill > discard`. Skill: [`triage`](skills/triage/SKILL.md) routes; [`audit`](skills/audit/SKILL.md) enforces a hard always-on budget. |
| **Fixes live in chat, not in code.** | A regression is fixed once, then rediscovered. | Every promoted artifact is attached to a native mechanism: CI, a test, a scoped rule, or a stage contract. One PR revert removes it. Skill: [`triage`](skills/triage/SKILL.md). |
| **Old rules never die.** | Legacy tips, ADRs, and lessons accumulate with no owner or expiry. | Every artifact carries provenance and a `verify_by` date. Skill: [`audit`](skills/audit/SKILL.md) prunes stale ones. |

## The skills

Four focused skills, each doing one job:

| Skill | Invoke | What it does |
|---|---|---|
| [`scaffold`](skills/scaffold/SKILL.md) | `/rlp-architect:scaffold` | Add minimal project-specific wiring: inbox, decisions log, capture/health scripts, inert promotion templates. Never copies the generalized skill into the project. |
| [`capture`](skills/capture/SKILL.md) | `/rlp-architect:capture` | Add a one-line learning candidate to the inbox after a correction. Cheap; default outcome is discard. |
| [`triage`](skills/triage/SKILL.md) | `/rlp-architect:triage` | Route inbox candidates through the promotion ladder and draft up to three promotion PRs. Nothing becomes durable without human approval. |
| [`audit`](skills/audit/SKILL.md) | `/rlp-architect:audit` | Check promoted learnings against the five RLP invariants: repeat, provenance, deletion, budget, liveness. |


## Install

### Native plugin (recommended)

Install `rlp-architect` as a plugin in your agent. The plugin namespace keeps the four skills grouped and avoids collisions with other skills you may have installed.

| Agent | Command |
|---|---|
| Devin | `devin plugins install Okja-Engineering/repo-learning-protocol` |
| Claude Code | `claude plugins install Okja-Engineering/repo-learning-protocol` |
| Codex | Install from the local plugin directory or marketplace entry (see [Codex plugin docs](https://www.codex-docs.com/en/docs/build-plugins)) |
| Cursor | Copy or symlink the plugin directory to your Cursor plugins folder (see [Cursor plugin docs](https://cursor.com/docs/plugins)) |

All native plugins use the same namespace:

```text
/rlp-architect:scaffold
/rlp-architect:capture
/rlp-architect:triage
/rlp-architect:audit
```

### Local checkout

```bash
# Devin
devin plugins install .

# Claude Code
claude --plugin-dir .
```

### Standalone manual copy (any agent)

Copy only the skills you want into your agent's skill directory. You own the files and pull updates when you choose. Because the skill names (`scaffold`, `capture`, `audit`, `triage`) are generic, this path works best when you control the skill namespace of the target agent.

```bash
cp -R skills/scaffold ~/.claude/skills/scaffold
cp -R skills/capture ~/.claude/skills/capture
cp -R skills/audit ~/.claude/skills/audit
cp -R skills/triage ~/.claude/skills/triage
```

The exact path depends on the agent (`~/.claude/skills/`, `.cursor/skills/`, `.codex/skills/`, etc.).

```bash
devin plugins install .
```

## Use

With the Devin plugin:

```text
/rlp-architect:scaffold
/rlp-architect:capture
/rlp-architect:triage
/rlp-architect:audit
```

If you copied a skill into your agent's skill directory, invoke it by skill name (`/scaffold`, `/capture`, `/audit`, `/triage` — exact syntax depends on the agent).

## Getting started

1. **Scaffold** a target repository: `/rlp-architect:scaffold`. This creates `docs/learnings/inbox.md`, `docs/learnings/decisions.md`, capture/health scripts, and inert promotion templates — only the wiring, never the generalized skill.
2. **Capture** corrections as one-line candidates in the inbox: `/rlp-architect:capture <sentence>` or the copied `capture_learnings.sh` script.
3. **Triage** weekly: `/rlp-architect:triage`. Second occurrence is the signal; security or data-corruption issues route immediately.
4. **Audit** before releases or after promotions: `/rlp-architect:audit` checks the five invariants.

## What RLP does not do

See [`.out-of-scope.md`](.out-of-scope.md) for the deliberate boundaries.

## Layout

```text
rlp-architect/
├── .devin-plugin/plugin.json   # Devin plugin manifest
├── .claude-plugin/plugin.json  # Claude Code plugin manifest
├── .codex-plugin/plugin.json   # Codex plugin manifest
├── .cursor-plugin/plugin.json  # Cursor plugin manifest
├── .out-of-scope.md             # deliberate boundaries
├── skills/
│   ├── scaffold/                # add project wiring
│   ├── capture/                 # add a learning candidate to the inbox
│   ├── triage/                  # route inbox candidates
│   └── audit/                   # verify the five invariants
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

**v0.4.0** — ships as a plugin for Devin, Claude Code, Codex, and Cursor, with Agent Skills in the open [`agentskills.io`](https://agentskills.io) format.

## Lineage

Modeled on [icm-architect](https://github.com/RinDig/icm-architect) (Van Clief & McDermott, MIT), which packages the Interpretable Context Methodology as a buildable skill. RLP does the same for repository-level learning, implementing the "systems that get better with use" loop ICM's paper (arXiv:2603.16021, §6.3) names as future work.

## License

MIT. See [`LICENSE`](LICENSE).
