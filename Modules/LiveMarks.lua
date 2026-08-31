-- Live raid targets are set only from an intentional mouseover gesture.

local _, ART = ...

local LiveMarks = ART.LiveMarks or {}
ART.LiveMarks = LiveMarks

local visibleNameplates = {}
local markerLeaseByIndex, markerByGuid, artMarkerByGuid = {}, {}, {}
local artSourceByGuid, artStepByGuid, artPriorityByGuid = {}, {}, {}
local managedPlayerByMarker = {}
local EVENTS = {
  "UPDATE_MOUSEOVER_UNIT", "MODIFIER_STATE_CHANGED", "PLAYER_TARGET_CHANGED", "UNIT_TARGET",
  "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "COMBAT_LOG_EVENT_UNFILTERED",
  "RAID_TARGET_UPDATE", "GROUP_ROSTER_UPDATE", "PLAYER_ENTERING_WORLD",
}

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
  artSourceByGuid[guid], artStepByGuid[guid], artPriorityByGuid[guid] = nil, nil, nil
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
    artMarkerByGuid[guid], artSourceByGuid[guid], artStepByGuid[guid], artPriorityByGuid[guid] = nil, nil, nil, nil
    releaseResolverAssignment(guid)
  end

  if marker > 0 then
    local displaced = markerLeaseByIndex[marker]
    if displaced and displaced ~= guid then
      markerByGuid[displaced] = nil
      if artMarkerByGuid[displaced] == marker then
        artMarkerByGuid[displaced], artSourceByGuid[displaced], artStepByGuid[displaced],
            artPriorityByGuid[displaced] = nil, nil, nil, nil
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
  for index = 1, 4 do tokens[#tokens + 1] = "party"..index end
  for index = 1, 40 do tokens[#tokens + 1] = "raid"..index end
  tokens[#tokens + 1] = "player"
  return tokens
end

function LiveMarks:ObserveKnownUnits()
  for _, unitToken in ipairs(knownUnitTokens()) do observeMarker(unitToken) end
end

function LiveMarks:IsMarkerAvailable(marker, guid)
  local owner = markerLeaseByIndex[tonumber(marker)]
  return owner == nil or owner == guid
end

local function fullName(unit)
  if type(UnitFullName) ~= "function" then return end
  local name, realm = UnitFullName(unit)
  if not name then return end
  if not realm or realm == "" then _, realm = UnitFullName("player") end
  return name..(realm and realm ~= "" and "-"..realm or "")
end

local function groupUnitForName(name)
  if type(name) ~= "string" then return end
  local wanted = name:lower()
  local units = { "player" }
  for index = 1, 4 do units[#units + 1] = "party"..index end
  for index = 1, 40 do units[#units + 1] = "raid"..index end
  for _, unit in ipairs(units) do
    local candidate = fullName(unit)
    if candidate and candidate:lower() == wanted then return unit end
  end
end

function LiveMarks:ReconcilePlayerMarks()
  local settings = db()
  local unitGuid = rawget(_G, "UnitGUID")
  if not (settings and settings.autoMark == true) or not canMarkUnits()
      or type(rawget(_G, "SetRaidTarget")) ~= "function"
      or type(unitGuid) ~= "function" then return false end
  self:ObserveKnownUnits()
  local preset = ART.GetCurrentPreset and ART:GetCurrentPreset()
  local desired = ART.PlayerMarks and ART.PlayerMarks.GetActiveMarks
      and ART.PlayerMarks:GetActiveMarks(preset) or {}

  local setRaidTarget = rawget(_G, "SetRaidTarget")
  for marker, guid in pairs(managedPlayerByMarker) do
    local player = desired[marker]
    local unit = player and groupUnitForName(player.name)
    if not unit or unitGuid(unit) ~= guid then
      local ownedUnit
      for index = 1, 40 do
        local candidate = "raid"..index
        if unitGuid(candidate) == guid then ownedUnit = candidate break end
      end
      if not ownedUnit then
        for index = 1, 4 do
          local candidate = "party"..index
          if unitGuid(candidate) == guid then ownedUnit = candidate break end
        end
      end
      if unitGuid("player") == guid then ownedUnit = "player" end
      if ownedUnit and tonumber(GetRaidTargetIndex and GetRaidTargetIndex(ownedUnit) or 0) == marker then
        setRaidTarget(ownedUnit, 0)
      end
      forgetGuid(guid)
      managedPlayerByMarker[marker] = nil
    end
  end

  for marker, player in pairs(desired) do
    local unit = groupUnitForName(player.name)
    local guid = unit and unitGuid(unit)
    if guid then
      local _, currentMarker = observeMarker(unit)
      if currentMarker == marker then
        managedPlayerByMarker[marker] = guid
      elseif currentMarker == 0 and self:IsMarkerAvailable(marker, guid) then
        if setRaidTarget(unit, marker) ~= false then
          markerLeaseByIndex[marker], markerByGuid[guid], artMarkerByGuid[guid] = guid, marker, marker
          artSourceByGuid[guid], managedPlayerByMarker[marker] = "player", guid
        end
      end
    end
  end
  return true
end

local function eligibleUnit(unitToken)
  if type(UnitExists) ~= "function" or UnitExists(unitToken) ~= true then return nil, "missing" end
  if type(UnitCanAttack) == "function" and UnitCanAttack("player", unitToken) ~= true then
    return nil, "friendly"
  end
  local unitDead = rawget(_G, "UnitIsDeadOrGhost") or rawget(_G, "UnitIsDead")
  if type(unitDead) == "function" and unitDead(unitToken) == true then return nil, "dead" end
  local guid = type(UnitGUID) == "function" and UnitGUID(unitToken)
  if not guid or not parseNpcId(guid) then return nil, "unknown-npc" end
  if not canMarkUnits() then return nil, "permission" end
  if type(rawget(_G, "SetRaidTarget")) ~= "function" then return nil, "api-forbidden" end
  return guid
end

local function reclaimOwnedCandidate(candidates, source, priority, stopAtAvailableForGuid)
  if groupInCombat() then return false end
  local planner = ART.RaidPlanner
  local activeStep = planner and planner.GetActiveStep and planner:GetActiveStep()
  local activeStepId = activeStep and activeStep.id
  for _, marker in ipairs(type(candidates) == "table" and candidates or {}) do
    local owner = markerLeaseByIndex[marker]
    if stopAtAvailableForGuid and (not owner or owner == stopAtAvailableForGuid) then return false end
    local oldPull = artSourceByGuid[owner] == "pull" and artStepByGuid[owner] ~= activeStepId
    local higherFloorPriority = source == "global" and artSourceByGuid[owner] == "global"
        and priority < (artPriorityByGuid[owner] or math.huge)
    if owner and artMarkerByGuid[owner] == marker
        and ((source == "pull" and (artSourceByGuid[owner] == "global" or oldPull)) or higherFloorPriority) then
      releaseResolverAssignment(owner)
      forgetGuid(owner)
      return true
    end
  end
  return false
end

local function tryUnit(self, unitToken, requireModifier, scanKnownUnits)
  local settings = db()
  if not (settings and settings.autoMark == true) then return false, "disabled" end
  if requireModifier and not modifierDown() then return false, "modifier" end
  local marks = ART.RaidMarks
  if not (marks and marks.initialized) then return false, "not-initialized" end

  if scanKnownUnits then self:ObserveKnownUnits() end
  local guid, reason = eligibleUnit(unitToken)
  if not guid then return false, reason end
  local _, currentMarker = observeMarker(unitToken)
  if currentMarker > 0 then return false, "existing-marker" end
  local candidates, source, priority = marks:GetRuleForNpcId(parseNpcId(guid))
  if source == "global" then reclaimOwnedCandidate(candidates, source, priority, guid) end

  local marker, result = marks:ResolveUnit(unitToken)
  if not marker and result and result.reason == "slots-exhausted"
      and reclaimOwnedCandidate(result.candidates, result.source, result.priority) then
    marker, result = marks:ResolveUnit(unitToken)
  end
  if not marker then return false, result and result.reason or "no-mark", result end
  if not self:IsMarkerAvailable(marker, guid) then
    marks:OnUnitDeath(guid)
    return false, "marker-in-use", result
  end

  local setRaidTarget = rawget(_G, "SetRaidTarget")
  if setRaidTarget(unitToken, marker) == false then
    marks:OnUnitDeath(guid)
    return false, "api-failed", result
  end
  markerLeaseByIndex[marker], markerByGuid[guid], artMarkerByGuid[guid] = guid, marker, marker
  artSourceByGuid[guid] = result and result.source
  artPriorityByGuid[guid] = result and result.priority
  local planner = ART.RaidPlanner
  local step = planner and planner.GetActiveStep and planner:GetActiveStep()
  artStepByGuid[guid] = step and step.id
  return true, marker, result
end

function LiveMarks:TryMouseover()
  if self.debugMode then self:PrintDebugMouseover() end
  return tryUnit(self, "mouseover", true, true)
end

function LiveMarks:TryNameplate(unitToken)
  local settings = db()
  if settings and settings.autoMarkNameplates == false then
    observeMarker(unitToken)
    return false, "nameplates-disabled"
  end
  return tryUnit(self, unitToken, false, false)
end

function LiveMarks:PrintDebugMouseover()
  local guid = type(UnitGUID) == "function" and UnitGUID("mouseover")
  local npcId = parseNpcId(guid)
  local resolver = ART.RaidMarks and ART.RaidMarks.resolver
  local candidates, source = resolver and resolver:GetRuleForNpcId(npcId)
  print(("ART marks | npc=%s source=%s candidates=%s modifier=%s"):format(
      tostring(npcId), tostring(source), table.concat(candidates or {}, ","), modifier()))
end

function LiveMarks:SetDebugMode(enabled)
  self.debugMode = enabled == nil and not self.debugMode or enabled == true
  print(self.debugMode and "|cffffd100ART:|r Marks debug enabled."
      or "|cffffd100ART:|r Marks debug disabled.")
  if self.debugMode then self:PrintDebugMouseover() end
  return self.debugMode
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
  for guid in pairs(artPriorityByGuid) do artPriorityByGuid[guid] = nil end
  for marker in pairs(managedPlayerByMarker) do managedPlayerByMarker[marker] = nil end
  if ART.CCAssignments and ART.CCAssignments.ClearActivePullAssignments then
    ART.CCAssignments:ClearActivePullAssignments()
  end
  if ART.RaidMarks and ART.RaidMarks.initialized then ART.RaidMarks:ResetActivePack() end
  return true
end

function LiveMarks:OnPlanChanged()
  local marks, planner = ART.RaidMarks, ART.RaidPlanner
  if marks and marks.initialized then
    local step = planner and planner:GetActiveStep()
    if step then marks:ActivateRouteStep(step.id) else marks:ActivateRouteStep(nil) end
  end
  self:ReconcilePlayerMarks()
  local tracker = ART.RaidMarksUI
  if tracker and tracker.RefreshPullTracker then tracker:RefreshPullTracker() end
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
      LiveMarks:TryNameplate(unitToken)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
      visibleNameplates[unitToken] = nil
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
      local _, subevent, _, _, _, _, _, destGuid = CombatLogGetCurrentEventInfo()
      if subevent == "UNIT_DIED" and destGuid then
        forgetGuid(destGuid)
        releaseResolverAssignment(destGuid)
      end
    elseif event == "RAID_TARGET_UPDATE" or event == "GROUP_ROSTER_UPDATE"
        or event == "PLAYER_ENTERING_WORLD" then
      LiveMarks:ObserveKnownUnits()
      LiveMarks:ReconcilePlayerMarks()
    end
  end)
  LiveMarks.eventFrame = eventFrame
end

function LiveMarks:SetEnabled(enabled)
  enabled = enabled == true
  if self.enabled == enabled then return end
  self.enabled = enabled
  local frame = self.eventFrame
  if not frame then return end
  for _, event in ipairs(EVENTS) do
    if enabled then frame:RegisterEvent(event)
    elseif frame.UnregisterEvent then frame:UnregisterEvent(event) end
  end
  if not enabled then wipe(visibleNameplates) end
end

LiveMarks:SetEnabled(db() and db().autoMark == true)

ART.LiveMarks = LiveMarks
