#!/usr/bin/env python3
"""Deterministic ART-081 Hyjal source, wave, and patrol checks."""
from __future__ import annotations
import hashlib, json, sys
from collections import Counter
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from tools.ac.pipeline import build_raid, load_snapshot  # noqa: E402
from tools.generator.generate import render_lua  # noqa: E402
from tools.validators.raid import validate_raid  # noqa: E402
SOURCE = ROOT / "tools/ac/fixtures/hyjal.json"
OUTPUT = ROOT / "Raids/TBC/Generated/Hyjal.lua"
DB_COMMIT="7060a217bcf7c454db570e842cd5e2179444d768"; CORE_COMMIT="adbc7f747a3a5c4741a012d86f6cd8112238b5bc"
DB_URL=f"https://github.com/cmangos/tbc-db/blob/{DB_COMMIT}/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz"
CORE_URL=f"https://github.com/cmangos/mangos-tbc/blob/{CORE_COMMIT}/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp"

EXPECTED_WAVES=[
 ("winterchill-ghouls","alliance-base",{17895:10}),
 ("winterchill-ghouls-crypt-pair","alliance-base",{17895:10,17897:2}),
 ("winterchill-split-ghoul-crypt","alliance-base",{17895:6,17897:6}),
 ("winterchill-necromancer-introduction","alliance-base",{17895:6,17897:4,17899:2}),
 ("winterchill-crypt-necromancer","alliance-base",{17895:2,17897:6,17899:4}),
 ("winterchill-ghoul-abomination","alliance-base",{17895:6,17898:6}),
 ("winterchill-abomination-necromancer","alliance-base",{17895:4,17898:4,17899:4}),
 ("winterchill-combined-assault","alliance-base",{17895:6,17897:4,17898:2,17899:2}),
 ("rage-winterchill","alliance-base",{17767:1}),
 ("anetheron-ghouls","alliance-base",{17895:10}),
 ("anetheron-ghoul-abomination","alliance-base",{17895:8,17898:4}),
 ("anetheron-ghoul-crypt-necromancer","alliance-base",{17895:4,17897:4,17899:4}),
 ("anetheron-banshee-introduction","alliance-base",{17897:6,17899:4,17905:2}),
 ("anetheron-ghoul-banshee","alliance-base",{17895:6,17899:2,17905:4}),
 ("anetheron-abomination-necromancer","alliance-base",{17895:6,17898:2,17899:4}),
 ("anetheron-banshee-abomination","alliance-base",{17895:2,17897:4,17898:4,17905:2}),
 ("anetheron-combined-assault","alliance-base",{17895:4,17897:2,17898:4,17899:2,17905:2}),
 ("anetheron","alliance-base",{17808:1}),
 ("kazrogal-undead-vanguard","horde-encampment",{17895:6,17898:4,17899:2,17905:2}),
 ("kazrogal-gargoyle-introduction","horde-encampment",{17895:4,17906:10}),
 ("kazrogal-crypt-assault","horde-encampment",{17895:6,17897:6,17899:2}),
 ("kazrogal-gargoyle-crypt","horde-encampment",{17897:6,17899:2,17906:6}),
 ("kazrogal-abomination-assault","horde-encampment",{17895:4,17898:6,17899:4}),
 ("kazrogal-aerial-assault","horde-encampment",{17906:8,17907:1}),
 ("kazrogal-frost-wyrm-assault","horde-encampment",{17895:6,17898:4,17907:1}),
 ("kazrogal-combined-assault","horde-encampment",{17895:4,17897:4,17898:4,17899:2,17905:2}),
 ("kazrogal","horde-encampment",{17888:1}),
 ("azgalor-abomination-necromancer","horde-encampment",{17898:6,17899:6}),
 ("azgalor-aerial-ghouls","horde-encampment",{17895:5,17906:8,17907:1}),
 ("azgalor-ghoul-infernals","horde-encampment",{17895:6,17908:8}),
 ("azgalor-fel-stalker-infernals","horde-encampment",{17908:8,17916:6}),
 ("azgalor-fel-stalker-abominations","horde-encampment",{17898:4,17899:4,17916:6}),
 ("azgalor-necromancer-banshee","horde-encampment",{17899:6,17905:6}),
 ("azgalor-mixed-infernals","horde-encampment",{17895:2,17897:2,17908:8,17916:2}),
 ("azgalor-combined-assault","horde-encampment",{17897:4,17898:4,17899:2,17905:2,17916:4}),
 ("azgalor","horde-encampment",{17842:1}),
 ("archimonde","nordrassil",{17895:6,17897:1,17898:1,17968:1}),
]

