---
id: negative-control
defect_class: never-seen-failing
triggers: a checker has never been seen failing; a passing control could be passing vacuously; a guard needle set just changed
requires: none
proven_in: psychic-crew, psychic-crew-lite, psychic-templates, psychic-sidekick, psychic-plugins
---

# negative-control — checks proven to fire, with existence asserted first

## What

Every non-trivial checker ships planted-defect fixtures it must REJECT, run through the same
check functions as the real sweep — plus, learned the hard way: an assertion that each fixture
EXISTS before any expect-fail run, and isolation rows proving each fixture fails ONLY its
target check.

## Why

A checker never seen failing proves nothing — it may be matching nothing at all. And an
expect-fail control against a MISSING fixture passes vacuously: the templates sibling watched
exactly that on its birth day, caught only by an isolation row. Existence-first turns that
silent green into a named red forever.

## When

Every validator, linter rule, or scanner from the day it is born. Controls travel WITH the
scaffold — a control added later documents the defect it already missed.

## Proven in

psychic-crew (planted-token redaction proofs; phantom-drop controls in the matrix suite),
psychic-crew-lite (F2 dangling-ref control), psychic-templates (the vacuous-control lesson
itself, hardened same-gate), psychic-sidekick (vendor-drift fixture), psychic-plugins
(reserved-word and XML-description fixtures).

## How to re-instantiate

1. Write check logic as functions taking a file parameter — never inline the sweep.
2. Plant one fixture per defect class, each valid in every OTHER respect (isolation).
3. Control section order: fixture EXISTS → expect-fail fires → phantom path refused → isolation
   both ways. Any "control DID NOT fire" is a suite failure of the highest order.
