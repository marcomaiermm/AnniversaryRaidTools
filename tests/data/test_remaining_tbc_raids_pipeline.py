#!/usr/bin/env python3
"""Deterministic source checks for SSC, The Eye, and Sunwell."""
from pathlib import Path
import json
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.generator.generate import render_lua, render_world_positions  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402

RAIDS = {
    "serpentshrine-cavern": ("SerpentshrineCavern", 548, 194, 66, 68, 18, {21212, 21213, 21214, 21215, 21216, 21217}),
    "the-eye": ("TheEye", 550, 187, 14, 45, 16, {18805, 19514, 19516, 19622}),
    "sunwell-plateau": ("SunwellPlateau", 580, 203, 23, 28, 7, {24850, 24882, 24891, 24892, 25038, 25165, 25166, 25608, 25741}),
}

ALL_RAIDS = {
    "black-temple": "BlackTemple",
    "gruuls-lair": "GruulsLair",
    "hyjal": "Hyjal",
    "karazhan": "Karazhan",
    "magtheridons-lair": "MagtheridonsLair",
    "serpentshrine-cavern": "SerpentshrineCavern",
    "sunwell-plateau": "SunwellPlateau",
    "the-eye": "TheEye",
}

for key, (stem, map_id, count, patrols, linked_packs, pull_groups, bosses) in RAIDS.items():
    source = ROOT / "tools/ac/fixtures" / f"{key}.json"
    raw = json.loads(source.read_text())
    raid = build_raid(load_snapshot(source))
    assert raid["key"] == key and raid["mapId"] == map_id
    assert validate_raid(raid) == []
    spawns = [spawn for enemy in raid["enemies"].values() for spawn in enemy["spawns"]]
    assert len(spawns) == count and sum("patrol" in spawn for spawn in spawns) == patrols
    assert bosses <= {spawn["npcId"] for spawn in spawns}
    assert all("Spotlight" not in spawn["name"] for spawn in raw["spawns"])
    assert sum(len(pack["spawnKeys"]) for pack in raid["packs"].values()) == count
    groups = [pack["pullGroup"] for pack in raid["packs"].values() if pack.get("pullGroup")]
    assert len(groups) == linked_packs and len(set(groups)) == pull_groups
    generated = ROOT / "Raids/TBC/Generated" / f"{stem}.lua"
    world = ROOT / "Raids/TBC/Generated" / f"{stem}WorldPositions.lua"
    assert render_lua(raid) == generated.read_text()
    assert render_world_positions(raw, raid) == world.read_text()
    if key == "the-eye":
        assert raid["enemies"]["19514"]["health"] == 2800000
        assert raid["enemies"]["19516"]["health"] == 4552500
        assert raid["enemies"]["20052"]["spells"][37123]["description"] == (
            "Debuff: Physical damage every 2 sec for 8 sec."
        )
        assert not raid["enemies"]["20052"]["spells"][37123].get("interruptible")
        assert not raid["enemies"]["19514"]["spells"][34342].get("interruptible")

for key, stem in ALL_RAIDS.items():
    source = ROOT / "tools/ac/fixtures" / f"{key}.json"
    raw = json.loads(source.read_text())
    raid = build_raid(load_snapshot(source))
    world = ROOT / "Raids/TBC/Generated" / f"{stem}WorldPositions.lua"
    rendered = render_world_positions(raw, raid)
    assert rendered and rendered == world.read_text()
    assert all(f'{key}:spawn:{spawn["npcId"]}:{spawn["id"]}' in rendered for spawn in raw["spawns"])
    assert "coordinateKind = " in rendered and "_meta = " in rendered and "provenance = " in rendered
    if any("worldX" in spawn and "worldY" in spawn for spawn in raw["spawns"]):
        assert 'coordinateKind = "raw-server"' in rendered
    if raw.get("metadata", {}).get("worldBounds") and any(
        "worldX" not in spawn and "x" in spawn and "y" in spawn for spawn in raw["spawns"]
    ):
        assert 'coordinateKind = "derived-affine"' in rendered

print("Remaining TBC raid pipeline checks passed")