PATROLS={
 "rage-winterchill-17767-01":"806c99d795e861dd5b90cd870ff88d788238a27e9490066e643a481daad317ea",
 "anetheron-17808-01":"806c99d795e861dd5b90cd870ff88d788238a27e9490066e643a481daad317ea",
 "azgalor-17842-01":"5fbb60e8244b0770a3cd64c21aa5c1645695d2edbc3f984c239f65b7a75214f5",
 "kazrogal-17888-01":"5fbb60e8244b0770a3cd64c21aa5c1645695d2edbc3f984c239f65b7a75214f5",
 "winterchill-ghouls-17895-01":"806c99d795e861dd5b90cd870ff88d788238a27e9490066e643a481daad317ea",
 "kazrogal-undead-vanguard-17895-01":"ffc5433b4567b8864e2593a8ccf55acf69c5b5f13dffd2631e689b518829a10c",
 "archimonde-night-elf-ghouls-17895-01":"fa9895d008df1fecd7ec67e1877cec0a5f91a814184a050f5846b1e6f654635c",
 "winterchill-ghouls-crypt-pair-17897-01":"806c99d795e861dd5b90cd870ff88d788238a27e9490066e643a481daad317ea",
 "kazrogal-crypt-assault-17897-01":"ffc5433b4567b8864e2593a8ccf55acf69c5b5f13dffd2631e689b518829a10c",
 "archimonde-night-elf-crypt-fiend-17897-01":"fa9895d008df1fecd7ec67e1877cec0a5f91a814184a050f5846b1e6f654635c",
 "winterchill-ghoul-abomination-17898-01":"806c99d795e861dd5b90cd870ff88d788238a27e9490066e643a481daad317ea",
 "kazrogal-undead-vanguard-17898-01":"ffc5433b4567b8864e2593a8ccf55acf69c5b5f13dffd2631e689b518829a10c",
 "archimonde-night-elf-ghoul-abomination-17898-01":"fa9895d008df1fecd7ec67e1877cec0a5f91a814184a050f5846b1e6f654635c",
 "winterchill-necromancer-introduction-17899-01":"806c99d795e861dd5b90cd870ff88d788238a27e9490066e643a481daad317ea",
 "kazrogal-undead-vanguard-17899-01":"ffc5433b4567b8864e2593a8ccf55acf69c5b5f13dffd2631e689b518829a10c",
 "anetheron-banshee-introduction-17905-01":"806c99d795e861dd5b90cd870ff88d788238a27e9490066e643a481daad317ea",
 "kazrogal-undead-vanguard-17905-01":"ffc5433b4567b8864e2593a8ccf55acf69c5b5f13dffd2631e689b518829a10c",
 "kazrogal-gargoyle-introduction-17906-01":"947aba7e50f2dc2a8ed3ae21a4ec25f92bf71eda20fe4d9541ed5a9ee057ad78",
 "kazrogal-aerial-assault-17906-01":"7a88eb879e3015b7f3d15be330db8ad554c2308a5dde17edd327c55e238cfad8",
 "kazrogal-frost-wyrm-assault-17907-01":"33b3eb3aec3da9c66b30e70c1b739ed925a52d4b3ee722afd55f28ba79aa206a",
 "kazrogal-aerial-assault-17907-01":"804fd4e5eb5b8897b2c6f497e956949cc3ba9cd677cd8d6d29307448358499ee",
 "azgalor-fel-stalker-infernals-17916-01":"ffc5433b4567b8864e2593a8ccf55acf69c5b5f13dffd2631e689b518829a10c",
}
ARCH={
 "archimonde-17968-01":(17968,.22562,.326337),
 "archimonde-night-elf-ghouls-17895-01":(17895,.289057,.457998),
 "archimonde-night-elf-ghouls-17895-02":(17895,.286853,.4645),
 "archimonde-night-elf-ghouls-17895-03":(17895,.290195,.463731),
 "archimonde-night-elf-crypt-fiend-17897-01":(17897,.297803,.464403),
 "archimonde-night-elf-ghoul-abomination-17895-01":(17895,.288853,.468281),
 "archimonde-night-elf-ghoul-abomination-17895-02":(17895,.293287,.463358),
 "archimonde-night-elf-ghoul-abomination-17895-03":(17895,.292402,.468353),
 "archimonde-night-elf-ghoul-abomination-17898-01":(17898,.29565,.470766),
}
ELIGIBLE_INFERNAL_POINTS={
 (0.485618,0.432542),(0.486121,0.37163),(0.510912,0.34628),
 (0.516355,0.39761),(0.539173,0.390938),(0.545251,0.371978),
}

