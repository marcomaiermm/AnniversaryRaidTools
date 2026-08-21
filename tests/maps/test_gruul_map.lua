-- Pure-Lua acceptance checks for ART-031 Gruul map calibration.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
local addon = { ART = ART }
local map = assert(loadfile(root.."/Raids/TBC/Maps/GruulsLair.lua"))("AnniversaryRaidTools", addon)
local transform = assert(loadfile(root.."/Raids/TBC/Transforms/GruulsLair.lua"))("AnniversaryRaidTools", addon)
local raid = assert(loadfile(root.."/Raids/TBC/Generated/GruulsLair.lua"))()

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
equal(map.mapId, raid.mapId, "map identity")
equal(map.sublevels[1].mapId, raid.sublevels[1].mapId, "sublevel map identity")
assert(type(map.sublevels[1].asset) == "table", "map asset metadata missing")
assert(map.sublevels[1].asset.textureFolder == "GruulsLair", "map asset folder missing")
assert(map.sublevels[1].asset.source.sourceRef ~= nil, "map asset provenance missing")
assert(map.source.source ~= nil and map.source.confidence ~= "verified", "candidate map provenance missing")
assert(transform.calibrations[1].provenance.sourceRef ~= nil, "transform provenance missing")

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

local poi = raid.pois[1][1]
local poiX, poiY = transform.toPlanner(raid.mapId, poi.sublevel, poi.x, poi.y)
assert(normalized(poiX) and normalized(poiY), "POI did not normalize")

local calibrated = {
  mapId = 565,
  sublevel = 1,
  offsetX = 0.01,
  offsetY = 0.02,
  scaleX = 0.98,
  scaleY = 0.97,
  flipY = false,
  tolerance = 0.0005,
  provenance = transform.calibrations[1].provenance,
}
local calibratedX, calibratedY = transform.toPlanner(565, 1, 0.5, 0.4, calibrated)
local sourceX, sourceY = transform.fromPlanner(565, 1, calibratedX, calibratedY, calibrated)
close(sourceX, 0.5, calibrated.tolerance, "calibration x round trip")
close(sourceY, 0.4, calibrated.tolerance, "calibration y round trip")

local value, reason = transform.toPlanner(999, 1, 0.5, 0.5)
equal(value, nil, "unknown map rejected")
equal(reason, "unknown-map-id", "unknown map reason")
value, reason = transform.toPlanner(565, 2, 0.5, 0.5)
equal(value, nil, "unknown sublevel rejected")
equal(reason, "unknown-sublevel", "unknown sublevel reason")
value, reason = transform.toPlanner(565, 1, 1 / 0, 0.5)
equal(value, nil, "non-finite coordinate rejected")
equal(reason, "invalid-source-coordinate", "non-finite coordinate reason")

assert(ART.MapDefinitions["gruuls-lair"] == map, "map registration missing")
assert(ART.MapTransforms["gruuls-lair"] == transform, "transform registration missing")
print("Gruul map checks passed")
