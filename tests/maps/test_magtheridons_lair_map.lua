-- Pure-Lua ART-101 Magtheridon's Lair map and transform checks.
local root = arg and arg[1] or "."
local ART = { StaticData = { raids = {} } }
_G.ART = ART
local map = assert(loadfile(root.."/Raids/TBC/Maps/MagtheridonsLair.lua"))("AnniversaryRaidTools", ART)
local transform = assert(loadfile(root.."/Raids/TBC/Transforms/MagtheridonsLair.lua"))("AnniversaryRaidTools", ART)
local raid = assert(loadfile(root.."/Raids/TBC/Generated/MagtheridonsLair.lua"))()

local function close(actual, expected, tolerance, message)
  assert(math.abs(actual - expected) <= tolerance,
    (message or "values differ")..": got "..actual..", expected "..expected)
end

assert(map.raidKey == raid.key and map.instanceId == 544 and map.mapId == raid.mapId, "map identity mismatch")
local floor = map.sublevels[1]
assert(floor.index == 1 and floor.mapId == 544 and floor.transformKey == "magtheridons-lair:transform:1", "floor identity mismatch")
assert(floor.asset.kind == "client-map" and floor.asset.mapId == 544, "client map asset identity mismatch")
assert(floor.asset.uiMapId == 331 and floor.asset.textureFolder == "MagtheridonsLair", "client map identity mismatch")
assert(floor.asset.texturePrefix == "MagtheridonsLair1_", "client tile prefix mismatch")
assert(floor.asset.source.sourceRef:find("b41181588b98391e160a0bd25531de45e5360381", 1, true), "asset source is not pinned")

local calibration = assert(transform.getCalibration(544, 1))
local bounds = calibration.worldBounds
assert(bounds.leftY == 385.5 and bounds.rightY == -170.5, "world Y bounds mismatch")
assert(bounds.topX == 255.33334350585938 and bounds.bottomX == -115.3333511352539, "world X bounds mismatch")
assert(calibration.provenance.confidence == "review-required", "candidate calibration overstated")

local function worldToPlanner(worldX, worldY)
  local sourceX = (bounds.leftY - worldY) / (bounds.leftY - bounds.rightY)
  local sourceY = (bounds.topX - worldX) / (bounds.topX - bounds.bottomX)
  return transform.toPlanner(544, 1, sourceX, sourceY)
end

local bossX, bossY = worldToPlanner(-18.701200485229492, 2.2405099868774414)
close(bossX, 0.6893156295200046, 0.0000005, "Magtheridon absolute world x")
close(bossY, 0.7393017715185187, 0.0000005, "Magtheridon absolute world y")
local eastX, eastY = worldToPlanner(-49.6813, 60.5927)
close(eastX, 0.5843656474820145, 0.0000005, "patrol absolute world x")
close(eastY, 0.8228811703764767, 0.0000005, "patrol absolute world y")
local fartherEastX = worldToPlanner(-49.6813, 61.5927)
local fartherSouthX, fartherSouthY = worldToPlanner(-50.6813, 60.5927)
assert(fartherEastX < eastX and fartherSouthY > eastY and fartherSouthX == eastX, "absolute transform direction reversed")

for _, enemy in pairs(raid.enemies) do
  for _, spawn in ipairs(enemy.spawns) do
    local x, y = transform.toPlanner(544, spawn.sublevel, spawn.x, spawn.y)
    assert(x and y and x >= 0 and x <= 1 and y >= 0 and y <= 1, "spawn did not normalize")
    local roundX, roundY = transform.fromPlanner(544, spawn.sublevel, x, y)
    close(roundX, spawn.x, calibration.tolerance, "spawn x round trip")
    close(roundY, spawn.y, calibration.tolerance, "spawn y round trip")
    for _, point in ipairs(spawn.patrol or {}) do
      local patrolX, patrolY = transform.toPlanner(544, spawn.sublevel, point.x, point.y)
      assert(patrolX and patrolY, "patrol point did not normalize")
    end
  end
end

local value, reason = transform.toPlanner(565, 1, 0.5, 0.5)
assert(value == nil and reason == "unknown-map-id", "unknown map accepted")
value, reason = transform.toPlanner(544, 2, 0.5, 0.5)
assert(value == nil and reason == "unknown-sublevel", "unknown floor accepted")
assert(ART.MapDefinitions[raid.key] == map and ART.MapTransforms[raid.key] == transform, "publication missing")
print("Magtheridon's Lair map checks passed")
