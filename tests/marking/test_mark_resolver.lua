-- Pure-Lua acceptance checks for ART.MarkResolver.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
assert(loadfile(root.."/Core/MarkResolver.lua"))("AnniversaryRaidTools", { ART = ART })

local function equal(actual, expected, message)
  assert(actual == expected, (message or "values differ")..": got "..tostring(actual)..", expected "..tostring(expected))
end

local function fixture()
  local units = {}
  local raid = {
    packs = {
      p = { spawnKeys = { "s1", "s2", "s3", "s4" } },
      q = { spawnKeys = { "s5" } },
    },
    enemies = {
      [100] = { spawns = {
        { key = "s1", npcId = 100, packKey = "p" },
        { key = "s2", npcId = 100, packKey = "p" },
        { key = "s3", npcId = 100, packKey = "p" },
      } },
      [200] = { spawns = { { key = "s4", npcId = 200, packKey = "p" } } },
      [300] = { spawns = { { key = "s5", npcId = 300, packKey = "q" } } },
    },
  }
  local step = { id = "step-1", packKeys = { "p" }, marks = { s1 = 8 } }
  local dependencies = {
    raid = raid,
    routeSteps = { step },
    profile = {
      npcDefaults = { [100] = { 1, 2 }, [200] = { 3 } },
      packOverrides = { p = { npcDefaults = { [100] = { 4 } }, spawns = { s2 = 7 } } },
    },
    getUnitInfo = function(token) return units[token] end,
    unitExists = function(token) return units[token] ~= nil end,
    setRaidTarget = function(token, marker) units[token].applied = marker end,
  }
  return dependencies, units
end

local function resolverWith(dependencies)
  local resolver = ART.MarkResolver.new(dependencies)
  assert(resolver:ActivateRouteStep("step-1"))
  return resolver
end

do
  local dependencies, units = fixture()
  units.step = { guid = "g-step", npcId = 100, spawnKey = "s1" }
  local resolver = resolverWith(dependencies)
  equal(resolver:ResolveUnit("step"), 8, "step spawn override wins")

  resolver:ResetActivePack()
  dependencies.routeSteps[1].marks = {}
  units.pack = { guid = "g-pack", npcId = 100, spawnKey = "s2" }
  equal(resolver:ResolveUnit("pack"), 7, "pack spawn override wins")

  resolver:ResetActivePack()
  dependencies.profile.packOverrides.p.spawns = {}
  units.packNpc = { guid = "g-pack-npc", npcId = 100, spawnKey = "s1" }
  equal(resolver:ResolveUnit("packNpc"), 4, "pack NPC rule wins")

  resolver:ResetActivePack()
  dependencies.profile.packOverrides.p.npcDefaults = {}
  dependencies.profile.packOverrides.p.spawns = {}
  units.presetNpc = { guid = "g-preset-npc", npcId = 100, spawnKey = "s1" }
  equal(resolver:ResolveUnit("presetNpc"), 1, "preset NPC rule wins")

  resolver:ResetActivePack()
  units.none = { guid = "g-none", npcId = 999, spawnKey = "s1" }
  equal(resolver:ResolveUnit("none"), nil, "missing rule has no mark")
end

do
  local dependencies, units = fixture()
  dependencies.profile.packOverrides.p = nil
  dependencies.routeSteps[1].marks = {}
  units.a = { guid = "guid-a", npcId = 100, spawnKey = "s1" }
  units.b = { guid = "guid-b", npcId = 100, spawnKey = "s2" }
  units.c = { guid = "guid-c", npcId = 100, spawnKey = "s3" }
  local resolver = resolverWith(dependencies)
  equal(resolver:ResolveUnit("a"), 1, "first duplicate gets first marker")
  equal(resolver:ResolveUnit("b"), 2, "second duplicate gets next marker")
  equal(resolver:ResolveUnit("a"), 1, "GUID assignment is stable")
  equal(resolver:ResolveUnit("c"), nil, "duplicate slots exhaust")
  resolver:OnUnitDeath("guid-a")
  equal(resolver:ResolveUnit("c"), 1, "dead GUID releases marker")
  resolver:ResetActivePack()
  equal(resolver:ResolveUnit("b"), 1, "step reset releases assignments")
end

do
  local dependencies, units = fixture()
  dependencies.profile.npcDefaults = {}
  dependencies.routeSteps[1].marks = { s1 = 8, s2 = 7 }
  units.poolA = { guid = "pool-a", npcId = 100, packKey = "p",
    candidateSpawnKeys = { "s1", "s2" } }
  units.poolB = { guid = "pool-b", npcId = 100, packKey = "p",
    candidateSpawnKeys = { "s1", "s2" } }
  local resolver = resolverWith(dependencies)
  equal(resolver:ResolveUnit("poolA"), 8, "ambiguous clone uses first planned pool marker")
  equal(resolver:ResolveUnit("poolB"), 7, "ambiguous clone uses second planned pool marker")
  assert(resolver.assignments["pool-a"].spawnKey == nil, "pool assignment has no fake spawn identity")

  resolver:ResetActivePack()
  dependencies.routeSteps[1].marks = {}
  dependencies.getSpawnMarker = function(spawnKey)
    return ({ s1 = 6, s2 = 5 })[spawnKey]
  end
  units.presetPool = { guid = "preset-pool", npcId = 100, packKey = "p",
    candidateSpawnKeys = { "s1", "s2" } }
  equal(resolver:ResolveUnit("presetPool"), 6, "preset pool markers survive without active-step marks")
