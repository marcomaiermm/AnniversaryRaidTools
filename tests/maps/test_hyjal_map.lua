-- Pure-Lua acceptance checks for the ART-081 Hyjal map calibration.

local root = arg and arg[1] or "."
local ART = { StaticData = { raids = {} } }
_G.ART = ART
local addon = { ART = ART }
local map = assert(loadfile(root.."/Raids/TBC/Maps/Hyjal.lua"))("AnniversaryRaidTools", addon)
local transform = assert(loadfile(root.."/Raids/TBC/Transforms/Hyjal.lua"))("AnniversaryRaidTools", addon)
local raid = assert(loadfile(root.."/Raids/TBC/Generated/Hyjal.lua"))()

local function equal(actual, expected, message)
  assert(actual == expected, (message or "values differ")..": got "..tostring(actual)..", expected "..tostring(expected))
end

local function close(actual, expected, tolerance, message)
  assert(math.abs(actual - expected) <= tolerance, (message or "values differ")..": got "..actual..", expected "..expected)
end

local function normalized(value)
  return type(value) == "number" and value == value and value >= 0 and value <= 1
end

equal(map.raidKey, raid.key, "map raid identity")
equal(map.schemaVersion, 1, "map schema")
equal(map.instanceId, 534, "instance identity")
equal(map.mapId, raid.mapId, "map identity")
equal(map.sublevels[1].mapId, raid.sublevels[1].mapId, "sublevel map identity")
equal(map.sublevels[1].index, 1, "sublevel index")
equal(map.sublevels[1].name, "Hyjal Summit", "sublevel name")
equal(map.sublevels[1].transformKey, "hyjal:transform:1", "transform key")
equal(map.sublevels[1].asset.kind, "client-map", "map asset kind")
equal(map.sublevels[1].asset.mapId, 534, "map asset identity")
equal(map.sublevels[1].asset.uiMapId, 329, "UI map identity")
equal(map.sublevels[1].asset.textureFolder, "CoTMountHyjal", "map asset folder")
equal(map.sublevels[1].asset.tilePrefix, "CoTMountHyjal", "map tile prefix")
equal(map.sublevels[1].asset.noFloorPrefix, true, "no-floor-prefix asset")
equal(map.source.source, "derived", "map provenance source")
equal(map.source.confidence, "candidate", "map provenance confidence")
equal(map.source.observedAt, "2026-08-21T19:30:00Z", "map provenance timestamp")
equal(map.source.sourceRef, "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz", "map provenance URL")
equal(map.sublevels[1].asset.source.source, "client-data", "asset provenance source")
equal(map.sublevels[1].asset.source.confidence, "candidate", "asset provenance confidence")
equal(map.sublevels[1].asset.source.observedAt, "2026-08-21T19:30:00Z", "asset provenance timestamp")
equal(map.sublevels[1].asset.source.sourceRef, "https://github.com/Babilounet/SimpleDungeonMap/blob/b41181588b98391e160a0bd25531de45e5360381/DungeonData.lua", "asset provenance URL")
equal(transform.schemaVersion, 1, "transform schema")
local calibration = transform.calibrations[1]
equal(calibration.mapId, 534, "calibration map")
equal(calibration.sublevel, 1, "calibration sublevel")
equal(calibration.worldBounds.leftY, -4025, "world left Y")
equal(calibration.worldBounds.rightY, -1460, "world right Y")
equal(calibration.worldBounds.topX, 6145.8330078125, "world top X")
equal(calibration.worldBounds.bottomX, 4479.16650390625, "world bottom X")
equal(calibration.worldBounds.eastMarginYards, 65, "world eastern margin")
assert(calibration.provenance.sourceRef:find("WorldMapArea%-775"), "transform provenance URL missing")

local function worldToPlanner(worldX, worldY, selected)
  selected = selected or calibration
  local bounds = calibration.worldBounds
  local sourceX = (worldY - bounds.leftY) / (bounds.rightY - bounds.leftY)
  local sourceY = (bounds.topX - worldX) / (bounds.topX - bounds.bottomX)
  return transform.toPlanner(534, 1, sourceX, sourceY, selected)
end

local archimondeX, archimondeY = worldToPlanner(5601.938, -3446.284)
close(archimondeX, 0.22562, 0.0000005, "Archimonde absolute world x")
close(archimondeY, 0.326337, 0.0000005, "Archimonde absolute world y")
local allianceX, allianceY = worldToPlanner(5084.06982421875, -1789.030029296875)
close(allianceX, 0.871723, 0.0000005, "Alliance POI absolute world x")
close(allianceY, 0.637058, 0.0000005, "Alliance POI absolute world y")

local adjusted = {
  mapId = 534, sublevel = 1, offsetX = 0.01, offsetY = 0.02,
  scaleX = 0.9, scaleY = 0.8, flipY = false, tolerance = 0.0005,
  provenance = calibration.provenance,
}
local adjustedX, adjustedY = worldToPlanner(5601.938, -3446.284, adjusted)
close(adjustedX, archimondeX * 0.9 + 0.01, 0.0000005, "non-identity absolute x")
close(adjustedY, archimondeY * 0.8 + 0.02, 0.0000005, "non-identity absolute y")
local sourceX, sourceY = transform.fromPlanner(534, 1, adjustedX, adjustedY, adjusted)
close(sourceX, archimondeX, adjusted.tolerance, "non-identity x round trip")
close(sourceY, archimondeY, adjusted.tolerance, "non-identity y round trip")

for _, enemy in pairs(raid.enemies) do
  for _, spawn in ipairs(enemy.spawns) do
    local x, y = transform.toPlanner(raid.mapId, spawn.sublevel, spawn.x, spawn.y)
    assert(normalized(x) and normalized(y), "spawn did not normalize")
    local roundX, roundY = transform.fromPlanner(raid.mapId, spawn.sublevel, x, y)
    close(roundX, spawn.x, transform.calibrations[1].tolerance, "spawn x round trip")
    close(roundY, spawn.y, transform.calibrations[1].tolerance, "spawn y round trip")
    if spawn.patrol then
      for _, point in ipairs(spawn.patrol) do
        local patrolX, patrolY = transform.toPlanner(raid.mapId, spawn.sublevel, point.x, point.y)
        assert(normalized(patrolX) and normalized(patrolY), "patrol point did not normalize")
      end
    end
  end
end

for _, poi in ipairs(raid.pois[1]) do
  local x, y = transform.toPlanner(raid.mapId, poi.sublevel, poi.x, poi.y)
  assert(normalized(x) and normalized(y), "POI did not normalize")
end

local value, reason = transform.toPlanner(999, 1, 0.5, 0.5)
equal(value, nil, "unknown map rejected")
equal(reason, "unknown-map-id", "unknown map reason")
value, reason = transform.toPlanner(534, 2, 0.5, 0.5)
equal(value, nil, "unknown sublevel rejected")
equal(reason, "unknown-sublevel", "unknown sublevel reason")
value, reason = transform.toPlanner(534, 1, 1 / 0, 0.5)
equal(value, nil, "non-finite coordinate rejected")
equal(reason, "invalid-source-coordinate", "non-finite coordinate reason")

assert(ART.MapDefinitions.hyjal == map, "map registration missing")
assert(ART.MapTransforms.hyjal == transform, "transform registration missing")
print("Hyjal map checks passed")
