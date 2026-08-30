local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
wipe = wipe or function(value) for key in pairs(value) do value[key] = nil end end

local eventFrame = { events = {} }
function eventFrame:RegisterEvent(event) self.events[event] = true end
function eventFrame:UnregisterEvent(event) self.events[event] = nil end
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
  plateDisabled = { guid = "Creature-0-0-0-0-900-nameplate-disabled" },
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
local combatLogDestGuid
_G.CombatLogGetCurrentEventInfo = function()
  return nil, "UNIT_DIED", nil, nil, nil, nil, nil, combatLogDestGuid
end

local liveMarkers = {}
local reportAppliedMarkers = true
_G.GetRaidTargetIndex = function(token)
  local guid = units[token] and units[token].guid
  return reportAppliedMarkers and guid and liveMarkers[guid]
end
_G.SetRaidTarget = function(token, marker)
  local guid = assert(units[token] and units[token].guid)
  if marker == 0 then liveMarkers[guid] = nil return end
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

local settings = { autoMark = true, autoMarkModifier = "ALT", autoMarkNameplates = true }
ART.GetDB = function() return settings end
assert(loadfile(root.."/Core/MarkResolver.lua"))("AnniversaryRaidTools", ART)
assert(loadfile(root.."/Modules/RaidMarks.lua"))("AnniversaryRaidTools", ART)
assert(loadfile(root.."/Modules/LiveMarks.lua"))("AnniversaryRaidTools", ART)

local raid = { enemies = {
  ["100"] = { spawns = {
    { key = "s1", npcId = 100 }, { key = "s2", npcId = 100 }, { key = "s11", npcId = 100 },
  } },
  ["200"] = { spawns = { { key = "s3", npcId = 200 } } },
  ["300"] = { spawns = { { key = "s4", npcId = 300 } } },
  ["400"] = { spawns = { { key = "s5", npcId = 400 } } },
  ["500"] = { spawns = { { key = "s6", npcId = 500 } } },
  ["600"] = { spawns = { { key = "s7", npcId = 600 } } },
  ["700"] = { spawns = { { key = "s8", npcId = 700 } } },
  ["900"] = { spawns = { { key = "s10", npcId = 900 } } },
} }
local step = { id = "pull-1", marks = { s1 = 8, s2 = 7, s11 = 1 } }
ART.RaidPlanner = { GetActiveStep = function() return step end }
local resolver = ART.MarkResolver.new({
  raid = raid,
  routeSteps = { step },
  profile = {
    floorNpcDefaults = { [1] = {
      [100] = { 1 }, [200] = { 5 }, [300] = { 2 }, [600] = { 4 }, [700] = { 6 }, [900] = { 3 },
    } },
  },
  getCurrentSublevel = function() return 1 end,
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
reportAppliedMarkers = false
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "one")
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "two")
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "three")
reportAppliedMarkers = true
assert(liveMarkers[units.one.guid] == 8 and liveMarkers[units.two.guid] == 7
    and liveMarkers[units.three.guid] == 1, "simultaneous nameplates receive skull, cross, and star")
assert(ART.LiveMarks:ClearWorldMarks())
assert(ART.RaidMarks:ActivateRouteStep(step.id))
hover("one")
hover("two")
hover("three")
assert(liveMarkers[units.one.guid] == 8 and liveMarkers[units.two.guid] == 7
    and liveMarkers[units.three.guid] == 1, "mouseover marking keeps the full pull pool")
combatLogDestGuid = units.three.guid
eventFrame.onEvent(eventFrame, "COMBAT_LOG_EVENT_UNFILTERED")
liveMarkers[combatLogDestGuid] = nil

altDown = false
units.mouseover = units.global
eventFrame.onEvent(eventFrame, "MODIFIER_STATE_CHANGED", "LALT", 1)
assert(liveMarkers[units.global.guid] == nil, "modifier event follows the actual key state")
altDown = true
eventFrame.onEvent(eventFrame, "MODIFIER_STATE_CHANGED", "LALT", 1)
assert(liveMarkers[units.global.guid] == 5, "pressing the modifier applies its floor mark")
hover("globalSecond")
assert(liveMarkers[units.global.guid] == 5 and liveMarkers[units.globalSecond.guid] == nil,
    "floor marks stay on the first intentionally hovered matching NPC")
settings.autoMarkNameplates = false
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "plateDisabled")
assert(liveMarkers[units.plateDisabled.guid] == nil, "disabled nameplate marking only observes units")
settings.autoMarkNameplates = true

inCombat = true
hover("combatFree")
assert(liveMarkers[units.combatFree.guid] == 2, "a free marker may be assigned in combat")

