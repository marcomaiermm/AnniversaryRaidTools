local loader = require("helpers.addon_loader")

describe("LiveMarks runtime nameplates", function()
  local function newRuntime(options)
    options = options or {}
    local settings = {
      autoMark = options.autoMark ~= false,
      autoMarkNameplates = options.autoMarkNameplates ~= false,
      autoMarkModifier = "ALT",
    }
    local units, markers, setCalls, getCalls = {}, {}, {}, {}
    local inCombat = false
    local frame = { events = {} }

    function frame:RegisterEvent(event) self.events[event] = true end
    function frame:UnregisterEvent(event) self.events[event] = nil end
    function frame:SetScript(_, callback) self.onEvent = callback end

    local env = setmetatable({
      UIParent = {},
      wipe = function(value) for key in pairs(value) do value[key] = nil end end,
    }, { __index = _G })
    env._G = env

    local function unit(token, details)
      details = details or {}
      details.guid = details.guid or error("unit GUID is required")
      units[token] = details
      return details
    end

    env.CreateFrame = function() return frame end
    env.UnitExists = function(token)
      return units[token] ~= nil and units[token].exists ~= false
    end
    env.UnitGUID = function(token)
      local value = units[token]
      return value and value.exists ~= false and value.guid
    end
    env.UnitCanAttack = function(_, token)
      local value = units[token]
      return value and value.friendly ~= true
    end
    env.UnitIsDeadOrGhost = function(token)
      return units[token] and units[token].dead == true
    end
    env.UnitFullName = function(token)
      local value = units[token]
      return value and value.name, value and value.realm
    end
    env.IsInRaid = function() return false end
    env.UnitIsGroupLeader = function() return false end
    env.UnitIsGroupAssistant = function() return false end
    env.IsAltKeyDown = function() return true end
    env.IsShiftKeyDown = function() return false end
    env.IsControlKeyDown = function() return false end
    env.UnitAffectingCombat = function() return inCombat end
    env.GetRaidTargetIndex = function(token)
      getCalls[token] = (getCalls[token] or 0) + 1
      local value = units[token]
      return value and markers[value.guid]
    end
    env.SetRaidTarget = function(token, marker)
      local value = units[token]
      if not value then error("unknown unit: "..tostring(token)) end
      if value.exists == false then error("missing unit: "..tostring(token)) end
      setCalls[#setCalls + 1] = { token = token, marker = marker }
      if marker == 0 then
        markers[value.guid] = nil
      else
        for guid, current in pairs(markers) do
          if guid ~= value.guid and current == marker then markers[guid] = nil end
        end
        markers[value.guid] = marker
      end
      return true
    end
    env.RemoveRaidTargets = function()
      for guid in pairs(markers) do markers[guid] = nil end
    end

    local combatSubevent, combatDestGuid
    env.CombatLogGetCurrentEventInfo = function()
      return nil, combatSubevent, nil, nil, nil, nil, nil, combatDestGuid
    end

    local ART = { GetDB = function() return settings end }
    loader.load("Core/MarkResolver.lua", ART, env)
    loader.load("Modules/RaidMarks.lua", ART, env)
    loader.load("Modules/LiveMarks.lua", ART, env)

    local step = {
      id = "pull-1",
      marks = { pullNpc = 8 },
    }
    local raid = {
      enemies = {
        [100] = { spawns = { { key = "pullNpc", npcId = 100 } } },
        [200] = { spawns = { { key = "floorNpc", npcId = 200 } } },
      },
    }
    local desiredPlayerMarks, preset = {}, { value = {} }
    ART.GetCurrentPreset = function() return preset end
    ART.PlayerMarks = {
      GetActiveMarks = function() return desiredPlayerMarks end,
    }
    ART.RaidPlanner = { GetActiveStep = function() return step end }
    local resolver = ART.MarkResolver.new({
      raid = raid,
      routeSteps = { step },
      profile = {
        floorNpcDefaults = { [1] = { [100] = { 8 }, [200] = { 8 } } },
        floorNpcPriority = { [1] = { 200, 100 } },
      },
      getCurrentSublevel = function() return 1 end,
      markerAvailable = function(marker, guid)
        return ART.LiveMarks:IsMarkerAvailable(marker, guid)
      end,
    })
    ART.RaidMarks:Initialize({ resolver = resolver })
    assert.is_true(ART.RaidMarks:ActivateRouteStep(step.id))

    local runtime = {
      ART = ART,
      frame = frame,
      units = units,
      markers = markers,
      setCalls = setCalls,
      getCalls = getCalls,
      settings = settings,
      step = step,
      desiredPlayerMarks = desiredPlayerMarks,
      unit = unit,
      setCombatLog = function(subevent, guid)
        combatSubevent, combatDestGuid = subevent, guid
      end,
      setCombat = function(value) inCombat = value == true end,
      emit = function(event, ...)
        if not frame.events[event] then error("event is not registered: "..event) end
        return frame.onEvent(frame, event, ...)
      end,
    }
    return runtime
  end

  it("observes nameplates when disabled and marks eligible ones when enabled", function()
    local observed = newRuntime({ autoMarkNameplates = false })
    local disabled = observed.unit("nameplate1", {
      guid = "Creature-0-0-0-0-100-disabled",
    })
    observed.emit("NAME_PLATE_UNIT_ADDED", "nameplate1")
    assert.is_nil(observed.markers[disabled.guid])
    assert.are.equal(0, #observed.setCalls)

    local applied = newRuntime({ autoMarkNameplates = true })
    local enabled = applied.unit("nameplate1", {
      guid = "Creature-0-0-0-0-100-enabled",
    })
    applied.emit("NAME_PLATE_UNIT_ADDED", "nameplate1")
    assert.are.equal(8, applied.markers[enabled.guid])
    assert.are.equal("nameplate1", applied.setCalls[1].token)
    assert.are.equal(8, applied.setCalls[1].marker)
  end)

  it("does not observe a removed nameplate token after token churn", function()
    local runtime = newRuntime()
    local oldUnit = runtime.unit("nameplate1", {
      guid = "Creature-0-0-0-0-100-old",
    })
    runtime.emit("NAME_PLATE_UNIT_ADDED", "nameplate1")
    assert.are.equal(8, runtime.markers[oldUnit.guid])

    runtime.emit("NAME_PLATE_UNIT_REMOVED", "nameplate1")
    local newUnit = runtime.unit("nameplate1", {
      guid = "Creature-0-0-0-0-100-new",
    })
    runtime.markers[newUnit.guid] = 8
    for token in pairs(runtime.getCalls) do runtime.getCalls[token] = nil end
    runtime.emit("RAID_TARGET_UPDATE")

    assert.is_nil(runtime.getCalls.nameplate1)
    assert.is_true(runtime.ART.LiveMarks:IsMarkerAvailable(8, oldUnit.guid))
    assert.is_false(runtime.ART.LiveMarks:IsMarkerAvailable(8, newUnit.guid))
  end)

  it("releases live and resolver ownership on UNIT_DIED without asserting icon clearing", function()
    local runtime = newRuntime()
    local dead = runtime.unit("nameplate1", {
      guid = "Creature-0-0-0-0-100-dead",
    })
    local sticky = runtime.ART.RaidMarks:ResolveUnit("nameplate1")
    assert.are.equal(8, sticky)
    runtime.emit("NAME_PLATE_UNIT_ADDED", "nameplate1")
    assert.is_false(runtime.ART.LiveMarks:IsMarkerAvailable(8, "Creature-0-0-0-0-100-other"))

    runtime.setCombatLog("UNIT_DIED", dead.guid)
    runtime.emit("COMBAT_LOG_EVENT_UNFILTERED")

    assert.is_true(runtime.ART.LiveMarks:IsMarkerAvailable(8, dead.guid))
    local replacement, result = runtime.ART.RaidMarks:ResolveUnit("nameplate1")
    assert.are.equal(8, replacement)
    assert.is_false(result.reused == true)
  end)

  it("lets pull and floor NPC rules replace ART-owned player marks, including in combat", function()
    local runtime = newRuntime()
    local player = runtime.unit("raid1", {
      guid = "Player-0-0-0-0-1-tank",
      name = "Tank",
      realm = "Realm",
      friendly = true,
    })
    runtime.desiredPlayerMarks[8] = { name = "Tank-Realm" }
    runtime.emit("GROUP_ROSTER_UPDATE")
    assert.are.equal(8, runtime.markers[player.guid])
    runtime.setCombat(true)

    local pullNpc = runtime.unit("nameplate1", {
      guid = "Creature-0-0-0-0-100-pull",
    })
    runtime.emit("NAME_PLATE_UNIT_ADDED", "nameplate1")
    assert.are.equal(8, runtime.markers[pullNpc.guid])
    assert.is_nil(runtime.markers[player.guid])

    assert.is_true(runtime.ART.LiveMarks:ClearWorldMarks())
    runtime.step.marks.pullNpc = nil
    assert.is_true(runtime.ART.RaidMarks:ActivateRouteStep(runtime.step.id))
    runtime.desiredPlayerMarks[8] = { name = "Tank-Realm" }
    runtime.emit("GROUP_ROSTER_UPDATE")
    local floorNpc = runtime.unit("nameplate2", {
      guid = "Creature-0-0-0-0-200-floor",
    })
    runtime.emit("NAME_PLATE_UNIT_ADDED", "nameplate2")
    assert.are.equal(8, runtime.markers[floorNpc.guid])
    assert.is_nil(runtime.markers[player.guid])

    assert.is_true(runtime.ART.LiveMarks:ClearWorldMarks())
    local foreign = runtime.unit("nameplate3", {
      guid = "Creature-0-0-0-0-999-foreign",
    })
    runtime.markers[foreign.guid] = 8
    runtime.emit("NAME_PLATE_UNIT_ADDED", "nameplate3")
    local blocked = runtime.unit("nameplate4", {
      guid = "Creature-0-0-0-0-100-blocked",
    })
    runtime.emit("NAME_PLATE_UNIT_ADDED", "nameplate4")
    assert.are.equal(8, runtime.markers[foreign.guid])
    assert.is_nil(runtime.markers[blocked.guid])
    assert.is_false(runtime.ART.LiveMarks:IsMarkerAvailable(8, blocked.guid))
  end)
end)
