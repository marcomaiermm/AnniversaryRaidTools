#!/usr/bin/env bash
# ART-060: dependency-free validation matrix for the addon and its pure tests.
set -u
set -o pipefail

ROOT=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
ALLOW_MISSING=${ART_ALLOW_MISSING:-0}
if [[ ${1:-} == "--allow-missing" ]]; then ALLOW_MISSING=1; fi

failures=0
missing=0
passes=0
skips=0
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/art-validate.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT

pass() { passes=$((passes + 1)); printf 'PASS  %s\n' "$*"; }
skip() { skips=$((skips + 1)); printf 'SKIP  %s\n' "$*"; }
fail() { failures=$((failures + 1)); printf 'FAIL  %s\n' "$*" >&2; }
missing_gate() {
  missing=$((missing + 1))
  if [[ $ALLOW_MISSING == 1 ]]; then
    skip "$* (ART_ALLOW_MISSING=1)"
  else
    fail "$* (use ART_ALLOW_MISSING=1 only for an incomplete work wave)"
  fi
}

printf 'ART-060 validation matrix\n'
printf 'root: %s\n' "$ROOT"
if head=$(git -C "$ROOT" rev-parse HEAD 2>/dev/null); then
  printf 'head: %s\n' "$head"
else
  fail "cannot determine git HEAD"
fi
if status=$(git -C "$ROOT" status --short 2>/dev/null); then
  if [[ -n $status ]]; then
    printf 'status: dirty (shared work may be in progress)\n'
  else
    printf 'status: clean\n'
  fi
else
  fail "cannot determine git status"
fi

for command_name in luac5.1 luajit python3 realpath; do
  if command -v "$command_name" >/dev/null 2>&1; then
    pass "tool available: $command_name"
  else
    fail "required tool missing: $command_name"
  fi
done

normalize() {
  # realpath -m is coreutils, not a project dependency, and does not touch files.
  realpath -m -- "$1"
}

check_toc_metadata() {
  local toc interfaces
  while IFS= read -r -d '' toc; do
    interfaces=$(sed -n 's/^## Interface:[[:space:]]*//p' "$toc" | tr -d '[:space:]')
    if [[ ",$interfaces," == *,20505,* && ",$interfaces," == *,20506,* ]]; then
      pass "${toc#"$ROOT/"}: declares Interface 20505 and 20506"
    else
      fail "${toc#"$ROOT/"}: must declare both Interface 20505 and 20506 (got '$interfaces')"
    fi
  done < <(find "$ROOT" -type f -name '*.toc' -not -path '*/.git/*' -print0 | sort -z)
}

