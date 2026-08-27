# witness-manifest — tracked files carry a stamped inventory that goes STALE on edit

## What

A manifest listing every tracked file with a content witness (count, hash, or both), plus a
checker with three verdicts: green (manifest matches tree), STALE with exit 2 (a tracked file
changed after the stamp), and a `--refresh` mode that re-stamps deliberately. Editing without
re-stamping is loud; re-stamping is a recorded act.

## Why

"What changed since the last known-good state?" needs an answer that survives sessions and
compactions. Git answers for commits; the witness answers for the WORKING state — it catches
the edit nobody remembers making, and its exit-2 lane distinguishes "drifted" from "broken."

## When

Repos where multiple sessions or agents edit between commits, or where a human wants one command
that says "nothing moved since I last blessed this."

## Proven in

psychic-crew-lite (WITNESS-MANIFEST at 48 entries, re-stamped through every gate; the
edit→STALE→refresh ritual exercised at each close and its discipline documented in the sync
correlation ledger).

## How to re-instantiate

1. Generate the manifest from `git ls-files` with a per-file witness; commit it.
2. Checker: recompute, diff, exit 0/2 with the drifted paths named; `--refresh` rewrites and
   prints what changed.
3. Law: every gate close re-stamps; a STALE at session start is a finding, never noise.
