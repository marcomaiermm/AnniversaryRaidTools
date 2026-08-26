#!/usr/bin/env bash
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
SOURCE="$PROJECT_ROOT/AnniversaryRaidTools_UI"
TARGET="$(dirname "$PROJECT_ROOT")/AnniversaryRaidTools_UI"

if [[ -L $TARGET && $(realpath -- "$TARGET") == "$SOURCE" ]]; then
  printf 'UI development link already exists: %s\n' "$TARGET"
  exit 0
fi
if [[ -e $TARGET || -L $TARGET ]]; then
  printf 'Refusing to replace existing path: %s\n' "$TARGET" >&2
  exit 1
fi

ln -s "$SOURCE" "$TARGET"
printf 'Linked %s -> %s\n' "$TARGET" "$SOURCE"
