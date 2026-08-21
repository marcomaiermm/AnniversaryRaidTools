#!/usr/bin/env python3
"""Validate an AC snapshot after normalizing it through the ART pipeline."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Validate an ART AzerothCore raid snapshot")
    parser.add_argument("input", type=Path, help="AzerothCore snapshot JSON")
    args = parser.parse_args(argv)
    try:
        raid = build_raid(load_snapshot(args.input))
    except (OSError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    errors = validate_raid(raid)
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print(f"valid: {args.input} -> {raid['key']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
