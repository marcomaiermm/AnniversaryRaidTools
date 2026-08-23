-- Client-map inventory for TBC Anniversary 20505/20506.
local _, addon = ...
local ART = rawget(_G, "ART")
if not ART then ART = addon and addon.ART or addon or {}; _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local source = {
  source = "client-data", confidence = "candidate",
  sourceRef = "UiMapID 334; LibMapData map 550",
  observedAt = "2026-08-22T12:00:00Z",
}
local floors = {
  { "The Eye", 334, "TempestKeep", "TempestKeep1_" },
}
local sublevels = {}
for index, floor in ipairs(floors) do
  sublevels[index] = {
    index = index, mapId = 550, uiMapId = floor[2], name = floor[1],
    transformKey = "the-eye:transform:"..index,
    asset = { kind = "client-map", mapId = 550, textureFolder = floor[3],
      texturePrefix = floor[4], uiMapId = floor[2], source = source },
    source = source,
  }
end
local map = { schemaVersion = 1, raidKey = "the-eye", instanceId = 550, mapId = 550, source = source, sublevels = sublevels }
ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
