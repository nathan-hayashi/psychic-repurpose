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
chk_frontmatter () { # $1=file $2=expected-stem → 0 iff frontmatter sound; reasons on stdout
  local f="$1" stem="$2" fm fid fcl ftr frq fpv sec bad="" t r
  fm=$(awk '/^---$/{c++;next} c==1{print} c>=2{exit}' "$f")
  [ -n "$fm" ] || { echo " no-frontmatter"; return 1; }
  fid=$(sed -n 's/^id: //p' <<<"$fm")
  [ "$fid" = "$stem" ] || bad="$bad id!=stem"
  fcl=$(sed -n 's/^defect_class: //p' <<<"$fm")
  [ -n "$fcl" ] || bad="$bad no-defect-class"
  ftr=$(sed -n 's/^triggers: //p' <<<"$fm")
  t=$(awk -F';' '{print NF}' <<<"$ftr"); [[ "$t" =~ ^[0-9]+$ ]] || t=0
  [ "$t" -ge 3 ] || bad="$bad triggers<3"
  frq=$(sed -n 's/^requires: //p' <<<"$fm")
  [ -n "$frq" ] || bad="$bad no-requires-line"
  if [ -n "$frq" ] && [ "$frq" != "none" ]; then
    for r in $(tr ',' ' ' <<<"$frq"); do
      [ -f "blueprints/$r.md" ] || bad="$bad requires-missing:$r"
    done
  fi
  fpv=$(sed -n 's/^proven_in: //p' <<<"$fm")
  [ -n "$fpv" ] || bad="$bad no-proven-in"
  sec=$(awk '/^## Proven in$/{f=1;next} f&&/^## /{exit} f' "$f")
  for r in $(tr ',' ' ' <<<"$fpv"); do
    case " $KNOWN " in *" $r "*) : ;; *) bad="$bad unknown-repo:$r" ;; esac
    grep -qF "$r" <<<"$sec" || bad="$bad fm-repo-not-in-prose:$r"
  done
  [ -z "$bad" ] && return 0
  echo "$bad"; return 1
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

echo "== C. README count bindings (every-occurrence — the head-1 form retired at RPG-1) =="
rvals=$(grep -oE '\*\*[0-9]+ blueprints\*\*' README.md | grep -oE '[0-9]+' | sort -u)
rvn=$(grep -c . <<<"$rvals"); [[ "$rvn" =~ ^[0-9]+$ ]] || rvn=0
{ [ "$rvn" -eq 1 ] && [ "$rvals" = "$bcount" ]; } \
  && ok "README blueprint count bound every-occurrence ($rvals == tree $bcount)" \
  || no "README blueprint binding broken: distinct values [$(tr '\n' ' ' <<<"$rvals")] vs tree $bcount"
rcp=$(mktemp); cat README.md > "$rcp"; printf '\n**99 blueprints**\n' >> "$rcp"
rv2=$(grep -oE '\*\*[0-9]+ blueprints\*\*' "$rcp" | grep -oE '[0-9]+' | sort -u | grep -c .)
[[ "$rv2" =~ ^[0-9]+$ ]] || rv2=0
[ "$rv2" -ge 2 ] && ok "control fires: a planted conflicting count reaches the every-occurrence extractor" \
  || no "every-occurrence control DID NOT fire"
rm -f "$rcp"