def main():
 raw=json.loads(SOURCE.read_text()); m=raw["metadata"]
 assert (m["project"],m["commit"],m["databaseVersion"])==("CMaNGOS TBC",DB_COMMIT,"TBCDB 1.11.0")
 assert (m["snapshot"],m["exportedAt"])==("hyjal-map-534-waves","2026-08-21T19:30:00Z")
 assert m["sourceInputs"]=={"databaseCommit":DB_COMMIT,"databaseVersion":"TBCDB 1.11.0","databaseUrl":DB_URL,"coreCommit":CORE_COMMIT,"coreUrl":CORE_URL}
 assert m["worldBounds"]=={"leftY":-4025.0,"rightY":-1460.0,"topX":6145.8330078125,"bottomX":4479.16650390625,"eastMarginYards":65}
 assert m["infernalTargets"]=={"relayCount":6,"databaseTargetCount":7,"eligibleTargetGuids":[5343057,5343058,5343059,5343060,5343061,5343062],"representativeIndices":[0,1,2,3,4,5,0,1]}
 assert m["archimondeEncounter"]=={"semantics":"concurrent","sourceInvasionPhases":[14,15,16],"waveId":"archimonde","packIds":["archimonde","archimonde-night-elf-ghouls","archimonde-night-elf-crypt-fiend","archimonde-night-elf-ghoul-abomination"]}
 assert raw["source"]["sourceRef"]==f"{DB_URL} | {CORE_URL}"
 assert (raw["source"]["source"],raw["source"]["confidence"],raw["source"]["observedAt"])==("derived","candidate","2026-08-21T19:30:00Z")
 raid=build_raid(raw); assert validate_raid(raid)==[]
 assert (raid["key"],raid["instanceId"],raid["mapId"],raid["mode"])==("hyjal",534,534,"waves")
 spawns={s["key"]:s for e in raid["enemies"].values() for s in e["spawns"]}
 assert len(raid["waves"])==37 and len(raid["packs"])==40 and len(spawns)==421
 assert sum("patrol" in s for s in spawns.values())==396
 actual=[]
 for wave in raid["waves"]:
  assert len(wave["packKeys"])==(4 if wave["waveKey"]=="hyjal:wave:archimonde" else 1)
  keys=[key for pack_key in wave["packKeys"] for key in raid["packs"][pack_key]["spawnKeys"]]
  actual.append((wave["waveKey"].removeprefix("hyjal:wave:"),wave["camp"],dict(Counter(spawns[k]["npcId"] for k in keys))))
 assert actual==EXPECTED_WAVES
 for pid in ("azgalor-ghoul-infernals","azgalor-fel-stalker-infernals","azgalor-mixed-infernals"):
  pack=raid["packs"][f"hyjal:pack:{pid}"]; pts=[(spawns[k]["x"],spawns[k]["y"]) for k in pack["spawnKeys"] if spawns[k]["npcId"]==17908]
  assert len(pts)==8 and set(pts)==ELIGIBLE_INFERNAL_POINTS and pts[6]==pts[0] and pts[7]==pts[1]
 for fixture_id,digest in PATROLS.items():
  npc=int(fixture_id.rsplit("-",2)[1]); patrol=spawns[f"hyjal:spawn:{npc}:{fixture_id}"]["patrol"]
  assert hashlib.sha256(json.dumps(patrol,separators=(",",":"),sort_keys=True).encode()).hexdigest()==digest
 for fixture_id,(npc,x,y) in ARCH.items():
  s=spawns[f"hyjal:spawn:{npc}:{fixture_id}"]; assert (s["npcId"],s["x"],s["y"],s["sublevel"])==(npc,x,y,1)
 final_wave=raid["waves"][-1]
 assert (final_wave["waveKey"],final_wave["camp"])==("hyjal:wave:archimonde","nordrassil")
 assert final_wave["packKeys"]==["hyjal:pack:archimonde","hyjal:pack:archimonde-night-elf-ghouls","hyjal:pack:archimonde-night-elf-crypt-fiend","hyjal:pack:archimonde-night-elf-ghoul-abomination"]
 assert final_wave["source"]==raw["source"]
 first=render_lua(raid); assert first==render_lua(build_raid(load_snapshot(SOURCE)))==OUTPUT.read_text()
 assert "ART.StaticData.raids[raid.key] = raid" in first and first.rstrip().endswith("return raid")
 print("Hyjal pipeline checks passed")
if __name__=="__main__": main()
