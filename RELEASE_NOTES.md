# Release notes

## v0.4.0

**RLP Architect is now available on every major agent substrate.**  
The same four skills run on Devin, Claude Code, Codex, and Cursor — each through a native plugin manifest. Wherever your team works, RLP turns corrections to AI-agent work into durable repository improvements: checks, tests, scoped context, and skills.

### What's new

- **Native plugins for Devin, Claude Code, Codex, and Cursor.** Each manifest points at the same `skills/` directory, so the behavior is identical across substrates. Invoke with your agent's plugin namespace:
  - `/rlp-architect:scaffold` — add minimal project wiring
  - `/rlp-architect:audit` — check the five RLP invariants
  - `/rlp-architect:triage` — route inbox candidates
  - `/rlp-architect:migrate` — move legacy learnings through triage
- **Four focused skills instead of one bundled mode.** `scaffold`, `audit`, `triage`, and `migrate` are independent Agent Skills. You can copy a single skill manually if your agent supports it, or install the whole plugin.
- **Cleaner repo surface.** The long research premise is now in `RLP.md`; `README.md` is the concise product entry point. The internal ICM workspace scaffolding was removed from the plugin repo.
- **Clear boundaries.** See [`.out-of-scope.md`](.out-of-scope.md) for what RLP deliberately does not do: no model tuning, no ungated memory, no auto-promotion, no custom runtime.
- **MIT license.**

### Install by substrate

| Agent | Install |
|---|---|
| Devin | `devin plugins install Okja-Engineering/repo-learning-protocol` |
| Claude Code | `claude plugins install Okja-Engineering/repo-learning-protocol` |
| Codex | Install from the local plugin directory or marketplace entry (see [Codex plugin docs](https://www.codex-docs.com/en/docs/build-plugins)) |
| Cursor | Copy or symlink the plugin directory to your Cursor plugins folder (see [Cursor plugin docs](https://cursor.com/docs/plugins)) |

For a manual standalone copy, copy the folders under `skills/` into your agent's skill directory. See `README.md` for details.

### Coming up

- Field install verification across Devin, Claude Code, Codex, and Cursor.
- Field reports from production repositories.
- Refined promotion rules based on real recurrence data.
