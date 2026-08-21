#!/usr/bin/env python3
"""Deterministic ART-101 Magtheridon source and encounter checks."""
from __future__ import annotations

import hashlib
import json
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.generator.generate import render_lua  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402

SOURCE = ROOT / "tools/ac/fixtures/magtheridons-lair.json"
OUTPUT = ROOT / "Raids/TBC/Generated/MagtheridonsLair.lua"
DB_COMMIT = "7060a217bcf7c454db570e842cd5e2179444d768"
CORE_COMMIT = "adbc7f747a3a5c4741a012d86f6cd8112238b5bc"
DB_URL = f"https://github.com/cmangos/tbc-db/blob/{DB_COMMIT}/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz"
CORE_BASE = f"https://github.com/cmangos/mangos-tbc/blob/{CORE_COMMIT}/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair"
SOURCE_REF = f"{DB_URL} | {CORE_BASE}/magtheridons_lair.cpp | {CORE_BASE}/boss_magtheridon.cpp"
PATROLS = {
    "guid-5440034": (36, "7b34289f9c7733d60ba236ce5951ac24cf503783d0200c497826cd89d5419f48"),
    "guid-5440035": (29, "98b524e0296f389132d2d1eeef99d4c6930a5c812477bbf07dc97eef007388d1"),
    "guid-5440036": (35, "56df8ea4ac3f617921cc34290fb46197e72dde88eb4b9969232ab2de86f6af21"),
}
COORDINATES = {
    "guid-5440003": (17256, 0.689442, 0.839089),
    "guid-5440004": (17256, 0.621007, 0.775039),
    "guid-5440005": (17256, 0.650195, 0.660582),
    "guid-5440006": (17256, 0.728946, 0.660962),
    "guid-5440007": (17256, 0.757801, 0.774544),
    "guid-5440008": (17257, 0.689316, 0.739302),
    "guid-5440028": (18829, 0.809174, 0.683449),
    "guid-5440029": (18829, 0.802942, 0.681571),
    "guid-5440030": (18829, 0.808604, 0.673874),
    "guid-5440031": (18829, 0.698822, 0.595540),
    "guid-5440032": (18829, 0.689695, 0.590514),
    "guid-5440033": (18829, 0.680833, 0.596284),
    "guid-5440034": (18829, 0.587508, 0.834363),
    "guid-5440035": (18829, 0.584921, 0.836793),
    "guid-5440036": (18829, 0.590599, 0.833225),
    "guid-5440037": (18829, 0.572508, 0.689338),
    "guid-5440038": (18829, 0.569123, 0.672324),
    "guid-5440039": (18829, 0.570365, 0.712880),
}


