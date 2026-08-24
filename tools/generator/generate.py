#!/usr/bin/env python3
"""Generate generator-owned Lua raid data from an AC candidate snapshot."""

from __future__ import annotations

import argparse
import math
import os
import sys
from pathlib import Path
from typing import Any

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402


GENERATOR_VERSION = "art-030-generator-v2"
ROOT = Path(__file__).resolve().parents[2]
DEFAULT_SOURCE = ROOT / "tools" / "ac" / "fixtures" / "gruuls-lair.json"
DEFAULT_OUTPUT = ROOT / "Raids" / "TBC" / "Generated" / "GruulsLair.lua"


def render_lua(raid: dict[str, Any]) -> str:
    """Render a raid table with stable field ordering and numeric formatting."""

    errors = validate_raid(raid)
    if errors:
        raise ValueError("cannot render invalid raid: " + "; ".join(errors))
    source = _first_provenance(raid)
    metadata = (
        "-- GENERATED FILE. Do not edit; rerun tools/generator/generate.py.\n"
        f"-- Generator: {GENERATOR_VERSION}\n"
        "-- Source: TBC candidate snapshot; not Anniversary-verified.\n"
        f"-- SourceRef: {source.get('sourceRef') or 'nil'}\n"
        f"-- ObservedAt: {source.get('observedAt') or 'nil'}\n"
        "-- Nnoggie's Mythic Dungeon Tools attribution and GPL-2.0 terms remain in the repository.\n"
    )
    return (
        metadata
        + "local raid = "
        + _lua_value(raid, 0)
        + "\n"
        + "local ART = rawget(_G, \"ART\")\n"
        + "if type(ART) ~= \"table\" then\n"
        + "  error(\"AnniversaryRaidTools static data requires Core/Bootstrap.lua to initialize ART\", 2)\n"
        + "end\n"
        + "if type(ART.StaticData) ~= \"table\" then\n"
        + "  error(\"AnniversaryRaidTools static data requires ART.StaticData bootstrap\", 2)\n"
        + "end\n"
        + "if type(ART.StaticData.raids) ~= \"table\" then\n"
        + "  error(\"AnniversaryRaidTools static data requires ART.StaticData.raids bootstrap\", 2)\n"
        + "end\n"
        + "ART.StaticData.raids[raid.key] = raid\n"
        + "return raid\n"
    )


def render_world_positions(snapshot: dict[str, Any], raid: dict[str, Any]) -> str:
    """Render integration-private world coordinates without extending raid schema v1."""

    bounds = snapshot.get("metadata", {}).get("worldBounds")
    positions: dict[str, Any] = {}
    for spawn in snapshot.get("spawns", []):
        position = _world_position(spawn, bounds)
        if position is None:
            continue
        key = f"{raid['key']}:spawn:{spawn['npcId']}:{spawn['id']}"
        if "worldZ" in spawn:
            position["z"] = spawn["worldZ"]
        patrol = spawn.get("patrol")
        world_patrol = [_world_position(point, bounds) for point in patrol or []]
        if world_patrol and all(point is not None for point in world_patrol):
            position["patrol"] = world_patrol
        positions[key] = position
    if not positions:
        return ""
    return (
        "-- GENERATED FILE. Do not edit; rerun tools/generator/generate.py.\n"
        f"-- Generator: {GENERATOR_VERSION}\n"
        "-- Integration-private C_Map projection inputs; raid schema v1 is unchanged.\n"
        "local ART = assert(rawget(_G, \"ART\"), \"AnniversaryRaidTools requires Core/Bootstrap.lua\")\n"
        "ART.MapWorldPositions = ART.MapWorldPositions or {}\n"
        f"ART.MapWorldPositions[{_lua_string(raid['key'])}] = {_lua_value(positions, 1)}\n"
        f"return ART.MapWorldPositions[{_lua_string(raid['key'])}]\n"
    )


def _world_position(point: dict[str, Any], bounds: Any) -> dict[str, Any] | None:
    if "worldX" in point and "worldY" in point:
        return {"x": point["worldX"], "y": point["worldY"]}
    if not isinstance(bounds, dict) or "x" not in point or "y" not in point:
        return None
    left_y, right_y = bounds["leftY"], bounds["rightY"]
    margin = bounds.get("eastMarginYards", 0)
    right_y += margin if right_y >= left_y else -margin
    return {
        "x": bounds["topX"] + point["y"] * (bounds["bottomX"] - bounds["topX"]),
        "y": left_y + point["x"] * (right_y - left_y),
    }


