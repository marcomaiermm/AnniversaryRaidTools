"""Turn a bounded AzerothCore export into the frozen raid v1 shape.

The checked-in fixture is deliberately small.  It is a candidate source, not
an Anniversary-verified map dump; the pipeline keeps that provenance on every
derived record instead of upgrading it during generation.
"""

from __future__ import annotations

import copy
import json
import math
import re
from pathlib import Path
from typing import Any


SOURCE_VALUES = {"azerothcore", "live-observed", "manual", "client-data", "derived"}
CONFIDENCE_VALUES = {"verified", "high", "candidate", "review-required"}
STABLE_ID = re.compile(r"^[a-z0-9][a-z0-9_-]*$")


class SnapshotError(ValueError):
    """Raised when an AC snapshot cannot be normalized safely."""


def load_snapshot(path: str | Path) -> dict[str, Any]:
    """Load and normalize a JSON AzerothCore snapshot."""

    source_path = Path(path)
    try:
        payload = json.loads(source_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise SnapshotError(f"cannot read snapshot {source_path}: {exc}") from exc
    if not isinstance(payload, dict):
        raise SnapshotError("snapshot root must be an object")
    return _normalize_snapshot(payload)


def build_raid(snapshot: dict[str, Any]) -> dict[str, Any]:
    """Build a deterministic ART raid definition from a normalized snapshot."""

    source = _provenance(snapshot.get("source"), "snapshot source")
    raid_input = _object(snapshot.get("raid"), "raid")
    raid_key = _stable_id(raid_input.get("key"), "raid.key")

    sublevels = _sublevels(snapshot.get("sublevels"), raid_input.get("mapId"))
    spawns = snapshot["spawns"]
    packs_input = snapshot["packs"]

    spawn_records: dict[str, dict[str, Any]] = {}
    enemies: dict[str, dict[str, Any]] = {}
    for raw in spawns:
        npc_id = _integer(raw.get("npcId"), "spawn.npcId", minimum=1)
        stable_id = _stable_id(raw.get("id"), "spawn.id")
        spawn_key = f"{raid_key}:spawn:{npc_id}:{stable_id}"
        if spawn_key in spawn_records:
            raise SnapshotError(f"duplicate spawn key: {spawn_key}")
        sublevel = _integer(raw.get("sublevel", 1), "spawn.sublevel", minimum=1)
        if sublevel > len(sublevels):
            raise SnapshotError(f"spawn {spawn_key} references unknown sublevel {sublevel}")
        spawn_source = _provenance(raw.get("source", source), f"spawn {spawn_key} source")
        spawn: dict[str, Any] = {
            "key": spawn_key,
            "npcId": npc_id,
            "x": _coordinate(raw.get("x"), f"spawn {spawn_key}.x"),
            "y": _coordinate(raw.get("y"), f"spawn {spawn_key}.y"),
            "sublevel": sublevel,
            "packKey": None,
            "source": spawn_source,
        }
        patrol = raw.get("patrol")
        if patrol is not None:
            spawn["patrol"] = _patrol(patrol, f"spawn {spawn_key}.patrol")
        if raw.get("hidden") is not None:
            if not isinstance(raw["hidden"], bool):
                raise SnapshotError(f"spawn {spawn_key}.hidden must be a boolean")
            spawn["hidden"] = raw["hidden"]
        spawn_records[spawn_key] = spawn

        enemy_key = str(npc_id)
        enemy_name = _string(raw.get("name"), f"spawn {spawn_key}.name")
        enemy = enemies.setdefault(
            enemy_key,
            {"npcId": npc_id, "name": enemy_name, "spawns": [], "source": spawn_source},
        )
        if enemy["name"] != enemy_name:
            raise SnapshotError(f"conflicting names for NPC {npc_id}")
        enemy["spawns"].append(spawn)

    packs: dict[str, dict[str, Any]] = {}
    for raw in packs_input:
        stable_id = _stable_id(raw.get("id"), "pack.id")
        pack_key = f"{raid_key}:pack:{stable_id}"
        if pack_key in packs:
            raise SnapshotError(f"duplicate pack key: {pack_key}")
        member_ids = raw.get("spawnIds")
        if not isinstance(member_ids, list) or not member_ids:
            raise SnapshotError(f"pack {pack_key} must have a non-empty spawnIds list")
        spawn_keys: list[str] = []
        for member_id in member_ids:
            member_stable_id = _stable_id(member_id, f"pack {pack_key}.spawnIds")
            matching = [
                key
                for key, spawn in spawn_records.items()
                if key.rsplit(":", 1)[-1] == member_stable_id
            ]
            if len(matching) != 1:
                raise SnapshotError(
                    f"pack {pack_key} spawn id {member_stable_id!r} does not identify one spawn"
                )
            spawn_key = matching[0]
            if spawn_key in spawn_keys:
                raise SnapshotError(f"duplicate member {spawn_key} in {pack_key}")
            spawn_keys.append(spawn_key)
        pack_source = _provenance(raw.get("source", source), f"pack {pack_key} source")
        pack: dict[str, Any] = {"key": pack_key, "spawnKeys": spawn_keys, "source": pack_source}
        if raw.get("label") is not None:
            pack["label"] = _string(raw["label"], f"pack {pack_key}.label")
        packs[pack_key] = pack
        for spawn_key in spawn_keys:
            spawn_records[spawn_key]["packKey"] = pack_key

    pois = _pois(snapshot.get("pois", []), source, len(sublevels))
    raid: dict[str, Any] = {
        "schemaVersion": 1,
        "key": raid_key,
        "name": _string(raid_input.get("name"), "raid.name"),
        "expansion": "TBC",
        "instanceId": _integer(raid_input.get("instanceId"), "raid.instanceId", minimum=1),
        "mapId": _integer(raid_input.get("mapId"), "raid.mapId", minimum=1),
        "mode": raid_input.get("mode", "route"),
        "sublevels": sublevels,
        "enemies": enemies,
        "packs": packs,
        "pois": pois,
    }
    if raid["mode"] == "waves":
        raid["waves"] = _waves(snapshot.get("waves"), source, packs, raid_key)
    elif raid["mode"] != "route":
        raise SnapshotError("raid.mode must be route or waves")

    # Keep normalization and validation in one place so the generator cannot
    # emit a partial raid when a source reference is malformed.
    from tools.validators.raid import validate_raid

    errors = validate_raid(raid)
    if errors:
        raise SnapshotError("invalid normalized raid: " + "; ".join(errors))
    return raid


def _normalize_snapshot(payload: dict[str, Any]) -> dict[str, Any]:
    source = _provenance(payload.get("source"), "snapshot source")
    _object(payload.get("metadata"), "metadata")
    raid = _object(payload.get("raid"), "raid")
    _stable_id(raid.get("key"), "raid.key")
    spawns = payload.get("spawns")
    packs = payload.get("packs")
    if not isinstance(spawns, list) or not spawns:
        raise SnapshotError("snapshot spawns must be a non-empty list")
    if not isinstance(packs, list) or not packs:
        raise SnapshotError("snapshot packs must be a non-empty list")
    # Detect duplicate source records before any dictionary conversion hides it.
    seen_spawn_ids: set[str] = set()
    for raw in spawns:
        raw = _object(raw, "spawn")
        stable_id = _stable_id(raw.get("id"), "spawn.id")
        if stable_id in seen_spawn_ids:
            raise SnapshotError(f"duplicate source spawn id: {stable_id}")
        seen_spawn_ids.add(stable_id)
    seen_pack_ids: set[str] = set()
    for raw in packs:
        raw = _object(raw, "pack")
        stable_id = _stable_id(raw.get("id"), "pack.id")
        if stable_id in seen_pack_ids:
            raise SnapshotError(f"duplicate source pack id: {stable_id}")
        seen_pack_ids.add(stable_id)
    return copy.deepcopy(payload)


def _provenance(value: Any, label: str) -> dict[str, Any]:
    value = _object(value, label)
    source = value.get("source")
    confidence = value.get("confidence")
    if source not in SOURCE_VALUES:
        raise SnapshotError(f"{label}.source must be one of {sorted(SOURCE_VALUES)}")
    if confidence not in CONFIDENCE_VALUES:
        raise SnapshotError(f"{label}.confidence must be one of {sorted(CONFIDENCE_VALUES)}")
    source_ref = value.get("sourceRef")
    observed_at = value.get("observedAt")
    if source_ref is not None and not isinstance(source_ref, str):
        raise SnapshotError(f"{label}.sourceRef must be a string or null")
    if observed_at is not None and not isinstance(observed_at, str):
        raise SnapshotError(f"{label}.observedAt must be a string or null")
    return {
        "source": source,
        "confidence": confidence,
        "sourceRef": source_ref,
        "observedAt": observed_at,
    }


def _sublevels(value: Any, default_map_id: Any) -> list[dict[str, Any]]:
    if not isinstance(value, list) or not value:
        raise SnapshotError("sublevels must be a non-empty list")
    result = []
    for expected, raw in enumerate(value, 1):
        raw = _object(raw, f"sublevels[{expected}]")
        index = _integer(raw.get("index", expected), "sublevel.index", minimum=1)
        if index != expected:
            raise SnapshotError("sublevel indexes must be contiguous and one-based")
        result.append(
            {
                "index": index,
                "name": _string(raw.get("name"), "sublevel.name"),
                "mapId": _integer(raw.get("mapId", default_map_id), "sublevel.mapId", minimum=1),
            }
        )
    return result


def _pois(value: Any, source: dict[str, Any], sublevel_count: int) -> dict[int, list[dict[str, Any]]]:
    if not isinstance(value, list):
        raise SnapshotError("pois must be a list")
    result: dict[int, list[dict[str, Any]]] = {index: [] for index in range(1, sublevel_count + 1)}
    for index, raw in enumerate(value, 1):
        raw = _object(raw, f"poi[{index}]")
        sublevel = _integer(raw.get("sublevel", 1), "poi.sublevel", minimum=1)
        if sublevel > sublevel_count:
            raise SnapshotError(f"poi[{index}] references unknown sublevel {sublevel}")
        poi: dict[str, Any] = {
            "x": _coordinate(raw.get("x"), f"poi[{index}].x"),
            "y": _coordinate(raw.get("y"), f"poi[{index}].y"),
            "sublevel": sublevel,
            "source": _provenance(raw.get("source", source), f"poi[{index}] source"),
        }
        if raw.get("label") is not None:
            poi["label"] = _string(raw["label"], f"poi[{index}].label")
        result[sublevel].append(poi)
    return result


def _waves(
    value: Any, source: dict[str, Any], packs: dict[str, Any], raid_key: str
) -> list[dict[str, Any]]:
    if not isinstance(value, list) or not value:
        raise SnapshotError("waves mode requires a non-empty waves list")
    result = []
    for index, raw in enumerate(value, 1):
        raw = _object(raw, f"wave[{index}]")
        wave_id = _stable_id(raw.get("id"), f"wave[{index}].id")
        pack_keys = []
        for pack_id in raw.get("packIds", []):
            pack_key = next((key for key in packs if key.rsplit(":", 1)[-1] == pack_id), None)
            if pack_key is None:
                raise SnapshotError(f"wave {wave_id} references unknown pack {pack_id}")
            pack_keys.append(pack_key)
        wave = {"waveKey": f"{raid_key}:wave:{wave_id}", "packKeys": pack_keys, "source": source}
        if raw.get("camp") is not None:
            wave["camp"] = _string(raw["camp"], f"wave {wave_id}.camp")
        result.append(wave)
    return result


def _patrol(value: Any, label: str) -> list[dict[str, float]]:
    if not isinstance(value, list):
        raise SnapshotError(f"{label} must be a list")
    result = []
    for index, raw in enumerate(value, 1):
        raw = _object(raw, f"{label}[{index}]")
        result.append(
            {
                "x": _coordinate(raw.get("x"), f"{label}[{index}].x"),
                "y": _coordinate(raw.get("y"), f"{label}[{index}].y"),
            }
        )
    return result


def _object(value: Any, label: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        raise SnapshotError(f"{label} must be an object")
    return value


def _string(value: Any, label: str) -> str:
    if not isinstance(value, str) or not value:
        raise SnapshotError(f"{label} must be a non-empty string")
    return value


def _stable_id(value: Any, label: str) -> str:
    value = _string(value, label)
    if not STABLE_ID.fullmatch(value):
        raise SnapshotError(f"{label} must match {STABLE_ID.pattern}")
    return value


def _integer(value: Any, label: str, minimum: int | None = None) -> int:
    if isinstance(value, bool) or not isinstance(value, int):
        raise SnapshotError(f"{label} must be an integer")
    if minimum is not None and value < minimum:
        raise SnapshotError(f"{label} must be >= {minimum}")
    return value


def _coordinate(value: Any, label: str) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise SnapshotError(f"{label} must be a number")
    value = float(value)
    if not math.isfinite(value) or not 0 <= value <= 1:
        raise SnapshotError(f"{label} must be finite and within 0..1")
    return value
