---
id: commit-straddle
defect_class: green-early-or-stale
triggers: a suite asserts its own commit count or head; the gated commit must contain the ledger row approving it; totals change in the closing commit itself
requires: gate-machine
proven_in: psychic-crew
---

# commit-straddle — pre-token reds that name post-commit truths

## What

When a gated change moves bound figures (tracked-file counts, suite totals), the STOP state is
deliberately red: the suites fail naming exactly the values that become true at the commit the
token authorizes ("README says 104, the tree has 103"). The straddle is documented in the STOP
report, and the token's commit resolves every named red to green.

## Why

The alternative is worse both ways: committing early to make suites green bypasses the gate;
holding the doc figures back means the committed state is born stale. The straddle makes the
in-between state HONEST — every red is a prediction, checkable the moment the commit lands.

## When

Any gated workflow where documentation figures are bound to live values (see count-binding) and
the gate adds or removes counted artifacts.

## Proven in

psychic-crew — every counting gate since the bindings landed (RSCH-3's 102-vs-100, SIDE-2's
103-vs-102, SIDE-3's 104-vs-103 with the 181→190 suite growth), each straddle predicted in the
ledger and resolved green at its commit, post-commit runs on record.

## How to re-instantiate

1. Cascade the doc figures to their POST-commit values before the STOP.
2. Run the suites; capture the reds; verify each red names the cascade and nothing else.
3. State the straddle in the STOP report as a table. After the token's commit, run everything
   again and record the green — the prediction and its resolution are both evidence.
