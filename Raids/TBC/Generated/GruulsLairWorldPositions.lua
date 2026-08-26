-- GENERATED FILE. Do not edit; rerun tools/generator/generate.py.
-- Generator: art-030-generator-v2
-- Integration-private world-position matching inputs; raid schema v1 is unchanged.
local _, ART = ...
ART.MapWorldPositions = ART.MapWorldPositions or {}
ART.MapWorldPositions["gruuls-lair"] = {
    _meta = {
      provenance = {
        confidence = "candidate",
        observedAt = "2026-08-21T18:15:00Z",
        source = "derived",
        sourceRef = "https://github.com/cmangos/tbc-db/blob/7060a217bcf7c454db570e842cd5e2179444d768/Full_DB/TBCDB_1.11.0_Vengeance_One_A_Cmangos_Story.sql.gz | https://warcraft.wiki.gg/wiki/Gruul_the_Dragonkiller#Locations",
      },
    },
    ["gruuls-lair:spawn:18831:maulgar"] = {
      coordinateKind = "derived-affine",
      x = 143.0491,
      y = 192.725875,
    },
    ["gruuls-lair:spawn:18832:krosh"] = {
      coordinateKind = "derived-affine",
      x = 149.823,
      y = 178.01905,
    },
    ["gruuls-lair:spawn:18834:olm"] = {
      coordinateKind = "derived-affine",
      x = 146.5211,
      y = 185.358025,
    },
    ["gruuls-lair:spawn:18835:kiggler"] = {
      coordinateKind = "derived-affine",
      x = 145.96005,
      y = 207.2962,
    },
    ["gruuls-lair:spawn:18836:blindeye"] = {
      coordinateKind = "derived-affine",
      x = 144.73085,
      y = 199.921,
    },
    ["gruuls-lair:spawn:19044:gruul"] = {
      coordinateKind = "derived-affine",
      x = 238.45,
      y = 370.525,
    },
    ["gruuls-lair:spawn:19389:entrance-brute"] = {
      coordinateKind = "derived-affine",
      patrol = {
        {
          x = 70.07515,
          y = 120.5452,
        },
        {
          x = 74.2258,
          y = 138.49495,
        },
        {
          x = 83.32265,
          y = 147.721825,
        },
        {
          x = 74.44245,
          y = 138.168925,
        },
        {
          x = 70.2708,
          y = 120.31315,
        },
        {
          x = 66.75015,
          y = 87.783625,
        },
      },
      patrolCoordinateKind = "derived-affine",
      x = 67.1292,
      y = 99.48535,
    },
    ["gruuls-lair:spawn:19389:gruul-hall-brute"] = {
      coordinateKind = "derived-affine",
      x = 177.683,
      y = 371.9572,
    },
    ["gruuls-lair:spawn:19389:lower-corridor-brute-1"] = {
      coordinateKind = "derived-affine",
      x = 109.35915,
      y = 281.6341,
    },
    ["gruuls-lair:spawn:19389:lower-corridor-brute-2"] = {
      coordinateKind = "derived-affine",
      x = 95.9797,
      y = 283.051075,
    },
    ["gruuls-lair:spawn:19389:upper-corridor-brute-1"] = {
      coordinateKind = "derived-affine",
      patrol = {
        {
          x = 115.93495,
          y = 345.88675,
        },
        {
          x = 111.50815,
          y = 332.610025,
        },
        {
          x = 108.46385,
          y = 331.852975,
        },
        {
          x = 114.04005,
          y = 339.618775,
        },
        {
          x = 117.38885,
          y = 347.852875,
        },
        {
          x = 124.308,
          y = 356.51695,
        },
        {
          x = 132.50815,
          y = 361.83205,
        },
        {
          x = 139.3629,
          y = 365.02615,
        },
        {
          x = 148.86785,
          y = 364.022875,
        },
        {
          x = 166.15295,
          y = 366.3208,
        },
        {
          x = 149.97805,
          y = 364.845025,
        },
        {
          x = 139.99115,
          y = 365.851975,
        },
        {
          x = 131.95795,
          y = 361.1359,
        },
      },
      patrolCoordinateKind = "derived-affine",
      x = 121.42505,
      y = 353.773825,
    },
    ["gruuls-lair:spawn:19389:upper-corridor-brute-2"] = {
      coordinateKind = "derived-affine",
      x = 175.19415,
      y = 365.849875,
    },
    ["gruuls-lair:spawn:19389:upper-corridor-brute-3"] = {
      coordinateKind = "derived-affine",
      x = 177.1391,
      y = 358.689925,
    },
    ["gruuls-lair:spawn:21350:entrance-priest-1"] = {
      coordinateKind = "derived-affine",
      x = 65.63505,
      y = 130.7029,
    },
    ["gruuls-lair:spawn:21350:entrance-priest-2"] = {
      coordinateKind = "derived-affine",
      x = 76.6184,
      y = 129.075925,
    },
    ["gruuls-lair:spawn:21350:gruul-hall-priest-1"] = {
      coordinateKind = "derived-affine",
      x = 101.22585,
      y = 326.935825,
    },
    ["gruuls-lair:spawn:21350:gruul-hall-priest-2"] = {
      coordinateKind = "derived-affine",
      x = 102.66785,
      y = 335.43295,
    },
    ["gruuls-lair:spawn:21350:lower-corridor-priest"] = {
      coordinateKind = "derived-affine",
      patrol = {
        {
          x = 102.66715,
          y = 285.111175,
        },
        {
          x = 108.47505,
          y = 311.023075,
        },
        {
          x = 107.4219,
          y = 315.295,
        },
        {
          x = 108.58005,
          y = 325.27,
        },
        {
          x = 108.65005,
          y = 310.837225,
        },
      },
      patrolCoordinateKind = "derived-affine",
      x = 102.559,
      y = 288.508975,
    },
  }
return ART.MapWorldPositions["gruuls-lair"]