echo "== C2. the graph source: frontmatter integrity (RPG-1) =="
fmpairs=$(mktemp); fmadj=$(mktemp)
for f in blueprints/*.md; do
  stem=$(basename "$f" .md)
  if msg=$(chk_frontmatter "$f" "$stem"); then
    ok "frontmatter sound: $stem"
  else
    no "frontmatter broken in $stem:$msg"
  fi
  fm=$(awk '/^---$/{c++;next} c==1{print} c>=2{exit}' "$f")
  printf '%s\t%s\n' "$stem" "$(sed -n 's/^defect_class: //p' <<<"$fm")" >> "$fmpairs"
  printf '%s\t%s\n' "$stem" "$(sed -n 's/^requires: //p' <<<"$fm")" >> "$fmadj"
done
ncls=$(cut -f2 "$fmpairs" | sort -u | grep -c .)
[[ "$ncls" =~ ^[0-9]+$ ]] || ncls=0
[ "$ncls" -eq "$bcount" ] && ok "slug bijection: $ncls distinct defect classes for $bcount blueprints" \
  || no "slug bijection broken: $ncls distinct classes vs $bcount blueprints"
rkills=$(grep -E '^\| `[a-z-]+` \| `[a-z-]+` — ' README.md | awk -F'`' '{print $2 "\t" $4}' | sort)
nrk=$(grep -c . <<<"$rkills"); [[ "$nrk" =~ ^[0-9]+$ ]] || nrk=0
[ "$nrk" -eq "$bcount" ] && ok "README Kills table carries $nrk slug rows" \
  || no "README Kills slug rows: $nrk (want $bcount)"
fmsorted=$(sort "$fmpairs")
if [ "$rkills" = "$fmsorted" ]; then
  ok "Kills table == frontmatter (id,slug) pairs, literal both ways"
else
  no "Kills/frontmatter divergence: $(comm -3 <(printf '%s\n' "$rkills") <(printf '%s\n' "$fmsorted") | head -2 | tr '\n' ' ')"
fi
acy=$(awk -F'\t' '
  { id[$1]=1; req[$1]=$2; n++ }
  END {
    peeled=0; progressed=1
    while (progressed) {
      progressed=0
      for (x in id) {
        if (done[x]) continue
        okp=1
        if (req[x] != "none" && req[x] != "") {
          m=split(req[x], a, ","); for (i=1;i<=m;i++) { if (!done[a[i]]) okp=0 }
        }
        if (okp) { done[x]=1; peeled++; progressed=1 }
      }
    }
    if (peeled==n) print "ACYCLIC"; else print "CYCLE"
  }' "$fmadj")
[ "$acy" = "ACYCLIC" ] && ok "requires graph is acyclic (Kahn peel over frontmatter)" \
  || no "requires graph has a CYCLE"

echo "== C3. the index: a faithful projection (RPG-1) =="
IDX=docs/PULL-INDEX.md
[ -f "$IDX" ] && ok "exists: $IDX" || no "missing: $IDX"
caps=$(awk '/^# PULL-INDEX v1$/{f=1;next} f&&/^```/{exit} f&&NF' "$IDX")
edges=$(awk '/^# PULL-EDGES v1$/{f=1;next} f&&/^```/{exit} f&&NF' "$IDX")
ncap=$(grep -c . <<<"$caps"); [[ "$ncap" =~ ^[0-9]+$ ]] || ncap=0
nedg=$(grep -c . <<<"$edges"); [[ "$nedg" =~ ^[0-9]+$ ]] || nedg=0
[ "$ncap" -ge "$bcount" ] && ok "capability block non-vacuous ($ncap rows >= $bcount)" \
  || no "capability block vacuous: $ncap rows (want >= $bcount)"
[ "$nedg" -ge "$bcount" ] && ok "edges block non-vacuous ($nedg rows >= $bcount)" \
  || no "edges block vacuous: $nedg rows (want >= $bcount)"
icap=$(printf '%s\n' "$caps" | awk -F'\t' '{print $1 "\t" $2}' | sort)
[ "$icap" = "$fmsorted" ] && ok "index (id,class) == frontmatter, set-equal both ways" \
  || no "index (id,class) diverges from frontmatter"
iadj=$(printf '%s\n' "$edges" | sort); fadj=$(sort "$fmadj")
[ "$iadj" = "$fadj" ] && ok "index adjacency == frontmatter requires, set-equal both ways" \
  || no "index adjacency diverges from frontmatter requires"
cloerr=$(printf '%s\n' "$caps" | awk -F'\t' '
  FNR==NR { req[$1]=$2; next }
  {
    x=$1; want=$5; out=""; frontier=req[x]; expc=""
    if (frontier=="none" || frontier=="") { expc="none" }
    else {
      changed=1
      while (changed) {
        changed=0; m=split(frontier, a, ",")
        for (i=1;i<=m;i++) {
          it=a[i]; if (it=="" || it=="none") continue
          if (index("," out ",", "," it ",")==0) {
            out=(out=="" ? it : out "," it)
            if (req[it]!="none" && req[it]!="") { frontier=frontier "," req[it]; changed=1 }
          }
        }
      }
      expc=out
    }
    if (index("," expc ",", "," x ",")>0) { print "BAD-SELF:" x; next }
    if (expc=="none" && want=="none") { print "OKROW " x; next }
    m1=split(expc, e1, ","); m2=split(want, e2, ",")
    if (m1!=m2) { print "BAD-LEN:" x; next }
    for (i=1;i<=m1;i++) if (index("," want ",", "," e1[i] ",")==0) { print "BAD-MISS:" x; next }
    print "OKROW " x
  }' "$fmadj" - 2>&1)
nokr=$(grep -c '^OKROW ' <<<"$cloerr"); [[ "$nokr" =~ ^[0-9]+$ ]] || nokr=0
nbad=$(grep -cv '^OKROW ' <<<"$cloerr"); [[ "$nbad" =~ ^[0-9]+$ ]] || nbad=0
{ [ "$nokr" -eq "$ncap" ] && [ "$nbad" -eq 0 ]; } \
  && ok "closure column is the fixed point of frontmatter requires ($nokr rows witnessed, irreflexive)" \
  || no "closure check broken or wrong: witnessed=$nokr/$ncap other-lines=$nbad $(grep -v '^OKROW ' <<<"$cloerr" | head -2 | tr '\n' ' ')"
if scripts/build-index.sh --check >/dev/null 2>&1; then
  ok "generated index is current (build-index --check clean)"
else
  no "index DRIFTED from frontmatter (build-index --check)"
fi
cvals=$(grep -oE '\*\*[0-9]+ capabilities\*\*' README.md | grep -oE '[0-9]+' | sort -u)
cvn=$(grep -c . <<<"$cvals"); [[ "$cvn" =~ ^[0-9]+$ ]] || cvn=0
{ [ "$cvn" -eq 1 ] && [ "$cvals" = "$ncap" ]; } \
  && ok "README capabilities bound every-occurrence ($cvals == index $ncap)" \
  || no "README capabilities binding broken: [$(tr '\n' ' ' <<<"$cvals")] vs index $ncap"
pb=$(mktemp)
awk 'BEGIN{skip=0} /^# PULL-INDEX v1$/{print; skip=1; next} skip&&/^```/{skip=0} skip{next} {print}' "$IDX" > "$pb"
pcap=$(awk '/^# PULL-INDEX v1$/{f=1;next} f&&/^```/{exit} f&&NF' "$pb")
pn=$(grep -c . <<<"$pcap"); [[ "$pn" =~ ^[0-9]+$ ]] || pn=0
[ "$pn" -lt "$bcount" ] && ok "control fires: an emptied capability block reads as vacuous ($pn rows)" \
  || no "emptied-block control DID NOT fire ($pn rows)"
pe=$(mktemp)
awk -F'\t' 'BEGIN{OFS="\t"; inb=0; donep=0} /^# PULL-EDGES v1$/{print; inb=1; next} inb&&/^```/{inb=0} inb&&!donep&&NF==2&&$2!="none"{$2="none"; donep=1} {print}' "$IDX" > "$pe"
pedge=$(awk '/^# PULL-EDGES v1$/{f=1;next} f&&/^```/{exit} f&&NF' "$pe" | sort)
[ "$pedge" != "$fadj" ] && ok "control fires: a dropped edge breaks adjacency set-equality" \
  || no "dropped-edge control DID NOT fire"
rm -f "$pb" "$pe" "$fmpairs" "$fmadj"

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
[ -f tests/fixtures/bad-frontmatter.md ] && ok "fixture exists: tests/fixtures/bad-frontmatter.md" \
  || no "fixture MISSING (controls would be vacuous): tests/fixtures/bad-frontmatter.md"
if fmmsg=$(chk_frontmatter tests/fixtures/bad-frontmatter.md bad-frontmatter); then
  no "control DID NOT fire: broken frontmatter accepted"
else
  case "$fmmsg" in *no-defect-class*) ok "control fires: missing defect_class caught" ;; \
    *) no "frontmatter control missed the absent class:$fmmsg" ;; esac
  case "$fmmsg" in *"triggers<3"*) ok "control fires: thin trigger list caught" ;; \
    *) no "frontmatter control missed thin triggers:$fmmsg" ;; esac
  case "$fmmsg" in *requires-missing:ghost-blueprint*) ok "control fires: phantom requires caught" ;; \
    *) no "frontmatter control missed the phantom edge:$fmmsg" ;; esac
fi
chk_sections tests/fixtures/bad-frontmatter.md \
  && ok "isolation: frontmatter fixture passes structure" || no "frontmatter fixture leaks into structure"
chk_provenance tests/fixtures/bad-frontmatter.md \
  && ok "isolation: frontmatter fixture passes provenance" || no "frontmatter fixture leaks into provenance"


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
