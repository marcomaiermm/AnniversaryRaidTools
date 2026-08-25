local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART

local eventFrame = { events = {} }
function eventFrame:RegisterEvent(event) self.events[event] = true end
function eventFrame:SetScript(_, script) self.onEvent = script end
_G.CreateFrame = function() return eventFrame end
_G.UIParent = {}
_G.SlashCmdList = {}

local units = {
  target = { guid = "Creature-0-0-0-0-100-target" },
  one = { guid = "Creature-0-0-0-0-100-one" },
  two = { guid = "Creature-0-0-0-0-100-two" },
  three = { guid = "Creature-0-0-0-0-100-three" },
  global = { guid = "Creature-0-0-0-0-200-global" },
  globalSecond = { guid = "Creature-0-0-0-0-200-global-second" },
  combatFree = { guid = "Creature-0-0-0-0-300-combat" },
  reclaim = { guid = "Creature-0-0-0-0-400-reclaim" },
  combatBlocked = { guid = "Creature-0-0-0-0-500-blocked" },
  foreignHolder = { guid = "Creature-0-0-0-0-999-foreign" },
  foreignRule = { guid = "Creature-0-0-0-0-600-foreign-rule" },
  friendly = { guid = "Creature-0-0-0-0-700-friendly", friendly = true },
  dead = { guid = "Creature-0-0-0-0-700-dead", dead = true },
  permission = { guid = "Creature-0-0-0-0-700-permission" },
  hostilePlayer = { guid = "Player-0-0-0-0-700-hostile" },
}
_G.UnitExists = function(token) return units[token] ~= nil end
_G.UnitGUID = function(token) return units[token] and units[token].guid end
_G.UnitCanAttack = function(_, token) return units[token] and units[token].friendly ~= true end
_G.UnitIsDeadOrGhost = function(token) return units[token] and units[token].dead == true end
local inRaid, isLeader, isAssistant = false, false, false
_G.IsInRaid = function() return inRaid end
_G.UnitIsGroupLeader = function() return isLeader end
_G.UnitIsGroupAssistant = function() return isAssistant end

local altDown, inCombat = false, false
_G.IsAltKeyDown = function() return altDown end
_G.IsShiftKeyDown = function() return false end
_G.IsControlKeyDown = function() return false end
_G.UnitAffectingCombat = function() return inCombat end

local liveMarkers = {}
_G.GetRaidTargetIndex = function(token)
  local guid = units[token] and units[token].guid
  return guid and liveMarkers[guid]
end
_G.SetRaidTarget = function(token, marker)
  local guid = assert(units[token] and units[token].guid)
  for otherGuid, otherMarker in pairs(liveMarkers) do
    if otherGuid ~= guid and otherMarker == marker then liveMarkers[otherGuid] = nil end
  end
  liveMarkers[guid] = marker
end
local clearedMarks = 0
_G.RemoveRaidTargets = function()
  clearedMarks = clearedMarks + 1
  for guid in pairs(liveMarkers) do liveMarkers[guid] = nil end
end

local settings = { autoMark = true, autoMarkModifier = "ALT" }
ART.GetDB = function() return settings end
assert(loadfile(root.."/Core/MarkResolver.lua"))("AnniversaryRaidTools", { ART = ART })
assert(loadfile(root.."/Modules/RaidMarks.lua"))("AnniversaryRaidTools", { ART = ART })
assert(loadfile(root.."/Modules/LiveMarks.lua"))("AnniversaryRaidTools", { ART = ART })

local raid = { enemies = {
  ["100"] = { spawns = { { key = "s1", npcId = 100 }, { key = "s2", npcId = 100 } } },
  ["200"] = { spawns = { { key = "s3", npcId = 200 } } },
  ["300"] = { spawns = { { key = "s4", npcId = 300 } } },
  ["400"] = { spawns = { { key = "s5", npcId = 400 } } },
  ["500"] = { spawns = { { key = "s6", npcId = 500 } } },
  ["600"] = { spawns = { { key = "s7", npcId = 600 } } },
  ["700"] = { spawns = { { key = "s8", npcId = 700 } } },
} }
local step = { id = "pull-1", marks = { s1 = 8, s2 = 7 } }
ART.RaidPlanner = { GetActiveStep = function() return step end }
local resolver = ART.MarkResolver.new({
  raid = raid,
  routeSteps = { step },
  profile = { npcDefaults = {
    [100] = { 1 }, [200] = { 5 }, [300] = { 2 }, [600] = { 4 }, [700] = { 6 },
  } },
  getRouteStep = function(id) return id == step.id and step or nil end,
  markerAvailable = function(marker, guid) return ART.LiveMarks:IsMarkerAvailable(marker, guid) end,
})
ART.RaidMarks:Initialize({ resolver = resolver })
ART.RaidMarks.resolver = resolver
assert(ART.RaidMarks:ActivateRouteStep(step.id))

