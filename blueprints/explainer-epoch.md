---
id: explainer-epoch
defect_class: opaque-gate-change
triggers: a gate ledger exists; the operator reads ledgers rather than diffs; non-author comprehension is a requirement
requires: gate-machine
proven_in: psychic-crew, psychic-templates, psychic-sidekick, psychic-plugins
---

# explainer-epoch — every gated change ships its plain-language explainer

## What

From a declared epoch row onward, every gate in the ledger ships `docs/explainers/<GATE>.md` in
plain words — what changed, why, how to verify it yourself, what could break and what catches
it. An INDEX file declares the epoch (`EXPLAINER-EPOCH:`) and enumerates grandfathered rows
(`EXPLAINER-GRANDFATHERED:` — events recorded without tokens, owing no explainer). The suite
walks every ledger row AFTER the epoch by row position and fails on any missing explainer.

## Why

Gated change without comprehension is drift with paperwork: a ledger the operator cannot read is
an audit trail for the author only. The parent program's operator asked for exactly this — an
easy way to understand what each gated phase did and why — and the discipline was born as a
suite-enforced law rather than a habit, because habits do not survive sessions.

## When

Any repo with a gate ledger and a human operator who reads outcomes rather than diffs. The epoch
lands at the gate that adopts the discipline; history before it is grandfathered by enumeration,
never rewritten.

## Proven in

psychic-crew (COMPREHEND-2: epoch bound by row position, vacuity guard, fire-probe; strict-FAIL
semantics), then ported in one estate gate to psychic-templates, psychic-sidekick, and
psychic-plugins with ONE declared variance (an empty post-epoch set is PASS-with-stated-reason,
because siblings gate rarely) — and the port's own fire-probe caught a real porting bug on day
one, which is the negative-control lesson arriving on schedule.

## How to re-instantiate

1. Create `docs/explainers/INDEX.md` with an `EXPLAINER-EPOCH: <gate>` line, an optional
   `EXPLAINER-GRANDFATHERED: <gates…>` line, and one index line per explainer.
2. Ship `docs/explainers/<GATE>.md` with every gate from the epoch on: What changed / Why /
   Verify it yourself / What could break and what catches it. Plain words; commands the reader
   can run.
3. Suite arm: extract the gate-name column from every ledger row AFTER the epoch row (row
   position, not date), skip the grandfathered enumeration, fail naming any gate whose explainer
   file is missing.
4. Fire-probe in the same arm: plant a synthetic post-epoch row into a COPY of the ledger and
   assert the extractor sees it — an extractor that misses the plant voids the binding.
5. Declare the empty-set semantics (FAIL where gates are frequent, PASS-with-reason where rare)
   — silently inheriting either is how the check rots.
