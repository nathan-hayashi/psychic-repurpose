#!/usr/bin/env bash
# validate-repurpose.sh — the RPG assertion layer, born WITH the scaffold. A gallery of blueprints
# about controls that ships without its own controls would be the joke that outlives the program;
# existence-first negative controls per the templates sibling's birth-day lesson.
set -uo pipefail
cd "$(dirname "$0")/.."
P=0; F=0
ok () { P=$((P+1)); printf '  [PASS] %s\n' "$1"; }
no () { F=$((F+1)); printf '  [FAIL] %s\n' "$1"; }

ABS=$(printf '/%s/' home)
CRED1="gh""p_"; CRED2="xox""b-"; CRED3="AKI""A"; CRED4="BEGIN ""PRIVATE KEY"
KNOWN="psychic-crew psychic-crew-lite psychic-templates psychic-sidekick psychic-plugins"

chk_sections () { # $1=file → 0 iff all five sections present
  local f="$1" h
  [ -f "$f" ] || return 1
  for h in '## What' '## Why' '## When' '## Proven in' '## How to re-instantiate'; do
    grep -qF "$h" "$f" || return 1
  done
  return 0
}
chk_provenance () { # $1=file → 0 iff the Proven-in section names at least one program repo
  local f="$1" sec r
  [ -f "$f" ] || return 1
  sec=$(awk '/^## Proven in$/{f=1;next} f&&/^## /{exit} f' "$f")
  [ -n "$sec" ] || return 1
  for r in $KNOWN; do
    grep -qF "$r" <<<"$sec" && return 0
  done
  return 1
}

echo "== A. structure =="
for f in README.md CLAUDE.md GATES.md; do
  [ -f "$f" ] && ok "exists: $f" || no "missing: $f"
done
for s in scripts/*.sh; do bash -n "$s" 2>/dev/null || no "syntax error in $s"; done
ok "all shell files parse"
bcount=0
for f in blueprints/*.md; do
  bcount=$((bcount+1))
  chk_sections "$f" && ok "five sections: $f" || no "section missing in $f"
done

echo "== B. provenance, both directions =="
for f in blueprints/*.md; do
  chk_provenance "$f" && ok "proven somewhere real: $f" || no "no program repo in Proven-in: $f"
done
for r in $KNOWN; do
  hits=$(grep -lF "$r" blueprints/*.md 2>/dev/null | grep -c .)
  [[ "$hits" =~ ^[0-9]+$ ]] || hits=0
  [ "$hits" -ge 1 ] && ok "cited by $hits blueprint(s): $r" || no "no blueprint cites $r"
done

echo "== C. README count binding =="
rn=$(grep -oE '\*\*[0-9]+ blueprints\*\*' README.md | head -1 | grep -oE '[0-9]+')
[[ "$rn" =~ ^[0-9]+$ ]] || rn=-1
[ "$rn" -eq "$bcount" ] && ok "README blueprint count ($rn) matches the tree ($bcount)" \
  || no "README says $rn blueprints, tree has $bcount"

echo "== D. hygiene =="
abshits=$(git ls-files -z | xargs -0 grep -lF -- "$ABS" 2>/dev/null)
[ -z "$abshits" ] && ok "no absolute machine paths in tracked files" || no "absolute path in: $(tr '\n' ' ' <<<"$abshits")"
credhits=""
for ndl in "$CRED1" "$CRED2" "$CRED3" "$CRED4"; do
  h=$(git ls-files -z | xargs -0 grep -lF -- "$ndl" 2>/dev/null)
  [ -n "$h" ] && credhits="$credhits $h"
done
[ -z "$credhits" ] && ok "no credential-shaped strings in tracked files" || no "credential shape in:$credhits"

echo "== E. negative controls (existence first, then fire) =="
for fx in tests/fixtures/bad-no-why.md tests/fixtures/bad-provenance.md; do
  [ -f "$fx" ] && ok "fixture exists: $fx" || no "fixture MISSING (controls would be vacuous): $fx"
done
chk_sections tests/fixtures/bad-no-why.md \
  && no "control DID NOT fire: missing section accepted" || ok "control fires: missing section caught"
chk_provenance tests/fixtures/bad-provenance.md \
  && no "control DID NOT fire: phantom proving ground accepted" || ok "control fires: phantom provenance caught"
chk_sections tests/fixtures/does-not-exist.md \
  && no "control DID NOT fire: phantom file passed" || ok "control fires: phantom path refused"
chk_provenance tests/fixtures/bad-no-why.md \
  && ok "isolation: fixture 1 fails ONLY structure" || no "fixture 1 leaks into provenance"
chk_sections tests/fixtures/bad-provenance.md \
  && ok "isolation: fixture 2 fails ONLY provenance" || no "fixture 2 leaks into structure"


# S0-RECONCILE — the explainer-epoch discipline, ported from the parent with ONE DECLARED
# VARIANCE: an empty post-epoch set is PASS-with-reason here (this repo gates rarely, so the
# epoch row is often the last row); the parent's stricter FAIL stands over there. Grandfathered
# rows (enumerated in INDEX.md) are events recorded without tokens and owe no explainer.
exepoch=$(grep -m1 '^EXPLAINER-EPOCH: ' docs/explainers/INDEX.md 2>/dev/null | awk '{print $2}')
exgf=$(grep -m1 '^EXPLAINER-GRANDFATHERED: ' docs/explainers/INDEX.md 2>/dev/null | sed 's/^EXPLAINER-GRANDFATHERED: //')
if [ -z "${exepoch:-}" ]; then
  no "explainer epoch line missing from docs/explainers/INDEX.md"
else
  exrows=$(awk -F'|' -v ep="$exepoch" '/^\| [A-Za-z]/ { g=$2; gsub(/^ +| +$/,"",g); if (found && g!="Gate") print g; if (g==ep) found=1 }' GATES.md)
  exmiss=""
  for g in $exrows; do
    case " ${exgf:-} " in *" $g "*) continue ;; esac
    [ -f "docs/explainers/$g.md" ] || exmiss="$exmiss [$g]"
  done
  if [ -z "$exrows" ]; then
    ok "explainer epoch: post-epoch set empty (epoch is the last row) — PASS with stated reason (declared variance)"
  elif [ -z "$exmiss" ]; then
    ok "every post-epoch gate has its plain-language explainer"
  else
    no "explainer(s) MISSING for post-epoch gate(s):$exmiss"
  fi
  exfx=$(mktemp); cat GATES.md > "$exfx"
  printf '| PROBE-X9 |  | p | p | awaiting probe |\n' >> "$exfx"
  exrows2=$(awk -F'|' -v ep="$exepoch" '/^\| [A-Za-z]/ { g=$2; gsub(/^ +| +$/,"",g); if (found && g!="Gate") print g; if (g==ep) found=1 }' "$exfx")
  case "$exrows2" in
    *"PROBE-X9"*) ok "explainer fire-probe: a planted post-epoch gate row is seen by the extractor" ;;
    *) no "explainer fire-probe FAILED — a planted row went unseen; the binding is void" ;;
  esac
  rm -f "$exfx"
fi

echo "== validate-repurpose: $P PASS / $F FAIL =="
[ "$F" -eq 0 ]
