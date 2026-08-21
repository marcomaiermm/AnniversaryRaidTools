-- Battle for Mount Hyjal map metadata. Asset and coordinates remain candidates
-- until verified on Anniversary clients 20505 and 20506.
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
  sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz",
  observedAt = "2026-08-21T19:30:00Z",
}

-- The inventory records instance 534 as a no-floor-prefix client map.
local assetSource = {
  source = "client-data",
  confidence = "candidate",
  sourceRef = "https://github.com/Babilounet/SimpleDungeonMap/blob/b41181588b98391e160a0bd25531de45e5360381/DungeonData.lua",
  observedAt = "2026-08-21T19:30:00Z",
}

local map = {
  schemaVersion = 1,
  raidKey = "hyjal",
  instanceId = 534,
  mapId = 534,
  source = source,
  sublevels = {
    [1] = {
      index = 1,
      mapId = 534,
      name = "Hyjal Summit",
      transformKey = "hyjal:transform:1",
      asset = {
        kind = "client-map",
        mapId = 534,
        uiMapId = 329,
        textureFolder = "CoTMountHyjal",
        tilePrefix = "CoTMountHyjal",
        noFloorPrefix = true,
        source = assetSource,
      },
      source = source,
    },
  },
}

ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
