# observer-fence — measurement that mutates state is budgeted or fenced, never ambient

## What

When a check or metric generator WRITES what it measures (a dispatch-cost ledger that grows on
every dispatch, a coverage row that flips a SKIP), the system treats measurement as a state
change: a hand-bound fence pins the expected figures, ordinary phases run with the mutating
observer OFF (zero-dispatch default), and the one phase allowed to run it hot budgets the whole
cascade inside its own gate.

## Why

The parent found that a single agent dispatch grew a tracked TSV, desynced a fence, flipped a
SKIP to live, and cascaded three bound counts — an observer effect that turns "just measuring"
into unreviewed state drift. Naming the cascade and gating it beats pretending measurement is
free.

## When

Any suite whose checks write tracked state; any metrics pipeline whose rows are themselves under
test; any counter that other assertions bind.

## Proven in

psychic-crew (CR-006 fence + C-25 SKIP + the H2a registered procedure; the zero-dispatch default
held through the entire HELIX research-and-build ladder, with STRESS-1 pre-registered as the one
phase that owns the cascade in-gate).

## How to re-instantiate

1. Inventory which checks WRITE. Each writer is either fenced (expected-state pinned by hand,
   resync gated) or off by default.
2. Make the default path zero-mutation and assert that it is.
3. Pre-register the hot phase: which figures move, which fences resync, which gate owns it.
