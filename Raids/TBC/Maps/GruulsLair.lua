-- Gruul's Lair map metadata. Coordinates remain candidate until verified in 20505/20506.
local _, addon = ...
local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local source = {
  source = "azerothcore",
  confidence = "candidate",
  sourceRef = "fixture://azerothcore/gruuls-lair-v1#map",
  observedAt = "2026-08-21T00:00:00Z",
}

-- Candidate CASC folder name from the external map-data inventory; not a client
-- verification of Anniversary map files or coordinates.
local assetSource = {
  source = "client-data",
  confidence = "candidate",
  sourceRef = "https://github.com/Babilounet/SimpleDungeonMap/blob/main/DungeonData.lua#L2185-L2249",
  observedAt = "2026-08-21T00:00:00Z",
}

local map = {
  schemaVersion = 1,
  raidKey = "gruuls-lair",
  instanceId = 565,
  mapId = 565,
  source = source,
  sublevels = {
    [1] = {
      index = 1,
      mapId = 565,
      name = "Gruul's Lair",
      transformKey = "gruuls-lair:transform:1",
      asset = {
        kind = "client-map",
        mapId = 565,
        textureFolder = "GruulsLair",
        source = assetSource,
      },
      source = source,
    },
  },
}

ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
