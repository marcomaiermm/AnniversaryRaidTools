-- Pure-Lua acceptance checks for ART.SpawnMatcher.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
assert(loadfile(root.."/Core/SpawnMatcher.lua"))("AnniversaryRaidTools", { ART = ART })

local function candidate(spawnKey, npcId, x, y, sublevelMapId)
  return { spawnKey = spawnKey, npcId = npcId, x = x, y = y, sublevelMapId = sublevelMapId }
end

do
  assert(ART.SpawnMatcher:Resolve(nil, { npcId = 1 }) == nil, "nil candidates accepted")
  local key, reason = ART.SpawnMatcher:Resolve({}, nil)
  assert(key == nil and reason == "invalid-input", "missing unit rejected")
end

do
  local key, reason = ART.SpawnMatcher:Resolve(
      { candidate("s1", 100) }, { npcId = 200 })
  assert(key == nil and reason == "no-candidate", "different npc has no candidate")
end

-- Floor gating: mismatched floors drop candidates; unknown floors stay comparable.
local floored = { candidate("a", 100, 0, 0, 565), candidate("b", 100, 50, 50, 566) }
assert(ART.SpawnMatcher:Resolve(floored, { npcId = 100, uiMapId = 566 }) == "b", "floor filters candidates")
key, reason = ART.SpawnMatcher:Resolve(floored, { npcId = 100 })
assert(key == nil and reason == "ambiguous", "unknown floor keeps all candidates")

-- Without positions an unambiguous instance falls back to the npc id match.
assert(ART.SpawnMatcher:Resolve({ candidate("only", 100) }, { npcId = 100 }) == "only",
    "single unpositioned candidate matches")
key, reason = ART.SpawnMatcher:Resolve(
    { candidate("x1", 100), candidate("x2", 100) }, { npcId = 100 })
assert(key == nil and reason == "ambiguous", "unpositioned duplicates refuse to guess")

