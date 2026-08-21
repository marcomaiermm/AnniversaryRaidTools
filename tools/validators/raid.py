"""Validation for ART Raid Definition Contract v1."""

from __future__ import annotations

import argparse
import json
import math
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import Any


PROVENANCE_SOURCES = {"azerothcore", "live-observed", "manual", "client-data", "derived"}
PROVENANCE_CONFIDENCE = {"verified", "high", "candidate", "review-required"}
RAID_KEY = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
STABLE_ID = r"[a-z0-9][a-z0-9_-]*"


def validate_raid(raid: Any) -> list[str]:
    """Return all validation failures; an empty list means valid v1 data."""

    errors: list[str] = []
    if not isinstance(raid, dict):
        return ["raid must be an object"]
    if raid.get("schemaVersion") != 1:
        errors.append("schemaVersion must be exactly 1")
    key = raid.get("key")
    if not isinstance(key, str) or not RAID_KEY.fullmatch(key):
        errors.append("key must be a lowercase ASCII slug")
        key = "<invalid>"
    for field in ("name", "expansion", "mode"):
        if not isinstance(raid.get(field), str) or not raid[field]:
            errors.append(f"{field} must be a non-empty string")
    if raid.get("expansion") != "TBC":
        errors.append("expansion must be TBC")
    if raid.get("mode") not in {"route", "waves"}:
        errors.append("mode must be route or waves")
    for field in ("instanceId", "mapId"):
        if not _positive_int(raid.get(field)):
            errors.append(f"{field} must be a positive integer")

    sublevels = raid.get("sublevels")
    sublevel_ids: set[int] = set()
    if not isinstance(sublevels, list) or not sublevels:
        errors.append("sublevels must be a non-empty list")
        sublevels = []
    for expected, sublevel in enumerate(sublevels, 1):
        if not isinstance(sublevel, dict):
            errors.append(f"sublevels[{expected}] must be an object")
            continue
        index = sublevel.get("index")
        if isinstance(index, int) and not isinstance(index, bool):
            sublevel_ids.add(index)
        if index != expected:
            errors.append("sublevel indexes must be contiguous and one-based")
        if not isinstance(sublevel.get("name"), str) or not sublevel["name"]:
            errors.append(f"sublevels[{expected}].name must be a non-empty string")
        if not _positive_int(sublevel.get("mapId")):
            errors.append(f"sublevels[{expected}].mapId must be a positive integer")

    enemies = raid.get("enemies")
    if not isinstance(enemies, dict):
        errors.append("enemies must be an object")
        enemies = {}
    packs = raid.get("packs")
    if not isinstance(packs, dict):
        errors.append("packs must be an object")
        packs = {}

    spawn_by_key: dict[str, dict[str, Any]] = {}
    for enemy_key, enemy in enemies.items():
        if not isinstance(enemy_key, str) or not enemy_key.isdecimal():
            errors.append(f"enemy key {enemy_key!r} must be a decimal NPC ID")
        if not isinstance(enemy, dict):
            errors.append(f"enemy {enemy_key!r} must be an object")
            continue
        npc_id = enemy.get("npcId")
        if not _positive_int(npc_id):
            errors.append(f"enemy {enemy_key!r}.npcId must be a positive integer")
        elif str(npc_id) != enemy_key:
            errors.append(f"enemy key {enemy_key!r} disagrees with npcId {npc_id}")
        if not isinstance(enemy.get("name"), str) or not enemy["name"]:
            errors.append(f"enemy {enemy_key!r}.name must be a non-empty string")
        _check_provenance(enemy.get("source"), f"enemy {enemy_key!r}.source", errors)
        spawns = enemy.get("spawns")
        if not isinstance(spawns, list) or not spawns:
            errors.append(f"enemy {enemy_key!r}.spawns must be a non-empty list")
            continue
        for spawn_index, spawn in enumerate(spawns, 1):
            path = f"enemy {enemy_key!r}.spawns[{spawn_index}]"
            if not isinstance(spawn, dict):
                errors.append(f"{path} must be an object")
                continue
            spawn_key = spawn.get("key")
            if not isinstance(spawn_key, str):
                errors.append(f"{path}.key must be a string")
                continue
            if spawn_key in spawn_by_key:
                errors.append(f"duplicate spawn key {spawn_key}")
            spawn_by_key[spawn_key] = spawn
            expected_key = re.compile(
                rf"^{re.escape(key)}:spawn:{npc_id}:{STABLE_ID}$"
            ) if key != "<invalid>" else None
            if expected_key is not None and not expected_key.fullmatch(spawn_key):
                errors.append(f"{path}.key is not a stable spawn key for this NPC")
            if spawn.get("npcId") != npc_id:
                errors.append(f"{path}.npcId disagrees with containing enemy")
            _check_coordinates(spawn, path, errors)
            sublevel = spawn.get("sublevel")
            if sublevel not in sublevel_ids:
                errors.append(f"{path}.sublevel references an unknown sublevel")
            _check_provenance(spawn.get("source"), f"{path}.source", errors)
            patrol = spawn.get("patrol")
            if patrol is not None:
                _check_patrol(patrol, f"{path}.patrol", errors)

    pack_membership: dict[str, str] = {}
    for pack_key, pack in packs.items():
        path = f"pack {pack_key!r}"
        expected_key = (
            re.compile(rf"^{re.escape(key)}:pack:{STABLE_ID}$")
            if key != "<invalid>" and isinstance(pack_key, str)
            else None
        )
        if not isinstance(pack_key, str):
            errors.append(f"{path} key must be a string")
        elif expected_key is not None and not expected_key.fullmatch(pack_key):
            errors.append(f"{path} key is not a stable pack key for this raid")
        if not isinstance(pack, dict):
            errors.append(f"{path} must be an object")
            continue
        if pack.get("key") != pack_key:
            errors.append(f"{path}.key disagrees with table key")
        if pack.get("label") is not None and not isinstance(pack["label"], str):
            errors.append(f"{path}.label must be a string or nil")
        _check_provenance(pack.get("source"), f"{path}.source", errors)
        members = pack.get("spawnKeys")
        if not isinstance(members, list) or not members:
            errors.append(f"{path}.spawnKeys must be a non-empty list")
            continue
        local_members: set[str] = set()
        for member in members:
            if not isinstance(member, str):
                errors.append(f"{path}.spawnKeys contains a non-string key")
                continue
            if member in local_members:
                errors.append(f"{path}.spawnKeys contains duplicate {member}")
            local_members.add(member)
            if member not in spawn_by_key:
                errors.append(f"{path}.spawnKeys references missing spawn {member}")
            elif member in pack_membership:
                errors.append(
                    f"spawn {member} belongs to both {pack_membership[member]} and {pack_key}"
                )
            else:
                pack_membership[member] = pack_key

    for spawn_key, spawn in spawn_by_key.items():
        pack_key = spawn.get("packKey")
        if pack_key is None:
            continue
        if not isinstance(pack_key, str):
            errors.append(f"spawn {spawn_key} packKey must be a string or nil")
        elif pack_key not in packs:
            errors.append(f"spawn {spawn_key} references missing pack {pack_key}")
        elif not isinstance(packs[pack_key], dict):
            errors.append(f"spawn {spawn_key} references a malformed pack {pack_key}")
        elif spawn_key not in packs[pack_key].get("spawnKeys", []):
            errors.append(f"spawn {spawn_key} disagrees with membership in {pack_key}")

    pois = raid.get("pois")
    if not isinstance(pois, dict):
        errors.append("pois must be an object keyed by sublevel")
        pois = {}
    for raw_sublevel, values in pois.items():
        try:
            sublevel = int(raw_sublevel)
        except (TypeError, ValueError):
            errors.append(f"pois key {raw_sublevel!r} must be a sublevel integer")
            continue
        if sublevel not in sublevel_ids:
            errors.append(f"pois references unknown sublevel {sublevel}")
        if not isinstance(values, list):
            errors.append(f"pois[{raw_sublevel!r}] must be a list")
            continue
        for index, poi in enumerate(values, 1):
            path = f"pois[{raw_sublevel!r}][{index}]"
            if not isinstance(poi, dict):
                errors.append(f"{path} must be an object")
                continue
            _check_coordinates(poi, path, errors)
            if poi.get("sublevel") != sublevel:
                errors.append(f"{path}.sublevel disagrees with its bucket")
            _check_provenance(poi.get("source"), f"{path}.source", errors)

    waves = raid.get("waves")
    if raid.get("mode") == "waves":
        if not isinstance(waves, list) or not waves:
            errors.append("waves mode requires a non-empty waves list")
        else:
            wave_keys: set[str] = set()
            for index, wave in enumerate(waves, 1):
                path = f"waves[{index}]"
                if not isinstance(wave, dict):
                    errors.append(f"{path} must be an object")
                    continue
                wave_key = wave.get("waveKey")
                if not isinstance(wave_key, str) or wave_key in wave_keys:
                    errors.append(f"{path}.waveKey must be unique and stable")
                if isinstance(wave_key, str):
                    wave_keys.add(wave_key)
                _check_provenance(wave.get("source"), f"{path}.source", errors)
                if not isinstance(wave.get("packKeys"), list):
                    errors.append(f"{path}.packKeys must be a list")
                else:
                    for pack_key in wave["packKeys"]:
                        if not isinstance(pack_key, str) or pack_key not in packs:
                            errors.append(f"{path} references missing pack {pack_key}")
    elif waves is not None:
        errors.append("route mode must not declare waves")

    return errors