def generate(source_path: str | Path = DEFAULT_SOURCE, output_path: str | Path = DEFAULT_OUTPUT) -> str:
    """Generate output atomically and return the exact bytes written as text."""

    raid = build_raid(load_snapshot(source_path))
    rendered = render_lua(raid)
    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = output.with_name(output.name + ".tmp")
    temporary.write_text(rendered, encoding="utf-8", newline="\n")
    os.replace(temporary, output)
    return rendered


def _first_provenance(raid: dict[str, Any]) -> dict[str, Any]:
    enemies = raid.get("enemies", {})
    if enemies:
        return next(iter(enemies.values())).get("source", {})
    return {}


def _lua_value(value: Any, level: int) -> str:
    if value is None:
        return "nil"
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, str):
        return _lua_string(value)
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        if isinstance(value, float):
            if not math.isfinite(value):
                raise ValueError("non-finite number cannot be rendered")
            return format(value, ".15g")
        return str(value)
    if isinstance(value, list):
        if not value:
            return "{}"
        indent = "  " * (level + 1)
        close_indent = "  " * level
        lines = ["{"]
        lines.extend(f"{indent}{_lua_value(item, level + 1)}," for item in value)
        lines.append(f"{close_indent}}}")
        return "\n".join(lines)
    if isinstance(value, dict):
        if not value:
            return "{}"
        indent = "  " * (level + 1)
        close_indent = "  " * level
        lines = ["{"]
        for key in _ordered_keys(value, level):
            lua_key = _lua_key(key)
            lines.append(f"{indent}{lua_key} = {_lua_value(value[key], level + 1)},")
        lines.append(f"{close_indent}}}")
        return "\n".join(lines)
    raise TypeError(f"unsupported value for Lua: {type(value).__name__}")


def _ordered_keys(value: dict[Any, Any], level: int) -> list[Any]:
    if level == 0:
        preferred = [
            "schemaVersion",
            "key",
            "name",
            "expansion",
            "instanceId",
            "mapId",
            "mode",
            "enemyMetadataSource",
            "sublevels",
            "enemies",
            "packs",
            "pois",
            "waves",
        ]
        return [key for key in preferred if key in value]
    if all(isinstance(key, str) for key in value):
        return sorted(value)
    return sorted(value, key=lambda key: (type(key).__name__, str(key)))


def _lua_key(key: Any) -> str:
    if isinstance(key, int):
        return f"[{key}]"
    if isinstance(key, str) and key.isidentifier():
        return key
    return f"[{_lua_string(str(key))}]"


def _lua_string(value: str) -> str:
    replacements = {"\\": "\\\\", '"': '\\"', "\n": "\\n", "\r": "\\r", "\t": "\\t"}
    return '"' + "".join(replacements.get(char, char) for char in value) + '"'


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Generate deterministic ART raid Lua data")
    parser.add_argument("--input", type=Path, default=DEFAULT_SOURCE, help="AC snapshot JSON")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT, help="generated Lua path")
    parser.add_argument("--world-output", type=Path, help="optional generated C_Map world-position path")
    parser.add_argument(
        "--check",
        action="store_true",
        help="verify the existing output is exactly what generation would produce",
    )
    args = parser.parse_args(argv)
    snapshot = load_snapshot(args.input)
    raid = build_raid(snapshot)
    rendered = render_lua(raid)
    world_rendered = render_world_positions(snapshot, raid)
    world_output = args.world_output or (
        args.output.with_name(args.output.stem + "WorldPositions.lua") if world_rendered else None
    )
    if args.check:
        try:
            current = args.output.read_text(encoding="utf-8")
        except OSError as exc:
            print(f"not deterministic: cannot read {args.output}: {exc}", file=sys.stderr)
            return 1
        if current != rendered:
            print(f"not deterministic: {args.output} differs from generator output", file=sys.stderr)
            return 1
        if world_output:
            try:
                current_world = world_output.read_text(encoding="utf-8")
            except OSError as exc:
                print(f"not deterministic: cannot read {world_output}: {exc}", file=sys.stderr)
                return 1
            if current_world != world_rendered:
                print(f"not deterministic: {world_output} differs from generator output", file=sys.stderr)
                return 1
        print(f"deterministic: {args.output}")
        return 0
    args.output.parent.mkdir(parents=True, exist_ok=True)
    temporary = args.output.with_name(args.output.name + ".tmp")
    temporary.write_text(rendered, encoding="utf-8", newline="\n")
    os.replace(temporary, args.output)
    if world_output:
        world_output.parent.mkdir(parents=True, exist_ok=True)
        temporary_world = world_output.with_name(world_output.name + ".tmp")
        temporary_world.write_text(world_rendered, encoding="utf-8", newline="\n")
        os.replace(temporary_world, world_output)
    print(f"generated: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
