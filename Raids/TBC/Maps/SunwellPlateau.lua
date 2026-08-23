-- Client-map inventory for TBC Anniversary 20505/20506.
local _, addon = ...
local ART = rawget(_G, "ART")
if not ART then ART = addon and addon.ART or addon or {}; _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local source = {
  source = "client-data", confidence = "candidate",
  sourceRef = "UiMapID 335, 336; LibMapData map 580",
  observedAt = "2026-08-22T12:00:00Z",
}
local floors = {
  { "Sunwell Plateau", 335, "SunwellPlateau", "SunwellPlateau" },
  { "Shrine of the Eclipse", 336, "SunwellPlateau", "SunwellPlateau1_" },
}
local sublevels = {}
for index, floor in ipairs(floors) do
  sublevels[index] = {
    index = index, mapId = 580, uiMapId = floor[2], name = floor[1],
    transformKey = "sunwell-plateau:transform:"..index,
    asset = { kind = "client-map", mapId = 580, textureFolder = floor[3],
      texturePrefix = floor[4], uiMapId = floor[2], source = source },
    source = source,
  }
end
local map = { schemaVersion = 1, raidKey = "sunwell-plateau", instanceId = 580, mapId = 580, source = source, sublevels = sublevels }
ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
