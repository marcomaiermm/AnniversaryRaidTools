-- Pure-Lua ART-080 Black Temple map and transform checks.
local root = arg and arg[1] or "."
local ART = { StaticData = { raids = {} } }
_G.ART = ART
local addon = { ART = ART }
local map = assert(loadfile(root.."/Raids/TBC/Maps/BlackTemple.lua"))("AnniversaryRaidTools", addon)
local transform = assert(loadfile(root.."/Raids/TBC/Transforms/BlackTemple.lua"))("AnniversaryRaidTools", addon)
local raid = assert(loadfile(root.."/Raids/TBC/Generated/BlackTemple.lua"))()

local function close(actual, expected, tolerance, message)
  assert(math.abs(actual - expected) <= tolerance,
    (message or "values differ")..": got "..actual..", expected "..expected)
end

local function normalized(value)
  return type(value) == "number" and value == value and value >= 0 and value <= 1
end

assert(map.raidKey == raid.key and map.mapId == raid.mapId, "map identity mismatch")
assert(#map.sublevels == 7 and #raid.sublevels == 7, "Black Temple must expose seven floors")
local uiMapIds = { 340, 341, 342, 343, 344, 345, 346 }
local worldBounds = {
  { 187.080150, 858.824850, 660.705748, 1109.049296 },
  { 430.626001, 847.944000, 332.085155, 1004.071850 },
  { 407.437457, 967.085550, -3.894115, 468.155820 },
  { 379.550447, 957.260550, 172.597654, 577.603350 },
  { 749.472150, 989.356853, 37.632015, 579.256285 },
  { 516.523600, 720.912400, 108.414655, 369.562335 },
  { 700.731995, 710.731995, 299.988007, 309.988007 },
}
local plannerAnchors = {
  { 0.824803, 0.631016, 0.824803, 0.631016 }, -- Naj'entus
  { 0.525839, 0.349381, 0.525839, 0.349381 }, -- Supremus
  { 0.404785, 0.398078, 0.404785, 0.398078 }, -- Bloodboil
  { 0.433155, 0.606913, 0.433155, 0.606913 }, -- Gorefiend
  { 0.794237, 0.183604, 0.794237, 0.183604 }, -- Shahraz
  { 0.255948, 0.098701, 0.255948, 0.098701 }, -- Gathios
  { 0.250000, 0.750000, 0.250000, 0.750000 }, -- summit transform probe
}
for sublevel = 1, 7 do
  local floor = map.sublevels[sublevel]
  assert(floor.index == sublevel and floor.mapId == 564, "floor identity mismatch")
  assert(floor.uiMapId == uiMapIds[sublevel], "candidate UIMap identity mismatch")
  assert(floor.asset.textureFolder == "BlackTemple", "asset folder mismatch")
  assert(floor.asset.texturePrefix == "BlackTemple"..sublevel.."_", "asset prefix mismatch")
  local calibration = transform.getCalibration(564, sublevel)
  assert(calibration and #calibration.worldBounds == 4, "world bounds missing")
  for index = 1, 4 do
    close(calibration.worldBounds[index], worldBounds[sublevel][index], 0.000001, "world bound mismatch")
  end
  assert(calibration.provenance.confidence == "review-required", "candidate transform overstated")
  local anchor = plannerAnchors[sublevel]
  local plannerX, plannerY = transform.toPlanner(564, sublevel, anchor[1], anchor[2])
  close(plannerX, anchor[3], 0.000001, "planner anchor x mismatch")
  close(plannerY, anchor[4], 0.000001, "planner anchor y mismatch")
end

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
value, reason = transform.toPlanner(564, 8, 0.5, 0.5)
assert(value == nil and reason == "unknown-sublevel", "unknown floor accepted")
value, reason = transform.toPlanner(564, 1, 1 / 0, 0.5)
assert(value == nil and reason == "invalid-source-coordinate", "non-finite coordinate accepted")

assert(ART.MapDefinitions["black-temple"] == map, "map publication missing")
assert(ART.MapTransforms["black-temple"] == transform, "transform publication missing")
print("Black Temple map checks passed")