local function hover(token)
  units.mouseover = units[token]
  eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
end

hover("one")
assert(liveMarkers[units.one.guid] == nil, "modifier is required")
altDown = true
eventFrame.onEvent(eventFrame, "PLAYER_TARGET_CHANGED")
assert(liveMarkers[units.target.guid] == nil, "target events never apply marks")
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "two")
assert(liveMarkers[units.two.guid] == nil, "nameplate events only observe")

hover("one")
hover("two")
hover("three")
assert(liveMarkers[units.one.guid] == 8 and liveMarkers[units.two.guid] == 7,
    "pull pool mismatch: one="..tostring(liveMarkers[units.one.guid]).." two="..tostring(liveMarkers[units.two.guid]))
assert(liveMarkers[units.three.guid] == nil, "exhausted pull pool does not use the global fallback")

altDown = false
units.mouseover = units.global
eventFrame.onEvent(eventFrame, "MODIFIER_STATE_CHANGED", "LALT", 1)
assert(liveMarkers[units.global.guid] == nil, "modifier event follows the actual key state")
altDown = true
eventFrame.onEvent(eventFrame, "MODIFIER_STATE_CHANGED", "LALT", 1)
assert(liveMarkers[units.global.guid] == 5, "pressing the modifier over a unit applies its global mark")
hover("globalSecond")
assert(liveMarkers[units.global.guid] == 5 and liveMarkers[units.globalSecond.guid] == nil,
    "global marks stay on the first intentionally hovered matching NPC")

inCombat = true
hover("combatFree")
assert(liveMarkers[units.combatFree.guid] == 2, "a free marker may be assigned in combat")

step.id, step.marks = "pull-2", { s5 = 2, s6 = 5 }
ART.LiveMarks:OnPullSelected()
hover("combatBlocked")
assert(liveMarkers[units.combatBlocked.guid] == nil and liveMarkers[units.global.guid] == 5,
    "combat never moves an ART-owned occupied marker")
inCombat = false
hover("reclaim")
assert(liveMarkers[units.reclaim.guid] == 2 and liveMarkers[units.combatFree.guid] == nil,
    "outside combat reclaim failed: new="..tostring(liveMarkers[units.reclaim.guid])
        .." old="..tostring(liveMarkers[units.combatFree.guid]))

liveMarkers[units.foreignHolder.guid] = 4
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "foreignHolder")
hover("foreignRule")
assert(liveMarkers[units.foreignHolder.guid] == 4 and liveMarkers[units.foreignRule.guid] == nil,
    "observed foreign markers are never displaced")

hover("friendly")
hover("dead")
hover("hostilePlayer")
assert(liveMarkers[units.friendly.guid] == nil and liveMarkers[units.dead.guid] == nil
    and liveMarkers[units.hostilePlayer.guid] == nil, "friendly, dead, and player units are ignored")
inRaid = true
hover("permission")
assert(liveMarkers[units.permission.guid] == nil, "raid members without leader or assistant cannot mark")
isAssistant = true
hover("permission")
assert(liveMarkers[units.permission.guid] == 6, "raid assistants may mark")
inRaid, isAssistant = false, false

settings.autoMark = false
units.disabled = { guid = "Creature-0-0-0-0-200-disabled" }
hover("disabled")
assert(liveMarkers[units.disabled.guid] == nil, "disabled auto marking is inert")

assert(ART.LiveMarks:ClearWorldMarks())
assert(clearedMarks == 1 and next(liveMarkers) == nil, "manual clear removes all world marks")
settings.autoMark, altDown = true, true
hover("one")
assert(liveMarkers[units.one.guid] == 1, "manual clear resets resolver assignments")

assert(eventFrame.events.UPDATE_MOUSEOVER_UNIT and eventFrame.events.MODIFIER_STATE_CHANGED)
assert(not eventFrame.events.PLAYER_REGEN_ENABLED and not eventFrame.events.ENCOUNTER_END,
    "live marking has no automatic pull progression events")

print("intentional mouseover marking checks passed")