def _check_provenance(value: Any, path: str, errors: list[str]) -> None:
    if not isinstance(value, dict):
        errors.append(f"{path} must be an object")
        return
    source = value.get("source")
    confidence = value.get("confidence")
    if not isinstance(source, str) or source not in PROVENANCE_SOURCES:
        errors.append(f"{path}.source is not a v1 provenance value")
    if not isinstance(confidence, str) or confidence not in PROVENANCE_CONFIDENCE:
        errors.append(f"{path}.confidence is not a v1 provenance value")
    if source == "azerothcore" and confidence not in {
        "candidate",
        "review-required",
    }:
        errors.append(f"{path} AzerothCore facts cannot be verified by source alone")
    for field in ("sourceRef", "observedAt"):
        if value.get(field) is not None and not isinstance(value[field], str):
            errors.append(f"{path}.{field} must be a string or nil")
    observed_at = value.get("observedAt")
    if isinstance(observed_at, str):
        try:
            datetime.fromisoformat(observed_at.replace("Z", "+00:00"))
        except ValueError:
            errors.append(f"{path}.observedAt must be an ISO-8601 timestamp")


def _check_coordinates(value: dict[str, Any], path: str, errors: list[str]) -> None:
    for field in ("x", "y"):
        coordinate = value.get(field)
        if isinstance(coordinate, bool) or not isinstance(coordinate, (int, float)):
            errors.append(f"{path}.{field} must be numeric")
        elif not math.isfinite(coordinate) or not 0 <= coordinate <= 1:
            errors.append(f"{path}.{field} must be finite and within 0..1")


def _check_patrol(value: Any, path: str, errors: list[str]) -> None:
    if not isinstance(value, list):
        errors.append(f"{path} must be a list")
        return
    previous: tuple[float, float] | None = None
    for index, point in enumerate(value, 1):
        point_path = f"{path}[{index}]"
        if not isinstance(point, dict):
            errors.append(f"{point_path} must be an object")
            continue
        _check_coordinates(point, point_path, errors)
        if isinstance(point.get("x"), (int, float)) and isinstance(point.get("y"), (int, float)):
            current = (point["x"], point["y"])
            if previous == current:
                errors.append(f"{path} contains duplicate consecutive patrol points")
            previous = current


def _positive_int(value: Any) -> bool:
    return isinstance(value, int) and not isinstance(value, bool) and value > 0


def _load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Validate an ART raid JSON definition")
    parser.add_argument("input", type=Path, help="normalized raid JSON")
    args = parser.parse_args(argv)
    try:
        errors = validate_raid(_load_json(args.input))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"validator input error: {exc}", file=sys.stderr)
        return 2
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print(f"valid: {args.input}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
