-- Live raid targets are set only from an intentional mouseover gesture.

local _, ART = ...

local LiveMarks = ART.LiveMarks or {}
ART.LiveMarks = LiveMarks

local visibleNameplates = {}
local leaseByMarker, leaseByGuid = {}, {}
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

local function forgetGuid(guid)
  local lease = leaseByGuid[guid]
  if lease and leaseByMarker[lease.marker] == lease then leaseByMarker[lease.marker] = nil end
  leaseByGuid[guid] = nil
end

local function rememberLease(guid, marker, details)
  forgetGuid(guid)
  local displaced = leaseByMarker[marker]
  if displaced then leaseByGuid[displaced.guid] = nil end
  local lease = {
    guid = guid,
    marker = marker,
    artOwned = details and details.artOwned == true,
    source = details and details.source,
    stepId = details and details.stepId,
    priority = details and details.priority,
  }
  leaseByMarker[marker], leaseByGuid[guid] = lease, lease
  return lease
end

local function observeMarker(unitToken)
  if type(unitToken) ~= "string" or type(UnitExists) ~= "function" or UnitExists(unitToken) ~= true then
    return nil, 0
  end
  local guid = type(UnitGUID) == "function" and UnitGUID(unitToken)
  if not guid then return nil, 0 end
  local getMarker = rawget(_G, "GetRaidTargetIndex")
  local marker = type(getMarker) == "function" and (tonumber(getMarker(unitToken)) or 0) or 0
  local previous = leaseByGuid[guid]
  if previous and previous.marker == marker then return guid, marker end
  if marker > 0 then rememberLease(guid, marker) else forgetGuid(guid) end
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
local function knownUnitsByGuid()
  local unitsByGuid = {}
  local unitGuid = rawget(_G, "UnitGUID")
  if type(unitGuid) ~= "function" then return unitsByGuid end
  for _, unitToken in ipairs(knownUnitTokens()) do
    local guid = unitGuid(unitToken)
    if guid and not unitsByGuid[guid] then unitsByGuid[guid] = unitToken end
  end
  return unitsByGuid
end

function LiveMarks:ObserveKnownUnits()
  local unitsByGuid = {}
  for _, unitToken in ipairs(knownUnitTokens()) do
    local guid = observeMarker(unitToken)
    if guid and not unitsByGuid[guid] then unitsByGuid[guid] = unitToken end
  end
  return unitsByGuid
end

function LiveMarks:IsMarkerAvailable(marker, guid)
  local lease = leaseByMarker[tonumber(marker)]
  return lease == nil or lease.guid == guid
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
          rememberLease(guid, marker, { artOwned = true, source = "player" })
          managedPlayerByMarker[marker] = guid
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

local function canDisplace(incoming, owner, activeStepId)
  if not owner or not owner.artOwned then return false end
  if incoming.source == "pull" then
    return owner.source == "global" or owner.source == "player"
        or owner.source == "pull" and owner.stepId ~= activeStepId
  end
  return incoming.source == "global"
      and (owner.source == "global" or owner.source == "player")
      and incoming.priority < (owner.priority or math.huge)
end

