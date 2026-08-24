-- Made by Nnoggie, 2017-2025
-- Live marking reconciles every unit token exposed by the client with the
-- preset-wide mark plan. The selected pull supplies matching context and safe
-- progression, but does not own the marks.

local _, addon = ...
local MDT = addon
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local LiveMarks = ART.LiveMarks or {}
ART.LiveMarks = LiveMarks

local visibleNameplates = {}
local fallbackStates = {}
local markerLeaseByIndex, markerByGuid = {}, {}
local artMarkerByGuid = {}
local deadGuids = {}
local trackingStepKey, trackingPullIndex
local trackedSpawnByGuid, trackedGuidBySpawn, deadTrackedSpawns = {}, {}, {}
local pendingAdvance = false

local function autoMarkEnabled()
  local db = ART.GetDB and ART.GetDB()
  return db and db.autoMark == true
end

local function parseNpcId(guid)
  if type(guid) ~= "string" then return nil end
  local previous, last
  for component in guid:gmatch("[^%-]+") do
    previous, last = last, component
  end
  return tonumber(previous)
end

function LiveMarks:SnapshotUnit(unitToken)
  if type(unitToken) ~= "string" or UnitExists(unitToken) ~= true then return { npcId = nil } end
  local guid = UnitGUID(unitToken)
  if guid and deadGuids[guid] then return { npcId = nil, guid = guid } end
  local unitDead = rawget(_G, "UnitIsDeadOrGhost") or rawget(_G, "UnitIsDead")
  if type(unitDead) == "function" and unitDead(unitToken) == true then
    return { npcId = nil, guid = guid }
  end
  local x, y = UnitPosition(unitToken)
  local compat = ART.Compat
  return {
    npcId = parseNpcId(guid),
    x = x,
    y = y,
    uiMapId = compat and compat.GetBestMapForUnit and compat:GetBestMapForUnit(unitToken) or nil,
    guid = guid,
  }
end

local function noteLiveUnit(unitToken, trustToken)
  if type(unitToken) ~= "string" or UnitExists(unitToken) ~= true then return end
  local guid = UnitGUID(unitToken)
  local unitDead = rawget(_G, "UnitIsDeadOrGhost") or rawget(_G, "UnitIsDead")
  if guid and (trustToken or type(unitDead) ~= "function" or unitDead(unitToken) ~= true) then
    deadGuids[guid] = nil
  end
end

