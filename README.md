# psychic-repurpose

The blueprint gallery — **10 blueprints**, each a pattern that ran as enforced law somewhere in
the psychic-crew program before it was allowed to become advice here. Every blueprint answers
five questions: What is it, Why does it exist (the defect class it kills), When to reach for it,
where it is Proven, and How to re-instantiate it step by step.

**PUBLIC** since an out-of-band flip after creation (flip date unrecorded — gh pushedAt matches
the birth commit; ratified 2026-08-31, see the VIS-RECONCILE ledger row). Private at creation.

| Blueprint | Kills |
|---|---|
| `gate-machine` | approval inferred from sentiment |
| `count-binding` | documented figures drifting from live totals |
| `negative-control` | checkers never seen failing (and controls that pass vacuously) |
| `commit-straddle` | the green-early-or-stale-forever dilemma at gated commits |
| `pair-edit-delta-zero` | two documents describing one structure, diverging |
| `witness-manifest` | untracked working-state drift between commits |
| `vendored-vocabulary` | cross-repo coupling that is either brittle or silent |
| `unknown-fields` | complete-looking artifacts hiding guessed-in requirements |
| `observer-fence` | measurement that mutates the state it measures |
| `assembled-needles` | scanners containing their own prey; docs that trip deny rules |

## Use

Read the blueprint, then re-instantiate in the target repo following its How section. Blueprints
cite their proving grounds; when a step and its proving ground disagree, the proving ground wins
and this gallery gets a correction under its own gate.

## Verification

`./scripts/validate-repurpose.sh` — five sections per blueprint, provenance resolving to real
program repos (both directions: every blueprint proven somewhere, every program repo cited
somewhere), README count binding, hygiene, and negative controls proven to fire.
