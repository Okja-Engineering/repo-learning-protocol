# RLP Dogfood Demo

This directory is a scratchpad for proving that `rlp-architect` installs and runs in a real target repository. Nothing in here is committed as a working install.

## One-time setup

From the root of `repo-learning-protocol`, install the checkout as a global Devin plugin:

```bash
scripts/install-skill.sh
```

The demo repository receives only project-specific wiring when scaffold runs; the generalized skill remains in the plugin.

## Dogfood steps

Open `examples/demo/` in your agent and run:

```text
/rlp-architect scaffold
```

Then:

1. Capture a sample learning:
   ```bash
   scripts/capture_learnings.sh -l https://example.com/pr/1 \
     -s naive-datetime -t "Use timezone-aware datetimes."
   ```

2. Capture a second learning with the same slug to trigger recurrence:
   ```bash
   scripts/capture_learnings.sh -l https://example.com/pr/2 \
     -s naive-datetime -t "Again, use UTC."
   ```

3. Run the health check:
   ```bash
   scripts/learning_health.sh -c
   ```

4. Run the audit:
   ```text
   /rlp-architect audit
   ```

5. Run triage and route the recurring `naive-datetime` slug to the strongest tier that fits.

## Expected evidence

- `docs/learnings/inbox.md` contains both captured lines.
- `docs/learnings/decisions.md` contains the triage decision.
- `scripts/learning_health.sh` reports `naive-datetime: 2` and exits 0 when the budget is respected.
