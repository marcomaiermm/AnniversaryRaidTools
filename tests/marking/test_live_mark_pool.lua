-- Live pooled marks must reconcile when the planner changes a marker.

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
  player = { guid = "Player-0-0", x = 0, y = 0 },
  nameplate1 = { guid = "Creature-0-0-0-0-100-a" },
  nameplate2 = { guid = "Creature-0-0-0-0-100-b" },
  nameplate3 = { guid = "Creature-0-0-0-0-100-c" },
}
_G.UnitExists = function(token) return units[token] ~= nil end
_G.UnitGUID = function(token) return units[token] and units[token].guid end
_G.UnitPosition = function(token)
  local unit = units[token]
  return unit and unit.x, unit and unit.y, nil, unit and unit.x and 1 or nil
end
_G.UnitCanAttack = function(_, token) return token ~= "player" end
_G.UnitIsDeadOrGhost = function() return false end

local liveMarkers = {}
_G.GetRaidTargetIndex = function(token)
  local guid = units[token] and units[token].guid
  return guid and liveMarkers[guid]
end
_G.SetRaidTarget = function(token, marker)
  local guid = assert(units[token] and units[token].guid)
  if liveMarkers[guid] == marker then
    liveMarkers[guid] = nil
    return
  end
  for otherGuid, otherMarker in pairs(liveMarkers) do
    if otherGuid ~= guid and otherMarker == marker then liveMarkers[otherGuid] = nil end
  end
  liveMarkers[guid] = marker
end
_G.RemoveRaidTargets = function()
  for guid in pairs(liveMarkers) do liveMarkers[guid] = nil end
end

ART.GetDB = function() return { autoMark = true } end
ART.Compat = { GetBestMapForUnit = function() return nil end }
assert(loadfile(root.."/Core/SpawnMatcher.lua"))("AnniversaryRaidTools", { ART = ART })
assert(loadfile(root.."/Core/PullProgress.lua"))("AnniversaryRaidTools", { ART = ART })
assert(loadfile(root.."/Core/MarkResolver.lua"))("AnniversaryRaidTools", { ART = ART })
assert(loadfile(root.."/Modules/RaidMarks.lua"))("AnniversaryRaidTools", { ART = ART })

local packKey = "pack"
local raid = {
  key = "pool-refresh",
  instanceId = 1,
  sublevels = { { mapId = 1 } },
  packs = {
    [packKey] = { spawnKeys = { "s1", "s2", "s3" } },
    other = { spawnKeys = { "o1" } },
  },
  enemies = { [100] = { spawns = {
    { key = "s1", npcId = 100, packKey = packKey, sublevel = 1 },
    { key = "s2", npcId = 100, packKey = packKey, sublevel = 1 },
    { key = "s3", npcId = 100, packKey = packKey, sublevel = 1 },
    { key = "o1", npcId = 100, packKey = "other", sublevel = 1 },
  } } },
}
local step = {
  id = "pull-1",
  packKeys = { packKey },
  spawnKeys = { "s1", "s2", "s3" },
  marks = { s1 = 8, s2 = 1, s3 = 2 },
}
ART.RaidPlanner = {
  initialized = true,
  raid = raid,
  preset = { routeSteps = { step } },
  lastPullIndex = 1,
  GetActiveStep = function() return step end,
  GetMarkedStep = function() return nil end,
  GetPullStep = function() return nil end,
  IsStepPinned = function() return false end,
}
ART.MapWorldPositions = { [raid.key] = {
  s1 = { x = 0, y = 0, coordinateKind = "derived-affine" },
  s2 = { x = 2, y = 0, coordinateKind = "derived-affine" },
  s3 = { x = 4, y = 0, coordinateKind = "derived-affine" },
  o1 = { x = 100, y = 0, coordinateKind = "derived-affine" },
} }
ART.MapDefinitions = { [raid.key] = { sublevels = { { uiMapId = 1 } } } }

local addon = { ART = ART, SetSelectionToPull = function() end }
assert(loadfile(root.."/Modules/LiveMarks.lua"))("AnniversaryRaidTools", addon)
local resolver = ART.MarkResolver.new({
  raid = raid,
  routeSteps = { step },
  profile = { npcDefaults = {}, packOverrides = {} },
  getRouteStep = function(id) return id == step.id and step or nil end,
  getMatchForUnit = function(_, token) return ART.LiveMarks:ResolveMatch(token) end,
  setRaidTarget = SetRaidTarget,
  canMark = true,
})
ART.RaidMarks:Initialize({ resolver = resolver })
ART.RaidMarks.resolver = resolver
assert(ART.RaidMarks:ActivateRouteStep(step.id))

