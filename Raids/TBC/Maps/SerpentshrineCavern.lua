-- Client-map inventory for TBC Anniversary 20505/20506.
local _, ART = ...

local source = {
  source = "client-data", confidence = "candidate",
  sourceRef = "UiMapID 332; LibMapData map 548",
  observedAt = "2026-08-22T12:00:00Z",
}
local floors = {
  { "Serpentshrine Cavern", 332, "CoilfangReservoir", "CoilfangReservoir1_" },
}
local sublevels = {}
for index, floor in ipairs(floors) do
  sublevels[index] = {
    index = index, mapId = 548, uiMapId = floor[2], name = floor[1],
    transformKey = "serpentshrine-cavern:transform:"..index,
    asset = { kind = "client-map", mapId = 548, textureFolder = floor[3],
      texturePrefix = floor[4], uiMapId = floor[2], source = source },
    source = source,
  }
end
local map = { schemaVersion = 1, raidKey = "serpentshrine-cavern", instanceId = 548, mapId = 548, source = source, sublevels = sublevels }
ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
