---
date: 2026-01-01
source: "team decision to adopt RLP"
owner: "<team>"
scope: "*"
verify_by: 2026-04-01
---

# ADR 0001: Adopt the Repository Learning Protocol

## Context

This repo uses a coding agent on closed-weight models. Corrections made in review do not persist in the model weights, and unreviewed self-generated context has been shown to degrade agent performance. RLP provides a lightweight, gated loop for turning recurring corrections into durable repository artifacts.

## Decision

Adopt the Repository Learning Protocol as the learning loop for this repository.

## Consequences

- Capture is automated but promotion is human-gated.
- Always-on context is capped at ~1,500 tokens; everything else loads on scope or trigger.
- Every promoted artifact carries provenance and a `verify_by` date.
- Deletion is a success mode; stale artifacts are pruned monthly.
