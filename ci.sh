#!/usr/bin/env bash
# The single acceptance entry point. One roster, three lanes.
#
#   ./ci.sh --fast    seconds — what to run while working
#   ./ci.sh --unit    minutes — before pushing
#   ./ci.sh           everything
#
# Exit codes are the contract, and the third is the one people get wrong:
#   0 = judged, passed   1 = judged, failed   2 = COULD NOT JUDGE
# Exit 2 is never a pass. A check that returns 0 when it could not run
# manufactures a green that somebody will trust.
#
# Silent on success. Output on every green run trains everyone to skim, and
# then the one run that printed something goes unread.
set -uo pipefail

# Nothing below can judge a repository nobody has described yet. START-HERE.md
# is the checklist that ends with deleting START-HERE.md, so its presence is
# exactly the statement "the harness is not filled in". Exit 2 -- COULD NOT
# JUDGE -- rather than 1: this is not a repository that failed its checks, it
# is a repository the checks cannot see yet. And because 2 is never a pass,
# nothing ships on it either.
if [ -e START-HERE.md ]; then
  echo "== the harness is not filled in yet: START-HERE.md is still here."
  echo "   Work through it. Deleting it is the last item, and this script"
  echo "   starts judging for real the moment it is gone."
  exit 2
fi

LANE="${1:-full}"
FAILED=0
UNJUDGED=0

run() {  # run <lane-floor> <name> <command...>
  local floor="$1" name="$2"; shift 2
  case "$LANE:$floor" in
    --fast:unit|--fast:full|--unit:full) return 0 ;;
  esac
  local out rc
  out="$("$@" 2>&1)"; rc=$?
  case $rc in
    0) ;;
    2) echo "== $name: COULD NOT JUDGE"; echo "$out"; UNJUDGED=1 ;;
    *) echo "== $name: FAILED"; echo "$out"; FAILED=1 ;;
  esac
}

# --- fast: seconds -----------------------------------------------------------
run fast "guards can still turn red" python3 scripts/guards/selftest.py
run fast "gates can still turn red"  python3 scripts/gates/selftest.py
run fast "hooks reach the model"     python3 scripts/context/selftest.py
run fast "hook commands resolve anywhere" python3 scripts/gates/check_hook_paths.py
run fast "always-on context budget"  python3 scripts/gates/check_context_budget.py
run fast "templates filled in"       python3 scripts/gates/check_templates_filled.py
run fast "docs routing table"        python3 scripts/gates/check_docs_index.py
run fast "docs top level"            python3 scripts/gates/check_docs_layout.py
run fast "no file too long to read"  python3 scripts/gates/check_file_size.py
run fast "documented commands run"   python3 scripts/gates/check_docs_runnable.py
run fast "public face"               python3 scripts/gates/check_community_health.py
run fast "nobody's home directory"   python3 scripts/gates/check_no_machine_paths.py

# Uncomment if this repository is itself a Claude Code plugin. It checks the
# manifest, the component layout, and that no skill tells an agent to guess a
# path instead of using ${CLAUDE_PLUGIN_ROOT}. Left off by default because it
# exits 2 -- COULD NOT JUDGE -- without a .claude-plugin/, and an unjudgeable
# check wired in unconditionally makes every run of this script exit 2.
# run fast "plugin surface"          python3 scripts/gates/check_plugin_structure.py

# --- unit: minutes -----------------------------------------------------------
run unit "layering"                  python3 scripts/gates/check_layering.py
# run unit "tests"                   <your test command>

# --- full --------------------------------------------------------------------
# run full "integration"             <your integration command>

if [ "$UNJUDGED" = 1 ]; then exit 2; fi
exit "$FAILED"