check_toc_files() {
  local toc line ref target ok
  while IFS= read -r -d '' toc; do
    ok=1
    while IFS= read -r line; do
      [[ -z $line || $line == \#* ]] && continue
      ref=${line//\\//}
      target=$(normalize "$(dirname "$toc")/$ref")
      # The UI addon is nested in this checkout but packaged as a sibling
      # addon, so its ..\AnniversaryRaidTools paths resolve to repository root.
      if [[ $ref == ../AnniversaryRaidTools/* ]]; then
        target=$(normalize "$ROOT/${ref#../AnniversaryRaidTools/}")
      fi
      if [[ ! -f $target ]]; then
        fail "${toc#"$ROOT/"}: missing load entry '$line'"
        ok=0
      fi
    done < <(sed -E '/^##/d; /^#/d; s/[[:space:]]+$//' "$toc")
    [[ $ok == 1 ]] && pass "${toc#"$ROOT/"}: all load entries exist"
  done < <(find "$ROOT" -type f -name '*.toc' -not -path '*/.git/*' -print0 | sort -z)
}

check_xml_files() {
  local xml tag ref target ok
  while IFS= read -r -d '' xml; do
    ok=1
    while IFS= read -r tag; do
      ref=$(printf '%s\n' "$tag" | sed -E "s/.*file=['\"]([^'\"]+)['\"].*/\1/")
      [[ $ref == "$tag" || -z $ref ]] && continue
      ref=${ref//\\//}
      target=$(normalize "$(dirname "$xml")/$ref")
      if [[ ! -f $target ]]; then
        # Third-party libraries are installed by scripts/install_addon_libs.py
        # in a packaged checkout; they are not required for pure validation.
        case $ref in
          LibStub/*|CallbackHandler-1.0/*|AceComm-3.0/*|AceDB-3.0/*|AceGUI-3.0/*|AceSerializer-3.0/*|LibCompress/*|LibDataBroker-1.1/*|LibDBIcon-1.0/*|LibDeflate/*|LibAsync/*)
            skip "${xml#"$ROOT/"}: external dependency not installed: $ref" ;;
          *)
            fail "${xml#"$ROOT/"}: missing XML load entry '$ref'"
            ok=0
            ;;
        esac
      fi
    done < <(grep -oE "<(Script|Include)[^>]*file=['\"][^'\"]+['\"][^>]*/?>" "$xml" 2>/dev/null || true)
    [[ $ok == 1 ]] && pass "${xml#"$ROOT/"}: all XML load entries exist"
  done < <(find "$ROOT" -type f -name '*.xml' -not -path '*/.git/*' -not -path '*/.codegraph/*' -print0 | sort -z)
}

toc_index() {
  local toc=$1 needle=$2
  awk -v needle="$needle" '
    $0 !~ /^#/ { line=$0; gsub(/\\/, "/", line); if (line == needle) { print NR; exit } }
  ' "$toc"
}

check_order() {
  local toc=$1 before=$2 after=$3 left right
  left=$(toc_index "$toc" "$before")
  right=$(toc_index "$toc" "$after")
  if [[ -n $left && -n $right && $left -lt $right ]]; then
    pass "${toc#"$ROOT/"}: $before before $after"
  else
    fail "${toc#"$ROOT/"}: expected $before before $after (got $left/$right)"
  fi
}

check_load_order() {
  local root_toc="$ROOT/AnniversaryRaidTools.toc"
  local ui_toc="$ROOT/MythicDungeonTools_UI/MythicDungeonTools_UI.toc"
  check_order "$root_toc" "libs/load_core_libs.xml" "BuildCheck.lua"
  check_order "$root_toc" "BuildCheck.lua" "Core/Compat.lua"
  check_order "$root_toc" "Core/Compat.lua" "Core/Bootstrap.lua"
  check_order "$ui_toc" "../AnniversaryRaidTools/Core/SavedVariables.lua" "../AnniversaryRaidTools/MythicDungeonTools.lua"
  check_order "$ui_toc" "../AnniversaryRaidTools/MythicDungeonTools.lua" "../AnniversaryRaidTools/Core/Lifecycle.lua"
  check_order "$ui_toc" "../AnniversaryRaidTools/Core/Lifecycle.lua" "../AnniversaryRaidTools/Modules/load_modules.xml"
}

check_lua_syntax() {
  local file rel output
  while IFS= read -r -d '' file; do
    rel=${file#"$ROOT/"}
    output="$tmpdir/$(printf '%s' "$rel" | tr '/\\' '__').out"
    if luac5.1 -p "$file" >"$output" 2>&1; then
      if luajit -b "$file" "$tmpdir/bytecode" >>"$output" 2>&1; then
        pass "Lua 5.1/LuaJIT syntax: $rel"
      else
        fail "LuaJIT syntax: $rel ($(tr '\n' ' ' <"$output"))"
      fi
    else
      fail "Lua 5.1 syntax: $rel ($(tr '\n' ' ' <"$output"))"
    fi
  done < <(find "$ROOT" -type f -name '*.lua' -not -path '*/.git/*' -not -path '*/.codegraph/*' -not -path '*/__pycache__/*' -print0 | sort -z)
}

check_banned_domain_tokens() {
  # Legacy MDT UI retains old dungeon terminology; scan only the new raid-domain
  # boundary so the guard catches regressions without rewriting inherited UI.
  local file rel hits
  while IFS= read -r -d '' file; do
    rel=${file#"$ROOT/"}
    hits=$(grep -nE '(C_ChallengeMode|C_MythicPlus|C_WeeklyRewards|GetCurrentAffixes|GetOwnedKeystone|GetKeystoneLevel|keyLevel|key_level|enemyForces|enemy_forces|[Ff]ortified|[Tt]yrannical|[Aa]ffix)' "$file" 2>/dev/null || true)
    if [[ -n $hits ]]; then
      fail "banned Retail API/semantic token in $rel: $(printf '%s' "$hits" | tr '\n' ' ')"
    else
      pass "Retail API/semantic guard: $rel"
    fi
  done < <(
    find "$ROOT/Core" -maxdepth 1 -type f \( -name 'RaidRegistry.lua' -o -name 'RoutePreset.lua' -o -name 'MarkResolver.lua' -o -name 'EnemyInfoRepository.lua' \) -print0
    find "$ROOT/Modules" -maxdepth 1 -type f \( -name 'Raid*.lua' -o -name 'LiveSession.lua' -o -name 'EnemyForces.lua' -o -name 'API.lua' \) -print0
    find "$ROOT/Developer" -maxdepth 1 -type f -name 'RaidRecorder.lua' -print0
    find "$ROOT/Raids/TBC" -type f -name '*.lua' -print0
  )
}

run_lua_test() {
  local file=$1 runtime=$2 rel
  rel=${file#"$ROOT/"}
  if "$runtime" "$file" "$ROOT"; then
    pass "$runtime: $rel"
  else
    fail "$runtime: $rel"
  fi
}

run_python_test() {
  local file=$1 rel=${file#"$ROOT/"}
  if python3 "$file"; then
    pass "python3: $rel"
  else
    fail "python3: $rel"
  fi
}

run_discovered_tests() {
  local category dir found file
  declare -A category_found=()
  for category in data maps marking enemy-info route; do category_found[$category]=0; done

  while IFS= read -r -d '' file; do
    case $file in
      */tests/data/*.py) category=data; run_python_test "$file" ;;
      */tests/data/*.lua) category=data; run_lua_test "$file" lua5.1; run_lua_test "$file" luajit ;;
      */tests/maps/*.lua) category=maps; run_lua_test "$file" lua5.1; run_lua_test "$file" luajit ;;
      */tests/marking/*.lua) category=marking; run_lua_test "$file" lua5.1; run_lua_test "$file" luajit ;;
      */tests/enemy-info/*.lua|*/tests/enemy_info/*.lua) category=enemy-info; run_lua_test "$file" lua5.1; run_lua_test "$file" luajit ;;
      */tests/route/*.lua|*/tests/preset/*.lua|*/tests/planner/*.lua) category=route; run_lua_test "$file" lua5.1; run_lua_test "$file" luajit ;;
      *) continue ;;
    esac
    category_found[$category]=1
  done < <(find "$ROOT/tests" -type f \( -name '*.lua' -o -name '*.py' \) -not -path '*/__pycache__/*' -print0 2>/dev/null | sort -z)

  # The compatibility mock is an existing load-on-demand/startup gate, not a
  # feature test directory, so keep it in the matrix explicitly.
  if [[ -f "$ROOT/scripts/test_plugin_compat.lua" ]]; then
    run_lua_test "$ROOT/scripts/test_plugin_compat.lua" lua5.1
    run_lua_test "$ROOT/scripts/test_plugin_compat.lua" luajit
  else
    fail "missing startup compatibility test: scripts/test_plugin_compat.lua"
  fi

  for category in data maps marking enemy-info route; do
    if [[ ${category_found[$category]} == 1 ]]; then
      pass "test category discovered: $category"
    else
      missing_gate "test category not discovered: $category"
    fi
  done
}

check_toc_metadata
check_toc_files
check_xml_files
check_load_order
check_lua_syntax
check_banned_domain_tokens
run_discovered_tests

printf '\nSummary: %d passed, %d skipped, %d failed\n' "$passes" "$skips" "$failures"
if [[ $failures -ne 0 ]]; then exit 1; fi
exit 0