step.id, step.marks = "pull-2", { s5 = 2, s6 = 5 }
local autoMarksRefreshes = 0
ART.AutoMarksUI = { Refresh = function() autoMarksRefreshes = autoMarksRefreshes + 1 end }
ART.LiveMarks:OnPullSelected()
assert(autoMarksRefreshes == 0, "route mark changes must not rebuild the Auto Marks NPC list")
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

units.raid1 = { guid = "Player-0-0-0-0-1-Mage" }
units.raid2 = { guid = "Player-0-0-0-0-2-Other" }
units.raid3 = { guid = "Player-0-0-0-0-3-New" }
_G.GetNumGroupMembers = function() return 3 end
_G.UnitFullName = function(token)
  if token == "raid1" then return "Mage", "Realm" end
  if token == "raid2" then return "Other", "Realm" end
  if token == "raid3" then return "New", "Realm" end
  if token == "player" then return "Leader", "Realm" end
end
local clearedAssignments = 0
local playerPreset = { value = {
  artPlayerMarkCurrent = { [1] = { name = "Mage-Realm", classFile = "MAGE" } },
  artPlayerMarksEnabled = true,
  artCCMarks = { [2] = { name = "Other-Realm", classFile = "ROGUE" } },
} }
ART.GetCurrentPreset = function() return playerPreset end
ART.PlayerMarks = { GetActiveMarks = function(_, preset)
  return preset.value.artPlayerMarksEnabled and preset.value.artPlayerMarkCurrent or {}
end }
ART.CCAssignments = { ClearActivePullAssignments = function() clearedAssignments = clearedAssignments + 1 end }
inRaid, isAssistant = true, true
eventFrame.onEvent(eventFrame, "GROUP_ROSTER_UPDATE")
assert(liveMarkers[units.raid1.guid] == 1 and liveMarkers[units.raid2.guid] == nil,
    "only an enabled player-mark loadout applies to raid members")
playerPreset.value.artPlayerMarksEnabled = nil
ART.LiveMarks:OnPlanChanged()
assert(liveMarkers[units.raid1.guid] == nil, "disabling the loadout removes its managed mark")
playerPreset.value.artPlayerMarksEnabled = true
ART.LiveMarks:OnPlanChanged()
liveMarkers[units.foreignHolder.guid] = 4
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "foreignHolder")
playerPreset.value.artPlayerMarkCurrent = { [4] = { name = "New-Realm", classFile = "MAGE" } }
ART.LiveMarks:OnPlanChanged()
assert(liveMarkers[units.raid1.guid] == nil and liveMarkers[units.raid3.guid] == nil
    and liveMarkers[units.foreignHolder.guid] == 4,
    "editing an enabled loadout removes stale managed marks without displacing foreign holders")
playerPreset.value.artPlayerMarkCurrent = { [1] = { name = "New-Realm", classFile = "MAGE" } }
ART.LiveMarks:OnPlanChanged()
assert(liveMarkers[units.raid3.guid] == 1 and liveMarkers[units.foreignHolder.guid] == 4,
    "editing an enabled loadout reapplies the new desired player")
inRaid, isAssistant = false, false

settings.autoMark = false
units.disabled = { guid = "Creature-0-0-0-0-200-disabled" }
hover("disabled")
assert(liveMarkers[units.disabled.guid] == nil, "disabled auto marking is inert")

assert(ART.LiveMarks:ClearWorldMarks())
assert(clearedMarks == 2 and next(liveMarkers) == nil, "manual clear removes all world marks")
assert(clearedAssignments == 1, "manual clear also removes active-pull CC assignments")
settings.autoMark, altDown = true, true
hover("one")
assert(liveMarkers[units.one.guid] == 1, "manual clear resets resolver assignments")

assert(eventFrame.events.UPDATE_MOUSEOVER_UNIT and eventFrame.events.MODIFIER_STATE_CHANGED)
assert(not eventFrame.events.PLAYER_REGEN_ENABLED and not eventFrame.events.ENCOUNTER_END,
    "live marking has no automatic pull progression events")
assert(ART.LiveMarks:SetDebugMode(true) and ART.LiveMarks.debugMode)
assert(not ART.LiveMarks:SetDebugMode(false) and not ART.LiveMarks.debugMode)
assert(not SLASH_ARTMARKDEBUG1 and not SlashCmdList.ARTMARKDEBUG,
    "marks debug no longer registers a separate slash command")
ART.LiveMarks:SetEnabled(false)
assert(next(eventFrame.events) == nil, "disabled live marking must unregister all runtime events")

print("intentional mouseover marking checks passed")
