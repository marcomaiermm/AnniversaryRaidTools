#!/usr/bin/env python3
"""Deterministic ART-080 Black Temple data checks."""

from __future__ import annotations

import hashlib
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.generator.generate import render_lua, render_world_positions  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402

SOURCE = ROOT / "tools" / "ac" / "fixtures" / "black-temple.json"
OUTPUT = ROOT / "Raids" / "TBC" / "Generated" / "BlackTemple.lua"
WORLD_OUTPUT = ROOT / "Raids" / "TBC" / "Generated" / "BlackTempleWorldPositions.lua"
PIN = "7060a217bcf7c454db570e842cd5e2179444d768"
SOURCE_URL = (
    "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/"
    "Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz#creature-map-564"
)


def main() -> None:
    snapshot = load_snapshot(SOURCE)
    raid = build_raid(snapshot)
    assert snapshot["metadata"]["project"] == "CMaNGOS TBC"
    assert snapshot["metadata"]["commit"] == PIN
    assert snapshot["metadata"]["databaseVersion"] == "TBCDB 1.11.0"
    assert snapshot["source"]["sourceRef"] == SOURCE_URL
    assert validate_raid(raid) == []
    spawns = [spawn for enemy in raid["enemies"].values() for spawn in enemy["spawns"]]
    assert raid["key"] == "black-temple" and raid["mapId"] == 564
    assert len(raid["sublevels"]) == 8
    assert len(spawns) == 626 and len(raid["enemies"]) == 74
    assert len(raid["packs"]) == 204
    pull_groups = [pack["pullGroup"] for pack in raid["packs"].values() if pack.get("pullGroup")]
    assert len(pull_groups) == 102 and len(set(pull_groups)) == 46
    assert raid["packs"]["black-temple:pack:group-5640051"]["pullGroup"] == (
        raid["packs"]["black-temple:pack:group-5640774"]["pullGroup"]
    )
    assert {spawn["sublevel"] for spawn in spawns} == set(range(1, 9))
    assert all("worldX" in spawn and "worldY" in spawn and "worldZ" in spawn for spawn in snapshot["spawns"])
    assert sum("patrol" in spawn for spawn in spawns) == 88
    assert all(len(spawn["patrol"]) >= 2 for spawn in spawns if "patrol" in spawn)
    assert all(PIN in spawn["source"]["sourceRef"] for spawn in spawns)
    assert all(spawn["key"].rsplit(":", 1)[-1].startswith("cmangos-") for spawn in spawns)

    by_id = {spawn["key"].rsplit(":", 1)[-1]: spawn for spawn in spawns}
    hidden = {
        "cmangos-5640457",
        "cmangos-5640458",
        "cmangos-5640784",
        "cmangos-5640785",
        "cmangos-5640786",
        "cmangos-5640787",
    }
    assert {spawn_id for spawn_id, spawn in by_id.items() if spawn.get("hidden")} == hidden
    bosses = {
        "cmangos-5640197": (22887, 1, 0.428721, 0.808477),
        "cmangos-5640198": (22898, 2, 0.362615, 0.473993),
        "cmangos-5640045": (22841, 3, 0.408006, 0.107070),
        "cmangos-5640284": (22948, 4, 0.534252, 0.513884),
        "cmangos-5640093": (22856, 4, 0.626701, 0.145928),
        "cmangos-5640105": (22871, 5, 0.392789, 0.897638),
        "cmangos-5640283": (22947, 6, 0.673018, 0.629439),
        "cmangos-5640285": (22949, 7, 0.474862, 0.533487),
        "cmangos-5640286": (22950, 7, 0.468522, 0.533600),
        "cmangos-5640287": (22951, 7, 0.479607, 0.526402),
        "cmangos-5640288": (22952, 7, 0.463615, 0.526585),
        "cmangos-5640199": (22917, 8, 0.528203, 0.418586),
    }
    for spawn_id, expected in bosses.items():
        spawn = by_id[spawn_id]
        assert (spawn["npcId"], spawn["sublevel"], spawn["x"], spawn["y"]) == expected

    patrols = {
        "cmangos-5640127": (1, 4, (0.370108, 0.744830), (0.369948, 0.696378)),
        "cmangos-5640048": (3, 8, (0.376338, 0.195428), (0.386508, 0.186111)),
        "cmangos-5640051": (3, 14, (0.552538, 0.466902), (0.554432, 0.517658)),
        "cmangos-5640091": (3, 16, (0.454691, 0.351486), (0.422064, 0.365473)),
        "cmangos-5640364": (6, 19, (0.374358, 0.656504), (0.370763, 0.631761)),
        "cmangos-5640633": (7, 9, (0.691747, 0.409392), (0.657559, 0.405466)),
    }
    for spawn_id, (floor, count, first, last) in patrols.items():
        spawn = by_id[spawn_id]
        assert spawn["sublevel"] == floor and len(spawn["patrol"]) == count
        assert (spawn["patrol"][0]["x"], spawn["patrol"][0]["y"]) == first
        assert (spawn["patrol"][-1]["x"], spawn["patrol"][-1]["y"]) == last

    council = raid["packs"]["black-temple:pack:illidari-council"]["spawnKeys"]
    by_key = {spawn["key"]: spawn for spawn in spawns}
    assert {by_key[key]["npcId"] for key in council} == {22949, 22950, 22951, 22952}
    assert {by_key[key]["sublevel"] for key in council} == {7}
    for npc_id in ("22849", "22878", "22946"):
        assert raid["enemies"][npc_id]["stealthDetect"] is True
        assert 18950 not in raid["enemies"][npc_id]["spells"]
    assert raid["enemies"]["23374"]["stealth"] is True

    rendered = render_lua(raid)
    assert rendered == render_lua(build_raid(load_snapshot(SOURCE)))
    assert OUTPUT.read_text(encoding="utf-8") == rendered
    assert WORLD_OUTPUT.read_text(encoding="utf-8") == render_world_positions(snapshot, raid)
    digest = hashlib.sha256(rendered.encode()).hexdigest()
    print(f"ART-080 Black Temple data checks passed: {digest}")


if __name__ == "__main__":
    main()
