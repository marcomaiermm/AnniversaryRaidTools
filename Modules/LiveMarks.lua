-- Live raid targets are set only from an intentional mouseover gesture.

local _, ART = ...

local LiveMarks = ART.LiveMarks or {}
ART.LiveMarks = LiveMarks

local visibleNameplates = {}
local markerLeaseByIndex, markerByGuid, artMarkerByGuid = {}, {}, {}
local artSourceByGuid, artStepByGuid = {}, {}

local function db()
  return ART.GetDB and ART.GetDB()
end

local function parseNpcId(guid)
  if type(guid) ~= "string" then return nil end
  local kind = guid:match("^([^%-]+)")
  if kind ~= "Creature" and kind ~= "Vehicle" then return nil end
  local previous, last
  for component in guid:gmatch("[^%-]+") do previous, last = last, component end
  return tonumber(previous)
end

local function modifier()
  local value = db() and db().autoMarkModifier or "ALT"
  if value == "NONE" or value == "SHIFT" or value == "CTRL" or value == "ALT" then return value end
  return "ALT"
end

local function modifierDown()
  local value = modifier()
  if value == "NONE" then return true end
  if value == "SHIFT" then return type(IsShiftKeyDown) == "function" and IsShiftKeyDown() == true end
  if value == "CTRL" then return type(IsControlKeyDown) == "function" and IsControlKeyDown() == true end
  return type(IsAltKeyDown) == "function" and IsAltKeyDown() == true
end

local function chosenModifierPressed(key, state)
  if state ~= 1 and state ~= "1" then return false end
  local value = modifier()
  return value ~= "NONE" and type(key) == "string" and key:find(value, 1, true) ~= nil
end

local function canMarkUnits()
  if not (type(IsInRaid) == "function" and IsInRaid()) then return true end
  local leader = type(UnitIsGroupLeader) == "function" and UnitIsGroupLeader("player")
  local assistant = type(UnitIsGroupAssistant) == "function" and UnitIsGroupAssistant("player")
  return leader == true or assistant == true
end

local function groupInCombat()
  if type(UnitAffectingCombat) == "function" then
    if UnitAffectingCombat("player") == true then return true end
    for index = 1, 4 do if UnitAffectingCombat("party"..index) == true then return true end end
    for index = 1, 40 do if UnitAffectingCombat("raid"..index) == true then return true end end
    return false
  end
  return type(InCombatLockdown) == "function" and InCombatLockdown() == true or false
end

local function forgetGuid(guid)
  local marker = markerByGuid[guid]
  if marker and markerLeaseByIndex[marker] == guid then markerLeaseByIndex[marker] = nil end
  markerByGuid[guid], artMarkerByGuid[guid] = nil, nil
  artSourceByGuid[guid], artStepByGuid[guid] = nil, nil
end

local function releaseResolverAssignment(guid)
  local marks = ART.RaidMarks
  if marks and marks.initialized then marks:OnUnitDeath(guid) end
end

local function observeMarker(unitToken)
  if type(unitToken) ~= "string" or type(UnitExists) ~= "function" or UnitExists(unitToken) ~= true then
    return nil, 0
  end
  local guid = type(UnitGUID) == "function" and UnitGUID(unitToken)
  if not guid then return nil, 0 end
  local getMarker = rawget(_G, "GetRaidTargetIndex")
  local marker = type(getMarker) == "function" and (tonumber(getMarker(unitToken)) or 0) or 0
  local previous = markerByGuid[guid]

  if previous and previous ~= marker and markerLeaseByIndex[previous] == guid then
    markerLeaseByIndex[previous] = nil
  end
  if artMarkerByGuid[guid] and artMarkerByGuid[guid] ~= marker then
    artMarkerByGuid[guid], artSourceByGuid[guid], artStepByGuid[guid] = nil, nil, nil
    releaseResolverAssignment(guid)
  end

  if marker > 0 then
    local displaced = markerLeaseByIndex[marker]
    if displaced and displaced ~= guid then
      markerByGuid[displaced] = nil
      if artMarkerByGuid[displaced] == marker then
        artMarkerByGuid[displaced], artSourceByGuid[displaced], artStepByGuid[displaced] = nil, nil, nil
        releaseResolverAssignment(displaced)
      end
    end
    markerLeaseByIndex[marker], markerByGuid[guid] = guid, marker
  else
    markerByGuid[guid] = nil
  end
  return guid, marker
