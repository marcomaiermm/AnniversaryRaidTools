-- GENERATED FILE. Do not edit; rerun tools/generator/generate.py.
-- Generator: art-030-generator-v2
-- Source: TBC candidate snapshot; not Anniversary-verified.
-- SourceRef: https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp
-- ObservedAt: 2026-08-21T21:30:00Z
local raid = {
  schemaVersion = 1,
  key = "magtheridons-lair",
  name = "Magtheridon's Lair",
  expansion = "TBC",
  instanceId = 544,
  mapId = 544,
  mode = "route",
  enemyMetadataSource = {
    confidence = "candidate",
    observedAt = "2026-08-23T00:00:00Z",
    source = "azerothcore",
    sourceRef = "azerothcore-wotlk@361ff97e5d2fbb4976d1bf18db09763a683309ca#creature_template,creature_template_model,creature_classlevelstats",
  },
  sublevels = {
    {
      index = 1,
      mapId = 544,
      name = "Magtheridon's Lair",
    },
  },
  enemies = {
    ["17256"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 9865,
      health = 242800,
      level = 73,
      name = "Hellfire Channeler",
      npcId = 17256,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T21:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
      },
      spawns = {
        {
          key = "magtheridons-lair:spawn:17256:guid-5440003",
          npcId = 17256,
          packKey = "magtheridons-lair:pack:magtheridon-encounter",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.689442,
          y = 0.839089,
        },
        {
          key = "magtheridons-lair:spawn:17256:guid-5440004",
          npcId = 17256,
          packKey = "magtheridons-lair:pack:magtheridon-encounter",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.621007,
          y = 0.775039,
        },
        {
          key = "magtheridons-lair:spawn:17256:guid-5440005",
          npcId = 17256,
          packKey = "magtheridons-lair:pack:magtheridon-encounter",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.650195,
          y = 0.660582,
        },
        {
          key = "magtheridons-lair:spawn:17256:guid-5440006",
          npcId = 17256,
          packKey = "magtheridons-lair:pack:magtheridon-encounter",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.728946,
          y = 0.660962,
        },
        {
          key = "magtheridons-lair:spawn:17256:guid-5440007",
          npcId = 17256,
          packKey = "magtheridons-lair:pack:magtheridon-encounter",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.757801,
          y = 0.774544,
        },
      },
      spells = {
        [30207] = {},
        [30510] = {
          interruptible = true,
        },
        [30511] = {},
        [30528] = {
          interruptible = true,
        },
        [30530] = {},
        [30531] = {},
      },
    },
    ["17257"] = {
      characteristics = {},
      creatureType = "Demon",
      displayId = 18527,
      health = 4818380,
      level = 73,
      name = "Magtheridon",
      npcId = 17257,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T21:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
      },
      spawns = {
        {
          key = "magtheridons-lair:spawn:17257:guid-5440008",
          npcId = 17257,
          packKey = "magtheridons-lair:pack:magtheridon-encounter",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.689316,
          y = 0.739302,
        },
      },
      spells = {
        [27680] = {},
        [30205] = {},
        [30541] = {},
        [30572] = {},
        [30616] = {},
        [30619] = {},
        [30657] = {},
        [36449] = {},
        [36455] = {},
      },
    },
    ["18829"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 11440,
      health = 188896,
      level = 72,
      name = "Hellfire Warder",
      npcId = 18829,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T21:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
      },
      spawns = {
        {
          key = "magtheridons-lair:spawn:18829:guid-5440028",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:south-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.809174,
          y = 0.683449,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440029",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:south-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.802942,
          y = 0.681571,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440030",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:south-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.808604,
          y = 0.673874,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440031",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:east-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.698822,
          y = 0.59554,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440032",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:east-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.689695,
          y = 0.590514,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440033",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:east-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.680833,
          y = 0.596284,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440034",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:roaming-warders",
          patrol = {
            {
              x = 0.584366,
              y = 0.822881,
            },
            {
              x = 0.579046,
              y = 0.788886,
            },
            {
              x = 0.577409,
              y = 0.730231,
            },
            {
              x = 0.58485,
              y = 0.696459,
            },
            {
              x = 0.595794,
              y = 0.660707,
            },
            {
              x = 0.604485,
              y = 0.638424,
            },
            {
              x = 0.656861,
              y = 0.57383,
            },
            {
              x = 0.703577,
              y = 0.573916,
            },
            {
              x = 0.721164,
              y = 0.577694,
            },
            {
              x = 0.751625,
              y = 0.607769,
            },
            {
              x = 0.782955,
              y = 0.650262,
            },
            {
              x = 0.806526,
              y = 0.724004,
            },
            {
              x = 0.802034,
              y = 0.78831,
            },
            {
              x = 0.782213,
              y = 0.861805,
            },
            {
              x = 0.759422,
              y = 0.902937,
            },
            {
              x = 0.738391,
              y = 0.921168,
            },
            {
              x = 0.747119,
              y = 0.914498,
            },
            {
              x = 0.760679,
              y = 0.904689,
            },
            {
              x = 0.785298,
              y = 0.861931,
            },
            {
              x = 0.805006,
              y = 0.78487,
            },
            {
              x = 0.807026,
              y = 0.725668,
            },
            {
              x = 0.790679,
              y = 0.670683,
            },
            {
              x = 0.782787,
              y = 0.646752,
            },
            {
              x = 0.750666,
              y = 0.603515,
            },
            {
              x = 0.721088,
              y = 0.573274,
            },
            {
              x = 0.686113,
              y = 0.570061,
            },
            {
              x = 0.657945,
              y = 0.579249,
            },
            {
              x = 0.626768,
              y = 0.611029,
            },
            {
              x = 0.600587,
              y = 0.639404,
            },
            {
              x = 0.58852,
              y = 0.660896,
            },
            {
              x = 0.585162,
              y = 0.696431,
            },
            {
              x = 0.573948,
              y = 0.732325,
            },
            {
              x = 0.576706,
              y = 0.791302,
            },
            {
              x = 0.583926,
              y = 0.826481,
            },
            {
              x = 0.612137,
              y = 0.892415,
            },
            {
              x = 0.592215,
              y = 0.846592,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.587508,
          y = 0.834363,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440035",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:roaming-warders",
          patrol = {
            {
              x = 0.584517,
              y = 0.837861,
            },
            {
              x = 0.574283,
              y = 0.790598,
            },
            {
              x = 0.569692,
              y = 0.729123,
            },
            {
              x = 0.590341,
              y = 0.632707,
            },
            {
              x = 0.605745,
              y = 0.616415,
            },
            {
              x = 0.65278,
              y = 0.561453,
            },
            {
              x = 0.634674,
              y = 0.584767,
            },
            {
              x = 0.590149,
              y = 0.634781,
            },
            {
              x = 0.562877,
              y = 0.682606,
            },
            {
              x = 0.566741,
              y = 0.732054,
            },
            {
              x = 0.573578,
              y = 0.804568,
            },
            {
              x = 0.589031,
              y = 0.863547,
            },
            {
              x = 0.617198,
              y = 0.90773,
            },
            {
              x = 0.693076,
              y = 0.946838,
            },
            {
              x = 0.763251,
              y = 0.907156,
            },
            {
              x = 0.787821,
              y = 0.865284,
            },
            {
              x = 0.8021,
              y = 0.820578,
            },
            {
              x = 0.81241,
              y = 0.729931,
            },
            {
              x = 0.788077,
              y = 0.631425,
            },
            {
              x = 0.726491,
              y = 0.562957,
            },
            {
              x = 0.789248,
              y = 0.631185,
            },
            {
              x = 0.812849,
              y = 0.730692,
            },
            {
              x = 0.805428,
              y = 0.807637,
            },
            {
              x = 0.787595,
              y = 0.865937,
            },
            {
              x = 0.76119,
              y = 0.907195,
            },
            {
              x = 0.675087,
              y = 0.944459,
            },
            {
              x = 0.614907,
              y = 0.904726,
            },
            {
              x = 0.588222,
              y = 0.864312,
            },
            {
              x = 0.579552,
              y = 0.840473,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.584921,
          y = 0.836793,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440036",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:roaming-warders",
          patrol = {
            {
              x = 0.593107,
              y = 0.82951,
            },
            {
              x = 0.583841,
              y = 0.7993,
            },
            {
              x = 0.576728,
              y = 0.729979,
            },
            {
              x = 0.580972,
              y = 0.685134,
            },
            {
              x = 0.598313,
              y = 0.644628,
            },
            {
              x = 0.619011,
              y = 0.623209,
            },
            {
              x = 0.652142,
              y = 0.588832,
            },
            {
              x = 0.661242,
              y = 0.579387,
            },
            {
              x = 0.628611,
              y = 0.614846,
            },
            {
              x = 0.599317,
              y = 0.649429,
            },
            {
              x = 0.576656,
              y = 0.685753,
            },
            {
              x = 0.578913,
              y = 0.730776,
            },
            {
              x = 0.584561,
              y = 0.789021,
            },
            {
              x = 0.591828,
              y = 0.825169,
            },
            {
              x = 0.600622,
              y = 0.851438,
            },
            {
              x = 0.62134,
              y = 0.905846,
            },
            {
              x = 0.731647,
              y = 0.917752,
            },
            {
              x = 0.759167,
              y = 0.900752,
            },
            {
              x = 0.776973,
              y = 0.854283,
            },
            {
              x = 0.79468,
              y = 0.798344,
            },
            {
              x = 0.801085,
              y = 0.729568,
            },
            {
              x = 0.779653,
              y = 0.651956,
            },
            {
              x = 0.764686,
              y = 0.634691,
            },
            {
              x = 0.719172,
              y = 0.579206,
            },
            {
              x = 0.739431,
              y = 0.603346,
            },
            {
              x = 0.779452,
              y = 0.650136,
            },
            {
              x = 0.79097,
              y = 0.667049,
            },
            {
              x = 0.801327,
              y = 0.731477,
            },
            {
              x = 0.794333,
              y = 0.798639,
            },
            {
              x = 0.775754,
              y = 0.855608,
            },
            {
              x = 0.758514,
              y = 0.899991,
            },
            {
              x = 0.683214,
              y = 0.926124,
            },
            {
              x = 0.618928,
              y = 0.897069,
            },
            {
              x = 0.603632,
              y = 0.858069,
            },
            {
              x = 0.5964,
              y = 0.833135,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.590599,
          y = 0.833225,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440037",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:north-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.572508,
          y = 0.689338,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440038",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:north-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.569123,
          y = 0.672324,
        },
        {
          key = "magtheridons-lair:spawn:18829:guid-5440039",
          npcId = 18829,
          packKey = "magtheridons-lair:pack:north-warders",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T21:30:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
          },
          sublevel = 1,
          x = 0.570365,
          y = 0.71288,
        },
      },
      spells = {
        [34435] = {},
        [34436] = {},
        [34437] = {},
        [34439] = {},
        [34441] = {},
        [39175] = {
          interruptible = true,
        },
      },
    },
  },
  packs = {
    ["magtheridons-lair:pack:east-warders"] = {
      key = "magtheridons-lair:pack:east-warders",
      label = "East Hellfire Warders",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T21:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
      },
      spawnKeys = {
        "magtheridons-lair:spawn:18829:guid-5440031",
        "magtheridons-lair:spawn:18829:guid-5440032",
        "magtheridons-lair:spawn:18829:guid-5440033",
      },
    },
    ["magtheridons-lair:pack:magtheridon-encounter"] = {
      key = "magtheridons-lair:pack:magtheridon-encounter",
      label = "Magtheridon encounter",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T21:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
      },
      spawnKeys = {
        "magtheridons-lair:spawn:17256:guid-5440003",
        "magtheridons-lair:spawn:17256:guid-5440004",
        "magtheridons-lair:spawn:17256:guid-5440005",
        "magtheridons-lair:spawn:17256:guid-5440006",
        "magtheridons-lair:spawn:17256:guid-5440007",
        "magtheridons-lair:spawn:17257:guid-5440008",
      },
    },
    ["magtheridons-lair:pack:north-warders"] = {
      key = "magtheridons-lair:pack:north-warders",
      label = "North Hellfire Warders",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T21:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
      },
      spawnKeys = {
        "magtheridons-lair:spawn:18829:guid-5440037",
        "magtheridons-lair:spawn:18829:guid-5440038",
        "magtheridons-lair:spawn:18829:guid-5440039",
      },
    },
    ["magtheridons-lair:pack:roaming-warders"] = {
      key = "magtheridons-lair:pack:roaming-warders",
      label = "Roaming Hellfire Warders",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T21:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
      },
      spawnKeys = {
        "magtheridons-lair:spawn:18829:guid-5440034",
        "magtheridons-lair:spawn:18829:guid-5440035",
        "magtheridons-lair:spawn:18829:guid-5440036",
      },
    },
    ["magtheridons-lair:pack:south-warders"] = {
      key = "magtheridons-lair:pack:south-warders",
      label = "South Hellfire Warders",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T21:30:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
      },
      spawnKeys = {
        "magtheridons-lair:spawn:18829:guid-5440028",
        "magtheridons-lair:spawn:18829:guid-5440029",
        "magtheridons-lair:spawn:18829:guid-5440030",
      },
    },
  },
  pois = {
    [1] = {
      {
        label = "Magtheridon's chamber",
        source = {
          confidence = "candidate",
          observedAt = "2026-08-21T21:30:00Z",
          source = "derived",
          sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/magtheridons_lair.cpp | https://github.com/cmangos/mangos-tbc/blob/adbc7f747a3a5c4741a012d86f6cd8112238b5bc/src/game/AI/ScriptDevAI/scripts/outland/hellfire_citadel/magtheridons_lair/boss_magtheridon.cpp",
        },
        sublevel = 1,
        x = 0.689316,
        y = 0.739302,
      },
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
