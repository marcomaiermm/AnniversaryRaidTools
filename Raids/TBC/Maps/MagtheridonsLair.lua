-- Magtheridon's Lair client-map metadata; Anniversary verification remains pending.
local _, addon = ...
local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local source = {
  source = "derived",
  confidence = "candidate",
  sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz#creature-map-544",
  observedAt = "2026-08-21T21:30:00Z",
}

local assetSource = {
  source = "client-data",
  confidence = "candidate",
  sourceRef = "https://github.com/Babilounet/SimpleDungeonMap/blob/b41181588b98391e160a0bd25531de45e5360381/DungeonData.lua#L38",
  observedAt = "2026-08-21T21:30:00Z",
}

local map = {
  schemaVersion = 1,
  raidKey = "magtheridons-lair",
  instanceId = 544,
  mapId = 544,
  source = source,
  sublevels = {
    [1] = {
      index = 1,
      mapId = 544,
      name = "Magtheridon's Lair",
      transformKey = "magtheridons-lair:transform:1",
      asset = {
        kind = "client-map",
        mapId = 544,
        uiMapId = 331,
        textureFolder = "MagtheridonsLair",
        texturePrefix = "MagtheridonsLair1_",
        source = assetSource,
      },
      source = source,
    },
  },
}

ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
