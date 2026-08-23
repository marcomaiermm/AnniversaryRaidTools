#!/usr/bin/env python3
"""Small stdlib-only checks for the ART-030 data boundary."""

from __future__ import annotations

import copy
import hashlib
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.generator.generate import render_lua  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402


SOURCE = ROOT / "tools" / "ac" / "fixtures" / "gruuls-lair.json"
OUTPUT = ROOT / "Raids" / "TBC" / "Generated" / "GruulsLair.lua"


def main() -> None:
    raid = build_raid(load_snapshot(SOURCE))
    assert validate_raid(raid) == []
    assert sum(len(enemy["spawns"]) for enemy in raid["enemies"].values()) == 18
    assert len(raid["packs"]) == 6
    spawns = {spawn["key"]: spawn for enemy in raid["enemies"].values() for spawn in enemy["spawns"]}
    gruul_hall = raid["packs"]["gruuls-lair:pack:trash-gruul-hall"]["spawnKeys"]
    assert len(gruul_hall) == 3 and {spawns[key]["npcId"] for key in gruul_hall} == {19389}
    patrols = [spawn["patrol"] for spawn in spawns.values() if "patrol" in spawn]
    assert sorted(map(len, patrols)) == [5, 6, 13]
    first = render_lua(raid)
    second = render_lua(build_raid(load_snapshot(SOURCE)))
    assert first == second, "repeated generation must be byte-identical"
    assert OUTPUT.read_text(encoding="utf-8") == first
    assert "local raid = {" in first
    assert "ART.StaticData.raids[raid.key] = raid" in first
    assert first.rstrip().endswith("return raid")

    broken = copy.deepcopy(raid)
    pack = next(iter(broken["packs"].values()))
    pack["spawnKeys"].append(pack["spawnKeys"][0])
    assert any("duplicate" in error for error in validate_raid(broken))

    broken = copy.deepcopy(raid)
    spawn = next(iter(next(iter(broken["enemies"].values()))["spawns"]))
    spawn["x"] = 2
    assert any("within 0..1" in error for error in validate_raid(broken))

    broken = copy.deepcopy(raid)
    spawn = next(iter(next(iter(broken["enemies"].values()))["spawns"]))
    spawn["key"] = "gruuls-lair:spawn:18831:unstable key"
    assert any("stable spawn key" in error for error in validate_raid(broken))

    digest = hashlib.sha256(first.encode("utf-8")).hexdigest()
    print(f"ART-030 checks passed: {digest}")


if __name__ == "__main__":
    main()
