#!/usr/bin/env bash
set -u
set -o pipefail

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
ROOT=$(realpath -m -- "${1:-$PROJECT_ROOT/.release/AnniversaryRaidTools}")
UI_ROOT=$(realpath -m -- "${2:-$(dirname "$ROOT")/AnniversaryRaidTools_UI}")
MAX_BYTES=$((11 * 1024 * 1024))
failures=0

fail() {
  failures=$((failures + 1))
  printf 'FAIL  %s\n' "$*" >&2
}

pass() {
  printf 'PASS  %s\n' "$*"
}

if [[ ! -d $ROOT || ! -d $UI_ROOT ]]; then
  printf 'FAIL  release addon roots do not exist: %s / %s\n' "$ROOT" "$UI_ROOT" >&2
  exit 1
fi

if [[ ! -f $ROOT/AnniversaryRaidTools.toc || ! -f $UI_ROOT/AnniversaryRaidTools_UI.toc ]]; then
  fail "release must contain core and load-on-demand UI manifests"
fi
if ! tr -d '\r' < "$UI_ROOT/AnniversaryRaidTools_UI.toc" | grep -q '^## LoadOnDemand: 1$'; then
  fail "UI release manifest is not load-on-demand"
fi
if [[ -e $ROOT/.github || -e $UI_ROOT/.github ]]; then fail "forbidden release path: .github"; fi
while IFS= read -r path; do
  if [[ -e $ROOT/$path || -e $UI_ROOT/$path ]]; then fail "forbidden release path: $path"; fi
done < <(sed -n '/^ignore:/,/^[^ ]/ s/^  - //p' "$PROJECT_ROOT/pkgmeta.yaml")

for path in \
  Raids/TBC/Generated/GruulsLairWorldPositions.lua \
  Raids/TBC/Generated/MagtheridonsLairWorldPositions.lua \
  Raids/TBC/Generated/SerpentshrineCavernWorldPositions.lua \
  Raids/TBC/Generated/TheEyeWorldPositions.lua
do
  if [[ ! -f $ROOT/$path ]]; then fail "required runtime positioning data missing: $path"; fi
done

while IFS= read -r -d '' file; do
  relative=${file#"$ROOT/"}
  case $relative in
    Raids/TBC/Generated/GruulsLairWorldPositions.lua|\
    Raids/TBC/Generated/MagtheridonsLairWorldPositions.lua|\
    Raids/TBC/Generated/SerpentshrineCavernWorldPositions.lua|\
    Raids/TBC/Generated/TheEyeWorldPositions.lua) ;;
    *) fail "unexpected raw positioning data: $relative" ;;
  esac
done < <(find "$ROOT" -type f -name '*WorldPositions.lua' -print0)

check_target() {
  local source=$1 reference=$2 target
  reference=${reference//\\//}
  target=$(realpath -m -- "$(dirname "$source")/$reference")
  if [[ $target != "$ROOT"/* && $target != "$UI_ROOT"/* ]]; then
    fail "load entry escapes release addons: $source -> $reference"
  elif [[ ! -f $target ]]; then
    fail "missing load entry: $source -> $reference"
  fi
}

while IFS= read -r -d '' toc; do
  while IFS= read -r line; do
    line=${line%$'\r'}
    line=${line%"${line##*[![:space:]]}"}
    [[ -z $line || $line == \#* ]] && continue
    check_target "$toc" "$line"
  done < "$toc"
done < <(find "$ROOT" "$UI_ROOT" -maxdepth 1 -type f -name '*.toc' -print0)

while IFS= read -r -d '' xml; do
  while IFS= read -r tag; do
    reference=$(sed -E "s/.*file=['\"]([^'\"]+)['\"].*/\1/" <<< "$tag")
    [[ -z $reference || $reference == "$tag" ]] && continue
    check_target "$xml" "$reference"
  done < <(grep -oE "<(Script|Include)[^>]*file=['\"][^'\"]+['\"][^>]*/?>" "$xml" 2>/dev/null || true)
done < <(find "$ROOT" "$UI_ROOT" -type f -name '*.xml' -print0)

size=$(du -sb -- "$ROOT" "$UI_ROOT" | awk '{ total += $1 } END { print total }')
if (( size > MAX_BYTES )); then
  fail "release tree is $size bytes; limit is $MAX_BYTES bytes"
else
  pass "release tree size: $size bytes (limit $MAX_BYTES)"
fi

if (( failures > 0 )); then
  printf '\nRelease audit: %d failure(s)\n' "$failures" >&2
  exit 1
fi

pass "release contains only loadable runtime files"