def main() -> None:
    raw = json.loads(SOURCE.read_text(encoding="utf-8"))
    metadata = raw["metadata"]
    assert (metadata["project"], metadata["commit"], metadata["databaseVersion"]) == (
        "CMaNGOS TBC", DB_COMMIT, "TBCDB 1.11.0"
    )
    assert metadata["sourceInputs"]["coreCommit"] == CORE_COMMIT
    assert metadata["sourceInputs"] == {
        "databaseCommit": DB_COMMIT,
        "databaseVersion": "TBCDB 1.11.0",
        "databaseUrl": DB_URL,
        "coreCommit": CORE_COMMIT,
        "instanceScriptUrl": f"{CORE_BASE}/magtheridons_lair.cpp",
        "bossScriptUrl": f"{CORE_BASE}/boss_magtheridon.cpp",
    }
    assert raw["source"] == {
        "source": "derived", "confidence": "candidate",
        "sourceRef": SOURCE_REF, "observedAt": "2026-08-21T21:30:00Z",
    }
    assert metadata["worldBounds"] == {
        "leftY": 385.5, "rightY": -170.5,
        "topX": 255.33334350585938, "bottomX": -115.3333511352539,
    }
    assert metadata["encounter"] == {
        "semantics": "linked-sequential-release",
        "encounterPackId": "magtheridon-encounter",
        "plannerRepresentation": "atomic-pack",
        "channelerGuids": [5440003, 5440004, 5440005, 5440006, 5440007],
        "magtheridonGuid": 5440008,
        "channelerSpawnGroupId": 5440005,
        "timedReleaseSeconds": 120,
        "allChannelersDeadRelease": "immediate",
    }

    raid = build_raid(load_snapshot(SOURCE))
    assert validate_raid(raid) == []
    assert (raid["key"], raid["instanceId"], raid["mapId"], raid["mode"]) == (
        "magtheridons-lair", 544, 544, "route"
    )
    spawns = {
        spawn["key"]: spawn
        for enemy in raid["enemies"].values()
        for spawn in enemy["spawns"]
    }
    assert len(spawns) == 18 and Counter(s["npcId"] for s in spawns.values()) == {
        17256: 5, 17257: 1, 18829: 12
    }
    for fixture_id, (npc_id, x, y) in COORDINATES.items():
        spawn = spawns[f"magtheridons-lair:spawn:{npc_id}:{fixture_id}"]
        assert (spawn["npcId"], spawn["x"], spawn["y"], spawn["sublevel"]) == (npc_id, x, y, 1)

    assert len(raid["packs"]) == 5
    encounter = raid["packs"]["magtheridons-lair:pack:magtheridon-encounter"]["spawnKeys"]
    assert encounter == [
        "magtheridons-lair:spawn:17256:guid-5440003",
        "magtheridons-lair:spawn:17256:guid-5440004",
        "magtheridons-lair:spawn:17256:guid-5440005",
        "magtheridons-lair:spawn:17256:guid-5440006",
        "magtheridons-lair:spawn:17256:guid-5440007",
        "magtheridons-lair:spawn:17257:guid-5440008",
    ]
    assert Counter(spawns[key]["npcId"] for key in encounter) == {17256: 5, 17257: 1}
    assert {key: pack["spawnKeys"] for key, pack in raid["packs"].items()} == {
        "magtheridons-lair:pack:south-warders": [
            f"magtheridons-lair:spawn:18829:guid-{guid}" for guid in range(5440028, 5440031)
        ],
        "magtheridons-lair:pack:east-warders": [
            f"magtheridons-lair:spawn:18829:guid-{guid}" for guid in range(5440031, 5440034)
        ],
        "magtheridons-lair:pack:roaming-warders": [
            f"magtheridons-lair:spawn:18829:guid-{guid}" for guid in range(5440034, 5440037)
        ],
        "magtheridons-lair:pack:north-warders": [
            f"magtheridons-lair:spawn:18829:guid-{guid}" for guid in range(5440037, 5440040)
        ],
        "magtheridons-lair:pack:magtheridon-encounter": encounter,
    }

    for fixture_id, (length, digest) in PATROLS.items():
        patrol = spawns[f"magtheridons-lair:spawn:18829:{fixture_id}"]["patrol"]
        assert len(patrol) == length
        assert hashlib.sha256(json.dumps(patrol, separators=(",", ":"), sort_keys=True).encode()).hexdigest() == digest
    assert sum("patrol" in spawn for spawn in spawns.values()) == 3

    sources = [enemy["source"] for enemy in raid["enemies"].values()]
    sources += [spawn["source"] for spawn in spawns.values()]
    sources += [pack["source"] for pack in raid["packs"].values()]
    sources += [poi["source"] for poi in raid["pois"][1]]
    assert sources and all(source == raw["source"] for source in sources)

    rendered = render_lua(raid)
    assert rendered == render_lua(build_raid(load_snapshot(SOURCE))) == OUTPUT.read_text(encoding="utf-8")
    assert "ART.StaticData.raids[raid.key] = raid" in rendered and rendered.rstrip().endswith("return raid")
    assert f"-- SourceRef: {SOURCE_REF}" in rendered
    print("Magtheridon's Lair pipeline checks passed")


if __name__ == "__main__":
    main()
