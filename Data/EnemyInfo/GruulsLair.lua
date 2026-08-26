-- Sourced AzerothCore candidate data; not Anniversary-verified.
-- SourceRef: fixture://azerothcore/gruuls-lair-v1
-- ObservedAt: 2026-08-21T00:00:00Z

local source = {
  source = "azerothcore",
  confidence = "candidate",
  sourceRef = "fixture://azerothcore/gruuls-lair-v1",
  observedAt = "2026-08-21T00:00:00Z",
}

local enemyInfo = {
  raidKey = "gruuls-lair",
  source = source,
  enemies = {
    [18831] = { name = { value = "High King Maulgar", source = source } },
    [18832] = { name = { value = "Krosh Firehand", source = source } },
    [18834] = { name = { value = "Olm the Summoner", source = source } },
    [18835] = { name = { value = "Kiggler the Crazed", source = source } },
    [18836] = { name = { value = "Blindeye the Seer", source = source } },
    [19044] = { name = { value = "Gruul the Dragonkiller", source = source } },
  },
}

local _, ART = ...
if type(ART) ~= "table" then
  error("AnniversaryRaidTools static data requires Core/Bootstrap.lua to initialize ART", 2)
end
if type(ART.StaticData) ~= "table" then
  error("AnniversaryRaidTools static data requires ART.StaticData bootstrap", 2)
end
if type(ART.StaticData.enemyInfo) ~= "table" then
  error("AnniversaryRaidTools static data requires ART.StaticData.enemyInfo bootstrap", 2)
end

ART.StaticData.enemyInfo[enemyInfo.raidKey] = enemyInfo
return enemyInfo