-- Runtime pull steps can narrow a spatial pack to the exact selected clones.
do
  local raid = {
    packs = { p = { spawnKeys = { "selected", "sibling" } } },
    enemies = { [100] = { spawns = {
      { key = "selected", npcId = 100, packKey = "p" },
      { key = "sibling", npcId = 100, packKey = "p" },
    } } },
  }
  local candidates = ART.SpawnMatcher:CandidatesForStep(raid, {
    packKeys = { "p" }, spawnKeys = { "selected" },
  })
  assert(#candidates == 1 and candidates[1].spawnKey == "selected", "runtime pull uses exact spawn membership")
end

-- Position matching picks the nearest instance within radius.
local spread = {
  candidate("near", 100, 10, 10),
  candidate("far", 100, 90, 90),
}
assert(ART.SpawnMatcher:Resolve(spread, { npcId = 100, x = 12, y = 11 }) == "near",
    "nearest candidate inside radius wins")

key, reason = ART.SpawnMatcher:Resolve(
    { candidate("spot", 100, 10, 10) }, { npcId = 100, x = 60, y = 60 })
assert(key == nil and reason == "out-of-range", "distant unit stays unmatched")

-- The ambiguity guard refuses close calls instead of guessing.
local tight = {
  candidate("left", 100, 10, 10),
  candidate("right", 100, 18, 10),
}
key, reason = ART.SpawnMatcher:Resolve(tight, { npcId = 100, x = 12, y = 10 })
assert(key == nil and reason == "ambiguous", "close pair refused")

-- Threshold overrides keep the guard testable.
key, reason = ART.SpawnMatcher:Resolve(tight, { npcId = 100, x = 12, y = 10 }, { margin = 2 })
assert(key == "left", "custom margin resolves clear winners")
key, reason = ART.SpawnMatcher:Resolve(
    { candidate("edge", 100, 29, 0) }, { npcId = 100, x = 0, y = 0 }, { radius = 30 })
assert(key == "edge", "radius boundary inclusive")

-- Chain check: the resolver consumes matcher results through getSpawnKeyForGuid.
assert(loadfile(root.."/Core/MarkResolver.lua"))("AnniversaryRaidTools", { ART = ART })
do
  local raid = {
    packs = { p = { spawnKeys = { "s1", "s2" } } },
    enemies = { [100] = { spawns = {
      { key = "s1", npcId = 100 },
      { key = "s2", npcId = 100 },
    } } },
  }
  local step = { id = "chain", packKeys = { "p" }, marks = { s1 = 8, s2 = 7 } }
  local world = { s1 = { x = 0, y = 0 }, s2 = { x = 100, y = 100 } }
  local candidates = ART.SpawnMatcher:CandidatesForStep(raid, step, world)
  local snapshots = {
    left = { npcId = 100, x = 2, y = 2 },
    right = { npcId = 100, x = 98, y = 99 },
    middle = { npcId = 100, x = 50, y = 50 },
  }
  local applied = {}
  local resolver = ART.MarkResolver.new({
    raid = raid,
    routeSteps = { step },
    profile = { npcDefaults = {}, packOverrides = {} },
    getUnitInfo = function(token)
      local snapshot = assert(snapshots[token], "unknown unit "..token)
      return { guid = token, npcId = snapshot.npcId, exists = true,
          x = snapshot.x, y = snapshot.y }
    end,
    -- Mirrors the LiveMarks runtime dependency, including threshold choice.
    getSpawnKeyForGuid = function(_, token)
      return ART.SpawnMatcher:Resolve(candidates, snapshots[token], { radius = 200, margin = 1 })
    end,
    setRaidTarget = function(token, marker) applied[token] = marker end,
  })
  assert(resolver:ActivateRouteStep("chain"))
  local marker = resolver:ResolveUnit("left")
  assert(marker == 8, "positioned unit receives its spawn override")
  marker = resolver:ResolveUnit("right")
  assert(marker == 7, "second instance receives its own override")
  marker = resolver:ResolveUnit("middle")
  assert(marker == nil, "ambiguous midpoint stays unmarked")
end

-- Mouseover of one live pack member marks every visible member of that pack.
do
  local eventFrame = { events = {} }
  function eventFrame:RegisterEvent(event) self.events[event] = true end
  function eventFrame:SetScript(_, script) self.onEvent = script end
  _G.CreateFrame = function() return eventFrame end
  _G.UIParent = {}
  _G.SlashCmdList = {}

  local units = {
    mouseover = { guid = "Creature-0-0-0-0-100-livea", x = 1, y = 1 },
    nameplate1 = { guid = "Creature-0-0-0-0-100-livea", x = 1, y = 1 },
    nameplate2 = { guid = "Creature-0-0-0-0-200-liveb", x = 11, y = 11 },
    nameplate3 = { guid = "Creature-0-0-0-0-300-livec", x = 101, y = 101 },
    nameplate4 = { guid = "Creature-0-0-0-0-400-lived", x = 111, y = 111 },
    raid1target = { guid = "Creature-0-0-0-0-200-liveb", x = 11, y = 11 },
  }
  _G.UnitExists = function(token) return units[token] ~= nil end
  _G.UnitGUID = function(token) return units[token] and units[token].guid end
  _G.UnitPosition = function(token)
    local unit = units[token]
    return unit and unit.x, unit and unit.y
  end
  local liveMarkers = {}
  local deadUnits = {}
  local markSettings = { autoMark = true }
  ART.GetDB = function() return markSettings end
  _G.GetRaidTargetIndex = function(token)
    local guid = units[token] and units[token].guid
    return guid and liveMarkers[guid]
  end
  _G.SetRaidTarget = function(token, marker)
    local guid = units[token] and units[token].guid
    if not guid then return end
    if liveMarkers[guid] == marker then
      liveMarkers[guid] = nil
    else
      for otherGuid, otherMarker in pairs(liveMarkers) do
        if otherGuid ~= guid and otherMarker == marker then liveMarkers[otherGuid] = nil end
      end
      liveMarkers[guid] = marker
    end
  end
  _G.UnitIsDeadOrGhost = function(token)
    local guid = units[token] and units[token].guid
    return guid and deadUnits[guid] == true or false
  end

  local raid = {
    key = "live",
    sublevels = { { mapId = 1 } },
    packs = {
      first = { spawnKeys = { "a", "b" } },
      second = { spawnKeys = { "c", "d" } },
    },
    enemies = {
      [100] = { spawns = { { key = "a", npcId = 100, packKey = "first", sublevel = 1 } } },
      [200] = { spawns = { { key = "b", npcId = 200, packKey = "first", sublevel = 1 } } },
      [300] = { spawns = { { key = "c", npcId = 300, packKey = "second", sublevel = 1 } } },
      [400] = { spawns = { { key = "d", npcId = 400, packKey = "second", sublevel = 1 } } },
    },
  }
  local step = { id = "live-step", packKeys = { "first" }, marks = { a = 8, b = 7 } }
  local activeMarks = { a = 8, b = 7 }
  local outsideMarks = { c = 6, d = 8 }
  ART.RaidPlanner = {
    initialized = true,
    raid = raid,
    preset = { routeSteps = { step } },
    lastPullIndex = 1,
    GetActiveStep = function() return step end,
    GetMarkedStep = function()
      local spawnKeys = {}
      for _, spawnKey in ipairs({ "c", "d" }) do
        if outsideMarks[spawnKey] then spawnKeys[#spawnKeys + 1] = spawnKey end
      end
      return {
        id = "preset-marks", packKeys = { "second" }, spawnKeys = spawnKeys, marks = outsideMarks,
      }
    end,
  }
  ART.MapWorldPositions = { live = {
    a = { x = 0, y = 0 }, b = { x = 10, y = 10 }, c = { x = 100, y = 100 }, d = { x = 110, y = 110 },
  } }
  ART.Compat = { GetBestMapForUnit = function() return 1 end }
  local applied = {}
  ART.RaidMarks = {
    initialized = true,
    ResolveUnit = function(_, token)
      local spawnKey = ART.LiveMarks and ART.LiveMarks:ResolveSpawnKey(token)
      local marker = activeMarks[spawnKey] or outsideMarks[spawnKey]
      return marker, { reason = marker and "planned" or "outside-active-step" }
    end,
    ApplyUnit = function(self, token)
      local marker = self:ResolveUnit(token)
      if not marker then return false, "outside-active-step" end
      SetRaidTarget(token, marker)
      applied[token] = true
      return true, marker
    end,
    ActivateRouteStep = function()
      for spawnKey in pairs(activeMarks) do activeMarks[spawnKey] = nil end
      for spawnKey, marker in pairs(step.marks) do activeMarks[spawnKey] = marker end
    end,
    ResetActivePack = function() end,
    OnUnitDeath = function() end,
  }

  local selectedPull
  local liveAddon = {
    ART = ART,
    SetSelectionToPull = function(_, pullIndex) selectedPull = pullIndex end,
  }
  assert(loadfile(root.."/Modules/LiveMarks.lua"))("AnniversaryRaidTools", liveAddon)
  assert(eventFrame.events.NAME_PLATE_UNIT_ADDED and eventFrame.events.NAME_PLATE_UNIT_REMOVED,
      "live marks tracks visible nameplates")
  assert(eventFrame.events.UNIT_TARGET, "live marks observes group targets")
  eventFrame.onEvent(eventFrame, "UNIT_TARGET", "raid1")
  eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "nameplate1")
  eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "nameplate2")
  eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "nameplate3")
  eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "nameplate4")
  eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
  assert(applied.raid1target, "a raid member target applies its planned mark")
  assert(applied.nameplate1 and liveMarkers[units.nameplate2.guid] == 7,
      "visible active-pull nameplates are marked immediately")
  assert(applied.nameplate3 and ART.RaidPlanner.lastPullIndex == 1,
      "preset-marked enemies outside the pull are marked without moving the pull")
  assert(not applied.nameplate4 and liveMarkers[units.nameplate1.guid] == 8,
      "outside-pull marks never steal an occupied current-pull marker")

  outsideMarks.c = 5
  ART.LiveMarks:OnPlanChanged()
  assert(liveMarkers[units.nameplate3.guid] == 5, "changed plans replace ART-owned live marks")
  outsideMarks.c = nil
  ART.LiveMarks:OnPlanChanged()
  assert(liveMarkers[units.nameplate3.guid] == nil, "cleared plans remove ART-owned live marks")
  local previousMouseover = units.mouseover
  units.mouseover = units.nameplate3
  eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
  units.mouseover = previousMouseover
  assert(liveMarkers[units.nameplate3.guid] == nil, "cleared plans stay clear on mouseover")

  step.marks.a = 6
  ART.LiveMarks:OnPlanChanged()
  assert(liveMarkers[units.nameplate1.guid] == 6, "changed active-pull marks replace Skull")
  assert(liveMarkers[units.nameplate2.guid] == 7, "changing Skull preserves other live marks")
  step.marks.a = nil
  ART.LiveMarks:OnPlanChanged()
  assert(liveMarkers[units.nameplate1.guid] == nil, "cleared active-pull Skull stays cleared")
  assert(liveMarkers[units.nameplate2.guid] == 7, "clearing Skull preserves other live marks")

  step.marks.a = 6
  markSettings.autoMark = false
  ART.LiveMarks:OnPlanChanged()
  eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
  assert(liveMarkers[units.nameplate1.guid] == nil, "disabled Auto Mark ignores plan and mouseover")
  markSettings.autoMark = true
  ART.LiveMarks:OnPlanChanged()
  assert(liveMarkers[units.nameplate1.guid] == 6, "enabling Auto Mark reconciles visible units")

  local releasedGuid = units.nameplate1.guid
  liveMarkers[releasedGuid] = nil -- Simulate a stale nameplate that still reports alive for this frame.
  _G.CombatLogGetCurrentEventInfo = function()
    return nil, "UNIT_DIED", nil, nil, nil, nil, nil, releasedGuid
  end
  eventFrame.onEvent(eventFrame, "COMBAT_LOG_EVENT_UNFILTERED")
  assert(applied.nameplate4 and liveMarkers[units.nameplate4.guid] == 8,
      "a pending outside-pull mark applies after its marker lease is released")

  -- Anniversary may expose no UnitPosition for hostile NPCs. One active pack
  -- can still map its planned instances stably onto distinct live GUIDs.
  units = {
    first = { guid = "Creature-0-0-0-0-100-first" },
    second = { guid = "Creature-0-0-0-0-100-second" },
    third = { guid = "Creature-0-0-0-0-100-third" },
  }
  raid = {
    key = "positionless",
    sublevels = { { mapId = 1 } },
    packs = { warders = { spawnKeys = { "w1", "w2", "w3" } } },
    enemies = { [100] = { spawns = {
      { key = "w1", npcId = 100, packKey = "warders", sublevel = 1 },
      { key = "w2", npcId = 100, packKey = "warders", sublevel = 1 },
      { key = "w3", npcId = 100, packKey = "warders", sublevel = 1 },
    } } },
  }
  step = {
    id = "pull-1", packKeys = { "warders" }, spawnKeys = { "w1", "w2", "w3" },
    marks = { w1 = 8, w2 = 1, w3 = 2 },
  }
  ART.RaidPlanner.raid, ART.RaidPlanner.preset = raid, { routeSteps = { step } }
  ART.RaidPlanner.lastPullIndex = 1
  ART.RaidPlanner.GetActiveStep = function() return step end
  ART.RaidPlanner.GetPullStep = function(_, pullIndex)
    return pullIndex == 2 and { id = "pull-2", packKeys = { "warders" }, spawnKeys = { "w1" }, marks = {} }
  end
  ART.MapWorldPositions.positionless = {}
  ART.LiveMarks:OnPullSelected(step, 1)
  assert(ART.LiveMarks:ResolveSpawnKey("first") == "w1", "first positionless unit gets a planned spawn")
  assert(ART.LiveMarks:ResolveSpawnKey("second") == "w2", "second positionless unit gets a distinct spawn")
  assert(ART.LiveMarks:ResolveSpawnKey("first") == "w1", "positionless GUID mapping stays stable")
  assert(ART.LiveMarks:ResolveSpawnKey("third") == "w3", "every planned positionless unit can resolve")

  -- The mover waits for every exact pull member and never advances on combat
  -- state alone. The last confirmed death advances to the next existing pull.
  local inCombat = true
  _G.UnitAffectingCombat = function(token) return token == "player" and inCombat end
  local deadGuid
  _G.CombatLogGetCurrentEventInfo = function()
    return nil, "UNIT_DIED", nil, nil, nil, nil, nil, deadGuid
  end
  for _, guid in ipairs({ units.first.guid, units.second.guid }) do
    deadGuid = guid
    deadUnits[guid] = true
    eventFrame.onEvent(eventFrame, "COMBAT_LOG_EVENT_UNFILTERED")
    assert(selectedPull == nil, "partial pull death must not advance")
  end
  deadGuid = units.third.guid
  deadUnits[deadGuid] = true
  eventFrame.onEvent(eventFrame, "COMBAT_LOG_EVENT_UNFILTERED")
  assert(selectedPull == nil, "completed pull waits until the raid leaves combat")
  inCombat = false
  eventFrame.onEvent(eventFrame, "PLAYER_REGEN_ENABLED")
  assert(selectedPull == 2, "all confirmed pull deaths advance to the next pull")

  -- A combined pull may contain multiple positionless packs of the same NPC.
  -- The player's world position anchors each live group to its nearest pack.
  units = {
    player = { guid = "Player-0-0", x = 0, y = 0 },
    near1 = { guid = "Creature-0-0-0-0-100-near1" },
    near2 = { guid = "Creature-0-0-0-0-100-near2" },
    far1 = { guid = "Creature-0-0-0-0-100-far1" },
    far2 = { guid = "Creature-0-0-0-0-100-far2" },
  }
  raid = {
    key = "positionless-multi-pack",
    sublevels = { { mapId = 1 } },
    packs = {
      near = { spawnKeys = { "n1", "n2" } },
      far = { spawnKeys = { "f1", "f2" } },
    },
    enemies = { [100] = { spawns = {
      { key = "n1", npcId = 100, packKey = "near", sublevel = 1 },
      { key = "n2", npcId = 100, packKey = "near", sublevel = 1 },
      { key = "f1", npcId = 100, packKey = "far", sublevel = 1 },
      { key = "f2", npcId = 100, packKey = "far", sublevel = 1 },
    } } },
  }
  step = {
    id = "pull-multi", packKeys = { "near", "far" }, spawnKeys = { "n1", "n2", "f1", "f2" },
    marks = { n1 = 1, n2 = 2, f1 = 3, f2 = 4 },
  }
  ART.RaidPlanner.raid, ART.RaidPlanner.preset = raid, { routeSteps = { step } }
  ART.RaidPlanner.GetActiveStep = function() return step end
  ART.MapWorldPositions[raid.key] = {
    n1 = { x = 0, y = 0 }, n2 = { x = 2, y = 0 },
    f1 = { x = 100, y = 0 }, f2 = { x = 102, y = 0 },
  }
  assert(ART.LiveMarks:ResolveSpawnKey("near1") == "n1", "near multi-pack unit resolves")
  assert(ART.LiveMarks:ResolveSpawnKey("near2") == "n2", "near pack allocation stays distinct")
  for spawnKey in pairs(activeMarks) do activeMarks[spawnKey] = nil end
  for spawnKey, marker in pairs(step.marks) do activeMarks[spawnKey] = marker end
  markSettings.autoMark = false
  eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "near1")
  eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "near2")
  units.mouseover = units.near1
  markSettings.autoMark = true
  eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
  assert(liveMarkers[units.near1.guid] == 1 and liveMarkers[units.near2.guid] == 2,
      "hover marks the visible group of a multi-pack pull")

  units.player.x = 100
  assert(ART.LiveMarks:ResolveSpawnKey("far1") == "f1", "far multi-pack unit resolves after moving")
  assert(ART.LiveMarks:ResolveSpawnKey("far2") == "f2", "far pack allocation stays distinct")
  markSettings.autoMark = false
  eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "far1")
  eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "far2")
  units.mouseover = units.far1
  markSettings.autoMark = true
  eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
  assert(liveMarkers[units.far1.guid] == 3 and liveMarkers[units.far2.guid] == 4,
      "hover marks the second visible group of a multi-pack pull")

  units = {
    first = { guid = "Creature-0-0-0-0-100-group1" },
    second = { guid = "Creature-0-0-0-0-100-group2" },
    third = { guid = "Creature-0-0-0-0-100-group3" },
    fourth = { guid = "Creature-0-0-0-0-100-group4" },
  }
  step.id = "pull-multi-without-player-position"
  assert(ART.LiveMarks:ResolveSpawnKey("first") == "n1", "pull order resolves without player position")
  assert(ART.LiveMarks:ResolveSpawnKey("second") == "n2", "first pack fills without player position")
  assert(ART.LiveMarks:ResolveSpawnKey("third") == "f1", "next pack starts after the first is full")
  assert(ART.LiveMarks:ResolveSpawnKey("fourth") == "f2", "all combined-pull mobs resolve without positions")
end

print("spawn matcher checks passed")
