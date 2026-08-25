-- Karazhan client-map inventory for TBC Anniversary 20505/20506.
local _, ART = ...

local source = {
  source = "client-data",
  confidence = "candidate",
  sourceRef = "https://warcraft.wiki.gg/wiki/UiMapID#Karazhan | https://github.com/Babilounet/SimpleDungeonMap/blob/b41181588b98391e160a0bd25531de45e5360381/DungeonData.lua#L173-L203",
  observedAt = "2026-08-21T22:15:00Z",
}

local names = {
  "Servant's Quarters", "Upper Livery Stables", "The Banquet Hall", "The Guest Chambers",
  "Opera Hall Balcony", "Master's Terrace", "Lower Broken Stair", "Upper Broken Stair",
  "The Menagerie", "Guardian's Library", "The Repository", "Upper Library",
  "The Celestial Watch", "Gamesman's Hall", "Medivh's Chambers", "The Power Station", "Netherspace",
}

local sublevels = {}
for index, name in ipairs(names) do
  sublevels[index] = {
    index = index,
    mapId = 532,
    uiMapId = 349 + index,
    name = name,
    transformKey = "karazhan:transform:"..index,
    asset = {
      kind = "client-map",
      mapId = 532,
      textureFolder = "Karazhan",
      texturePrefix = "Karazhan"..index.."_",
      source = source,
    },
    source = source,
  }
end

local map = {
  schemaVersion = 1,
  raidKey = "karazhan",
  instanceId = 532,
  mapId = 532,
  source = source,
  sublevels = sublevels,
}

ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