local function positionlessSpawn(raid, step, candidates, snapshot, reason, worldPositions)
  if reason ~= "ambiguous" or snapshot.x ~= nil or snapshot.y ~= nil or not snapshot.guid then return nil end
  local matches = {}
  for _, candidate in ipairs(candidates) do
    if candidate.npcId == snapshot.npcId then matches[#matches + 1] = candidate end
  end
  if #matches == 0 then return nil end

  local stepKey = raid.key..":"..step.id
  local state = fallbackStates[stepKey]
  if not state then
    state = { spawnByGuid = {}, guidBySpawn = {} }
    fallbackStates[stepKey] = state
  end
  local assigned = state.spawnByGuid[snapshot.guid]
  if assigned then
    for _, candidate in ipairs(matches) do
      if candidate.spawnKey == assigned then return assigned end
    end
    state.spawnByGuid[snapshot.guid], state.guidBySpawn[assigned] = nil, nil
  end

  local packs, packOrder = {}, {}
  for _, candidate in ipairs(matches) do
    if not state.guidBySpawn[candidate.spawnKey] then
      local packKey = candidate.packKey
      if not packs[packKey] then
        packs[packKey] = {}
        packOrder[#packOrder + 1] = packKey
      end
      packs[packKey][#packs[packKey] + 1] = candidate
    end
  end
  if #packOrder == 0 then return nil end

  local selectedPack = #packOrder == 1 and packOrder[1] or nil
  if not selectedPack then
    local playerX, playerY = UnitPosition("player")
    local bestDistance
    if playerX ~= nil and playerY ~= nil then
      for _, packKey in ipairs(packOrder) do
        for _, candidate in ipairs(packs[packKey]) do
          local function consider(point)
            if type(point) ~= "table" or point.x == nil or point.y == nil then return end
            local dx, dy = playerX - point.x, playerY - point.y
            local distance = dx * dx + dy * dy
            if not bestDistance or distance < bestDistance then
              selectedPack, bestDistance = packKey, distance
            end
          end
          consider(candidate)
          local world = worldPositions and worldPositions[candidate.spawnKey]
          for _, point in ipairs(world and world.patrol or {}) do consider(point) end
        end
      end
    end
  end
  selectedPack = selectedPack or packOrder[1]

  -- ponytail: player proximity, then pull order, disambiguates positionless
  -- packs; replace this heuristic if Blizzard exposes hostile coordinates.
  for _, candidate in ipairs(packs[selectedPack]) do
    if not state.guidBySpawn[candidate.spawnKey] then
      state.spawnByGuid[snapshot.guid] = candidate.spawnKey
      state.guidBySpawn[candidate.spawnKey] = snapshot.guid
      return candidate.spawnKey
    end
  end
end

local function forgetPositionlessGuid(guid)
  for _, state in pairs(fallbackStates) do
    local spawnKey = state.spawnByGuid[guid]
    if spawnKey then
      state.spawnByGuid[guid], state.guidBySpawn[spawnKey] = nil, nil
    end
  end
end

local function runtimeStepKey(raid, step)
  return raid and step and raid.key..":"..step.id or nil
end

local function resetPullTracking(raid, step, pullIndex)
  trackingStepKey = runtimeStepKey(raid, step)
  trackingPullIndex = pullIndex
  trackedSpawnByGuid, trackedGuidBySpawn, deadTrackedSpawns = {}, {}, {}
  pendingAdvance = false
end

local function stepContainsSpawn(step, spawnKey)
  for _, expected in ipairs(step and step.spawnKeys or {}) do
    if expected == spawnKey then return true end
  end
  return false
end

local function trackCurrentSpawn(raid, step, pullIndex, guid, spawnKey)
  if not guid or not stepContainsSpawn(step, spawnKey) then return end
  local stepKey = runtimeStepKey(raid, step)
  if trackingStepKey ~= stepKey or trackingPullIndex ~= pullIndex then
    resetPullTracking(raid, step, pullIndex)
  end
  local previousGuid = trackedGuidBySpawn[spawnKey]
  if previousGuid and previousGuid ~= guid then trackedSpawnByGuid[previousGuid] = nil end
  trackedSpawnByGuid[guid], trackedGuidBySpawn[spawnKey] = spawnKey, guid
  deadTrackedSpawns[spawnKey] = nil
end

local function activePullComplete(step)
  if type(step) ~= "table" or type(step.spawnKeys) ~= "table" or #step.spawnKeys == 0 then return false end
  for _, spawnKey in ipairs(step.spawnKeys) do
    if not deadTrackedSpawns[spawnKey] then return false end
  end
  return true
end

local function groupInCombat()
  local inCombat = rawget(_G, "UnitAffectingCombat")
  if type(inCombat) ~= "function" then return false end
  if inCombat("player") then return true end
  for index = 1, 4 do if inCombat("party"..index) then return true end end
  for index = 1, 40 do if inCombat("raid"..index) then return true end end
  return false
end

local function maybeAdvancePull()
  if not pendingAdvance or groupInCombat() then return false end
  local planner = ART.RaidPlanner
  local step = planner and planner:GetActiveStep()
  if not planner or runtimeStepKey(planner.raid, step) ~= trackingStepKey
      or planner.lastPullIndex ~= trackingPullIndex then return false end
  local nextPull = trackingPullIndex and trackingPullIndex + 1
  if not nextPull or type(planner.GetPullStep) ~= "function" or not planner:GetPullStep(nextPull) then
    pendingAdvance = false
    return false
  end
  if type(MDT) ~= "table" or type(MDT.SetSelectionToPull) ~= "function" then return false end
  pendingAdvance = false
  MDT:SetSelectionToPull(nextPull)
  return true
end

local function markTrackedDeath(guid)
  local spawnKey = trackedSpawnByGuid[guid]
  if not spawnKey then return false end
  deadTrackedSpawns[spawnKey] = true
  local planner = ART.RaidPlanner
  local step = planner and planner:GetActiveStep()
  if runtimeStepKey(planner and planner.raid, step) == trackingStepKey and activePullComplete(step) then
    pendingAdvance = true
  end
  return true
end

-- Runtime half of the resolver's getSpawnKeyForGuid dependency.
function LiveMarks:ResolveSpawnKey(unitToken)
  local planner = ART.RaidPlanner
  if not planner or not planner.initialized then return nil, "not-initialized" end
  local raid, preset = planner.raid, planner.preset
  local activeStep = planner:GetActiveStep()
  if not raid or not preset or not activeStep then return nil, "no-active-step" end
  local marks, resolver = ART.RaidMarks, ART.RaidMarks and ART.RaidMarks.resolver
  if resolver and resolver.activeRouteStepId ~= activeStep.id then
    local activated = marks:ActivateRouteStep(activeStep.id)
    if not activated then return nil, "no-active-step" end
  end
  local worldPositions = ART.MapWorldPositions and ART.MapWorldPositions[raid.key]
  local snapshot = self:SnapshotUnit(unitToken)
  local candidates = ART.SpawnMatcher:CandidatesForStep(raid, activeStep, worldPositions)
  local spawnKey, reason = ART.SpawnMatcher:Resolve(candidates, snapshot)
  spawnKey = spawnKey or positionlessSpawn(raid, activeStep, candidates, snapshot, reason, worldPositions)
  if spawnKey then
    trackCurrentSpawn(raid, activeStep, planner.lastPullIndex, snapshot.guid, spawnKey)
    return spawnKey, reason
  end

  -- A pull narrows ambiguous matching but never owns the preset mark plan.
  -- Only explicit preset marks are considered outside the active pull.
  if reason == "no-candidate" and planner.GetMarkedStep then
    local markedStep = planner:GetMarkedStep()
    if markedStep then
      candidates = ART.SpawnMatcher:CandidatesForStep(raid, markedStep, worldPositions)
      spawnKey, reason = ART.SpawnMatcher:Resolve(candidates, snapshot)
      spawnKey = spawnKey or positionlessSpawn(raid, markedStep, candidates, snapshot, reason, worldPositions)
      if spawnKey then return spawnKey, reason end
    end
  end
  return nil, reason
end

local function forgetMarkerLease(guid)
  local marker = markerByGuid[guid]
  if marker and markerLeaseByIndex[marker] == guid then markerLeaseByIndex[marker] = nil end
  markerByGuid[guid], artMarkerByGuid[guid] = nil, nil
end

local function observeMarker(unitToken)
  if type(unitToken) ~= "string" or UnitExists(unitToken) ~= true then return nil, 0 end
  local guid = UnitGUID(unitToken)
  if not guid then return nil, 0 end
  local marker = rawget(_G, "GetRaidTargetIndex")
  marker = type(marker) == "function" and tonumber(marker(unitToken)) or 0
  marker = marker or 0
  if artMarkerByGuid[guid] and artMarkerByGuid[guid] ~= marker then artMarkerByGuid[guid] = nil end
  local previous = markerByGuid[guid]
  if previous and previous ~= marker and markerLeaseByIndex[previous] == guid then
    markerLeaseByIndex[previous] = nil
  end
  if marker > 0 then
    local displaced = markerLeaseByIndex[marker]
    if displaced and displaced ~= guid then markerByGuid[displaced] = nil end
    markerLeaseByIndex[marker], markerByGuid[guid] = guid, marker
  else
    markerByGuid[guid] = nil
  end
  return guid, marker
end

local function knownUnitTokens()
  local tokens = { "target", "mouseover" }
  for unitToken in pairs(visibleNameplates) do tokens[#tokens + 1] = unitToken end
  for index = 1, 4 do tokens[#tokens + 1] = "party"..index.."target" end
  for index = 1, 40 do tokens[#tokens + 1] = "raid"..index.."target" end
  return tokens
end

local function tryApply(unitToken)
  if not autoMarkEnabled() then return false, "disabled" end
  local marks = ART.RaidMarks
  if not (marks and marks.initialized) then return false, "not-initialized" end
  local guid, currentMarker = observeMarker(unitToken)
  if not guid then return false, "missing" end
  if currentMarker > 0 then
    if artMarkerByGuid[guid] ~= currentMarker then return false, "existing-marker" end
    local desiredMarker = marks:ResolveUnit(unitToken)
    if desiredMarker == currentMarker then return false, "existing-marker" end
    marks:OnUnitDeath(guid)
    local setRaidTarget = rawget(_G, "SetRaidTarget")
    if type(setRaidTarget) ~= "function" then return false, "api-forbidden" end
    setRaidTarget(unitToken, currentMarker) -- Setting the same icon toggles ART's own mark off.
    forgetMarkerLease(guid)
    if not desiredMarker then return false, "plan-cleared" end
  end

  local marker, result = marks:ResolveUnit(unitToken)
  if not marker then return false, result and result.reason or "no-mark" end
  local lease = markerLeaseByIndex[marker]
  if lease and lease ~= guid then
    marks:OnUnitDeath(guid)
    return false, "marker-in-use"
  end

  local applied, appliedMarker, details = marks:ApplyUnit(unitToken)
  if applied then
    markerLeaseByIndex[appliedMarker], markerByGuid[guid] = guid, appliedMarker
    artMarkerByGuid[guid] = appliedMarker
  elseif appliedMarker == "existing-marker" then
    observeMarker(unitToken)
  else
    marks:OnUnitDeath(guid)
  end
  return applied, appliedMarker, details
end

function LiveMarks:ApplyKnownUnits()
  local tokens = knownUnitTokens()
  -- Observe first so an existing/manual icon cannot be stolen by an earlier
  -- token in the same reconciliation pass.
  for _, unitToken in ipairs(tokens) do observeMarker(unitToken) end
  for _, unitToken in ipairs(tokens) do tryApply(unitToken) end
end

function LiveMarks:OnPlanChanged()
  local marks = ART.RaidMarks
  if marks and marks.initialized then
    local planner = ART.RaidPlanner
    local step = planner and planner:GetActiveStep()
    if step then
      marks:ActivateRouteStep(step.id)
    else
      marks:ResetActivePack()
    end
  end
  self:ApplyKnownUnits()
end

local function packKeyForSpawn(raid, step, spawnKey)
  if not spawnKey then return nil end
  for _, packKey in ipairs(step.packKeys or {}) do
    local pack = raid.packs and raid.packs[packKey]
    for _, key in ipairs(pack and pack.spawnKeys or {}) do
      if key == spawnKey then return packKey end
    end
  end
end

function LiveMarks:ResolvePackKey(unitToken)
  local planner = ART.RaidPlanner
  local step = planner and planner:GetActiveStep()
  if not (planner and planner.raid and step) then return nil end
  return packKeyForSpawn(planner.raid, step, self:ResolveSpawnKey(unitToken))
end

function LiveMarks:ApplyMouseoverPack()
  local packKey = self:ResolvePackKey("mouseover")
  if not packKey then return false, "outside-active-step" end

  local mouseoverGuid = UnitGUID("mouseover")
  tryApply("mouseover")
  for unitToken in pairs(visibleNameplates) do
    if UnitGUID(unitToken) ~= mouseoverGuid and self:ResolvePackKey(unitToken) == packKey then
      tryApply(unitToken)
    end
  end
  return true
end

function LiveMarks:OnPullSelected(step, pullIndex)
  local planner = ART.RaidPlanner
  local stepKey = runtimeStepKey(planner and planner.raid, step)
  if stepKey ~= trackingStepKey or pullIndex ~= trackingPullIndex then
    resetPullTracking(planner and planner.raid, step, pullIndex)
  end
  self:ApplyKnownUnits()
end

local eventFrame = CreateFrame("Frame", "MDTLiveMarksEventFrame", UIParent)
eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("UNIT_TARGET")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("RAID_TARGET_UPDATE")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("UNIT_FLAGS")
eventFrame:RegisterEvent("ENCOUNTER_END")
eventFrame:SetScript("OnEvent", function(_, event, ...)
  local unitToken = ...
  if event == "UPDATE_MOUSEOVER_UNIT" then
    noteLiveUnit("mouseover")
    local applied = LiveMarks:ApplyMouseoverPack()
    if not applied then tryApply("mouseover") end
  elseif event == "PLAYER_TARGET_CHANGED" then
    noteLiveUnit("target")
    tryApply("target")
  elseif event == "UNIT_TARGET" then
    if unitToken == "player" then
      noteLiveUnit("target")
      tryApply("target")
    elseif type(unitToken) == "string"
        and (unitToken:match("^party%d+$") or unitToken:match("^raid%d+$")) then
      local targetToken = unitToken.."target"
      noteLiveUnit(targetToken)
      tryApply(targetToken)
    end
  elseif event == "NAME_PLATE_UNIT_ADDED" then
    visibleNameplates[unitToken] = true
    noteLiveUnit(unitToken, true)
    tryApply(unitToken)
  elseif event == "NAME_PLATE_UNIT_REMOVED" then
    visibleNameplates[unitToken] = nil
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local _, subevent, _, _, _, _, _, destGUID = CombatLogGetCurrentEventInfo()
    if subevent == "UNIT_DIED" and destGUID then
      deadGuids[destGUID] = true
      markTrackedDeath(destGUID)
      forgetPositionlessGuid(destGUID)
      forgetMarkerLease(destGUID)
      local marks = ART.RaidMarks
      if marks and marks.initialized then marks:OnUnitDeath(destGUID) end
      LiveMarks:ApplyKnownUnits()
      maybeAdvancePull()
    end
  elseif event == "ENCOUNTER_END" then
    local success = select(5, ...)
    if success == 1 then
      pendingAdvance = true
      maybeAdvancePull()
    else
      local planner = ART.RaidPlanner
      for guid in pairs(trackedSpawnByGuid) do deadGuids[guid] = nil end
      resetPullTracking(planner and planner.raid, planner and planner:GetActiveStep(), planner and planner.lastPullIndex)
    end
  elseif event == "RAID_TARGET_UPDATE" or event == "GROUP_ROSTER_UPDATE" then
    LiveMarks:ApplyKnownUnits()
  elseif event == "PLAYER_REGEN_ENABLED" or event == "UNIT_FLAGS" then
    maybeAdvancePull()
  end
end)

SLASH_ARTMARKDEBUG1 = "/artmarkdebug"
SlashCmdList.ARTMARKDEBUG = function()
  local db = ART.GetDB and ART.GetDB()
  if not (db and db.devMode) then
    print("ART mark debug requires devMode.")
    return
  end
  local planner = ART.RaidPlanner
  local activeStep = planner and planner:GetActiveStep()
  print(("ART marks | raid=%s step=%s pinned=%s"):format(
      planner and planner.raid and planner.raid.key or "-",
      activeStep and activeStep.id or "-", tostring(planner and planner:IsStepPinned())))
  for _, unitToken in ipairs({ "target", "mouseover" }) do
    local snapshot = LiveMarks:SnapshotUnit(unitToken)
    if not snapshot.npcId then
      print(("- %s: none"):format(unitToken))
    else
      local spawnKey, reason = LiveMarks:ResolveSpawnKey(unitToken)
      local applied, resultReason, result = ART.RaidMarks:ApplyUnit(unitToken)
      print(("- %s: npc=%s pos=%.1f,%.1f map=%s -> spawn=%s (%s), apply=%s/%s"):format(
          unitToken, snapshot.npcId, snapshot.x or -1, snapshot.y or -1,
          tostring(snapshot.uiMapId),
          tostring(spawnKey), tostring(reason),
          tostring(applied), tostring(resultReason or result and result.reason)))
    end
  end
end

ART.LiveMarks = LiveMarks
