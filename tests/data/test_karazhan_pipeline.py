#!/usr/bin/env python3
"""Deterministic ART-100 Karazhan data checks."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.generator.generate import render_lua, render_world_positions  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402

SOURCE = ROOT / "tools" / "ac" / "fixtures" / "karazhan.json"
OUTPUT = ROOT / "Raids" / "TBC" / "Generated" / "Karazhan.lua"
WORLD_OUTPUT = ROOT / "Raids" / "TBC" / "Generated" / "KarazhanWorldPositions.lua"
PIN = "7060a217bcf7c454db570e842cd5e2179444d768"
CORE_PIN = "adbc7f747a3a5c4741a012d86f6cd8112238b5bc"
DB_SOURCE = (
    f"https://github.com/cmangos/tbc-db/blob/{PIN}/Full_DB/"
    "TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz#creature-map-532"
)
CORE_SOURCE = (
    f"https://github.com/cmangos/mangos-tbc/blob/{CORE_PIN}/src/game/AI/"
    "ScriptDevAI/scripts/eastern_kingdoms/karazhan"
)
CORE_PROVENANCE = (
    CORE_SOURCE + "/karazhan.h | " + CORE_SOURCE + "/karazhan.cpp | "
    + CORE_SOURCE + "/boss_moroes.cpp | " + CORE_SOURCE + "/bosses_opera.cpp"
)


def main() -> None:
    snapshot = load_snapshot(SOURCE)
    raid = build_raid(snapshot)
    metadata = snapshot["metadata"]
    assert metadata["project"] == "CMaNGOS TBC"
    assert metadata["commit"] == PIN and metadata["coreCommit"] == CORE_PIN
    assert metadata["databaseVersion"] == "TBCDB 1.11.0"
    assert metadata["mapReferenceCommit"] == "b41181588b98391e160a0bd25531de45e5360381"
    assert metadata["coverage"] == {
        "staticHostileSelectableSpawns": 605,
        "candidateDynamicEncounterSpawns": 0,
        "npcIds": 57,
        "sourceMovementRecords": 961,
        "renderedPatrols": 53,
        "excludedFactionRelativeChessSpawns": 32,
        "excludedNonselectableNpcIds": [17161, 17225, 25213],
        "nonselectableVariantPolicy": (
            "Servants' Quarters, Opera, Moroes guests, Attumen, Chess, and Nightbane "
            "are informational POIs only"
        ),
    }
    assert hashlib.sha256(
        json.dumps(metadata, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest() == "b826879b06a989fc2b0587cf212a3a17a4157b11dcba8b83dda609807f2ec926"
    assert snapshot["source"]["sourceRef"] == DB_SOURCE + " | " + CORE_PROVENANCE
    assert validate_raid(raid) == []

    spawns = [spawn for enemy in raid["enemies"].values() for spawn in enemy["spawns"]]
    assert raid["key"] == "karazhan" and raid["instanceId"] == raid["mapId"] == 532
    assert len(raid["sublevels"]) == 17
    # ART-0007: client UiMapAssignment height gates place the last two Upper
    # Broken Stair ghosts (z=124.6) below floor 8's z>=140 base on floor 7.
    assert {s["sublevel"] for s in spawns} == (set(range(1, 18)) - {8, 14})
    assert len(spawns) == 605 and len(raid["enemies"]) == 57 and len(raid["packs"]) == 286
    assert sum("patrol" in spawn for spawn in spawns) == 53
    assert all("worldX" in spawn and "worldY" in spawn and "worldZ" in spawn for spawn in snapshot["spawns"])
    assert all(len(spawn["patrol"]) >= 2 for spawn in spawns if "patrol" in spawn)

    by_id = {spawn["key"].rsplit(":", 1)[-1]: spawn for spawn in spawns}
    assert len(by_id) == 605 and all(PIN in spawn["source"]["sourceRef"] for spawn in spawns)
    assert all(spawn_id.startswith("cmangos-532") for spawn_id in by_id)

    dynamic = {15550, 16179, 16180, 16181, 17007, 19872, 19873, 19874, 19875, 19876,
               17521, 17533, 17534, 17535, 17543, 17546, 17547, 17603, 18168}
    chess = {17211, 17469, 21160, 21664, 21682, 21683, 21684, 21726, 21747, 21748, 21750, 21752}
    nonselectable = {17161, 17225, 25213}
    assert not ({spawn["npcId"] for spawn in spawns} & (dynamic | chess | nonselectable))

    bosses = {
        "cmangos-5320144": (16151, 1, 0.462022, 0.827379),
        "cmangos-5320139": (15687, 3, 0.263672, 0.446615),
        "cmangos-5320420": (16457, 4, 0.816406, 0.565104),
        "cmangos-5320143": (15691, 9, 0.482422, 0.679166),
        "cmangos-5320644": (16524, 10, 0.710006, 0.260966),
        "cmangos-5320140": (15688, 11, 0.514648, 0.391927),
        "cmangos-5320141": (15689, 13, 0.342661, 0.292034),
        "cmangos-5320142": (15690, 17, 0.579224, 0.227691),
    }
    for spawn_id, expected in bosses.items():
        spawn = by_id[spawn_id]
        assert (spawn["npcId"], spawn["sublevel"], spawn["x"], spawn["y"]) == expected

    members = [key for pack in raid["packs"].values() for key in pack["spawnKeys"]]
    spawn_keys = {spawn["key"] for spawn in spawns}
    assert len(members) == len(set(members)) == len(spawn_keys) and set(members) == spawn_keys
    for pack in raid["packs"].values():
        assert pack["source"]["sourceRef"] == DB_SOURCE
        assert all(next(s for s in spawns if s["key"] == key)["packKey"] == pack["key"]
                   for key in pack["spawnKeys"])

    patrol_signature = []
    for spawn_id, spawn in sorted(by_id.items()):
        if "patrol" not in spawn:
            continue
        points = ";".join(f'{point["x"]:.6f},{point["y"]:.6f}' for point in spawn["patrol"])
        patrol_signature.append(
            f'{spawn_id}|{spawn["sublevel"]}|{spawn["packKey"].rsplit(":", 1)[-1]}|{points}'
        )
    assert len(patrol_signature) == 53
    assert hashlib.sha256("\n".join(patrol_signature).encode()).hexdigest() == (
        "f20f1920bc33029db59d2b0a54f07091d0e3791eaf52a846ec85fc6eefa0100f"
    )

    poi_labels = {poi["label"] for floor in raid["pois"].values() for poi in floor}
    nonselectable_pois = {
        "Nonselectable candidate location: Shadikith (one of three)",
        "Nonselectable candidate location: Rokad (one of three)",
        "Nonselectable candidate location: Hyakiss (one of three)",
        "Nonselectable encounter roster: four of six Moroes guests",
        "Nonselectable Opera candidate: Wizard of Oz",
        "Nonselectable Opera candidate: Big Bad Wolf",
        "Nonselectable Opera candidate: Romulo and Julianne",
        "Nonselectable summoned actor: Attumen",
        "Nonselectable faction-relative Chess encounter",
        "Nonselectable summoned encounter location: Nightbane",
    }
    expected_pois = nonselectable_pois | {"Entrance / upper-livery connection"}
    assert poi_labels == expected_pois
    exact_pois = {
        "Nonselectable candidate location: Shadikith (one of three)": (1, 0.483383, 0.371448),
        "Nonselectable candidate location: Rokad (one of three)": (1, 0.746287, 0.210280),
        "Nonselectable candidate location: Hyakiss (one of three)": (1, 0.665640, 0.318652),
        "Nonselectable encounter roster: four of six Moroes guests": (3, 0.279811, 0.655741),
        "Nonselectable Opera candidate: Wizard of Oz": (4, 0.168531, 0.356937),
        "Nonselectable Opera candidate: Big Bad Wolf": (4, 0.169281, 0.343553),
        "Nonselectable Opera candidate: Romulo and Julianne": (4, 0.173934, 0.348024),
        "Nonselectable summoned actor: Attumen": (1, 0.462022, 0.827379),
        "Nonselectable faction-relative Chess encounter": (14, 0.362648, 0.618463),
        "Nonselectable summoned encounter location: Nightbane": (6, 0.233797, 0.517927),
    }
    pois_by_label = {poi["label"]: poi for floor in raid["pois"].values() for poi in floor}
    for label, expected in exact_pois.items():
        poi = pois_by_label[label]
        assert (poi["sublevel"], poi["x"], poi["y"]) == expected
    for poi in (poi for floor in raid["pois"].values() for poi in floor if poi["label"] in nonselectable_pois):
        assert poi["source"]["sourceRef"] == CORE_PROVENANCE

    rendered = render_lua(raid)
    assert rendered == render_lua(build_raid(load_snapshot(SOURCE)))
    assert OUTPUT.read_text(encoding="utf-8") == rendered
    assert WORLD_OUTPUT.read_text(encoding="utf-8") == render_world_positions(snapshot, raid)
    print(f"ART-100 Karazhan data checks passed: {hashlib.sha256(rendered.encode()).hexdigest()}")


if __name__ == "__main__":
    main()