end

do
  local dependencies, units = fixture()
  local matchCalls, legacyCalls = 0, 0
  dependencies.getMatchForUnit = function()
    matchCalls = matchCalls + 1
    return { kind = "packPool", packKey = "p", candidateSpawnKeys = { "s1", "s2" } }
  end
  dependencies.getSpawnKeyForGuid = function()
    legacyCalls = legacyCalls + 1
    return "s1"
  end
  units.pool = { guid = "pool", npcId = 100 }
  local resolver = resolverWith(dependencies)
  equal(resolver:ResolveUnit("pool"), 8, "canonical match resolves planned pool marker")
  assert(matchCalls == 1 and legacyCalls == 0, "canonical match does not invoke legacy spawn resolution")
end

do
  local dependencies, units = fixture()
  dependencies.routeSteps[1].marks = {}
  local resolver = resolverWith(dependencies)
  local beforeAssignments, beforeMarkers = resolver.assignments, resolver.usedMarkers
  local preview = resolver:GetPreviewForPack("p")
  equal(preview.s1.marker, 4, "preview uses pack NPC rule")
  equal(preview.s2.marker, 7, "preview uses pack spawn rule")
  assert(resolver.assignments == beforeAssignments and resolver.usedMarkers == beforeMarkers, "preview changes resolver state")
end

do
  local dependencies, units = fixture()
  dependencies.routeSteps[1].marks = {}
  local resolver = resolverWith(dependencies)
  local ok, reason = resolver:ApplyUnit("missing")
  equal(ok, false, "missing unit is not applied")
  equal(reason, "missing", "missing reason")

  units.friendly = { guid = "friendly", npcId = 100, spawnKey = "s1", friendly = true }
  ok, reason = resolver:ApplyUnit("friendly")
  equal(reason, "friendly", "friendly reason")
  units.dead = { guid = "dead", npcId = 100, spawnKey = "s1", dead = true }
  ok, reason = resolver:ApplyUnit("dead")
  equal(reason, "dead", "dead reason")
  dependencies.canMark = false
  units.permission = { guid = "permission", npcId = 100, spawnKey = "s1" }
  ok, reason = resolver:ApplyUnit("permission")
  equal(reason, "permission", "permission reason")
  dependencies.canMark = nil
  dependencies.inCombat = true
  units.combat = { guid = "combat", npcId = 100, spawnKey = "s1" }
  ok, reason = resolver:ApplyUnit("combat")
  equal(reason, "combat", "combat reason")
  dependencies.inCombat = nil
  units.outside = { guid = "outside", npcId = 100, spawnKey = "not-in-step" }
  ok, reason = resolver:ApplyUnit("outside")
  equal(reason, "outside-active-step", "outside-step reason")
  dependencies.allowOutsideActiveStep = true
  dependencies.getSpawnMarker = function(spawnKey) return spawnKey == "s5" and 6 or nil end
  units.presetWide = { guid = "preset-wide", npcId = 300, spawnKey = "s5" }
  ok, reason = resolver:ApplyUnit("presetWide")
  equal(ok, true, "an explicit preset mark applies outside the active pull")
  equal(units.presetWide.applied, 6, "outside-pull application keeps the planned marker")
  resolver:ResetActivePack()
  units.existing = { guid = "existing", npcId = 100, spawnKey = "s1", currentMarker = 6 }
  ok, reason = resolver:ApplyUnit("existing")
  equal(reason, "existing-marker", "preservation reason")
  units.good = { guid = "good", npcId = 100, spawnKey = "s1" }
  ok, reason = resolver:ApplyUnit("good")
  equal(ok, true, "valid unit is applied")
  equal(units.good.applied, 4, "ApplyUnit sets the resolved marker without changing target")

  _G.InCombatLockdown = function() return true end
  resolver:ResetActivePack()
  units.nativeCombat = { guid = "native-combat", npcId = 100, spawnKey = "s1" }
  ok, reason = resolver:ApplyUnit("nativeCombat")
  equal(ok, true, "native combat lockdown does not block raid target marking")
  _G.InCombatLockdown = nil

  dependencies.profile.packOverrides.p.npcDefaults = {}
  dependencies.profile.packOverrides.p.spawns = {}
  dependencies.profile.npcDefaults[100] = { 1 }
  resolver:ResetActivePack()
  units.fullA = { guid = "full-a", npcId = 100, spawnKey = "s1" }
  units.fullB = { guid = "full-b", npcId = 100, spawnKey = "s2" }
  equal(resolver:ApplyUnit("fullA"), true, "first slot applies")
  ok, reason = resolver:ApplyUnit("fullB")
  equal(reason, "slots-exhausted", "exhausted slots reason")

  resolver:ResetActivePack()
  dependencies.apiAllowsMarking = false
  units.api = { guid = "api", npcId = 100, spawnKey = "s1" }
  ok, reason = resolver:ApplyUnit("api")
  equal(reason, "api-forbidden", "API restriction reason")
  dependencies.apiAllowsMarking = nil
  units.unmarked = { guid = "unmarked", npcId = 999, spawnKey = "s1" }
  ok, reason = resolver:ApplyUnit("unmarked")
  equal(reason, "no-mark", "unmarked NPC reason")
end

print("mark resolver checks passed")
