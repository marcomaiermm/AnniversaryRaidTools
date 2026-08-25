-- GENERATED FILE. Do not edit; rerun tools/generator/generate.py.
-- Generator: art-030-generator-v2
-- Source: TBC candidate snapshot; not Anniversary-verified.
-- SourceRef: https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations
-- ObservedAt: 2026-08-21T18:15:00Z
local raid = {
  schemaVersion = 1,
  key = "gruuls-lair",
  name = "Gruul's Lair",
  expansion = "TBC",
  instanceId = 565,
  mapId = 565,
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
      mapId = 565,
      name = "Gruul's Lair",
    },
  },
  enemies = {
    ["18831"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 18649,
      health = 758800,
      level = 73,
      name = "High King Maulgar",
      npcId = 18831,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18831:maulgar",
          npcId = 18831,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.537665,
          y = 0.555574,
        },
      },
      spells = {
        [16508] = {},
        [26561] = {},
        [28168] = {},
        [33230] = {},
        [33232] = {},
        [33238] = {},
        [39144] = {},
      },
    },
    ["18832"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 20194,
      health = 303500,
      level = 73,
      name = "Krosh Firehand",
      npcId = 18832,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18832:krosh",
          npcId = 18832,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.565678,
          y = 0.53622,
        },
      },
      spells = {
        [33051] = {},
        [33054] = {},
        [33061] = {},
      },
    },
    ["18834"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 20195,
      health = 303500,
      level = 73,
      name = "Olm the Summoner",
      npcId = 18834,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18834:olm",
          npcId = 18834,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.551699,
          y = 0.545654,
        },
      },
      spells = {
        [33129] = {},
        [33130] = {},
        [33131] = {},
      },
    },
    ["18835"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 12472,
      health = 303500,
      level = 73,
      name = "Kiggler the Crazed",
      npcId = 18835,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18835:kiggler",
          npcId = 18835,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.509912,
          y = 0.547257,
        },
      },
      spells = {
        [33173] = {},
        [33175] = {},
        [33237] = {},
        [36152] = {},
      },
    },
    ["18836"] = {
      characteristics = {
        Stun = true,
      },
      creatureType = "Humanoid",
      displayId = 11585,
      health = 212450,
      level = 73,
      name = "Blindeye the Seer",
      npcId = 18836,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:18836:blindeye",
          npcId = 18836,
          packKey = "gruuls-lair:pack:maulgar",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.52396,
          y = 0.550769,
        },
      },
      spells = {
        [30991] = {},
        [30992] = {},
        [33144] = {
          interruptible = true,
        },
        [33147] = {},
        [33152] = {
          interruptible = true,
        },
      },
    },
    ["19044"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 18698,
      health = 3414600,
      level = 73,
      name = "Gruul the Dragonkiller",
      npcId = 19044,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:19044:gruul",
          npcId = 19044,
          packKey = "gruuls-lair:pack:gruul",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.199,
          y = 0.283,
        },
      },
      spells = {
        [33525] = {},
        [33654] = {},
        [33812] = {},
        [33965] = {},
        [36240] = {},
        [36297] = {},
        [36300] = {},
        [39188] = {},
      },
    },
    ["19389"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 18356,
      health = 298298,
      level = 72,
      name = "Lair Brute",
      npcId = 19389,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:19389:entrance-brute",
          npcId = 19389,
          packKey = "gruuls-lair:pack:trash-entrance",
          patrol = {
            {
              x = 0.675152,
              y = 0.764071,
            },
            {
              x = 0.640962,
              y = 0.752212,
            },
            {
              x = 0.623387,
              y = 0.726221,
            },
            {
              x = 0.641583,
              y = 0.751593,
            },
            {
              x = 0.675594,
              y = 0.763512,
            },
            {
              x = 0.737555,
              y = 0.773571,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.715266,
          y = 0.772488,
        },
        {
          key = "gruuls-lair:spawn:19389:lower-corridor-brute-1",
          npcId = 19389,
          packKey = "gruuls-lair:pack:trash-lower-corridor",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.368316,
          y = 0.651831,
        },
        {
          key = "gruuls-lair:spawn:19389:lower-corridor-brute-2",
          npcId = 19389,
          packKey = "gruuls-lair:pack:trash-lower-corridor",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.365617,
          y = 0.690058,
        },
        {
          key = "gruuls-lair:spawn:19389:upper-corridor-brute-1",
          npcId = 19389,
          packKey = "gruuls-lair:pack:trash-upper-corridor",
          patrol = {
            {
              x = 0.24593,
              y = 0.633043,
            },
            {
              x = 0.271219,
              y = 0.645691,
            },
            {
              x = 0.272661,
              y = 0.654389,
            },
            {
              x = 0.257869,
              y = 0.638457,
            },
            {
              x = 0.242185,
              y = 0.628889,
            },
            {
              x = 0.225682,
              y = 0.60912,
            },
            {
              x = 0.215558,
              y = 0.585691,
            },
            {
              x = 0.209474,
              y = 0.566106,
            },
            {
              x = 0.211385,
              y = 0.538949,
            },
            {
              x = 0.207008,
              y = 0.489563,
            },
            {
              x = 0.209819,
              y = 0.535777,
            },
            {
              x = 0.207901,
              y = 0.564311,
            },
            {
              x = 0.216884,
              y = 0.587263,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.230907,
          y = 0.617357,
        },
        {
          key = "gruuls-lair:spawn:19389:upper-corridor-brute-2",
          npcId = 19389,
          packKey = "gruuls-lair:pack:trash-gruul-hall",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.207905,
          y = 0.463731,
        },
        {
          key = "gruuls-lair:spawn:19389:upper-corridor-brute-3",
          npcId = 19389,
          packKey = "gruuls-lair:pack:trash-gruul-hall",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.221543,
          y = 0.458174,
        },
        {
          key = "gruuls-lair:spawn:19389:gruul-hall-brute",
          npcId = 19389,
          packKey = "gruuls-lair:pack:trash-gruul-hall",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.196272,
          y = 0.45662,
        },
      },
      spells = {
        [24193] = {},
        [39171] = {},
        [39174] = {},
      },
    },
    ["21350"] = {
      characteristics = {},
      creatureType = "Humanoid",
      displayId = 20241,
      health = 236120,
      level = 72,
      name = "Gronn-Priest",
      npcId = 21350,
      scale = 1,
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawns = {
        {
          key = "gruuls-lair:spawn:21350:entrance-priest-1",
          npcId = 21350,
          packKey = "gruuls-lair:pack:trash-entrance",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.655804,
          y = 0.776757,
        },
        {
          key = "gruuls-lair:spawn:21350:entrance-priest-2",
          npcId = 21350,
          packKey = "gruuls-lair:pack:trash-entrance",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.658903,
          y = 0.745376,
        },
        {
          key = "gruuls-lair:spawn:21350:lower-corridor-priest",
          npcId = 21350,
          packKey = "gruuls-lair:pack:trash-lower-corridor",
          patrol = {
            {
              x = 0.361693,
              y = 0.670951,
            },
            {
              x = 0.312337,
              y = 0.654357,
            },
            {
              x = 0.3042,
              y = 0.657366,
            },
            {
              x = 0.2852,
              y = 0.654057,
            },
            {
              x = 0.312691,
              y = 0.653857,
            },
          },
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.355221,
          y = 0.67126,
        },
        {
          key = "gruuls-lair:spawn:21350:gruul-hall-priest-1",
          npcId = 21350,
          packKey = "gruuls-lair:pack:trash-upper-corridor",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.282027,
          y = 0.675069,
        },
        {
          key = "gruuls-lair:spawn:21350:gruul-hall-priest-2",
          npcId = 21350,
          packKey = "gruuls-lair:pack:trash-upper-corridor",
          source = {
            confidence = "candidate",
            observedAt = "2026-08-21T18:15:00Z",
            source = "derived",
            sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
          },
          sublevel = 1,
          x = 0.265842,
          y = 0.670949,
        },
      },
      spells = {
        [22884] = {},
        [36678] = {
          interruptible = true,
        },
        [36679] = {},
      },
    },
  },
  packs = {
    ["gruuls-lair:pack:gruul"] = {
      key = "gruuls-lair:pack:gruul",
      label = "Gruul the Dragonkiller",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
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
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawnKeys = {
        "gruuls-lair:spawn:18831:maulgar",
        "gruuls-lair:spawn:18832:krosh",
        "gruuls-lair:spawn:18834:olm",
        "gruuls-lair:spawn:18835:kiggler",
        "gruuls-lair:spawn:18836:blindeye",
      },
    },
    ["gruuls-lair:pack:trash-entrance"] = {
      key = "gruuls-lair:pack:trash-entrance",
      label = "Entrance trash",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawnKeys = {
        "gruuls-lair:spawn:19389:entrance-brute",
        "gruuls-lair:spawn:21350:entrance-priest-1",
        "gruuls-lair:spawn:21350:entrance-priest-2",
      },
    },
    ["gruuls-lair:pack:trash-gruul-hall"] = {
      key = "gruuls-lair:pack:trash-gruul-hall",
      label = "Gruul hall trash",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawnKeys = {
        "gruuls-lair:spawn:19389:gruul-hall-brute",
        "gruuls-lair:spawn:19389:upper-corridor-brute-2",
        "gruuls-lair:spawn:19389:upper-corridor-brute-3",
      },
    },
    ["gruuls-lair:pack:trash-lower-corridor"] = {
      key = "gruuls-lair:pack:trash-lower-corridor",
      label = "Lower corridor trash",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawnKeys = {
        "gruuls-lair:spawn:19389:lower-corridor-brute-1",
        "gruuls-lair:spawn:19389:lower-corridor-brute-2",
        "gruuls-lair:spawn:21350:lower-corridor-priest",
      },
    },
    ["gruuls-lair:pack:trash-upper-corridor"] = {
      key = "gruuls-lair:pack:trash-upper-corridor",
      label = "Upper corridor trash",
      source = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
      spawnKeys = {
        "gruuls-lair:spawn:19389:upper-corridor-brute-1",
        "gruuls-lair:spawn:21350:gruul-hall-priest-1",
        "gruuls-lair:spawn:21350:gruul-hall-priest-2",
      },
    },
  },
  pois = {
    [1] = {
      {
        label = "Gruul's arena",
        source = {
          confidence = "candidate",
          observedAt = "2026-08-21T18:15:00Z",
          source = "derived",
          sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
        },
        sublevel = 1,
        x = 0.199,
        y = 0.283,
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
