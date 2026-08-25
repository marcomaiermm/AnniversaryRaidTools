-- Pure-Lua ART-080 Black Temple map and transform checks.
local root = arg and arg[1] or "."
local ART = { StaticData = { raids = {} } }
_G.ART = ART
local map = assert(loadfile(root.."/Raids/TBC/Maps/BlackTemple.lua"))("AnniversaryRaidTools", ART)
local transform = assert(loadfile(root.."/Raids/TBC/Transforms/BlackTemple.lua"))("AnniversaryRaidTools", ART)
local raid = assert(loadfile(root.."/Raids/TBC/Generated/BlackTemple.lua"))()

local function close(actual, expected, tolerance, message)
  assert(math.abs(actual - expected) <= tolerance,
    (message or "values differ")..": got "..actual..", expected "..expected)
end

local function normalized(value)
  return type(value) == "number" and value == value and value >= 0 and value <= 1
end

assert(map.raidKey == raid.key and map.mapId == raid.mapId, "map identity mismatch")
assert(#map.sublevels == 8 and #raid.sublevels == 8, "Black Temple must expose the training grounds and seven interior floors")
local linkCount = 0
for sublevel, links in pairs(map.links) do
  linkCount = linkCount + #links
  for _, link in ipairs(links) do
    local reverse
    for _, candidate in ipairs(map.links[link.target] or {}) do
      if candidate.target == sublevel then reverse = true break end
    end
    assert(reverse, "Black Temple floor transition has no return link")
  end
end
assert(linkCount == 14 and #map.links[3] == 4, "Black Temple floor transitions missing")
local expectedLinks = {
  [1] = { { 0.279, 0.088, 2, -1 } },
  [2] = { { 0.279, 0.780, 1, 1 }, { 0.690, 0.475, 3, 2 } },
  [3] = { { 0.269, 0.228, 6, 1 }, { 0.632, 0.349, 4, 2 },
    { 0.233, 0.516, 2, -2 }, { 0.574, 0.921, 5, -2 } },
  [4] = { { 0.623, 0.398, 3, -2 } },
  [5] = { { 0.690, 0.689, 3, 2 } },
  [6] = { { 0.084, 0.471, 3, -1 }, { 0.673, 0.581, 7, 1 } },
  [7] = { { 0.694, 0.126, 6, -1 }, { 0.475, 0.271, 8, -1 } },
  [8] = { { 0.530, 0.103, 7, -1 } },
}
for sublevel, expected in pairs(expectedLinks) do
  for index, values in ipairs(expected) do
    local link = map.links[sublevel][index]
    close(link.x, values[1], 0.000001, "map link x mismatch")
    close(link.y, values[2], 0.000001, "map link y mismatch")
    assert(link.target == values[3] and link.direction == values[4], "map link target/direction mismatch")
  end
end
local uiMapIds = { 340, 339, 341, 342, 343, 344, 345, 346 }
local texturePrefixes = { "BlackTemple1_", false, "BlackTemple2_", "BlackTemple3_", "BlackTemple4_",
  "BlackTemple5_", "BlackTemple6_", "BlackTemple7_" }
local worldBounds = {
  { 1252.2495784759521, 834.8330078125, -23.87053871154785, -240, -1276.1201171875, 594.8330078125 },
  { 427.08331298828, 949.99993896484, 366.66665649414, 1150 },
  { 975, 650, 176, 380, -799, 1030 },
  { 1005, 670, 191, 400, -814, 1070 },
  { 440.0009765625, 293.333984375, -134.99951171875, 343.3330078125, -575.00048828125, 636.6669921875 },
  { 670, 446.66668701171875, 70, 664.1636352539062, -600, 1110.830322265625 },
  { 705, 470, 67.5, 450, -637.5, 920 },
  { 355, 236.6666259765625, -137.5, 606.6666870117188, -492.5, 843.3333129882812 },
}
local supremus = raid.enemies["22898"].spawns[1]
local plannerAnchors = {
  { 0.428721, 0.808477, 0.428721, 0.191523 }, -- Naj'entus
  { supremus.x, supremus.y, 0.634675, 0.471065 }, -- Supremus
  { 0.408006, 0.107070, 0.408006, 0.892930 }, -- Shade of Akama
  { 0.534252, 0.513884, 0.534252, 0.486116 }, -- Bloodboil
  { 0.392789, 0.897638, 0.392789, 0.102362 }, -- Gorefiend
  { 0.673018, 0.629439, 0.673018, 0.370561 }, -- Shahraz
  { 0.474862, 0.533487, 0.474862, 0.466513 }, -- Gathios
  { 0.250000, 0.750000, 0.250000, 0.250000 }, -- summit transform probe
}
for sublevel = 1, 8 do
  local floor = map.sublevels[sublevel]
  assert(floor.index == sublevel and floor.mapId == 564, "floor identity mismatch")
  assert(floor.uiMapId == uiMapIds[sublevel], "candidate UIMap identity mismatch")
  assert(floor.asset.textureFolder == "BlackTemple", "asset folder mismatch")
  if sublevel == 2 then
    assert(floor.asset.texturePrefix == nil, "training grounds must not claim a missing client texture")
    assert(floor.asset.customTextures:match("BlackTempleTrainingGrounds$"), "training grounds custom texture missing")
  else
    assert(floor.asset.texturePrefix == texturePrefixes[sublevel], "client texture prefix mismatch")
  end
  local calibration = transform.getCalibration(564, sublevel)
  assert(calibration and #calibration.worldBounds == #worldBounds[sublevel], "world bounds missing")
  assert(calibration.flipX == (sublevel == 2), "Black Temple texture x orientation drifted")
  assert(calibration.flipY == (sublevel ~= 2), "Black Temple texture y orientation drifted")
  if sublevel == 2 then
    close(calibration.scaleX, 1.003209118, 0.000001, "training grounds x scale mismatch")
    close(calibration.scaleY, 0.993225521, 0.000001, "training grounds y scale mismatch")
  end
  for index = 1, #worldBounds[sublevel] do
    close(calibration.worldBounds[index], worldBounds[sublevel][index], 0.000001, "world bound mismatch")
  end
  assert(calibration.provenance.confidence == "candidate", "transform confidence mismatch")
  local anchor = plannerAnchors[sublevel]
  local plannerX, plannerY = transform.toPlanner(564, sublevel, anchor[1], anchor[2])
  close(plannerX, anchor[3], 0.000001, "planner anchor x mismatch")
  close(plannerY, anchor[4], 0.000001, "planner anchor y mismatch")
end

local upperWestX, upperWestY = transform.toPlanner(564, 2, 0.777171, 0.582392)
close(upperWestX, 0.218789, 0.000001, "upper western pack x mismatch")
close(upperWestY, 0.578730, 0.000001, "upper western pack y mismatch")
local lowerWestX, lowerWestY = transform.toPlanner(564, 2, 0.750765, 0.249505)
close(lowerWestX, 0.245280, 0.000001, "lower western pack x mismatch")
close(lowerWestY, 0.248098, 0.000001, "lower western pack y mismatch")
local playerWorkerX, playerWorkerY = transform.toPlanner(564, 2, 0.774662, 0.628194)
close(playerWorkerX, 0.221306, 0.000001, "player worker x mismatch")
close(playerWorkerY, 0.624221, 0.000001, "player worker y mismatch")
local lowerWorkerX, lowerWorkerY = transform.toPlanner(564, 2, 0.672383, 0.684262)
close(lowerWorkerX, 0.323913, 0.000001, "lower worker x mismatch")
close(lowerWorkerY, 0.679909, 0.000001, "lower worker y mismatch")

for _, enemy in pairs(raid.enemies) do
  for _, spawn in ipairs(enemy.spawns) do
    local x, y = transform.toPlanner(564, spawn.sublevel, spawn.x, spawn.y)
    assert(normalized(x) and normalized(y), "spawn did not normalize")
    local roundX, roundY = transform.fromPlanner(564, spawn.sublevel, x, y)
    close(roundX, spawn.x, 0.0005, "spawn x round trip")
    close(roundY, spawn.y, 0.0005, "spawn y round trip")
    for _, point in ipairs(spawn.patrol or {}) do
      local patrolX, patrolY = transform.toPlanner(564, spawn.sublevel, point.x, point.y)
      assert(normalized(patrolX) and normalized(patrolY), "patrol point did not normalize")
    end
  end
end

local value, reason = transform.toPlanner(565, 1, 0.5, 0.5)
assert(value == nil and reason == "unknown-map-id", "unknown map accepted")
value, reason = transform.toPlanner(564, 9, 0.5, 0.5)
assert(value == nil and reason == "unknown-sublevel", "unknown floor accepted")
value, reason = transform.toPlanner(564, 1, 1 / 0, 0.5)
assert(value == nil and reason == "invalid-source-coordinate", "non-finite coordinate accepted")

assert(ART.MapDefinitions["black-temple"] == map, "map publication missing")
assert(ART.MapTransforms["black-temple"] == transform, "transform publication missing")
for tile = 1, 150 do
  local file = io.open(root.."/Raids/TBC/Textures/BlackTempleTrainingGrounds/2_"..tile..".png", "rb")
  assert(file, "training grounds tile missing: "..tile)
  file:close()
end
print("Black Temple map checks passed")
