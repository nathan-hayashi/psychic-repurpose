---
id: gate-machine
defect_class: sentiment-approval
triggers: phase advancement exists; approval is currently inferred from chat sentiment; multiple sessions or writers share one ledger
requires: none
proven_in: psychic-crew, psychic-crew-lite, psychic-templates, psychic-sidekick, psychic-plugins
---

# gate-machine — exact-token approval gates

## What

A GATES.md ledger where every phase closes only on the operator's literal token, a stamp ritual
(`awaiting `APPROVE X`` → `**APPROVED** `APPROVE X` @ ISO`), and a guard script that reads the
ledger and refuses any gated commit until the stamped row exists.

## Why

Approval inferred from sentiment is the root defect this kills: enthusiasm, paraphrase, and
"looks good" all read as consent to a system that wants to proceed. Making approval a recorded
byte string turns a social ambiguity into a mechanical check, and the guard's refusal branch
makes the absence of approval loud instead of silent.

## When

Any work where a human must own the go/no-go: phase closes, releases, permission changes,
anything irreversible. Overkill for solo scratch work; mandatory the moment a second party's
authority is in the loop.

## Proven in

psychic-crew (32+ gates, two demonstrated wrong-token refusals), psychic-crew-lite,
psychic-templates, psychic-sidekick, psychic-plugins — the guard ported unchanged to all four
siblings, and the portable rendition ships as the gate-machine skill in psychic-plugins.

## How to re-instantiate

1. Seed GATES.md with the four-column table (Gate / Scope / Evidence / Status).
2. Port `scripts/gate-guard.sh` (grep -cF the APPROVED line; numeric-validate; refuse with the
   row-exists-vs-no-row distinction).
3. Law: exact case-sensitive token, stamp-then-guard-then-commit, demonstrate the refusal BEFORE
   requesting the token, STOP on a dirty tree until it arrives.