end

local function knownUnitTokens()
  local tokens = { "target", "focus", "mouseover" }
  for unitToken in pairs(visibleNameplates) do tokens[#tokens + 1] = unitToken end
  for index = 1, 5 do tokens[#tokens + 1] = "boss"..index end
  for index = 1, 4 do tokens[#tokens + 1] = "party"..index.."target" end
  for index = 1, 40 do tokens[#tokens + 1] = "raid"..index.."target" end
  return tokens
end

function LiveMarks:ObserveKnownUnits()
  for _, unitToken in ipairs(knownUnitTokens()) do observeMarker(unitToken) end
end

function LiveMarks:IsMarkerAvailable(marker, guid)
  local owner = markerLeaseByIndex[tonumber(marker)]
  return owner == nil or owner == guid
end

local function eligibleMouseover()
  if type(UnitExists) ~= "function" or UnitExists("mouseover") ~= true then return nil, "missing" end
  if type(UnitCanAttack) == "function" and UnitCanAttack("player", "mouseover") ~= true then
    return nil, "friendly"
  end
  local unitDead = rawget(_G, "UnitIsDeadOrGhost") or rawget(_G, "UnitIsDead")
  if type(unitDead) == "function" and unitDead("mouseover") == true then return nil, "dead" end
  local guid = type(UnitGUID) == "function" and UnitGUID("mouseover")
  if not guid or not parseNpcId(guid) then return nil, "unknown-npc" end
  if not canMarkUnits() then return nil, "permission" end
  if type(rawget(_G, "SetRaidTarget")) ~= "function" then return nil, "api-forbidden" end
  return guid
end

local function reclaimOwnedCandidate(candidates)
  if groupInCombat() then return false end
  local planner = ART.RaidPlanner
  local activeStep = planner and planner.GetActiveStep and planner:GetActiveStep()
  local activeStepId = activeStep and activeStep.id
  for _, marker in ipairs(type(candidates) == "table" and candidates or {}) do
    local owner = markerLeaseByIndex[marker]
    local oldPull = artSourceByGuid[owner] == "pull" and artStepByGuid[owner] ~= activeStepId
    if owner and artMarkerByGuid[owner] == marker and (artSourceByGuid[owner] == "global" or oldPull) then
      releaseResolverAssignment(owner)
      forgetGuid(owner)
      return true
    end
  end
  return false
end

function LiveMarks:TryMouseover()
  local settings = db()
  if not (settings and settings.autoMark == true) then return false, "disabled" end
  if not modifierDown() then return false, "modifier" end
  local marks = ART.RaidMarks
  if not (marks and marks.initialized) then return false, "not-initialized" end

  self:ObserveKnownUnits()
  local guid, reason = eligibleMouseover()
  if not guid then return false, reason end
  local _, currentMarker = observeMarker("mouseover")
  if currentMarker > 0 then return false, "existing-marker" end

  local marker, result = marks:ResolveUnit("mouseover")
  if not marker and result and result.reason == "slots-exhausted" and result.source == "pull"
      and reclaimOwnedCandidate(result.candidates) then
    marker, result = marks:ResolveUnit("mouseover")
  end
  if not marker then return false, result and result.reason or "no-mark", result end
  if not self:IsMarkerAvailable(marker, guid) then
    marks:OnUnitDeath(guid)
    return false, "marker-in-use", result
  end

  local setRaidTarget = rawget(_G, "SetRaidTarget")
  if setRaidTarget("mouseover", marker) == false then
    marks:OnUnitDeath(guid)
    return false, "api-failed", result
  end
  markerLeaseByIndex[marker], markerByGuid[guid], artMarkerByGuid[guid] = guid, marker, marker
  artSourceByGuid[guid] = result and result.source
  local planner = ART.RaidPlanner
  local step = planner and planner.GetActiveStep and planner:GetActiveStep()
  artStepByGuid[guid] = step and step.id
  return true, marker, result
end

function LiveMarks:ClearWorldMarks()
  local removeRaidTargets = rawget(_G, "RemoveRaidTargets")
  if type(removeRaidTargets) ~= "function" then return false, "api-forbidden" end
  removeRaidTargets()
  for marker in pairs(markerLeaseByIndex) do markerLeaseByIndex[marker] = nil end
  for guid in pairs(markerByGuid) do markerByGuid[guid] = nil end
  for guid in pairs(artMarkerByGuid) do artMarkerByGuid[guid] = nil end
  for guid in pairs(artSourceByGuid) do artSourceByGuid[guid] = nil end
  for guid in pairs(artStepByGuid) do artStepByGuid[guid] = nil end
  if ART.RaidMarks and ART.RaidMarks.initialized then ART.RaidMarks:ResetActivePack() end
  return true
end

function LiveMarks:OnPlanChanged()
  local marks, planner = ART.RaidMarks, ART.RaidPlanner
  if marks and marks.initialized then
    local step = planner and planner:GetActiveStep()
    if step then marks:ActivateRouteStep(step.id) else marks:ActivateRouteStep(nil) end
  end
  local tracker = ART.RaidMarksUI
  if tracker and tracker.RefreshPullTracker then tracker:RefreshPullTracker() end
  local ui = ART.AutoMarksUI
  if ui and ui.Refresh then ui:Refresh() end
end

function LiveMarks:OnPullSelected()
  self:OnPlanChanged()
end

local function observeTargetEvent(unitToken)
  if unitToken == "player" then
    observeMarker("target")
  elseif type(unitToken) == "string"
      and (unitToken:match("^party%d+$") or unitToken:match("^raid%d+$")) then
    observeMarker(unitToken.."target")
  end
end

if type(CreateFrame) == "function" then
  local eventFrame = CreateFrame("Frame", "ARTLiveMarksEventFrame", UIParent)
  for _, event in ipairs({
    "UPDATE_MOUSEOVER_UNIT", "MODIFIER_STATE_CHANGED", "PLAYER_TARGET_CHANGED", "UNIT_TARGET",
    "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "COMBAT_LOG_EVENT_UNFILTERED",
    "RAID_TARGET_UPDATE", "GROUP_ROSTER_UPDATE",
  }) do eventFrame:RegisterEvent(event) end
  eventFrame:SetScript("OnEvent", function(_, event, ...)
    local unitToken = ...
    if event == "UPDATE_MOUSEOVER_UNIT" then
      LiveMarks:TryMouseover()
    elseif event == "MODIFIER_STATE_CHANGED" then
      if chosenModifierPressed(...) then LiveMarks:TryMouseover() end
    elseif event == "PLAYER_TARGET_CHANGED" then
      observeMarker("target")
    elseif event == "UNIT_TARGET" then
      observeTargetEvent(unitToken)
    elseif event == "NAME_PLATE_UNIT_ADDED" then
      visibleNameplates[unitToken] = true
      observeMarker(unitToken)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
      visibleNameplates[unitToken] = nil
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
      local _, subevent, _, _, _, _, _, destGuid = CombatLogGetCurrentEventInfo()
      if subevent == "UNIT_DIED" and destGuid then
        forgetGuid(destGuid)
        releaseResolverAssignment(destGuid)
      end
    elseif event == "RAID_TARGET_UPDATE" or event == "GROUP_ROSTER_UPDATE" then
      LiveMarks:ObserveKnownUnits()
    end
  end)
  LiveMarks.eventFrame = eventFrame
end

SLASH_ARTMARKDEBUG1 = "/artmarkdebug"
SlashCmdList.ARTMARKDEBUG = function()
  local settings = db()
  if not (settings and settings.devMode) then print("ART mark debug requires devMode."); return end
  local guid = type(UnitGUID) == "function" and UnitGUID("mouseover")
  local npcId = parseNpcId(guid)
  local resolver = ART.RaidMarks and ART.RaidMarks.resolver
  local candidates, source = resolver and resolver:GetRuleForNpcId(npcId)
  print(("ART mouseover | npc=%s source=%s candidates=%s modifier=%s"):format(
      tostring(npcId), tostring(source), table.concat(candidates or {}, ","), modifier()))
end

ART.LiveMarks = LiveMarks
