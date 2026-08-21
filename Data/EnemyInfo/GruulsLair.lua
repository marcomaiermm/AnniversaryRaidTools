-- Sourced AzerothCore candidate data; not Anniversary-verified.
-- SourceRef: fixture://azerothcore/gruuls-lair-v1
-- ObservedAt: 2026-08-21T00:00:00Z
-- Nnoggie's Mythic Dungeon Tools attribution and GPL-2.0 terms remain in the repository.

local source = {
  source = "azerothcore",
  confidence = "candidate",
  sourceRef = "fixture://azerothcore/gruuls-lair-v1",
  observedAt = "2026-08-21T00:00:00Z",
}

return {
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
