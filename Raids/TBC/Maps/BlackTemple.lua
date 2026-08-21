-- Black Temple client-map inventory; floor alignment remains candidate for 20505/20506.
local _, addon = ...
local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local source = {
  source = "client-data",
  confidence = "candidate",
  sourceRef = "https://github.com/Babilounet/SimpleDungeonMap/blob/main/DungeonData.lua#L42-L204 | https://wowwiki-archive.fandom.com/wiki/Burning_Crusade_instance_maps#Black_Temple",
  observedAt = "2026-08-21T20:50:00Z",
}

local names = {
  "Karabor Sewers",
  "Sanctuary of Shadows",
  "Halls of Anguish",
  "Gorefiend's Vigil",
  "Den of Mortal Delights",
  "Chamber of Command",
  "Temple Summit",
}

local sublevels = {}
for index, name in ipairs(names) do
  sublevels[index] = {
    index = index,
    mapId = 564,
    uiMapId = 339 + index,
    name = name,
    transformKey = "black-temple:transform:"..index,
    asset = {
      kind = "client-map",
      mapId = 564,
      textureFolder = "BlackTemple",
      texturePrefix = "BlackTemple"..index.."_",
      source = source,
    },
    source = source,
  }
end

local map = {
  schemaVersion = 1,
  raidKey = "black-temple",
  instanceId = 564,
  mapId = 564,
  source = source,
  sublevels = sublevels,
}

ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
