#!/usr/bin/env python3
"""Deterministic ART-080 Black Temple data checks."""

from __future__ import annotations

import hashlib
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.generator.generate import render_lua  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402

SOURCE = ROOT / "tools" / "ac" / "fixtures" / "black-temple.json"
OUTPUT = ROOT / "Raids" / "TBC" / "Generated" / "BlackTemple.lua"
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
    assert len(raid["sublevels"]) == 7
    assert len(spawns) == 626 and len(raid["enemies"]) == 74
    assert len(raid["packs"]) == 204
    assert {spawn["sublevel"] for spawn in spawns} == set(range(1, 8))
    assert sum("patrol" in spawn for spawn in spawns) == 88
    assert all(len(spawn["patrol"]) >= 2 for spawn in spawns if "patrol" in spawn)
    assert all(PIN in spawn["source"]["sourceRef"] for spawn in spawns)
    assert all(spawn["key"].rsplit(":", 1)[-1].startswith("cmangos-") for spawn in spawns)

    by_id = {spawn["key"].rsplit(":", 1)[-1]: spawn for spawn in spawns}
    bosses = {
        "cmangos-5640197": (22887, 1, 0.824803, 0.631016),
        "cmangos-5640198": (22898, 2, 0.525839, 0.349381),
        "cmangos-5640045": (22841, 2, 0.897157, 0.954545),
        "cmangos-5640284": (22948, 3, 0.404785, 0.398078),
        "cmangos-5640093": (22856, 3, 0.601610, 0.838587),
        "cmangos-5640105": (22871, 4, 0.433155, 0.606913),
        "cmangos-5640283": (22947, 5, 0.794237, 0.183604),
        "cmangos-5640285": (22949, 6, 0.255948, 0.098701),
        "cmangos-5640286": (22950, 6, 0.238832, 0.098442),
        "cmangos-5640287": (22951, 6, 0.268757, 0.114994),
        "cmangos-5640288": (22952, 6, 0.225586, 0.114573),
        "cmangos-5640199": (22917, 7, 0.500000, 0.500000),
    }
    for spawn_id, expected in bosses.items():
        spawn = by_id[spawn_id]
        assert (spawn["npcId"], spawn["sublevel"], spawn["x"], spawn["y"]) == expected

    patrols = {
        "cmangos-5640127": (1, 4, (0.661094, 0.710115), (0.660646, 0.770330)),
        "cmangos-5640048": (2, 8, (0.851210, 0.816921), (0.865965, 0.831433)),
        "cmangos-5640051": (3, 14, (0.440377, 0.506746), (0.444289, 0.447795)),
        "cmangos-5640091": (4, 16, (0.547961, 0.603754), (0.469416, 0.588017)),
        "cmangos-5640364": (5, 19, (0.424789, 0.133209), (0.420342, 0.179281)),
        "cmangos-5640633": (6, 9, (0.841456, 0.384064), (0.749160, 0.393091)),
    }
    for spawn_id, (floor, count, first, last) in patrols.items():
        spawn = by_id[spawn_id]
        assert spawn["sublevel"] == floor and len(spawn["patrol"]) == count
        assert (spawn["patrol"][0]["x"], spawn["patrol"][0]["y"]) == first
        assert (spawn["patrol"][-1]["x"], spawn["patrol"][-1]["y"]) == last

    council = raid["packs"]["black-temple:pack:illidari-council"]["spawnKeys"]
    by_key = {spawn["key"]: spawn for spawn in spawns}
    assert {by_key[key]["npcId"] for key in council} == {22949, 22950, 22951, 22952}
    assert {by_key[key]["sublevel"] for key in council} == {6}

    rendered = render_lua(raid)
    assert rendered == render_lua(build_raid(load_snapshot(SOURCE)))
    assert OUTPUT.read_text(encoding="utf-8") == rendered
    digest = hashlib.sha256(rendered.encode()).hexdigest()
    print(f"ART-080 Black Temple data checks passed: {digest}")


if __name__ == "__main__":
    main()
