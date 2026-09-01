---
id: count-binding
defect_class: unbound-figure-drift
triggers: a readme states a number the repo can recompute; totals are quoted in more than one doc; a figure sat stale across sessions
requires: negative-control
proven_in: psychic-crew, psychic-crew-lite, psychic-templates, psychic-sidekick, psychic-plugins
---

# count-binding — documented figures equal live totals, mechanically

## What

Every number a README or summary states about the system (assertion counts, tracked-file counts,
hook counts) is bound by an assertion that recomputes the live value and fails on divergence —
in both directions, covering EVERY claim instance, running last so it sees the full total.

## Why

Unbound figures drift: the parent watched "37 / 144 / 24" sit four sessions stale in the one
file a new reader starts from, and fixing without binding would only restart the clock. A count
that is asserted stays true or turns red; there is no third state.

## When

The moment any document states a number the repo itself can recompute. The binding lands in the
same commit as the first statement of the figure — retrofitting is the failure mode.

## Proven in

psychic-crew (CR-027 / C-28 / R4-12 / PB-06 — four bindings across three suites),
psychic-crew-lite (F1 hook-count), psychic-templates and psychic-sidekick and psychic-plugins
(README template/field/skill counts, bound at birth).

## How to re-instantiate

1. Extract every numeric claim: `grep -oE '[0-9]+ <noun>'` over the doc, distinct values.
2. Recompute the live value in the suite (its own total, a `git ls-files | wc -l`, an `ls` count).
3. Fail listing the stale values found; pass naming both figures. Cover ALL instances of the
   claim, not the first one — a binding that covers one instance is a canary that covers one trail.
