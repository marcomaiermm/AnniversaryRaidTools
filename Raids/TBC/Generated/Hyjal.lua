-- GENERATED FILE. Do not edit; rerun tools/generator/generate.py.
-- Generator: art-030-generator-v2
-- Source: TBC candidate snapshot; not Anniversary-verified.
-- SourceRef: https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp
-- ObservedAt: 2026-08-21T19:30:00Z
local raid = {
  schemaVersion = 1,
  key = "hyjal",
  name = "Battle for Mount Hyjal",
  expansion = "TBC",
  instanceId = 534,
  mapId = 534,
  mode = "waves",
  enemyMetadataSource = {
    confidence = "candidate",
    observedAt = "2026-08-23T00:00:00Z",
    source = "azerothcore",
    sourceRef = "azerothcore-wotlk@361ff97e5d2fbb4976d1bf18db09763a683309ca#creature_template,creature_template_model,creature_classlevelstats",
  },
  sublevels = {
    {
      index = 1,
      mapId = 534,
      name = "Hyjal Summit",
    },
  },
  enemies = {
    ["17767"] = {
      characteristics = {},
      creatureType = "Undead",
      displayId = 17444,
      health = 4249000,
      level = 73,
      name = "Rage Winterchill",
      npcId = 17767,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17767:rage-winterchill-17767-01",
          npcId = 17767,
          packKey = "hyjal:pack:rage-winterchill",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979168,
          y = 0.725767,
        },
      },
      spells = {
        [26662] = {},
        [31249] = {},
        [31250] = {},
        [31256] = {},
        [31258] = {},
      },
    },
    ["17808"] = {
      characteristics = {},
      creatureType = "Demon",
      displayId = 21069,
      health = 4249000,
      level = 73,
      name = "Anetheron",
      npcId = 17808,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17808:anetheron-17808-01",
          npcId = 17808,
          packKey = "hyjal:pack:anetheron",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980264,
          y = 0.724247,
        },
      },
      spells = {
        [26662] = {},
        [31298] = {},
        [31299] = {},
        [31302] = {},
        [31304] = {},
        [31306] = {},
        [31317] = {},
        [38061] = {},
        [39346] = {},
      },
    },
    ["17842"] = {
      characteristics = {},
      creatureType = "Demon",
      displayId = 18526,
      health = 4249000,
      level = 73,
      name = "Azgalor",
      npcId = 17842,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17842:azgalor-17842-01",
          npcId = 17842,
          packKey = "hyjal:pack:azgalor",
          patrol = {
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.614324,
          y = 0.371526,
        },
      },
      spells = {
        [26662] = {},
        [31340] = {},
        [31344] = {},
        [31345] = {},
        [31347] = {},
        [40505] = {},
        [42023] = {},
      },
    },
    ["17888"] = {
      characteristics = {},
      creatureType = "Demon",
      displayId = 17886,
      health = 4249000,
      level = 73,
      name = "Kaz'rogal",
      npcId = 17888,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17888:kazrogal-17888-01",
          npcId = 17888,
          packKey = "hyjal:pack:kazrogal",
          patrol = {
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.614303,
          y = 0.371708,
        },
      },
      spells = {
        [31436] = {},
        [31447] = {},
        [31477] = {},
        [31480] = {},
        [40936] = {},
      },
    },
    ["17895"] = {
      characteristics = {
        Disorient = true,
        Root = true,
        ["Shackle Undead"] = true,
        Silence = true,
        Slow = true,
        Stun = true,
        ["Turn Evil"] = true,
      },
      creatureType = "Undead",
      displayId = 571,
      health = 139720,
      level = 70,
      name = "Ghoul",
      npcId = 17895,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973326,
          y = 0.732114,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975724,
          y = 0.734746,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975209,
          y = 0.729995,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977343,
          y = 0.732916,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976343,
          y = 0.726319,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977674,
          y = 0.729602,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-07",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978294,
          y = 0.724764,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-08",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979873,
          y = 0.728367,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-09",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979809,
          y = 0.731945,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-17895-10",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978193,
          y = 0.734975,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976358,
          y = 0.737657,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974932,
          y = 0.735834,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973338,
          y = 0.733263,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.971687,
          y = 0.731051,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978074,
          y = 0.73529,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976798,
          y = 0.732675,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-07",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97514,
          y = 0.730447,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-08",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97284,
          y = 0.728209,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-09",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973448,
          y = 0.737588,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-10",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.971682,
          y = 0.735425,
        },
        {
          key = "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.96992,
          y = 0.731273,
        },
        {
          key = "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.971917,
          y = 0.733149,
        },
        {
          key = "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972795,
          y = 0.736952,
        },
        {
          key = "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974641,
          y = 0.738779,
        },
        {
          key = "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975333,
          y = 0.742835,
        },
        {
          key = "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978081,
          y = 0.744556,
        },
        {
          key = "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975395,
          y = 0.740829,
        },
        {
          key = "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977406,
          y = 0.742114,
        },
        {
          key = "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973782,
          y = 0.738908,
        },
        {
          key = "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972009,
          y = 0.736814,
        },
        {
          key = "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.970691,
          y = 0.73434,
        },
        {
          key = "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.969388,
          y = 0.73157,
        },
        {
          key = "hyjal:spawn:17895:winterchill-crypt-necromancer-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973813,
          y = 0.736589,
        },
        {
          key = "hyjal:spawn:17895:winterchill-crypt-necromancer-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972875,
          y = 0.733766,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.970538,
          y = 0.728596,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.971031,
          y = 0.730569,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972186,
          y = 0.734068,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973183,
          y = 0.736537,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974099,
          y = 0.7383,
        },
        {
          key = "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97569,
          y = 0.740851,
        },
        {
          key = "hyjal:spawn:17895:winterchill-abomination-necromancer-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.970978,
          y = 0.731621,
        },
        {
          key = "hyjal:spawn:17895:winterchill-abomination-necromancer-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972404,
          y = 0.733894,
        },
        {
          key = "hyjal:spawn:17895:winterchill-abomination-necromancer-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973952,
          y = 0.735891,
        },
        {
          key = "hyjal:spawn:17895:winterchill-abomination-necromancer-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975511,
          y = 0.737928,
        },
        {
          key = "hyjal:spawn:17895:winterchill-combined-assault-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972314,
          y = 0.728292,
        },
        {
          key = "hyjal:spawn:17895:winterchill-combined-assault-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973165,
          y = 0.730509,
        },
        {
          key = "hyjal:spawn:17895:winterchill-combined-assault-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973595,
          y = 0.733337,
        },
        {
          key = "hyjal:spawn:17895:winterchill-combined-assault-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973526,
          y = 0.735409,
        },
        {
          key = "hyjal:spawn:17895:winterchill-combined-assault-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973791,
          y = 0.738856,
        },
        {
          key = "hyjal:spawn:17895:winterchill-combined-assault-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974354,
          y = 0.741982,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972866,
          y = 0.727728,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974092,
          y = 0.730051,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975418,
          y = 0.73272,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976685,
          y = 0.735418,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977919,
          y = 0.737608,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974536,
          y = 0.724642,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-07",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97625,
          y = 0.72668,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-08",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977766,
          y = 0.729455,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-09",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979145,
          y = 0.732899,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghouls-17895-10",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghouls",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980554,
          y = 0.735407,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.970968,
          y = 0.730399,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972409,
          y = 0.732718,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973345,
          y = 0.734258,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974407,
          y = 0.736564,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975706,
          y = 0.738344,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977014,
          y = 0.740642,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-07",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.971685,
          y = 0.735589,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-08",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973922,
          y = 0.738856,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-crypt-necromancer-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.971203,
          y = 0.7318,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-crypt-necromancer-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972595,
          y = 0.734219,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-crypt-necromancer-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974253,
          y = 0.736847,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-crypt-necromancer-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975897,
          y = 0.739565,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97262,
          y = 0.727326,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973928,
          y = 0.729208,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975757,
          y = 0.731555,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977319,
          y = 0.733834,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978567,
          y = 0.735875,
        },
        {
          key = "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980161,
          y = 0.738424,
        },
        {
          key = "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973166,
          y = 0.725941,
        },
        {
          key = "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974365,
          y = 0.728166,
        },
        {
          key = "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975353,
          y = 0.7306,
        },
        {
          key = "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976583,
          y = 0.733073,
        },
        {
          key = "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977502,
          y = 0.735546,
        },
        {
          key = "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978538,
          y = 0.737966,
        },
        {
          key = "hyjal:spawn:17895:anetheron-banshee-abomination-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974621,
          y = 0.73258,
        },
        {
          key = "hyjal:spawn:17895:anetheron-banshee-abomination-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976171,
          y = 0.734513,
        },
        {
          key = "hyjal:spawn:17895:anetheron-combined-assault-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972575,
          y = 0.730705,
        },
        {
          key = "hyjal:spawn:17895:anetheron-combined-assault-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974356,
          y = 0.733793,
        },
        {
          key = "hyjal:spawn:17895:anetheron-combined-assault-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976314,
          y = 0.737092,
        },
        {
          key = "hyjal:spawn:17895:anetheron-combined-assault-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977996,
          y = 0.740518,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.63658,
          y = 0.404382,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637847,
          y = 0.402067,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638908,
          y = 0.399874,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64034,
          y = 0.397877,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641366,
          y = 0.395294,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642745,
          y = 0.393538,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-gargoyle-introduction-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.635927,
          y = 0.403333,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-gargoyle-introduction-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638566,
          y = 0.39851,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-gargoyle-introduction-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.639964,
          y = 0.396516,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-gargoyle-introduction-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642152,
          y = 0.392527,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-crypt-assault-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.636239,
          y = 0.403522,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-crypt-assault-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637439,
          y = 0.401179,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-crypt-assault-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638148,
          y = 0.399437,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-crypt-assault-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640047,
          y = 0.396824,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-crypt-assault-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640638,
          y = 0.395261,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-crypt-assault-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642136,
          y = 0.393736,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-abomination-assault-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637551,
          y = 0.400087,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-abomination-assault-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638482,
          y = 0.39807,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-abomination-assault-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.639333,
          y = 0.396681,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-abomination-assault-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64023,
          y = 0.394285,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637091,
          y = 0.401227,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638123,
          y = 0.399428,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.639535,
          y = 0.397627,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640655,
          y = 0.394687,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641947,
          y = 0.393708,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.643382,
          y = 0.390818,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-combined-assault-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637715,
          y = 0.400915,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-combined-assault-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638647,
          y = 0.398918,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-combined-assault-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.639745,
          y = 0.397147,
        },
        {
          key = "hyjal:spawn:17895:kazrogal-combined-assault-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64077,
          y = 0.395392,
        },
        {
          key = "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637907,
          y = 0.402145,
        },
        {
          key = "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.639026,
          y = 0.400122,
        },
        {
          key = "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640438,
          y = 0.397934,
        },
        {
          key = "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641507,
          y = 0.395452,
        },
        {
          key = "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642887,
          y = 0.393611,
        },
        {
          key = "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.636266,
          y = 0.404089,
        },
        {
          key = "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637467,
          y = 0.401716,
        },
        {
          key = "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.63848,
          y = 0.399836,
        },
        {
          key = "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-04",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640085,
          y = 0.39755,
        },
        {
          key = "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-05",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641055,
          y = 0.395386,
        },
        {
          key = "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-06",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642483,
          y = 0.393466,
        },
        {
          key = "hyjal:spawn:17895:azgalor-mixed-infernals-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640054,
          y = 0.397579,
        },
        {
          key = "hyjal:spawn:17895:azgalor-mixed-infernals-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641231,
          y = 0.394795,
        },
        {
          key = "hyjal:spawn:17895:archimonde-night-elf-ghouls-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:archimonde-night-elf-ghouls",
          patrol = {
            {
              x = 0.270745,
              y = 0.454988,
            },
            {
              x = 0.264538,
              y = 0.449264,
            },
            {
              x = 0.257275,
              y = 0.445856,
            },
            {
              x = 0.252031,
              y = 0.448964,
            },
            {
              x = 0.246799,
              y = 0.454748,
            },
            {
              x = 0.243875,
              y = 0.462476,
            },
            {
              x = 0.243614,
              y = 0.47546,
            },
            {
              x = 0.246561,
              y = 0.485606,
            },
            {
              x = 0.252827,
              y = 0.499322,
            },
            {
              x = 0.257259,
              y = 0.51899,
            },
            {
              x = 0.25639,
              y = 0.53453,
            },
            {
              x = 0.25655,
              y = 0.551498,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.289057,
          y = 0.457998,
        },
        {
          key = "hyjal:spawn:17895:archimonde-night-elf-ghouls-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:archimonde-night-elf-ghouls",
          patrol = {
            {
              x = 0.270745,
              y = 0.454988,
            },
            {
              x = 0.264538,
              y = 0.449264,
            },
            {
              x = 0.257275,
              y = 0.445856,
            },
            {
              x = 0.252031,
              y = 0.448964,
            },
            {
              x = 0.246799,
              y = 0.454748,
            },
            {
              x = 0.243875,
              y = 0.462476,
            },
            {
              x = 0.243614,
              y = 0.47546,
            },
            {
              x = 0.246561,
              y = 0.485606,
            },
            {
              x = 0.252827,
              y = 0.499322,
            },
            {
              x = 0.257259,
              y = 0.51899,
            },
            {
              x = 0.25639,
              y = 0.53453,
            },
            {
              x = 0.25655,
              y = 0.551498,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.286853,
          y = 0.4645,
        },
        {
          key = "hyjal:spawn:17895:archimonde-night-elf-ghouls-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:archimonde-night-elf-ghouls",
          patrol = {
            {
              x = 0.270745,
              y = 0.454988,
            },
            {
              x = 0.264538,
              y = 0.449264,
            },
            {
              x = 0.257275,
              y = 0.445856,
            },
            {
              x = 0.252031,
              y = 0.448964,
            },
            {
              x = 0.246799,
              y = 0.454748,
            },
            {
              x = 0.243875,
              y = 0.462476,
            },
            {
              x = 0.243614,
              y = 0.47546,
            },
            {
              x = 0.246561,
              y = 0.485606,
            },
            {
              x = 0.252827,
              y = 0.499322,
            },
            {
              x = 0.257259,
              y = 0.51899,
            },
            {
              x = 0.25639,
              y = 0.53453,
            },
            {
              x = 0.25655,
              y = 0.551498,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.290195,
          y = 0.463731,
        },
        {
          key = "hyjal:spawn:17895:archimonde-night-elf-ghoul-abomination-17895-01",
          npcId = 17895,
          packKey = "hyjal:pack:archimonde-night-elf-ghoul-abomination",
          patrol = {
            {
              x = 0.270745,
              y = 0.454988,
            },
            {
              x = 0.264538,
              y = 0.449264,
            },
            {
              x = 0.257275,
              y = 0.445856,
            },
            {
              x = 0.252031,
              y = 0.448964,
            },
            {
              x = 0.246799,
              y = 0.454748,
            },
            {
              x = 0.243875,
              y = 0.462476,
            },
            {
              x = 0.243614,
              y = 0.47546,
            },
            {
              x = 0.246561,
              y = 0.485606,
            },
            {
              x = 0.252827,
              y = 0.499322,
            },
            {
              x = 0.257259,
              y = 0.51899,
            },
            {
              x = 0.25639,
              y = 0.53453,
            },
            {
              x = 0.25655,
              y = 0.551498,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.288853,
          y = 0.468281,
        },
        {
          key = "hyjal:spawn:17895:archimonde-night-elf-ghoul-abomination-17895-02",
          npcId = 17895,
          packKey = "hyjal:pack:archimonde-night-elf-ghoul-abomination",
          patrol = {
            {
              x = 0.270745,
              y = 0.454988,
            },
            {
              x = 0.264538,
              y = 0.449264,
            },
            {
              x = 0.257275,
              y = 0.445856,
            },
            {
              x = 0.252031,
              y = 0.448964,
            },
            {
              x = 0.246799,
              y = 0.454748,
            },
            {
              x = 0.243875,
              y = 0.462476,
            },
            {
              x = 0.243614,
              y = 0.47546,
            },
            {
              x = 0.246561,
              y = 0.485606,
            },
            {
              x = 0.252827,
              y = 0.499322,
            },
            {
              x = 0.257259,
              y = 0.51899,
            },
            {
              x = 0.25639,
              y = 0.53453,
            },
            {
              x = 0.25655,
              y = 0.551498,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.293287,
          y = 0.463358,
        },
        {
          key = "hyjal:spawn:17895:archimonde-night-elf-ghoul-abomination-17895-03",
          npcId = 17895,
          packKey = "hyjal:pack:archimonde-night-elf-ghoul-abomination",
          patrol = {
            {
              x = 0.270745,
              y = 0.454988,
            },
            {
              x = 0.264538,
              y = 0.449264,
            },
            {
              x = 0.257275,
              y = 0.445856,
            },
            {
              x = 0.252031,
              y = 0.448964,
            },
            {
              x = 0.246799,
              y = 0.454748,
            },
            {
              x = 0.243875,
              y = 0.462476,
            },
            {
              x = 0.243614,
              y = 0.47546,
            },
            {
              x = 0.246561,
              y = 0.485606,
            },
            {
              x = 0.252827,
              y = 0.499322,
            },
            {
              x = 0.257259,
              y = 0.51899,
            },
            {
              x = 0.25639,
              y = 0.53453,
            },
            {
              x = 0.25655,
              y = 0.551498,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.292402,
          y = 0.468353,
        },
      },
      spells = {
        [21727] = {},
        [31537] = {},
        [31540] = {},
      },
    },
    ["17897"] = {
      characteristics = {
        Disorient = true,
        Root = true,
        ["Shackle Undead"] = true,
        Silence = true,
        Slow = true,
        Stun = true,
        ["Turn Evil"] = true,
      },
      creatureType = "Undead",
      displayId = 17308,
      health = 174650,
      level = 70,
      name = "Crypt Fiend",
      npcId = 17897,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17897:winterchill-ghouls-crypt-pair-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978631,
          y = 0.731539,
        },
        {
          key = "hyjal:spawn:17897:winterchill-ghouls-crypt-pair-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-ghouls-crypt-pair",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975642,
          y = 0.727302,
        },
        {
          key = "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97129,
          y = 0.728651,
        },
        {
          key = "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973276,
          y = 0.731531,
        },
        {
          key = "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975475,
          y = 0.734655,
        },
        {
          key = "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976587,
          y = 0.739553,
        },
        {
          key = "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-05",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974726,
          y = 0.727012,
        },
        {
          key = "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-06",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-split-ghoul-crypt",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977651,
          y = 0.731132,
        },
        {
          key = "hyjal:spawn:17897:winterchill-necromancer-introduction-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978024,
          y = 0.737831,
        },
        {
          key = "hyjal:spawn:17897:winterchill-necromancer-introduction-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977778,
          y = 0.731694,
        },
        {
          key = "hyjal:spawn:17897:winterchill-necromancer-introduction-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975455,
          y = 0.728966,
        },
        {
          key = "hyjal:spawn:17897:winterchill-necromancer-introduction-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97186,
          y = 0.728801,
        },
        {
          key = "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977714,
          y = 0.737899,
        },
        {
          key = "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976718,
          y = 0.735187,
        },
        {
          key = "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974918,
          y = 0.732226,
        },
        {
          key = "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973396,
          y = 0.728626,
        },
        {
          key = "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-05",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979127,
          y = 0.732947,
        },
        {
          key = "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-06",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977114,
          y = 0.728555,
        },
        {
          key = "hyjal:spawn:17897:winterchill-combined-assault-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974792,
          y = 0.727988,
        },
        {
          key = "hyjal:spawn:17897:winterchill-combined-assault-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975868,
          y = 0.732421,
        },
        {
          key = "hyjal:spawn:17897:winterchill-combined-assault-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976042,
          y = 0.736823,
        },
        {
          key = "hyjal:spawn:17897:winterchill-combined-assault-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976497,
          y = 0.740729,
        },
        {
          key = "hyjal:spawn:17897:anetheron-ghoul-crypt-necromancer-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972681,
          y = 0.728525,
        },
        {
          key = "hyjal:spawn:17897:anetheron-ghoul-crypt-necromancer-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97425,
          y = 0.731199,
        },
        {
          key = "hyjal:spawn:17897:anetheron-ghoul-crypt-necromancer-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976005,
          y = 0.734413,
        },
        {
          key = "hyjal:spawn:17897:anetheron-ghoul-crypt-necromancer-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977827,
          y = 0.737465,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-introduction-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975278,
          y = 0.72409,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-introduction-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97727,
          y = 0.72744,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-introduction-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978809,
          y = 0.730733,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-introduction-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.9804,
          y = 0.734623,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-introduction-17897-05",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979279,
          y = 0.723463,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-introduction-17897-06",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.981434,
          y = 0.727436,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-abomination-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972916,
          y = 0.73,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-abomination-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97762,
          y = 0.737001,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-abomination-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974218,
          y = 0.726707,
        },
        {
          key = "hyjal:spawn:17897:anetheron-banshee-abomination-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976286,
          y = 0.728998,
        },
        {
          key = "hyjal:spawn:17897:anetheron-combined-assault-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977687,
          y = 0.72782,
        },
        {
          key = "hyjal:spawn:17897:anetheron-combined-assault-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979957,
          y = 0.731262,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-crypt-assault-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64164,
          y = 0.407876,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-crypt-assault-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.645837,
          y = 0.400072,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-crypt-assault-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638353,
          y = 0.407029,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-crypt-assault-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640481,
          y = 0.40294,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-crypt-assault-17897-05",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642445,
          y = 0.398966,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-crypt-assault-17897-06",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644451,
          y = 0.395614,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64156,
          y = 0.40807,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.645935,
          y = 0.400175,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638521,
          y = 0.406942,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64042,
          y = 0.403171,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-05",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642517,
          y = 0.398875,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-06",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644733,
          y = 0.394968,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-combined-assault-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641507,
          y = 0.408938,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-combined-assault-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642827,
          y = 0.405634,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-combined-assault-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644928,
          y = 0.401602,
        },
        {
          key = "hyjal:spawn:17897:kazrogal-combined-assault-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.646772,
          y = 0.398546,
        },
        {
          key = "hyjal:spawn:17897:azgalor-mixed-infernals-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640678,
          y = 0.40326,
        },
        {
          key = "hyjal:spawn:17897:azgalor-mixed-infernals-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642685,
          y = 0.399473,
        },
        {
          key = "hyjal:spawn:17897:azgalor-combined-assault-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638485,
          y = 0.406477,
        },
        {
          key = "hyjal:spawn:17897:azgalor-combined-assault-17897-02",
          npcId = 17897,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64228,
          y = 0.399278,
        },
        {
          key = "hyjal:spawn:17897:azgalor-combined-assault-17897-03",
          npcId = 17897,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644642,
          y = 0.394873,
        },
        {
          key = "hyjal:spawn:17897:azgalor-combined-assault-17897-04",
          npcId = 17897,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64069,
          y = 0.402582,
        },
        {
          key = "hyjal:spawn:17897:archimonde-night-elf-crypt-fiend-17897-01",
          npcId = 17897,
          packKey = "hyjal:pack:archimonde-night-elf-crypt-fiend",
          patrol = {
            {
              x = 0.270745,
              y = 0.454988,
            },
            {
              x = 0.264538,
              y = 0.449264,
            },
            {
              x = 0.257275,
              y = 0.445856,
            },
            {
              x = 0.252031,
              y = 0.448964,
            },
            {
              x = 0.246799,
              y = 0.454748,
            },
            {
              x = 0.243875,
              y = 0.462476,
            },
            {
              x = 0.243614,
              y = 0.47546,
            },
            {
              x = 0.246561,
              y = 0.485606,
            },
            {
              x = 0.252827,
              y = 0.499322,
            },
            {
              x = 0.257259,
              y = 0.51899,
            },
            {
              x = 0.25639,
              y = 0.53453,
            },
            {
              x = 0.25655,
              y = 0.551498,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.297803,
          y = 0.464403,
        },
      },
      spells = {
        [21727] = {},
      },
    },
    ["17898"] = {
      characteristics = {
        Disorient = true,
        Root = true,
        ["Shackle Undead"] = true,
        Silence = true,
        Slow = true,
        Stun = true,
        ["Turn Evil"] = true,
      },
      creatureType = "Undead",
      displayId = 12818,
      health = 179525,
      level = 71,
      name = "Abomination",
      npcId = 17898,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972735,
          y = 0.726954,
        },
        {
          key = "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973426,
          y = 0.730217,
        },
        {
          key = "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975018,
          y = 0.734574,
        },
        {
          key = "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976417,
          y = 0.73793,
        },
        {
          key = "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-05",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975684,
          y = 0.727429,
        },
        {
          key = "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-06",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977695,
          y = 0.734227,
        },
        {
          key = "hyjal:spawn:17898:winterchill-abomination-necromancer-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.9721,
          y = 0.728388,
        },
        {
          key = "hyjal:spawn:17898:winterchill-abomination-necromancer-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974,
          y = 0.730727,
        },
        {
          key = "hyjal:spawn:17898:winterchill-abomination-necromancer-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975691,
          y = 0.733385,
        },
        {
          key = "hyjal:spawn:17898:winterchill-abomination-necromancer-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977966,
          y = 0.736414,
        },
        {
          key = "hyjal:spawn:17898:winterchill-combined-assault-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97835,
          y = 0.729615,
        },
        {
          key = "hyjal:spawn:17898:winterchill-combined-assault-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979101,
          y = 0.734424,
        },
        {
          key = "hyjal:spawn:17898:anetheron-ghoul-abomination-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972824,
          y = 0.727286,
        },
        {
          key = "hyjal:spawn:17898:anetheron-ghoul-abomination-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974478,
          y = 0.729901,
        },
        {
          key = "hyjal:spawn:17898:anetheron-ghoul-abomination-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976491,
          y = 0.73382,
        },
        {
          key = "hyjal:spawn:17898:anetheron-ghoul-abomination-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-ghoul-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977972,
          y = 0.73686,
        },
        {
          key = "hyjal:spawn:17898:anetheron-abomination-necromancer-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977052,
          y = 0.727529,
        },
        {
          key = "hyjal:spawn:17898:anetheron-abomination-necromancer-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979048,
          y = 0.731561,
        },
        {
          key = "hyjal:spawn:17898:anetheron-banshee-abomination-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977686,
          y = 0.731755,
        },
        {
          key = "hyjal:spawn:17898:anetheron-banshee-abomination-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979786,
          y = 0.734737,
        },
        {
          key = "hyjal:spawn:17898:anetheron-banshee-abomination-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976278,
          y = 0.722998,
        },
        {
          key = "hyjal:spawn:17898:anetheron-banshee-abomination-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978047,
          y = 0.725738,
        },
        {
          key = "hyjal:spawn:17898:anetheron-combined-assault-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974111,
          y = 0.727847,
        },
        {
          key = "hyjal:spawn:17898:anetheron-combined-assault-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976105,
          y = 0.731462,
        },
        {
          key = "hyjal:spawn:17898:anetheron-combined-assault-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97768,
          y = 0.734712,
        },
        {
          key = "hyjal:spawn:17898:anetheron-combined-assault-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.979414,
          y = 0.738626,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-undead-vanguard-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638544,
          y = 0.407622,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-undead-vanguard-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640906,
          y = 0.40363,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-undead-vanguard-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.643009,
          y = 0.399454,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-undead-vanguard-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64508,
          y = 0.39562,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-abomination-assault-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641097,
          y = 0.407446,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-abomination-assault-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.645343,
          y = 0.39963,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-abomination-assault-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637908,
          y = 0.406168,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-abomination-assault-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640017,
          y = 0.402237,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-abomination-assault-17898-05",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641918,
          y = 0.398303,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-abomination-assault-17898-06",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.643828,
          y = 0.395491,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-frost-wyrm-assault-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638256,
          y = 0.406446,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-frost-wyrm-assault-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640313,
          y = 0.402848,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-frost-wyrm-assault-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642137,
          y = 0.399133,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-frost-wyrm-assault-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644524,
          y = 0.394568,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-combined-assault-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638425,
          y = 0.406789,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-combined-assault-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640752,
          y = 0.40266,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-combined-assault-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642655,
          y = 0.398565,
        },
        {
          key = "hyjal:spawn:17898:kazrogal-combined-assault-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644437,
          y = 0.395716,
        },
        {
          key = "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641578,
          y = 0.407807,
        },
        {
          key = "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.645665,
          y = 0.400323,
        },
        {
          key = "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638133,
          y = 0.406922,
        },
        {
          key = "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640313,
          y = 0.403142,
        },
        {
          key = "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-05",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642274,
          y = 0.399258,
        },
        {
          key = "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-06",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644424,
          y = 0.395248,
        },
        {
          key = "hyjal:spawn:17898:azgalor-fel-stalker-abominations-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638416,
          y = 0.407237,
        },
        {
          key = "hyjal:spawn:17898:azgalor-fel-stalker-abominations-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640826,
          y = 0.403144,
        },
        {
          key = "hyjal:spawn:17898:azgalor-fel-stalker-abominations-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64265,
          y = 0.399465,
        },
        {
          key = "hyjal:spawn:17898:azgalor-fel-stalker-abominations-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644941,
          y = 0.395139,
        },
        {
          key = "hyjal:spawn:17898:azgalor-combined-assault-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641443,
          y = 0.408641,
        },
        {
          key = "hyjal:spawn:17898:azgalor-combined-assault-17898-02",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64274,
          y = 0.405437,
        },
        {
          key = "hyjal:spawn:17898:azgalor-combined-assault-17898-03",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64497,
          y = 0.401518,
        },
        {
          key = "hyjal:spawn:17898:azgalor-combined-assault-17898-04",
          npcId = 17898,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.646685,
          y = 0.398372,
        },
        {
          key = "hyjal:spawn:17898:archimonde-night-elf-ghoul-abomination-17898-01",
          npcId = 17898,
          packKey = "hyjal:pack:archimonde-night-elf-ghoul-abomination",
          patrol = {
            {
              x = 0.270745,
              y = 0.454988,
            },
            {
              x = 0.264538,
              y = 0.449264,
            },
            {
              x = 0.257275,
              y = 0.445856,
            },
            {
              x = 0.252031,
              y = 0.448964,
            },
            {
              x = 0.246799,
              y = 0.454748,
            },
            {
              x = 0.243875,
              y = 0.462476,
            },
            {
              x = 0.243614,
              y = 0.47546,
            },
            {
              x = 0.246561,
              y = 0.485606,
            },
            {
              x = 0.252827,
              y = 0.499322,
            },
            {
              x = 0.257259,
              y = 0.51899,
            },
            {
              x = 0.25639,
              y = 0.53453,
            },
            {
              x = 0.25655,
              y = 0.551498,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.29565,
          y = 0.470766,
        },
      },
      spells = {
        [21727] = {},
        [31607] = {},
        [31610] = {},
      },
    },
    ["17899"] = {
      characteristics = {
        Disorient = true,
        Fear = true,
        ["Mind Control"] = true,
        Polymorph = true,
        Repentance = true,
        Root = true,
        Sap = true,
        Silence = true,
        Slow = true,
        Stun = true,
      },
      creatureType = "Humanoid",
      displayId = 17537,
      health = 120000,
      level = 70,
      name = "Shadowy Necromancer",
      npcId = 17899,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17899:winterchill-necromancer-introduction-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975917,
          y = 0.735506,
        },
        {
          key = "hyjal:spawn:17899:winterchill-necromancer-introduction-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-necromancer-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974023,
          y = 0.733335,
        },
        {
          key = "hyjal:spawn:17899:winterchill-crypt-necromancer-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.974837,
          y = 0.738377,
        },
        {
          key = "hyjal:spawn:17899:winterchill-crypt-necromancer-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975628,
          y = 0.739831,
        },
        {
          key = "hyjal:spawn:17899:winterchill-crypt-necromancer-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972258,
          y = 0.731915,
        },
        {
          key = "hyjal:spawn:17899:winterchill-crypt-necromancer-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.971135,
          y = 0.729381,
        },
        {
          key = "hyjal:spawn:17899:winterchill-abomination-necromancer-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.971958,
          y = 0.730966,
        },
        {
          key = "hyjal:spawn:17899:winterchill-abomination-necromancer-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.972969,
          y = 0.732137,
        },
        {
          key = "hyjal:spawn:17899:winterchill-abomination-necromancer-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975402,
          y = 0.735623,
        },
        {
          key = "hyjal:spawn:17899:winterchill-abomination-necromancer-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975967,
          y = 0.736322,
        },
        {
          key = "hyjal:spawn:17899:winterchill-combined-assault-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977347,
          y = 0.725545,
        },
        {
          key = "hyjal:spawn:17899:winterchill-combined-assault-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:winterchill-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.98019,
          y = 0.737923,
        },
        {
          key = "hyjal:spawn:17899:anetheron-ghoul-crypt-necromancer-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975131,
          y = 0.724855,
        },
        {
          key = "hyjal:spawn:17899:anetheron-ghoul-crypt-necromancer-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.976739,
          y = 0.727354,
        },
        {
          key = "hyjal:spawn:17899:anetheron-ghoul-crypt-necromancer-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978697,
          y = 0.730735,
        },
        {
          key = "hyjal:spawn:17899:anetheron-ghoul-crypt-necromancer-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980562,
          y = 0.733913,
        },
        {
          key = "hyjal:spawn:17899:anetheron-banshee-introduction-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973664,
          y = 0.727816,
        },
        {
          key = "hyjal:spawn:17899:anetheron-banshee-introduction-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975655,
          y = 0.730753,
        },
        {
          key = "hyjal:spawn:17899:anetheron-banshee-introduction-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977174,
          y = 0.733797,
        },
        {
          key = "hyjal:spawn:17899:anetheron-banshee-introduction-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978501,
          y = 0.736508,
        },
        {
          key = "hyjal:spawn:17899:anetheron-ghoul-banshee-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978082,
          y = 0.724612,
        },
        {
          key = "hyjal:spawn:17899:anetheron-ghoul-banshee-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.98131,
          y = 0.729869,
        },
        {
          key = "hyjal:spawn:17899:anetheron-abomination-necromancer-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97517,
          y = 0.725054,
        },
        {
          key = "hyjal:spawn:17899:anetheron-abomination-necromancer-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97938,
          y = 0.726113,
        },
        {
          key = "hyjal:spawn:17899:anetheron-abomination-necromancer-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980603,
          y = 0.728337,
        },
        {
          key = "hyjal:spawn:17899:anetheron-abomination-necromancer-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-abomination-necromancer",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980074,
          y = 0.734846,
        },
        {
          key = "hyjal:spawn:17899:anetheron-combined-assault-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980138,
          y = 0.724513,
        },
        {
          key = "hyjal:spawn:17899:anetheron-combined-assault-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.981815,
          y = 0.727628,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-undead-vanguard-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644453,
          y = 0.403553,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-undead-vanguard-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.645772,
          y = 0.401575,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-crypt-assault-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642905,
          y = 0.404474,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-crypt-assault-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-crypt-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644204,
          y = 0.402608,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-gargoyle-crypt-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642911,
          y = 0.404618,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-gargoyle-crypt-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644044,
          y = 0.402943,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-abomination-assault-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.635044,
          y = 0.404239,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-abomination-assault-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.63632,
          y = 0.40244,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-abomination-assault-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64155,
          y = 0.392786,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-abomination-assault-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-abomination-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642736,
          y = 0.39124,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-combined-assault-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.634938,
          y = 0.405292,
        },
        {
          key = "hyjal:spawn:17899:kazrogal-combined-assault-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.643248,
          y = 0.391913,
        },
        {
          key = "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.636146,
          y = 0.403477,
        },
        {
          key = "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637665,
          y = 0.400878,
        },
        {
          key = "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.63825,
          y = 0.399503,
        },
        {
          key = "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640081,
          y = 0.396731,
        },
        {
          key = "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-05",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641095,
          y = 0.394389,
        },
        {
          key = "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-06",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-abomination-necromancer",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642264,
          y = 0.39268,
        },
        {
          key = "hyjal:spawn:17899:azgalor-fel-stalker-abominations-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641391,
          y = 0.409353,
        },
        {
          key = "hyjal:spawn:17899:azgalor-fel-stalker-abominations-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642927,
          y = 0.405765,
        },
        {
          key = "hyjal:spawn:17899:azgalor-fel-stalker-abominations-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64509,
          y = 0.402199,
        },
        {
          key = "hyjal:spawn:17899:azgalor-fel-stalker-abominations-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64708,
          y = 0.398929,
        },
        {
          key = "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637758,
          y = 0.401727,
        },
        {
          key = "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638862,
          y = 0.399706,
        },
        {
          key = "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-03",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640135,
          y = 0.397501,
        },
        {
          key = "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-04",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641305,
          y = 0.395381,
        },
        {
          key = "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-05",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642723,
          y = 0.393486,
        },
        {
          key = "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-06",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.643892,
          y = 0.391794,
        },
        {
          key = "hyjal:spawn:17899:azgalor-combined-assault-17899-01",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.634691,
          y = 0.405364,
        },
        {
          key = "hyjal:spawn:17899:azgalor-combined-assault-17899-02",
          npcId = 17899,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.643503,
          y = 0.390914,
        },
      },
      spells = {
        [21727] = {},
        [31617] = {
          interruptible = true,
        },
        [31624] = {
          interruptible = true,
        },
        [31625] = {
          interruptible = true,
        },
        [31626] = {},
        [31627] = {
          interruptible = true,
        },
      },
    },
    ["17905"] = {
      characteristics = {
        Disorient = true,
        Root = true,
        ["Shackle Undead"] = true,
        Silence = true,
        Slow = true,
        Stun = true,
        ["Turn Evil"] = true,
      },
      creatureType = "Undead",
      displayId = 8783,
      health = 8383,
      level = 70,
      name = "Banshee",
      npcId = 17905,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17905:anetheron-banshee-introduction-17905-01",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.973936,
          y = 0.733447,
        },
        {
          key = "hyjal:spawn:17905:anetheron-banshee-introduction-17905-02",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-banshee-introduction",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.975534,
          y = 0.7363,
        },
        {
          key = "hyjal:spawn:17905:anetheron-ghoul-banshee-17905-01",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.97548,
          y = 0.726344,
        },
        {
          key = "hyjal:spawn:17905:anetheron-ghoul-banshee-17905-02",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977478,
          y = 0.728624,
        },
        {
          key = "hyjal:spawn:17905:anetheron-ghoul-banshee-17905-03",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.978855,
          y = 0.731254,
        },
        {
          key = "hyjal:spawn:17905:anetheron-ghoul-banshee-17905-04",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-ghoul-banshee",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980683,
          y = 0.733694,
        },
        {
          key = "hyjal:spawn:17905:anetheron-banshee-abomination-17905-01",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.980128,
          y = 0.728258,
        },
        {
          key = "hyjal:spawn:17905:anetheron-banshee-abomination-17905-02",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-banshee-abomination",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.981823,
          y = 0.731318,
        },
        {
          key = "hyjal:spawn:17905:anetheron-combined-assault-17905-01",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.977587,
          y = 0.72218,
        },
        {
          key = "hyjal:spawn:17905:anetheron-combined-assault-17905-02",
          npcId = 17905,
          packKey = "hyjal:pack:anetheron-combined-assault",
          patrol = {
            {
              x = 0.949002,
              y = 0.750242,
            },
            {
              x = 0.941992,
              y = 0.74969,
            },
            {
              x = 0.935119,
              y = 0.74936,
            },
            {
              x = 0.928281,
              y = 0.748232,
            },
            {
              x = 0.919181,
              y = 0.74423,
            },
            {
              x = 0.914819,
              y = 0.737378,
            },
            {
              x = 0.910881,
              y = 0.7295,
            },
            {
              x = 0.908062,
              y = 0.719696,
            },
            {
              x = 0.90706,
              y = 0.709376,
            },
            {
              x = 0.902062,
              y = 0.702026,
            },
            {
              x = 0.898417,
              y = 0.696596,
            },
            {
              x = 0.890698,
              y = 0.683078,
            },
            {
              x = 0.887322,
              y = 0.677336,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.983342,
          y = 0.731137,
        },
        {
          key = "hyjal:spawn:17905:kazrogal-undead-vanguard-17905-01",
          npcId = 17905,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642392,
          y = 0.407336,
        },
        {
          key = "hyjal:spawn:17905:kazrogal-undead-vanguard-17905-02",
          npcId = 17905,
          packKey = "hyjal:pack:kazrogal-undead-vanguard",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.643346,
          y = 0.405404,
        },
        {
          key = "hyjal:spawn:17905:kazrogal-combined-assault-17905-01",
          npcId = 17905,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.636467,
          y = 0.403292,
        },
        {
          key = "hyjal:spawn:17905:kazrogal-combined-assault-17905-02",
          npcId = 17905,
          packKey = "hyjal:pack:kazrogal-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642181,
          y = 0.393599,
        },
        {
          key = "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-01",
          npcId = 17905,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640789,
          y = 0.405039,
        },
        {
          key = "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-02",
          npcId = 17905,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641873,
          y = 0.402966,
        },
        {
          key = "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-03",
          npcId = 17905,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.643088,
          y = 0.401071,
        },
        {
          key = "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-04",
          npcId = 17905,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.644295,
          y = 0.399273,
        },
        {
          key = "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-05",
          npcId = 17905,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.645278,
          y = 0.397624,
        },
        {
          key = "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-06",
          npcId = 17905,
          packKey = "hyjal:pack:azgalor-necromancer-banshee",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.646683,
          y = 0.395788,
        },
        {
          key = "hyjal:spawn:17905:azgalor-combined-assault-17905-01",
          npcId = 17905,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.632788,
          y = 0.400016,
        },
        {
          key = "hyjal:spawn:17905:azgalor-combined-assault-17905-02",
          npcId = 17905,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640184,
          y = 0.389337,
        },
      },
      spells = {
        [21727] = {},
        [31651] = {},
        [31662] = {
          interruptible = true,
        },
        [38183] = {
          interruptible = true,
        },
      },
    },
    ["17906"] = {
      characteristics = {
        Disorient = true,
        Root = true,
        ["Shackle Undead"] = true,
        Silence = true,
        Slow = true,
        Stun = true,
        ["Turn Evil"] = true,
      },
      creatureType = "Undead",
      displayId = 17311,
      health = 125748,
      level = 70,
      name = "Gargoyle",
      npcId = 17906,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-01",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.435377,
          y = 0.193105,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-02",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.443713,
          y = 0.205966,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-03",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.44933,
          y = 0.221762,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-04",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.464195,
          y = 0.225068,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-05",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.4688,
          y = 0.219006,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-06",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.454278,
          y = 0.215742,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-07",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.438093,
          y = 0.204693,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-08",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.423709,
          y = 0.193334,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-09",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.433717,
          y = 0.2093,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-10",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-introduction",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.462397,
          y = 0.213512,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-01",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.447857,
          y = 0.211197,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-02",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.435025,
          y = 0.197302,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-03",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.438825,
          y = 0.221041,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-04",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.466533,
          y = 0.224902,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-05",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.452577,
          y = 0.218332,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-06",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-gargoyle-crypt",
          patrol = {
            {
              x = 0.44876,
              y = 0.230336,
            },
            {
              x = 0.469431,
              y = 0.31151,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.474479,
          y = 0.21667,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-aerial-assault-17906-01",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.580277,
          y = 0.455272,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-aerial-assault-17906-02",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.591425,
          y = 0.457036,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-aerial-assault-17906-03",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.587444,
          y = 0.427094,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-aerial-assault-17906-04",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.585383,
          y = 0.400726,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-aerial-assault-17906-05",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.579275,
          y = 0.432457,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-aerial-assault-17906-06",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.579841,
          y = 0.414901,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-aerial-assault-17906-07",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.574619,
          y = 0.445256,
        },
        {
          key = "hyjal:spawn:17906:kazrogal-aerial-assault-17906-08",
          npcId = 17906,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.575176,
          y = 0.415606,
        },
        {
          key = "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-01",
          npcId = 17906,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.592852,
          y = 0.442724,
        },
        {
          key = "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-02",
          npcId = 17906,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.587257,
          y = 0.42544,
        },
        {
          key = "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-03",
          npcId = 17906,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.591857,
          y = 0.45142,
        },
        {
          key = "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-04",
          npcId = 17906,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.578921,
          y = 0.427166,
        },
        {
          key = "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-05",
          npcId = 17906,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.57671,
          y = 0.435883,
        },
        {
          key = "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-06",
          npcId = 17906,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.576571,
          y = 0.417726,
        },
        {
          key = "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-07",
          npcId = 17906,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.579618,
          y = 0.453677,
        },
        {
          key = "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-08",
          npcId = 17906,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.572491,
              y = 0.408632,
            },
            {
              x = 0.532908,
              y = 0.418892,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.572458,
          y = 0.426467,
        },
      },
      spells = {
        [31664] = {
          interruptible = true,
        },
      },
    },
    ["17907"] = {
      characteristics = {},
      creatureType = "Undead",
      displayId = 16919,
      health = 332100,
      level = 72,
      name = "Frost Wyrm",
      npcId = 17907,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17907:kazrogal-aerial-assault-17907-01",
          npcId = 17907,
          packKey = "hyjal:pack:kazrogal-aerial-assault",
          patrol = {
            {
              x = 0.570066,
              y = 0.416192,
            },
            {
              x = 0.554366,
              y = 0.409052,
            },
            {
              x = 0.535532,
              y = 0.401588,
            },
            {
              x = 0.514183,
              y = 0.394682,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.604047,
          y = 0.418559,
        },
        {
          key = "hyjal:spawn:17907:kazrogal-frost-wyrm-assault-17907-01",
          npcId = 17907,
          packKey = "hyjal:pack:kazrogal-frost-wyrm-assault",
          patrol = {
            {
              x = 0.514308,
              y = 0.24944,
            },
            {
              x = 0.508,
              y = 0.336224,
            },
            {
              x = 0.498795,
              y = 0.355106,
            },
            {
              x = 0.501002,
              y = 0.386312,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.515821,
          y = 0.235386,
        },
        {
          key = "hyjal:spawn:17907:azgalor-aerial-ghouls-17907-01",
          npcId = 17907,
          packKey = "hyjal:pack:azgalor-aerial-ghouls",
          patrol = {
            {
              x = 0.570066,
              y = 0.416192,
            },
            {
              x = 0.554366,
              y = 0.409052,
            },
            {
              x = 0.535532,
              y = 0.401588,
            },
            {
              x = 0.514183,
              y = 0.394682,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.578592,
          y = 0.433475,
        },
      },
      spells = {
        [31688] = {},
      },
    },
    ["17908"] = {
      characteristics = {
        Banish = true,
        Disorient = true,
        Fear = true,
        Root = true,
        Silence = true,
        Slow = true,
        Stun = true,
        ["Turn Evil"] = true,
      },
      creatureType = "Demon",
      displayId = 14520,
      health = 129258,
      level = 71,
      name = "Giant Infernal",
      npcId = 17908,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-01",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.510912,
          y = 0.34628,
        },
        {
          key = "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-02",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.486121,
          y = 0.37163,
        },
        {
          key = "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-03",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.485618,
          y = 0.432542,
        },
        {
          key = "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-04",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.516355,
          y = 0.39761,
        },
        {
          key = "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-05",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.545251,
          y = 0.371978,
        },
        {
          key = "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-06",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.539173,
          y = 0.390938,
        },
        {
          key = "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-07",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.510912,
          y = 0.34628,
        },
        {
          key = "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-08",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-ghoul-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.486121,
          y = 0.37163,
        },
        {
          key = "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-01",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.510912,
          y = 0.34628,
        },
        {
          key = "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-02",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.486121,
          y = 0.37163,
        },
        {
          key = "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-03",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.485618,
          y = 0.432542,
        },
        {
          key = "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-04",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.516355,
          y = 0.39761,
        },
        {
          key = "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-05",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.545251,
          y = 0.371978,
        },
        {
          key = "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-06",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.539173,
          y = 0.390938,
        },
        {
          key = "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-07",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.510912,
          y = 0.34628,
        },
        {
          key = "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-08",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.486121,
          y = 0.37163,
        },
        {
          key = "hyjal:spawn:17908:azgalor-mixed-infernals-17908-01",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.510912,
          y = 0.34628,
        },
        {
          key = "hyjal:spawn:17908:azgalor-mixed-infernals-17908-02",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.486121,
          y = 0.37163,
        },
        {
          key = "hyjal:spawn:17908:azgalor-mixed-infernals-17908-03",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.485618,
          y = 0.432542,
        },
        {
          key = "hyjal:spawn:17908:azgalor-mixed-infernals-17908-04",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.516355,
          y = 0.39761,
        },
        {
          key = "hyjal:spawn:17908:azgalor-mixed-infernals-17908-05",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.545251,
          y = 0.371978,
        },
        {
          key = "hyjal:spawn:17908:azgalor-mixed-infernals-17908-06",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.539173,
          y = 0.390938,
        },
        {
          key = "hyjal:spawn:17908:azgalor-mixed-infernals-17908-07",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.510912,
          y = 0.34628,
        },
        {
          key = "hyjal:spawn:17908:azgalor-mixed-infernals-17908-08",
          npcId = 17908,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.486121,
          y = 0.37163,
        },
      },
      spells = {
        [21727] = {},
        [31722] = {},
        [35747] = {},
      },
    },
    ["17916"] = {
      characteristics = {
        Banish = true,
        Disorient = true,
        Fear = true,
        Root = true,
        Silence = true,
        Slow = true,
        Stun = true,
        ["Turn Evil"] = true,
      },
      creatureType = "Demon",
      displayId = 17321,
      health = 104790,
      level = 70,
      name = "Fel Stalker",
      npcId = 17916,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-01",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.635708,
          y = 0.403235,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-02",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637547,
          y = 0.400382,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-03",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638471,
          y = 0.398265,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-04",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.639288,
          y = 0.397387,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-05",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640437,
          y = 0.394577,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-06",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64209,
          y = 0.392197,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-01",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.636492,
          y = 0.403849,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-02",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.637533,
          y = 0.401747,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-03",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.63872,
          y = 0.399587,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-04",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640151,
          y = 0.397418,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-05",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64101,
          y = 0.395311,
        },
        {
          key = "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-06",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-fel-stalker-abominations",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.642491,
          y = 0.393413,
        },
        {
          key = "hyjal:spawn:17916:azgalor-mixed-infernals-17916-01",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638525,
          y = 0.407077,
        },
        {
          key = "hyjal:spawn:17916:azgalor-mixed-infernals-17916-02",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-mixed-infernals",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.64485,
          y = 0.395671,
        },
        {
          key = "hyjal:spawn:17916:azgalor-combined-assault-17916-01",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.638717,
          y = 0.39853,
        },
        {
          key = "hyjal:spawn:17916:azgalor-combined-assault-17916-02",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.639883,
          y = 0.397016,
        },
        {
          key = "hyjal:spawn:17916:azgalor-combined-assault-17916-03",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.640814,
          y = 0.394762,
        },
        {
          key = "hyjal:spawn:17916:azgalor-combined-assault-17916-04",
          npcId = 17916,
          packKey = "hyjal:pack:azgalor-combined-assault",
          patrol = {
            {
              x = 0.626589,
              y = 0.38969,
            },
            {
              x = 0.62023,
              y = 0.382688,
            },
            {
              x = 0.612877,
              y = 0.374942,
            },
            {
              x = 0.606589,
              y = 0.368018,
            },
            {
              x = 0.600507,
              y = 0.364172,
            },
            {
              x = 0.592756,
              y = 0.362162,
            },
            {
              x = 0.587458,
              y = 0.360986,
            },
            {
              x = 0.582008,
              y = 0.361454,
            },
            {
              x = 0.575708,
              y = 0.36254,
            },
            {
              x = 0.568698,
              y = 0.363674,
            },
            {
              x = 0.560916,
              y = 0.364484,
            },
            {
              x = 0.549715,
              y = 0.365798,
            },
            {
              x = 0.54407,
              y = 0.371306,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.641938,
          y = 0.393666,
        },
      },
      spells = {
        [21727] = {},
        [31729] = {
          interruptible = true,
        },
      },
    },
    ["17968"] = {
      characteristics = {},
      creatureType = "Demon",
      displayId = 20939,
      health = 4552500,
      level = 73,
      name = "Archimonde",
      npcId = 17968,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawns = {
        {
          key = "hyjal:spawn:17968:archimonde-17968-01",
          npcId = 17968,
          packKey = "hyjal:pack:archimonde",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T19:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
          },
          sublevel = 1,
          x = 0.22562,
          y = 0.326337,
        },
      },
      spells = {
        [31903] = {},
        [31945] = {},
        [31970] = {},
        [31972] = {},
        [31984] = {},
        [32014] = {},
        [32074] = {},
        [32124] = {},
        [35354] = {},
        [38528] = {},
        [39140] = {},
        [39314] = {},
      },
    },
  },
  packs = {
    ["hyjal:pack:anetheron"] = {
      key = "hyjal:pack:anetheron",
      label = "Anetheron",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17808:anetheron-17808-01",
      },
    },
    ["hyjal:pack:anetheron-abomination-necromancer"] = {
      key = "hyjal:pack:anetheron-abomination-necromancer",
      label = "Anetheron Abomination Necromancer",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-01",
        "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-02",
        "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-03",
        "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-04",
        "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-05",
        "hyjal:spawn:17895:anetheron-abomination-necromancer-17895-06",
        "hyjal:spawn:17898:anetheron-abomination-necromancer-17898-01",
        "hyjal:spawn:17898:anetheron-abomination-necromancer-17898-02",
        "hyjal:spawn:17899:anetheron-abomination-necromancer-17899-01",
        "hyjal:spawn:17899:anetheron-abomination-necromancer-17899-02",
        "hyjal:spawn:17899:anetheron-abomination-necromancer-17899-03",
        "hyjal:spawn:17899:anetheron-abomination-necromancer-17899-04",
      },
    },
    ["hyjal:pack:anetheron-banshee-abomination"] = {
      key = "hyjal:pack:anetheron-banshee-abomination",
      label = "Anetheron Banshee Abomination",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:anetheron-banshee-abomination-17895-01",
        "hyjal:spawn:17895:anetheron-banshee-abomination-17895-02",
        "hyjal:spawn:17897:anetheron-banshee-abomination-17897-01",
        "hyjal:spawn:17897:anetheron-banshee-abomination-17897-02",
        "hyjal:spawn:17897:anetheron-banshee-abomination-17897-03",
        "hyjal:spawn:17897:anetheron-banshee-abomination-17897-04",
        "hyjal:spawn:17898:anetheron-banshee-abomination-17898-01",
        "hyjal:spawn:17898:anetheron-banshee-abomination-17898-02",
        "hyjal:spawn:17898:anetheron-banshee-abomination-17898-03",
        "hyjal:spawn:17898:anetheron-banshee-abomination-17898-04",
        "hyjal:spawn:17905:anetheron-banshee-abomination-17905-01",
        "hyjal:spawn:17905:anetheron-banshee-abomination-17905-02",
      },
    },
    ["hyjal:pack:anetheron-banshee-introduction"] = {
      key = "hyjal:pack:anetheron-banshee-introduction",
      label = "Anetheron Banshee Introduction",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17897:anetheron-banshee-introduction-17897-01",
        "hyjal:spawn:17897:anetheron-banshee-introduction-17897-02",
        "hyjal:spawn:17897:anetheron-banshee-introduction-17897-03",
        "hyjal:spawn:17897:anetheron-banshee-introduction-17897-04",
        "hyjal:spawn:17897:anetheron-banshee-introduction-17897-05",
        "hyjal:spawn:17897:anetheron-banshee-introduction-17897-06",
        "hyjal:spawn:17899:anetheron-banshee-introduction-17899-01",
        "hyjal:spawn:17899:anetheron-banshee-introduction-17899-02",
        "hyjal:spawn:17899:anetheron-banshee-introduction-17899-03",
        "hyjal:spawn:17899:anetheron-banshee-introduction-17899-04",
        "hyjal:spawn:17905:anetheron-banshee-introduction-17905-01",
        "hyjal:spawn:17905:anetheron-banshee-introduction-17905-02",
      },
    },
    ["hyjal:pack:anetheron-combined-assault"] = {
      key = "hyjal:pack:anetheron-combined-assault",
      label = "Anetheron Combined Assault",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:anetheron-combined-assault-17895-01",
        "hyjal:spawn:17895:anetheron-combined-assault-17895-02",
        "hyjal:spawn:17895:anetheron-combined-assault-17895-03",
        "hyjal:spawn:17895:anetheron-combined-assault-17895-04",
        "hyjal:spawn:17898:anetheron-combined-assault-17898-01",
        "hyjal:spawn:17898:anetheron-combined-assault-17898-02",
        "hyjal:spawn:17898:anetheron-combined-assault-17898-03",
        "hyjal:spawn:17898:anetheron-combined-assault-17898-04",
        "hyjal:spawn:17897:anetheron-combined-assault-17897-01",
        "hyjal:spawn:17897:anetheron-combined-assault-17897-02",
        "hyjal:spawn:17905:anetheron-combined-assault-17905-01",
        "hyjal:spawn:17905:anetheron-combined-assault-17905-02",
        "hyjal:spawn:17899:anetheron-combined-assault-17899-01",
        "hyjal:spawn:17899:anetheron-combined-assault-17899-02",
      },
    },
    ["hyjal:pack:anetheron-ghoul-abomination"] = {
      key = "hyjal:pack:anetheron-ghoul-abomination",
      label = "Anetheron Ghoul Abomination",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-01",
        "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-02",
        "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-03",
        "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-04",
        "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-05",
        "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-06",
        "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-07",
        "hyjal:spawn:17895:anetheron-ghoul-abomination-17895-08",
        "hyjal:spawn:17898:anetheron-ghoul-abomination-17898-01",
        "hyjal:spawn:17898:anetheron-ghoul-abomination-17898-02",
        "hyjal:spawn:17898:anetheron-ghoul-abomination-17898-03",
        "hyjal:spawn:17898:anetheron-ghoul-abomination-17898-04",
      },
    },
    ["hyjal:pack:anetheron-ghoul-banshee"] = {
      key = "hyjal:pack:anetheron-ghoul-banshee",
      label = "Anetheron Ghoul Banshee",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-01",
        "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-02",
        "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-03",
        "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-04",
        "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-05",
        "hyjal:spawn:17895:anetheron-ghoul-banshee-17895-06",
        "hyjal:spawn:17905:anetheron-ghoul-banshee-17905-01",
        "hyjal:spawn:17905:anetheron-ghoul-banshee-17905-02",
        "hyjal:spawn:17905:anetheron-ghoul-banshee-17905-03",
        "hyjal:spawn:17905:anetheron-ghoul-banshee-17905-04",
        "hyjal:spawn:17899:anetheron-ghoul-banshee-17899-01",
        "hyjal:spawn:17899:anetheron-ghoul-banshee-17899-02",
      },
    },
    ["hyjal:pack:anetheron-ghoul-crypt-necromancer"] = {
      key = "hyjal:pack:anetheron-ghoul-crypt-necromancer",
      label = "Anetheron Ghoul Crypt Necromancer",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:anetheron-ghoul-crypt-necromancer-17895-01",
        "hyjal:spawn:17895:anetheron-ghoul-crypt-necromancer-17895-02",
        "hyjal:spawn:17895:anetheron-ghoul-crypt-necromancer-17895-03",
        "hyjal:spawn:17895:anetheron-ghoul-crypt-necromancer-17895-04",
        "hyjal:spawn:17897:anetheron-ghoul-crypt-necromancer-17897-01",
        "hyjal:spawn:17897:anetheron-ghoul-crypt-necromancer-17897-02",
        "hyjal:spawn:17897:anetheron-ghoul-crypt-necromancer-17897-03",
        "hyjal:spawn:17897:anetheron-ghoul-crypt-necromancer-17897-04",
        "hyjal:spawn:17899:anetheron-ghoul-crypt-necromancer-17899-01",
        "hyjal:spawn:17899:anetheron-ghoul-crypt-necromancer-17899-02",
        "hyjal:spawn:17899:anetheron-ghoul-crypt-necromancer-17899-03",
        "hyjal:spawn:17899:anetheron-ghoul-crypt-necromancer-17899-04",
      },
    },
    ["hyjal:pack:anetheron-ghouls"] = {
      key = "hyjal:pack:anetheron-ghouls",
      label = "Anetheron Ghouls",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:anetheron-ghouls-17895-01",
        "hyjal:spawn:17895:anetheron-ghouls-17895-02",
        "hyjal:spawn:17895:anetheron-ghouls-17895-03",
        "hyjal:spawn:17895:anetheron-ghouls-17895-04",
        "hyjal:spawn:17895:anetheron-ghouls-17895-05",
        "hyjal:spawn:17895:anetheron-ghouls-17895-06",
        "hyjal:spawn:17895:anetheron-ghouls-17895-07",
        "hyjal:spawn:17895:anetheron-ghouls-17895-08",
        "hyjal:spawn:17895:anetheron-ghouls-17895-09",
        "hyjal:spawn:17895:anetheron-ghouls-17895-10",
      },
    },
    ["hyjal:pack:archimonde"] = {
      key = "hyjal:pack:archimonde",
      label = "Archimonde",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17968:archimonde-17968-01",
      },
    },
    ["hyjal:pack:archimonde-night-elf-crypt-fiend"] = {
      key = "hyjal:pack:archimonde-night-elf-crypt-fiend",
      label = "Archimonde Night Elf Crypt Fiend",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17897:archimonde-night-elf-crypt-fiend-17897-01",
      },
    },
    ["hyjal:pack:archimonde-night-elf-ghoul-abomination"] = {
      key = "hyjal:pack:archimonde-night-elf-ghoul-abomination",
      label = "Archimonde Night Elf Ghoul Abomination",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:archimonde-night-elf-ghoul-abomination-17895-01",
        "hyjal:spawn:17895:archimonde-night-elf-ghoul-abomination-17895-02",
        "hyjal:spawn:17895:archimonde-night-elf-ghoul-abomination-17895-03",
        "hyjal:spawn:17898:archimonde-night-elf-ghoul-abomination-17898-01",
      },
    },
    ["hyjal:pack:archimonde-night-elf-ghouls"] = {
      key = "hyjal:pack:archimonde-night-elf-ghouls",
      label = "Archimonde Night Elf Ghouls",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:archimonde-night-elf-ghouls-17895-01",
        "hyjal:spawn:17895:archimonde-night-elf-ghouls-17895-02",
        "hyjal:spawn:17895:archimonde-night-elf-ghouls-17895-03",
      },
    },
    ["hyjal:pack:azgalor"] = {
      key = "hyjal:pack:azgalor",
      label = "Azgalor",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17842:azgalor-17842-01",
      },
    },
    ["hyjal:pack:azgalor-abomination-necromancer"] = {
      key = "hyjal:pack:azgalor-abomination-necromancer",
      label = "Azgalor Abomination Necromancer",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-01",
        "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-02",
        "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-03",
        "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-04",
        "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-05",
        "hyjal:spawn:17898:azgalor-abomination-necromancer-17898-06",
        "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-01",
        "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-02",
        "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-03",
        "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-04",
        "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-05",
        "hyjal:spawn:17899:azgalor-abomination-necromancer-17899-06",
      },
    },
    ["hyjal:pack:azgalor-aerial-ghouls"] = {
      key = "hyjal:pack:azgalor-aerial-ghouls",
      label = "Azgalor Aerial Ghouls",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-01",
        "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-02",
        "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-03",
        "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-04",
        "hyjal:spawn:17895:azgalor-aerial-ghouls-17895-05",
        "hyjal:spawn:17907:azgalor-aerial-ghouls-17907-01",
        "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-01",
        "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-02",
        "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-03",
        "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-04",
        "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-05",
        "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-06",
        "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-07",
        "hyjal:spawn:17906:azgalor-aerial-ghouls-17906-08",
      },
    },
    ["hyjal:pack:azgalor-combined-assault"] = {
      key = "hyjal:pack:azgalor-combined-assault",
      label = "Azgalor Combined Assault",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17898:azgalor-combined-assault-17898-01",
        "hyjal:spawn:17898:azgalor-combined-assault-17898-02",
        "hyjal:spawn:17898:azgalor-combined-assault-17898-03",
        "hyjal:spawn:17898:azgalor-combined-assault-17898-04",
        "hyjal:spawn:17897:azgalor-combined-assault-17897-01",
        "hyjal:spawn:17897:azgalor-combined-assault-17897-02",
        "hyjal:spawn:17897:azgalor-combined-assault-17897-03",
        "hyjal:spawn:17897:azgalor-combined-assault-17897-04",
        "hyjal:spawn:17905:azgalor-combined-assault-17905-01",
        "hyjal:spawn:17905:azgalor-combined-assault-17905-02",
        "hyjal:spawn:17899:azgalor-combined-assault-17899-01",
        "hyjal:spawn:17899:azgalor-combined-assault-17899-02",
        "hyjal:spawn:17916:azgalor-combined-assault-17916-01",
        "hyjal:spawn:17916:azgalor-combined-assault-17916-02",
        "hyjal:spawn:17916:azgalor-combined-assault-17916-03",
        "hyjal:spawn:17916:azgalor-combined-assault-17916-04",
      },
    },
    ["hyjal:pack:azgalor-fel-stalker-abominations"] = {
      key = "hyjal:pack:azgalor-fel-stalker-abominations",
      label = "Azgalor Fel Stalker Abominations",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17898:azgalor-fel-stalker-abominations-17898-01",
        "hyjal:spawn:17898:azgalor-fel-stalker-abominations-17898-02",
        "hyjal:spawn:17898:azgalor-fel-stalker-abominations-17898-03",
        "hyjal:spawn:17898:azgalor-fel-stalker-abominations-17898-04",
        "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-01",
        "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-02",
        "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-03",
        "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-04",
        "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-05",
        "hyjal:spawn:17916:azgalor-fel-stalker-abominations-17916-06",
        "hyjal:spawn:17899:azgalor-fel-stalker-abominations-17899-01",
        "hyjal:spawn:17899:azgalor-fel-stalker-abominations-17899-02",
        "hyjal:spawn:17899:azgalor-fel-stalker-abominations-17899-03",
        "hyjal:spawn:17899:azgalor-fel-stalker-abominations-17899-04",
      },
    },
    ["hyjal:pack:azgalor-fel-stalker-infernals"] = {
      key = "hyjal:pack:azgalor-fel-stalker-infernals",
      label = "Azgalor Fel Stalker Infernals",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-01",
        "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-02",
        "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-03",
        "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-04",
        "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-05",
        "hyjal:spawn:17916:azgalor-fel-stalker-infernals-17916-06",
        "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-01",
        "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-02",
        "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-03",
        "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-04",
        "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-05",
        "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-06",
        "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-07",
        "hyjal:spawn:17908:azgalor-fel-stalker-infernals-17908-08",
      },
    },
    ["hyjal:pack:azgalor-ghoul-infernals"] = {
      key = "hyjal:pack:azgalor-ghoul-infernals",
      label = "Azgalor Ghoul Infernals",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-01",
        "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-02",
        "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-03",
        "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-04",
        "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-05",
        "hyjal:spawn:17895:azgalor-ghoul-infernals-17895-06",
        "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-01",
        "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-02",
        "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-03",
        "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-04",
        "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-05",
        "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-06",
        "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-07",
        "hyjal:spawn:17908:azgalor-ghoul-infernals-17908-08",
      },
    },
    ["hyjal:pack:azgalor-mixed-infernals"] = {
      key = "hyjal:pack:azgalor-mixed-infernals",
      label = "Azgalor Mixed Infernals",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:azgalor-mixed-infernals-17895-01",
        "hyjal:spawn:17895:azgalor-mixed-infernals-17895-02",
        "hyjal:spawn:17897:azgalor-mixed-infernals-17897-01",
        "hyjal:spawn:17897:azgalor-mixed-infernals-17897-02",
        "hyjal:spawn:17916:azgalor-mixed-infernals-17916-01",
        "hyjal:spawn:17916:azgalor-mixed-infernals-17916-02",
        "hyjal:spawn:17908:azgalor-mixed-infernals-17908-01",
        "hyjal:spawn:17908:azgalor-mixed-infernals-17908-02",
        "hyjal:spawn:17908:azgalor-mixed-infernals-17908-03",
        "hyjal:spawn:17908:azgalor-mixed-infernals-17908-04",
        "hyjal:spawn:17908:azgalor-mixed-infernals-17908-05",
        "hyjal:spawn:17908:azgalor-mixed-infernals-17908-06",
        "hyjal:spawn:17908:azgalor-mixed-infernals-17908-07",
        "hyjal:spawn:17908:azgalor-mixed-infernals-17908-08",
      },
    },
    ["hyjal:pack:azgalor-necromancer-banshee"] = {
      key = "hyjal:pack:azgalor-necromancer-banshee",
      label = "Azgalor Necromancer Banshee",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-01",
        "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-02",
        "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-03",
        "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-04",
        "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-05",
        "hyjal:spawn:17899:azgalor-necromancer-banshee-17899-06",
        "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-01",
        "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-02",
        "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-03",
        "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-04",
        "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-05",
        "hyjal:spawn:17905:azgalor-necromancer-banshee-17905-06",
      },
    },
    ["hyjal:pack:kazrogal"] = {
      key = "hyjal:pack:kazrogal",
      label = "Kazrogal",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17888:kazrogal-17888-01",
      },
    },
    ["hyjal:pack:kazrogal-abomination-assault"] = {
      key = "hyjal:pack:kazrogal-abomination-assault",
      label = "Kazrogal Abomination Assault",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:kazrogal-abomination-assault-17895-01",
        "hyjal:spawn:17895:kazrogal-abomination-assault-17895-02",
        "hyjal:spawn:17895:kazrogal-abomination-assault-17895-03",
        "hyjal:spawn:17895:kazrogal-abomination-assault-17895-04",
        "hyjal:spawn:17898:kazrogal-abomination-assault-17898-01",
        "hyjal:spawn:17898:kazrogal-abomination-assault-17898-02",
        "hyjal:spawn:17898:kazrogal-abomination-assault-17898-03",
        "hyjal:spawn:17898:kazrogal-abomination-assault-17898-04",
        "hyjal:spawn:17898:kazrogal-abomination-assault-17898-05",
        "hyjal:spawn:17898:kazrogal-abomination-assault-17898-06",
        "hyjal:spawn:17899:kazrogal-abomination-assault-17899-01",
        "hyjal:spawn:17899:kazrogal-abomination-assault-17899-02",
        "hyjal:spawn:17899:kazrogal-abomination-assault-17899-03",
        "hyjal:spawn:17899:kazrogal-abomination-assault-17899-04",
      },
    },
    ["hyjal:pack:kazrogal-aerial-assault"] = {
      key = "hyjal:pack:kazrogal-aerial-assault",
      label = "Kazrogal Aerial Assault",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17906:kazrogal-aerial-assault-17906-01",
        "hyjal:spawn:17906:kazrogal-aerial-assault-17906-02",
        "hyjal:spawn:17906:kazrogal-aerial-assault-17906-03",
        "hyjal:spawn:17906:kazrogal-aerial-assault-17906-04",
        "hyjal:spawn:17906:kazrogal-aerial-assault-17906-05",
        "hyjal:spawn:17906:kazrogal-aerial-assault-17906-06",
        "hyjal:spawn:17906:kazrogal-aerial-assault-17906-07",
        "hyjal:spawn:17906:kazrogal-aerial-assault-17906-08",
        "hyjal:spawn:17907:kazrogal-aerial-assault-17907-01",
      },
    },
    ["hyjal:pack:kazrogal-combined-assault"] = {
      key = "hyjal:pack:kazrogal-combined-assault",
      label = "Kazrogal Combined Assault",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:kazrogal-combined-assault-17895-01",
        "hyjal:spawn:17895:kazrogal-combined-assault-17895-02",
        "hyjal:spawn:17895:kazrogal-combined-assault-17895-03",
        "hyjal:spawn:17895:kazrogal-combined-assault-17895-04",
        "hyjal:spawn:17897:kazrogal-combined-assault-17897-01",
        "hyjal:spawn:17897:kazrogal-combined-assault-17897-02",
        "hyjal:spawn:17897:kazrogal-combined-assault-17897-03",
        "hyjal:spawn:17897:kazrogal-combined-assault-17897-04",
        "hyjal:spawn:17898:kazrogal-combined-assault-17898-01",
        "hyjal:spawn:17898:kazrogal-combined-assault-17898-02",
        "hyjal:spawn:17898:kazrogal-combined-assault-17898-03",
        "hyjal:spawn:17898:kazrogal-combined-assault-17898-04",
        "hyjal:spawn:17899:kazrogal-combined-assault-17899-01",
        "hyjal:spawn:17899:kazrogal-combined-assault-17899-02",
        "hyjal:spawn:17905:kazrogal-combined-assault-17905-01",
        "hyjal:spawn:17905:kazrogal-combined-assault-17905-02",
      },
    },
    ["hyjal:pack:kazrogal-crypt-assault"] = {
      key = "hyjal:pack:kazrogal-crypt-assault",
      label = "Kazrogal Crypt Assault",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:kazrogal-crypt-assault-17895-01",
        "hyjal:spawn:17895:kazrogal-crypt-assault-17895-02",
        "hyjal:spawn:17895:kazrogal-crypt-assault-17895-03",
        "hyjal:spawn:17895:kazrogal-crypt-assault-17895-04",
        "hyjal:spawn:17895:kazrogal-crypt-assault-17895-05",
        "hyjal:spawn:17895:kazrogal-crypt-assault-17895-06",
        "hyjal:spawn:17897:kazrogal-crypt-assault-17897-01",
        "hyjal:spawn:17897:kazrogal-crypt-assault-17897-02",
        "hyjal:spawn:17897:kazrogal-crypt-assault-17897-03",
        "hyjal:spawn:17897:kazrogal-crypt-assault-17897-04",
        "hyjal:spawn:17897:kazrogal-crypt-assault-17897-05",
        "hyjal:spawn:17897:kazrogal-crypt-assault-17897-06",
        "hyjal:spawn:17899:kazrogal-crypt-assault-17899-01",
        "hyjal:spawn:17899:kazrogal-crypt-assault-17899-02",
      },
    },
    ["hyjal:pack:kazrogal-frost-wyrm-assault"] = {
      key = "hyjal:pack:kazrogal-frost-wyrm-assault",
      label = "Kazrogal Frost Wyrm Assault",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-01",
        "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-02",
        "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-03",
        "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-04",
        "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-05",
        "hyjal:spawn:17895:kazrogal-frost-wyrm-assault-17895-06",
        "hyjal:spawn:17898:kazrogal-frost-wyrm-assault-17898-01",
        "hyjal:spawn:17898:kazrogal-frost-wyrm-assault-17898-02",
        "hyjal:spawn:17898:kazrogal-frost-wyrm-assault-17898-03",
        "hyjal:spawn:17898:kazrogal-frost-wyrm-assault-17898-04",
        "hyjal:spawn:17907:kazrogal-frost-wyrm-assault-17907-01",
      },
    },
    ["hyjal:pack:kazrogal-gargoyle-crypt"] = {
      key = "hyjal:pack:kazrogal-gargoyle-crypt",
      label = "Kazrogal Gargoyle Crypt",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-01",
        "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-02",
        "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-03",
        "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-04",
        "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-05",
        "hyjal:spawn:17897:kazrogal-gargoyle-crypt-17897-06",
        "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-01",
        "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-02",
        "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-03",
        "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-04",
        "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-05",
        "hyjal:spawn:17906:kazrogal-gargoyle-crypt-17906-06",
        "hyjal:spawn:17899:kazrogal-gargoyle-crypt-17899-01",
        "hyjal:spawn:17899:kazrogal-gargoyle-crypt-17899-02",
      },
    },
    ["hyjal:pack:kazrogal-gargoyle-introduction"] = {
      key = "hyjal:pack:kazrogal-gargoyle-introduction",
      label = "Kazrogal Gargoyle Introduction",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:kazrogal-gargoyle-introduction-17895-01",
        "hyjal:spawn:17895:kazrogal-gargoyle-introduction-17895-02",
        "hyjal:spawn:17895:kazrogal-gargoyle-introduction-17895-03",
        "hyjal:spawn:17895:kazrogal-gargoyle-introduction-17895-04",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-01",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-02",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-03",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-04",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-05",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-06",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-07",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-08",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-09",
        "hyjal:spawn:17906:kazrogal-gargoyle-introduction-17906-10",
      },
    },
    ["hyjal:pack:kazrogal-undead-vanguard"] = {
      key = "hyjal:pack:kazrogal-undead-vanguard",
      label = "Kazrogal Undead Vanguard",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-01",
        "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-02",
        "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-03",
        "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-04",
        "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-05",
        "hyjal:spawn:17895:kazrogal-undead-vanguard-17895-06",
        "hyjal:spawn:17898:kazrogal-undead-vanguard-17898-01",
        "hyjal:spawn:17898:kazrogal-undead-vanguard-17898-02",
        "hyjal:spawn:17898:kazrogal-undead-vanguard-17898-03",
        "hyjal:spawn:17898:kazrogal-undead-vanguard-17898-04",
        "hyjal:spawn:17905:kazrogal-undead-vanguard-17905-01",
        "hyjal:spawn:17905:kazrogal-undead-vanguard-17905-02",
        "hyjal:spawn:17899:kazrogal-undead-vanguard-17899-01",
        "hyjal:spawn:17899:kazrogal-undead-vanguard-17899-02",
      },
    },
    ["hyjal:pack:rage-winterchill"] = {
      key = "hyjal:pack:rage-winterchill",
      label = "Rage Winterchill",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17767:rage-winterchill-17767-01",
      },
    },
    ["hyjal:pack:winterchill-abomination-necromancer"] = {
      key = "hyjal:pack:winterchill-abomination-necromancer",
      label = "Winterchill Abomination Necromancer",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:winterchill-abomination-necromancer-17895-01",
        "hyjal:spawn:17895:winterchill-abomination-necromancer-17895-02",
        "hyjal:spawn:17895:winterchill-abomination-necromancer-17895-03",
        "hyjal:spawn:17895:winterchill-abomination-necromancer-17895-04",
        "hyjal:spawn:17899:winterchill-abomination-necromancer-17899-01",
        "hyjal:spawn:17899:winterchill-abomination-necromancer-17899-02",
        "hyjal:spawn:17899:winterchill-abomination-necromancer-17899-03",
        "hyjal:spawn:17899:winterchill-abomination-necromancer-17899-04",
        "hyjal:spawn:17898:winterchill-abomination-necromancer-17898-01",
        "hyjal:spawn:17898:winterchill-abomination-necromancer-17898-02",
        "hyjal:spawn:17898:winterchill-abomination-necromancer-17898-03",
        "hyjal:spawn:17898:winterchill-abomination-necromancer-17898-04",
      },
    },
    ["hyjal:pack:winterchill-combined-assault"] = {
      key = "hyjal:pack:winterchill-combined-assault",
      label = "Winterchill Combined Assault",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:winterchill-combined-assault-17895-01",
        "hyjal:spawn:17895:winterchill-combined-assault-17895-02",
        "hyjal:spawn:17895:winterchill-combined-assault-17895-03",
        "hyjal:spawn:17895:winterchill-combined-assault-17895-04",
        "hyjal:spawn:17895:winterchill-combined-assault-17895-05",
        "hyjal:spawn:17895:winterchill-combined-assault-17895-06",
        "hyjal:spawn:17897:winterchill-combined-assault-17897-01",
        "hyjal:spawn:17897:winterchill-combined-assault-17897-02",
        "hyjal:spawn:17897:winterchill-combined-assault-17897-03",
        "hyjal:spawn:17897:winterchill-combined-assault-17897-04",
        "hyjal:spawn:17898:winterchill-combined-assault-17898-01",
        "hyjal:spawn:17898:winterchill-combined-assault-17898-02",
        "hyjal:spawn:17899:winterchill-combined-assault-17899-01",
        "hyjal:spawn:17899:winterchill-combined-assault-17899-02",
      },
    },
    ["hyjal:pack:winterchill-crypt-necromancer"] = {
      key = "hyjal:pack:winterchill-crypt-necromancer",
      label = "Winterchill Crypt Necromancer",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:winterchill-crypt-necromancer-17895-01",
        "hyjal:spawn:17895:winterchill-crypt-necromancer-17895-02",
        "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-01",
        "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-02",
        "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-03",
        "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-04",
        "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-05",
        "hyjal:spawn:17897:winterchill-crypt-necromancer-17897-06",
        "hyjal:spawn:17899:winterchill-crypt-necromancer-17899-01",
        "hyjal:spawn:17899:winterchill-crypt-necromancer-17899-02",
        "hyjal:spawn:17899:winterchill-crypt-necromancer-17899-03",
        "hyjal:spawn:17899:winterchill-crypt-necromancer-17899-04",
      },
    },
    ["hyjal:pack:winterchill-ghoul-abomination"] = {
      key = "hyjal:pack:winterchill-ghoul-abomination",
      label = "Winterchill Ghoul Abomination",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-01",
        "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-02",
        "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-03",
        "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-04",
        "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-05",
        "hyjal:spawn:17895:winterchill-ghoul-abomination-17895-06",
        "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-01",
        "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-02",
        "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-03",
        "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-04",
        "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-05",
        "hyjal:spawn:17898:winterchill-ghoul-abomination-17898-06",
      },
    },
    ["hyjal:pack:winterchill-ghouls"] = {
      key = "hyjal:pack:winterchill-ghouls",
      label = "Winterchill Ghouls",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:winterchill-ghouls-17895-01",
        "hyjal:spawn:17895:winterchill-ghouls-17895-02",
        "hyjal:spawn:17895:winterchill-ghouls-17895-03",
        "hyjal:spawn:17895:winterchill-ghouls-17895-04",
        "hyjal:spawn:17895:winterchill-ghouls-17895-05",
        "hyjal:spawn:17895:winterchill-ghouls-17895-06",
        "hyjal:spawn:17895:winterchill-ghouls-17895-07",
        "hyjal:spawn:17895:winterchill-ghouls-17895-08",
        "hyjal:spawn:17895:winterchill-ghouls-17895-09",
        "hyjal:spawn:17895:winterchill-ghouls-17895-10",
      },
    },
    ["hyjal:pack:winterchill-ghouls-crypt-pair"] = {
      key = "hyjal:pack:winterchill-ghouls-crypt-pair",
      label = "Winterchill Ghouls Crypt Pair",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-01",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-02",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-03",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-04",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-05",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-06",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-07",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-08",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-09",
        "hyjal:spawn:17895:winterchill-ghouls-crypt-pair-17895-10",
        "hyjal:spawn:17897:winterchill-ghouls-crypt-pair-17897-01",
        "hyjal:spawn:17897:winterchill-ghouls-crypt-pair-17897-02",
      },
    },
    ["hyjal:pack:winterchill-necromancer-introduction"] = {
      key = "hyjal:pack:winterchill-necromancer-introduction",
      label = "Winterchill Necromancer Introduction",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-01",
        "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-02",
        "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-03",
        "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-04",
        "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-05",
        "hyjal:spawn:17895:winterchill-necromancer-introduction-17895-06",
        "hyjal:spawn:17897:winterchill-necromancer-introduction-17897-01",
        "hyjal:spawn:17897:winterchill-necromancer-introduction-17897-02",
        "hyjal:spawn:17897:winterchill-necromancer-introduction-17897-03",
        "hyjal:spawn:17897:winterchill-necromancer-introduction-17897-04",
        "hyjal:spawn:17899:winterchill-necromancer-introduction-17899-01",
        "hyjal:spawn:17899:winterchill-necromancer-introduction-17899-02",
      },
    },
    ["hyjal:pack:winterchill-split-ghoul-crypt"] = {
      key = "hyjal:pack:winterchill-split-ghoul-crypt",
      label = "Winterchill Split Ghoul Crypt",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      spawnKeys = {
        "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-01",
        "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-02",
        "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-03",
        "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-04",
        "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-05",
        "hyjal:spawn:17895:winterchill-split-ghoul-crypt-17895-06",
        "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-01",
        "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-02",
        "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-03",
        "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-04",
        "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-05",
        "hyjal:spawn:17897:winterchill-split-ghoul-crypt-17897-06",
      },
    },
  },
  pois = {
    [1] = {
      {
        label = "Alliance Base",
        source = {
          confidence = "candidate",
          observedAt = "2026-08-21T19:30:00Z",
          source = "derived",
          sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
        },
        sublevel = 1,
        x = 0.128277,
        y = 0.637058,
      },
      {
        label = "Horde Encampment",
        source = {
          confidence = "candidate",
          observedAt = "2026-08-21T19:30:00Z",
          source = "derived",
          sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
        },
        sublevel = 1,
        x = 0.492776,
        y = 0.417176,
      },
      {
        label = "Nordrassil",
        source = {
          confidence = "candidate",
          observedAt = "2026-08-21T19:30:00Z",
          source = "derived",
          sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
        },
        sublevel = 1,
        x = 0.77438,
        y = 0.326337,
      },
    },
  },
  waves = {
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:winterchill-ghouls",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:winterchill-ghouls",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:winterchill-ghouls-crypt-pair",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:winterchill-ghouls-crypt-pair",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:winterchill-split-ghoul-crypt",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:winterchill-split-ghoul-crypt",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:winterchill-necromancer-introduction",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:winterchill-necromancer-introduction",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:winterchill-crypt-necromancer",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:winterchill-crypt-necromancer",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:winterchill-ghoul-abomination",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:winterchill-ghoul-abomination",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:winterchill-abomination-necromancer",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:winterchill-abomination-necromancer",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:winterchill-combined-assault",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:winterchill-combined-assault",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:rage-winterchill",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:rage-winterchill",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron-ghouls",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron-ghouls",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron-ghoul-abomination",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron-ghoul-abomination",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron-ghoul-crypt-necromancer",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron-ghoul-crypt-necromancer",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron-banshee-introduction",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron-banshee-introduction",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron-ghoul-banshee",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron-ghoul-banshee",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron-abomination-necromancer",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron-abomination-necromancer",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron-banshee-abomination",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron-banshee-abomination",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron-combined-assault",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron-combined-assault",
    },
    {
      camp = "alliance-base",
      packKeys = {
        "hyjal:pack:anetheron",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:anetheron",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal-undead-vanguard",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal-undead-vanguard",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal-gargoyle-introduction",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal-gargoyle-introduction",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal-crypt-assault",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal-crypt-assault",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal-gargoyle-crypt",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal-gargoyle-crypt",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal-abomination-assault",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal-abomination-assault",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal-aerial-assault",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal-aerial-assault",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal-frost-wyrm-assault",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal-frost-wyrm-assault",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal-combined-assault",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal-combined-assault",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:kazrogal",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:kazrogal",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor-abomination-necromancer",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor-abomination-necromancer",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor-aerial-ghouls",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor-aerial-ghouls",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor-ghoul-infernals",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor-ghoul-infernals",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor-fel-stalker-infernals",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor-fel-stalker-infernals",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor-fel-stalker-abominations",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor-fel-stalker-abominations",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor-necromancer-banshee",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor-necromancer-banshee",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor-mixed-infernals",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor-mixed-infernals",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor-combined-assault",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor-combined-assault",
    },
    {
      camp = "horde-encampment",
      packKeys = {
        "hyjal:pack:azgalor",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:azgalor",
    },
    {
      camp = "nordrassil",
      packKeys = {
        "hyjal:pack:archimonde",
        "hyjal:pack:archimonde-night-elf-ghouls",
        "hyjal:pack:archimonde-night-elf-crypt-fiend",
        "hyjal:pack:archimonde-night-elf-ghoul-abomination",
      },
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T19:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/kalimdor/caverns_of_time/hyjal/hyjal.cpp",
      },
      waveKey = "hyjal:wave:archimonde",
    },
  },
}
local ART = rawget(_G, "ART")
if type(ART) ~= "table" then
  error("AnniversaryRaidTools static data requires Core/Bootstrap.lua to initialize ART", 2)
end
if type(ART.StaticData) ~= "table" then
  error("AnniversaryRaidTools static data requires ART.StaticData bootstrap", 2)
end
if type(ART.StaticData.raids) ~= "table" then
  error("AnniversaryRaidTools static data requires ART.StaticData.raids bootstrap", 2)
end
ART.StaticData.raids[raid.key] = raid
return raid
