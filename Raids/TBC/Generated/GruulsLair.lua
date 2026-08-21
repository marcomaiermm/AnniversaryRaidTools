-- GENERATED FILE. Do not edit; rerun tools/generator/generate.py.
-- Generator: art-030-generator-v1
-- Source: AzerothCore candidate snapshot; not Anniversary-verified.
-- SourceRef: fixture://azerothcore/gruuls-lair-v1
-- ObservedAt: 2026-08-21T00:00:00Z
-- Nnoggie's Mythic Dungeon Tools attribution and GPL-2.0 terms remain in the repository.
return {
  schemaVersion = 1,
  key = "gruuls-lair",
  name = "Gruul's Lair",
  expansion = "TBC",
  instanceId = 565,
  mapId = 565,
  mode = "route",
  sublevels = {
    {
      index = 1,
      mapId = 565,
      name = "Gruul's Lair",
    },
  },
  enemies = {
    ["18831"] = {
      name = "High King Maulgar",
      npcId = 18831,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T00:00:00Z",
        source = "azerothcore",
        sourceRef = "fixture://azerothcore/gruuls-lair-v1",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18831:maulgar",
          npcId = 18831,
          packKey = "gruuls-lair:pack:maulgar",
          patrol = {
            {
              x = 0.46,
              y = 0.54,
            },
            {
              x = 0.48,
              y = 0.56,
            },
            {
              x = 0.5,
              y = 0.54,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T00:00:00Z",
            source = "azerothcore",
            sourceRef = "fixture://azerothcore/gruuls-lair-v1",
          },
          sublevel = 1,
          x = 0.48,
          y = 0.56,
        },
      },
    },
    ["18832"] = {
      name = "Krosh Firehand",
      npcId = 18832,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T00:00:00Z",
        source = "azerothcore",
        sourceRef = "fixture://azerothcore/gruuls-lair-v1",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18832:krosh",
          npcId = 18832,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T00:00:00Z",
            source = "azerothcore",
            sourceRef = "fixture://azerothcore/gruuls-lair-v1",
          },
          sublevel = 1,
          x = 0.42,
          y = 0.53,
        },
      },
    },
    ["18834"] = {
      name = "Olm the Summoner",
      npcId = 18834,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T00:00:00Z",
        source = "azerothcore",
        sourceRef = "fixture://azerothcore/gruuls-lair-v1",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18834:olm",
          npcId = 18834,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T00:00:00Z",
            source = "azerothcore",
            sourceRef = "fixture://azerothcore/gruuls-lair-v1",
          },
          sublevel = 1,
          x = 0.54,
          y = 0.53,
        },
      },
    },
    ["18835"] = {
      name = "Kiggler the Crazed",
      npcId = 18835,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T00:00:00Z",
        source = "azerothcore",
        sourceRef = "fixture://azerothcore/gruuls-lair-v1",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18835:kiggler",
          npcId = 18835,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T00:00:00Z",
            source = "azerothcore",
            sourceRef = "fixture://azerothcore/gruuls-lair-v1",
          },
          sublevel = 1,
          x = 0.42,
          y = 0.6,
        },
      },
    },
    ["18836"] = {
      name = "Blindeye the Seer",
      npcId = 18836,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T00:00:00Z",
        source = "azerothcore",
        sourceRef = "fixture://azerothcore/gruuls-lair-v1",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18836:blindeye",
          npcId = 18836,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T00:00:00Z",
            source = "azerothcore",
            sourceRef = "fixture://azerothcore/gruuls-lair-v1",
          },
          sublevel = 1,
          x = 0.54,
          y = 0.6,
        },
      },
    },
    ["19044"] = {
      name = "Gruul the Dragonkiller",
      npcId = 19044,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T00:00:00Z",
        source = "azerothcore",
        sourceRef = "fixture://azerothcore/gruuls-lair-v1",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:19044:gruul",
          npcId = 19044,
          packKey = "gruuls-lair:pack:gruul",
          patrol = {
            {
              x = 0.7,
              y = 0.42,
            },
            {
              x = 0.72,
              y = 0.44,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T00:00:00Z",
            source = "azerothcore",
            sourceRef = "fixture://azerothcore/gruuls-lair-v1",
          },
          sublevel = 1,
          x = 0.72,
          y = 0.44,
        },
      },
    },
  },
  packs = {
    ["gruuls-lair:pack:gruul"] = {
      key = "gruuls-lair:pack:gruul",
      label = "Gruul the Dragonkiller",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T00:00:00Z",
        source = "azerothcore",
        sourceRef = "fixture://azerothcore/gruuls-lair-v1",
      },
      spawnKeys = {
        "gruuls-lair:spawn:19044:gruul",
      },
    },
    ["gruuls-lair:pack:maulgar"] = {
      key = "gruuls-lair:pack:maulgar",
      label = "High King Maulgar",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T00:00:00Z",
        source = "azerothcore",
        sourceRef = "fixture://azerothcore/gruuls-lair-v1",
      },
      spawnKeys = {
        "gruuls-lair:spawn:18831:maulgar",
        "gruuls-lair:spawn:18832:krosh",
        "gruuls-lair:spawn:18834:olm",
        "gruuls-lair:spawn:18835:kiggler",
        "gruuls-lair:spawn:18836:blindeye",
      },
    },
  },
  pois = {
    [1] = {
      {
        label = "Gruul's arena",
        source = {
          confidence = "candidate",
          observedAt = "2026-08-21T00:00:00Z",
          source = "azerothcore",
          sourceRef = "fixture://azerothcore/gruuls-lair-v1",
        },
        sublevel = 1,
        x = 0.72,
        y = 0.44,
      },
    },
  },
}
