-- Pure-Lua ART-100 Karazhan map and transform checks.
local root = arg and arg[1] or "."
local ART = { StaticData = { raids = {} } }
_G.ART = ART
local map = assert(loadfile(root.."/Raids/TBC/Maps/Karazhan.lua"))("AnniversaryRaidTools", ART)
local transform = assert(loadfile(root.."/Raids/TBC/Transforms/Karazhan.lua"))("AnniversaryRaidTools", ART)
local raid = assert(loadfile(root.."/Raids/TBC/Generated/Karazhan.lua"))()

local function close(actual, expected, tolerance, message)
  assert(math.abs(actual - expected) <= tolerance,
    (message or "values differ")..": got "..actual..", expected "..expected)
end

assert(map.raidKey == raid.key and map.mapId == raid.mapId and map.instanceId == raid.instanceId,
  "map identity mismatch")
assert(#map.sublevels == 17 and #raid.sublevels == 17, "Karazhan must expose 17 client floors")
assert(map.instanceId == 532 and map.mapId == 532, "instance/map identity mismatch")
local mapSource = "https://warcraft.wiki.gg/wiki/UiMapID#Karazhan | https://github.com/Babilounet/SimpleDungeonMap/blob/b41181588b98391e160a0bd25531de45e5360381/DungeonData.lua#L173-L203"
local transformSource = "https://gist.github.com/Stanzilla/dd2085b9a4f9229dc0ac#mapData-799-rzti-532"
assert(map.source.sourceRef == mapSource, "map provenance drifted")

local exactBounds = {
  {550.048828125,366.69921875,2225.0244140625,-11189.599609375,1674.9755859375,-10822.900390625},
  {257.85986328125,171.90625,2081.419921875,-11189.0029296875,1823.56005859375,-11017.0966796875},
  {345.1494140625,230.099609375,2132.57470703125,-11066.2998046875,1787.42529296875,-10836.2001953125},
  {520.048828125,346.69921875,2190.0244140625,-11119.599609375,1669.9755859375,-10772.900390625},
  {234.14990234375,156.099609375,1932.5799560546875,-10969.2998046875,1698.4300537109375,-10813.2001953125},
  {581.548828125,387.69921875,2205.7744140625,-11190.599609375,1624.2255859375,-10802.900390625},
  {191.548828125,127.69921875,2066.7744140625,-11115.599609375,1875.2255859375,-10987.900390625},
  {139.3505859375,92.900390625,2037.6802978515625,-11105.2001953125,1898.3297119140625,-11012.2998046875},
  {760.048828125,506.69921875,2270.0244140625,-11459.599609375,1509.9755859375,-10952.900390625},
  {450.25,300.166015625,2040.1300048828125,-11386.3330078125,1589.8800048828125,-11086.1669921875},
  {271.050048828125,180.69921875,1825.530029296875,-11285.099609375,1554.47998046875,-11104.400390625},
  {595.048828125,396.69921875,2182.5244140625,-11444.599609375,1587.4755859375,-11047.900390625},
  {529.048828125,352.69921875,1963.0244140625,-11339.099609375,1433.9755859375,-10986.400390625},
  {245.25,163.5,2032.6300048828125,-11143.0,1787.3800048828125,-10979.5},
  {211.14990234375,140.765625,2025.0799560546875,-11113.6328125,1813.9300537109375,-10972.8671875},
  {101.25,67.5,2020.1300048828125,-11097.0,1918.8800048828125,-11029.5},
  {341.25,227.5,2155.1298828125,-11102.0,1813.8798828125,-10874.5},
}
for sublevel = 1, 17 do
  local floor = map.sublevels[sublevel]
  assert(floor.index == sublevel and floor.mapId == 532, "floor identity mismatch")
  assert(floor.uiMapId == 349 + sublevel, "UIMap identity mismatch")
  assert(floor.asset.kind == "client-map" and floor.asset.mapId == 532, "asset identity mismatch")
  assert(floor.asset.textureFolder == "Karazhan", "asset folder mismatch")
  assert(floor.asset.texturePrefix == "Karazhan"..sublevel.."_", "asset prefix mismatch")
  assert(floor.asset.source.sourceRef == mapSource, "asset provenance drifted")
  local calibration = transform.getCalibration(532, sublevel)
  assert(calibration.provenance.confidence == "candidate", "candidate transform overstated")
  assert(calibration.provenance.sourceRef == transformSource, "transform provenance drifted")
  assert(calibration.flipY == true, "Karazhan texture orientation drifted")
  local actual, expected = calibration.worldBounds, exactBounds[sublevel]
  for index = 1, 6 do close(actual[index], expected[index], 0.000001, "world bound mismatch") end
end

-- Absolute direction: increasing world Y moves left; increasing world X moves up.
local x, y = transform.worldToPlanner(532, 3, -10982.7001953125, -1877.9300537109375)
close(x, 0.263672, 0.000001, "Moroes world-to-planner x")
close(y, 0.446615, 0.000001, "Moroes world-to-planner y")
local rightX = assert(transform.worldToPlanner(532, 3, -10982.7001953125, -1887.9300537109375))
local _, downY = transform.worldToPlanner(532, 3, -10972.7001953125, -1877.9300537109375)
assert(rightX > x and downY < y, "absolute transform axes reversed")
local worldX, worldY = transform.plannerToWorld(532, 3, x, y)
close(worldX, -10982.7001953125, 0.001, "world x round trip")
close(worldY, -1877.9300537109375, 0.001, "world y round trip")

local nonIdentity = {
  mapId = 532, sublevel = 3, offsetX = 0.1, offsetY = 0.05,
  scaleX = 0.8, scaleY = 0.7, flipY = true,
}
local calibratedX, calibratedY = transform.toPlanner(532, 3, 0.25, 0.40, nonIdentity)
close(calibratedX, 0.30, 0.000001, "non-identity x")
close(calibratedY, 0.47, 0.000001, "non-identity flipped y")
local sourceX, sourceY = transform.fromPlanner(532, 3, calibratedX, calibratedY, nonIdentity)
close(sourceX, 0.25, 0.000001, "non-identity x round trip")
close(sourceY, 0.40, 0.000001, "non-identity y round trip")

for _, enemy in pairs(raid.enemies) do
  for _, spawn in ipairs(enemy.spawns) do
    assert(spawn.x >= 0 and spawn.x <= 1 and spawn.y >= 0 and spawn.y <= 1, "spawn did not normalize")
    for _, point in ipairs(spawn.patrol or {}) do
      assert(point.x >= 0 and point.x <= 1 and point.y >= 0 and point.y <= 1, "patrol did not normalize")
    end
  end
end

local value, reason = transform.worldToPlanner(532, 3, 0, 0)
assert(value == nil and reason == "outside-world-bounds", "outside world coordinate accepted")
value, reason = transform.toPlanner(531, 1, 0.5, 0.5)
assert(value == nil and reason == "unknown-map-id", "unknown map accepted")
value, reason = transform.toPlanner(532, 18, 0.5, 0.5)
assert(value == nil and reason == "unknown-sublevel", "unknown floor accepted")

assert(ART.MapDefinitions.karazhan == map, "map publication missing")
assert(ART.MapTransforms.karazhan == transform, "transform publication missing")
print("Karazhan map checks passed")