for index = 1, 3 do eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "nameplate"..index) end
local function markerSet(expected)
  local wanted, count = {}, 0
  for _, marker in ipairs(expected) do wanted[marker] = true end
  for _, marker in pairs(liveMarkers) do
    assert(wanted[marker], "unexpected live marker "..marker)
    count = count + 1
  end
  assert(count == #expected, "wrong live marker count")
  for _, marker in ipairs(expected) do
    local found
    for _, liveMarker in pairs(liveMarkers) do
      if liveMarker == marker then found = true break end
    end
    assert(found, "missing live marker "..marker)
  end
end
local function hover(token)
  units.mouseover = units[token]
  eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
end
local function hoverAll()
  for index = 1, 3 do
    local token = "nameplate"..index
    if units[token] then hover(token) end
  end
end
hoverAll()
markerSet({ 8, 1, 2 })

-- A UI reload keeps world markers but loses LiveMarks' in-memory ownership.
assert(loadfile(root.."/Modules/LiveMarks.lua"))("AnniversaryRaidTools", addon)
for index = 1, 3 do eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "nameplate"..index) end
hoverAll()

step.marks.s1 = 4
ART.LiveMarks:OnPlanChanged()
hoverAll()
markerSet({ 4, 1, 2 })

step.marks.s2 = nil
ART.LiveMarks:OnPlanChanged()
hoverAll()
markerSet({ 4, 2 })

-- A marker reassigned while its previous holder is out of token range must not
-- be blocked by the previous holder's stale local lease.
local distantToken
for index = 1, 3 do
  local token = "nameplate"..index
  if liveMarkers[units[token].guid] == 4 then distantToken = token break end
end
assert(distantToken, "marker 4 holder exists")
local distantUnit = units[distantToken]
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_REMOVED", distantToken)
units[distantToken], units.mouseover = nil, nil
step.marks.s1, step.marks.s2 = nil, 4
ART.LiveMarks:OnPullSelected(step, 2)
hoverAll()
markerSet({ 4, 2 })
assert(liveMarkers[distantUnit.guid] == nil, "reassigned marker must leave its distant previous holder")

-- Local proximity prevents a same-NPC mouseover from borrowing the active
-- pull's marks when the observed unit belongs to another pack.
step.marks.s1, step.marks.s2, step.marks.s3 = 8, nil, nil
units.player.x = 100
units.nameplate4 = { guid = "Creature-0-0-0-0-100-other" }
ART.LiveMarks:OnPullSelected(step, 3)
eventFrame.onEvent(eventFrame, "NAME_PLATE_UNIT_ADDED", "nameplate4")
assert(liveMarkers[units.nameplate4.guid] == nil, "unhovered other-pack mob stays unmarked")
units.mouseover = units.nameplate4
eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
assert(liveMarkers[units.nameplate4.guid] == nil, "mouseover never borrows the active pull's marker")
local otherMatch = ART.LiveMarks:ResolveMatch("mouseover")
assert(otherMatch.kind == "exact" and otherMatch.packKey == "other" and otherMatch.spawnKey == "o1",
    "player proximity identifies the observed mob's actual pack")
units.player.x, units.mouseover = 0, units.nameplate1
eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
assert(liveMarkers[units.nameplate1.guid] == 8, "mouseover still marks a nearby active-pack mob")
units.player.x, units.mouseover = nil, nil
assert(ART.LiveMarks:ResolveMatch("nameplate4").kind == "unresolved",
    "mouseover does not persist a pack identity for the GUID")
units.mouseover = units.nameplate1
local hoverFallback = ART.LiveMarks:ResolveMatch("mouseover")
assert(hoverFallback.kind == "packPool" and hoverFallback.packKey == packKey,
    "explicit mouseover falls back to the active pull when proximity is unavailable")
units.mouseover = nil

step.id, step.packKeys, step.spawnKeys, step.marks = "pull-other", { "other" }, { "o1" }, { o1 = 4 }
liveMarkers["Creature-manual"] = 7
ART.LiveMarks:OnPullSelected(step, 4)
assert(liveMarkers[units.nameplate4.guid] == nil, "pull change clears the previous active-pull mark")
assert(liveMarkers["Creature-manual"] == nil, "pull change clears all raid targets")
eventFrame.onEvent(eventFrame, "RAID_TARGET_UPDATE")
assert(next(liveMarkers) == nil, "the clear event must not immediately restore old marks")
units.player.x, units.mouseover = 100, units.nameplate4
eventFrame.onEvent(eventFrame, "UPDATE_MOUSEOVER_UNIT")
assert(liveMarkers[units.nameplate4.guid] == 4, "new mouseover marks the nearby mob from the new pull")

print("live pooled mark refresh checks passed")