local function planRebalance(marks, unitToken, guid, unitsByGuid)
  unitsByGuid = unitsByGuid or knownUnitsByGuid()
  unitsByGuid[guid] = unitToken
  local planner = ART.RaidPlanner
  local activeStep = planner and planner.GetActiveStep and planner:GetActiveStep()
  local activeStepId = activeStep and activeStep.id
  local npcId = parseNpcId(guid)
  local candidates, source, priority = marks:GetRuleForNpcId(npcId)
  local root = {
    guid = guid, unit = unitToken, candidates = candidates, source = source,
    priority = priority or math.huge, stepId = activeStepId, artOwned = true,
  }
  local result = {
    source = source, guid = guid, npcId = npcId,
    candidates = candidates, priority = priority,
  }
  if #candidates == 0 then result.reason = "no-mark"; return nil, result end

  local virtualByMarker, virtualByGuid = {}, {}
  for marker, lease in pairs(leaseByMarker) do virtualByMarker[marker] = lease end
  for ownerGuid, lease in pairs(leaseByGuid) do virtualByGuid[ownerGuid] = lease end
  local plan = { operations = {}, affected = {}, unitsByGuid = unitsByGuid }
  local queue, head = { root }, 1
  while queue[head] do
    local incoming = queue[head]
    head = head + 1
    local marker, displaced
    for _, candidate in ipairs(incoming.candidates) do
      local owner = virtualByMarker[candidate]
      if not owner or owner.guid == incoming.guid then
        marker = candidate
        break
      end
      if canDisplace(incoming, owner, activeStepId) then
        marker, displaced = candidate, owner
        break
      end
    end
    if not marker then
      if incoming == root then
        result.reason = "slots-exhausted"
        return nil, result
      end
    else
      local previous = virtualByGuid[incoming.guid]
      if previous and virtualByMarker[previous.marker] == previous then
        virtualByMarker[previous.marker] = nil
      end
      incoming.marker = marker
      virtualByMarker[marker], virtualByGuid[incoming.guid] = incoming, incoming
      plan.operations[#plan.operations + 1] = incoming
      plan.affected[incoming.guid] = true
      if displaced then
        virtualByGuid[displaced.guid] = nil
        plan.affected[displaced.guid] = true
        local displacedUnit = unitsByGuid[displaced.guid]
        if displacedUnit then
          local nextCandidates, nextSource, nextPriority =
              marks:GetRuleForNpcId(parseNpcId(displaced.guid))
          if #nextCandidates > 0 then
            queue[#queue + 1] = {
              guid = displaced.guid, unit = displacedUnit, candidates = nextCandidates,
              source = nextSource, priority = nextPriority or math.huge,
              stepId = activeStepId, artOwned = true,
            }
          end
        end
      end
    end
  end
  result.marker = root.marker
  return plan, result
end

local function applyPlan(plan, result)
  local setRaidTarget = rawget(_G, "SetRaidTarget")
  local getRaidTarget = rawget(_G, "GetRaidTargetIndex")
  local originals = {}
  for guid in pairs(plan.affected) do originals[guid] = leaseByGuid[guid] or false end

  local function restoreOriginals()
    for guid, lease in pairs(originals) do
      local unit = plan.unitsByGuid[guid]
      if lease and unit then pcall(setRaidTarget, unit, lease.marker) end
    end
    for guid, lease in pairs(originals) do
      local unit = plan.unitsByGuid[guid]
      local marker = unit and type(getRaidTarget) == "function" and tonumber(getRaidTarget(unit))
      if not lease and marker and marker > 0 then pcall(setRaidTarget, unit, 0) end
    end
  end

  for _, operation in ipairs(plan.operations) do
    local ok, response = pcall(setRaidTarget, operation.unit, operation.marker)
    local observed = type(getRaidTarget) == "function" and tonumber(getRaidTarget(operation.unit))
    if not ok or response == false or observed and observed ~= operation.marker then
      restoreOriginals()
      return false, "api-failed", result
    end
  end

  for guid in pairs(plan.affected) do forgetGuid(guid) end
  for _, operation in ipairs(plan.operations) do rememberLease(operation.guid, operation.marker, operation) end
  return true, result.marker, result
end

local function markUnit(unitToken, unitsByGuid)
  local marks = ART.RaidMarks
  if not (marks and marks.initialized) then return false, "not-initialized" end
  local guid, reason = eligibleUnit(unitToken)
  if not guid then return false, reason end
  local _, currentMarker = observeMarker(unitToken)
  if currentMarker > 0 then return false, "existing-marker" end
  local plan, result = planRebalance(marks, unitToken, guid, unitsByGuid)
  if not plan then return false, result.reason, result end
  return applyPlan(plan, result)
end

function LiveMarks:TryMouseover()
  if self.debugMode then self:PrintDebugMouseover() end
  local settings = db()
  if not (settings and settings.autoMark == true) then return false, "disabled" end
  if not modifierDown() then return false, "modifier" end
  return markUnit("mouseover", self:ObserveKnownUnits())
end

function LiveMarks:TryNameplate(unitToken)
  local settings = db()
  if not (settings and settings.autoMark == true) then return false, "disabled" end
  if settings.autoMarkNameplates == false then
    observeMarker(unitToken)
    return false, "nameplates-disabled"
  end
  return markUnit(unitToken)
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
  for marker in pairs(leaseByMarker) do leaseByMarker[marker] = nil end
  for guid in pairs(leaseByGuid) do leaseByGuid[guid] = nil end
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
        local marks = ART.RaidMarks
        if marks and marks.initialized then marks:OnUnitDeath(destGuid) end
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
