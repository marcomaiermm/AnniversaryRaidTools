-- Client-map and calibration checks for SSC, The Eye, and Sunwell.
local root = arg and arg[1] or "."
local ART = { StaticData = { raids = {} } }
_G.ART = ART
local addon = { ART = ART }
local raids = {
  { "SerpentshrineCavern", "serpentshrine-cavern", 548, { 332 }, { "CoilfangReservoir1_" } },
  { "TheEye", "the-eye", 550, { 334 }, { "TempestKeep1_" } },
  { "SunwellPlateau", "sunwell-plateau", 580, { 335, 336 }, { "SunwellPlateau1_", "SunwellPlateau2_" } },
}
for _, spec in ipairs(raids) do
  local map = assert(loadfile(root.."/Raids/TBC/Maps/"..spec[1]..".lua"))("AnniversaryRaidTools", addon)
  local transform = assert(loadfile(root.."/Raids/TBC/Transforms/"..spec[1]..".lua"))("AnniversaryRaidTools", addon)
  local raid = assert(loadfile(root.."/Raids/TBC/Generated/"..spec[1]..".lua"))()
  assert(map.raidKey == spec[2] and map.mapId == spec[3] and #map.sublevels == #spec[4])
  for floor, uiMapId in ipairs(spec[4]) do
    assert(map.sublevels[floor].asset.uiMapId == uiMapId)
    assert(map.sublevels[floor].asset.texturePrefix == spec[5][floor])
  end
  for _, enemy in pairs(raid.enemies) do for _, spawn in ipairs(enemy.spawns) do
    local x, y = assert(transform.toPlanner(spec[3], spawn.sublevel, spawn.x, spawn.y))
    local sx, sy = transform.fromPlanner(spec[3], spawn.sublevel, x, y)
    assert(math.abs(sx - spawn.x) <= 0.0005 and math.abs(sy - spawn.y) <= 0.0005)
  end end
end
print("Remaining TBC raid map checks passed")
