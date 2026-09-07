# Release notes

## v0.3.0

`rlp-architect` is a Devin plugin (and a set of standalone Agent Skills) for running the **Repository Learning Protocol (RLP)**. RLP turns corrections to AI-agent work into durable repository improvements — checks, tests, scoped context, and skills — so the same mistake is not bought twice.

### What's new

- **Four focused skills instead of one bundled mode.** The plugin now exposes `scaffold`, `audit`, `triage`, and `migrate` as separate skills:
  - `/rlp-architect:scaffold` — add minimal project wiring
  - `/rlp-architect:audit` — check the five RLP invariants
  - `/rlp-architect:triage` — route inbox candidates
  - `/rlp-architect:migrate` — move legacy learnings through triage
- **Native plugin support for Devin, Claude Code, Codex, and Cursor.** The plugin ships manifests for all four agents, so you can install `rlp-architect` once and invoke `/rlp-architect:scaffold` (or your agent's equivalent) without copying individual skill folders.
- **Cleaner repo surface.** The long research premise is now in `RLP.md`; `README.md` is the concise product entry point. The internal ICM workspace scaffolding was removed from the plugin repo.
- **Clear boundaries.** See [`.out-of-scope.md`](.out-of-scope.md) for what RLP deliberately does not do: no model tuning, no ungated memory, no auto-promotion, no custom runtime.
- **Cross-agent install (v0.5).** In the future, the skills may be installable via the open `npx skills` CLI. For v0.4.0, use the Devin plugin or manual copy. the skills can now be installed via the open `npx skills` CLI into Claude Code, Codex, Cursor, OpenCode, and 60+ Agent Skills-compatible agents.
- **MIT license.**

### Install

```bash
devin plugins install Okja-Engineering/repo-learning-protocol
```

Then invoke any skill, e.g.:

```text
/rlp-architect:scaffold
```

See `README.md` for per-agent install paths.

### Coming up

- Public install verification.
- Field reports from production repositories (field trial prep in progress).
- Refined promotion rules based on real recurrence data.
