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
local markerLeaseByIndex, markerByGuid = {}, {}
local artMarkerByGuid = {}
local deadGuids = {}
local trackingStepKey, trackingPullIndex
local pullProgress = assert(ART.PullProgress, "LiveMarks requires PullProgress").new()
local pendingAdvance = false
local skipRaidTargetRefresh = false
local PLAYER_PACK_RADIUS_YARDS = 60
local PLAYER_PACK_MARGIN_YARDS = 10

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
  local x, y, _, instanceId = UnitPosition(unitToken)
  local compat = ART.Compat
  return {
    npcId = parseNpcId(guid),
    x = x,
    y = y,
    instanceId = instanceId,
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

local function resolveCandidates(candidates, snapshot)
  return ART.SpawnMatcher:ResolveMatch(candidates, snapshot, { allowDerived = true, margin = 1 })
end

local function usesPlayerPosition(unitToken)
  return unitToken == "target" or unitToken == "mouseover" or visibleNameplates[unitToken] == true
end

local function resolveByPlayerProximity(candidates, snapshot, unitToken)
  if not usesPlayerPosition(unitToken) or snapshot.x ~= nil or snapshot.y ~= nil then return end
  local playerX, playerY, _, playerInstanceId = UnitPosition("player")
  if playerX == nil or playerY == nil then return end
  local compat = ART.Compat
  local player = {
    npcId = snapshot.npcId,
    x = playerX,
    y = playerY,
    instanceId = playerInstanceId,
    uiMapId = compat and compat.GetBestMapForUnit and compat:GetBestMapForUnit("player") or nil,
  }
  local packDistance = {}
  for _, candidate in ipairs(candidates) do
    if candidate.npcId == snapshot.npcId then
      local match = ART.SpawnMatcher:ResolveMatch({ candidate }, player, {
        allowDerived = true, radius = PLAYER_PACK_RADIUS_YARDS, margin = 0,
      })
      if match.distance and candidate.packKey
          and (not packDistance[candidate.packKey] or match.distance < packDistance[candidate.packKey]) then
        packDistance[candidate.packKey] = match.distance
      end
    end
  end
  local nearby = {}
  for packKey, distance in pairs(packDistance) do
    nearby[#nearby + 1] = { packKey = packKey, distance = distance }
  end
  table.sort(nearby, function(left, right) return left.distance < right.distance end)
  if not nearby[1] or (nearby[2] and nearby[2].distance - nearby[1].distance < PLAYER_PACK_MARGIN_YARDS) then return end

  local packCandidates = {}
  for _, candidate in ipairs(candidates) do
    if candidate.packKey == nearby[1].packKey then packCandidates[#packCandidates + 1] = candidate end
  end
  local match = ART.SpawnMatcher:ResolveMatch(packCandidates, {
    npcId = snapshot.npcId,
    instanceId = snapshot.instanceId or player.instanceId,
    uiMapId = snapshot.uiMapId or player.uiMapId,
  })
  if match.kind == "exact" or match.kind == "packPool" then
    match.reasons[1] = "player-proximity"
    match.anchorDistance = nearby[1].distance
    return match
  end
end

local function unresolvedMatch(reason)
  return { kind = "unresolved", confidence = "none", candidateSpawnKeys = {}, reasons = { reason } }
end

local function runtimeStepKey(raid, step)
  return raid and step and raid.key..":"..step.id or nil
end

local function stepContainsPack(step, packKey)
  for _, key in ipairs(step and step.packKeys or {}) do
    if key == packKey then return true end
  end
  return false
end

local function resetPullTracking(raid, step, pullIndex)
  trackingStepKey = runtimeStepKey(raid, step)
  trackingPullIndex = pullIndex
  pullProgress:Reset()
  pendingAdvance = false
end

local function trackCurrentMatch(raid, step, pullIndex, guid, match)
  if not guid or type(match) ~= "table" then return end
  local stepKey = runtimeStepKey(raid, step)
  if trackingStepKey ~= stepKey or trackingPullIndex ~= pullIndex then
    resetPullTracking(raid, step, pullIndex)
  end
  pullProgress:Track(guid, match, step)
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
  if not pullProgress:MarkDead(guid) then return false end
  local planner = ART.RaidPlanner
  local step = planner and planner:GetActiveStep()
  if runtimeStepKey(planner and planner.raid, step) == trackingStepKey and pullProgress:IsComplete(step) then
    pendingAdvance = true
  end
  return true
end

function LiveMarks:ResolveMatch(unitToken)
  local planner = ART.RaidPlanner
  if not planner or not planner.initialized then return unresolvedMatch("not-initialized") end
  local raid, preset = planner.raid, planner.preset
  local activeStep = planner:GetActiveStep()
  if not raid or not preset or not activeStep then return unresolvedMatch("no-active-step") end
  local marks, resolver = ART.RaidMarks, ART.RaidMarks and ART.RaidMarks.resolver
  if resolver and resolver.activeRouteStepId ~= activeStep.id then
    local activated = marks:ActivateRouteStep(activeStep.id)
    if not activated then return unresolvedMatch("no-active-step") end
  end
  local worldPositions = ART.MapWorldPositions and ART.MapWorldPositions[raid.key]
  local mapDefinition = ART.MapDefinitions and ART.MapDefinitions[raid.key]
  local snapshot = self:SnapshotUnit(unitToken)
  local allPacks = { packKeys = {} }
  for packKey in pairs(raid.packs or {}) do allPacks.packKeys[#allPacks.packKeys + 1] = packKey end
  local candidates = ART.SpawnMatcher:CandidatesForStep(raid, allPacks, worldPositions, mapDefinition)
  local match, matchSnapshot = nil, snapshot
  if unitToken == "mouseover" then
    matchSnapshot = {
      npcId = snapshot.npcId, instanceId = snapshot.instanceId, uiMapId = snapshot.uiMapId,
    }
    match = ART.SpawnMatcher:ResolveMatch(candidates, matchSnapshot)
  else
    match = resolveCandidates(candidates, snapshot)
  end
  match = resolveByPlayerProximity(candidates, matchSnapshot, unitToken) or match
  if unitToken == "mouseover" and match.kind == "unresolved" then
    local activeCandidates = ART.SpawnMatcher:CandidatesForStep(
        raid, activeStep, worldPositions, mapDefinition)
    local activeMatch = ART.SpawnMatcher:ResolveMatch(activeCandidates, { npcId = snapshot.npcId })
    if activeMatch.kind == "exact" or activeMatch.kind == "packPool" then
      activeMatch.reasons[1] = "mouseover-active-step"
      match = activeMatch
    end
  end
  if match.kind == "exact" or match.kind == "packPool" then
    if match.kind == "exact" or stepContainsPack(activeStep, match.packKey) then
      trackCurrentMatch(raid, activeStep, planner.lastPullIndex, snapshot.guid, match)
    end
    return match
  end

  -- A pull narrows ambiguous matching but never owns the preset mark plan.
  -- Only explicit preset marks are considered outside the active pull.
  if match.reasons[1] == "no-candidate" and planner.GetMarkedStep then
    local markedStep = planner:GetMarkedStep()
    if markedStep then
      candidates = ART.SpawnMatcher:CandidatesForStep(raid, markedStep, worldPositions, mapDefinition)
      match = resolveCandidates(candidates, snapshot)
      if match.kind == "exact" or match.kind == "packPool" then return match end
    end
  end
  return match
end

-- Backward-compatible exact-key facade for debug and external callers.
function LiveMarks:ResolveSpawnKey(unitToken)
  local match = self:ResolveMatch(unitToken)
  return match.spawnKey, match.reasons[1]
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
    local desiredMarker = marks:ResolveUnit(unitToken)
    if artMarkerByGuid[guid] ~= currentMarker then
      if desiredMarker == currentMarker then
        -- `/reload` preserves world markers but not local ownership; matching
        -- plan state is sufficient to reconstruct ART's lease.
        artMarkerByGuid[guid] = currentMarker
      else
        marks:OnUnitDeath(guid)
      end
      return false, "existing-marker"
    end
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

function LiveMarks:OnPlanChanged(reconcile)
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
  -- Old holders may be outside token range; the new plan is authoritative.
  for marker in pairs(markerLeaseByIndex) do markerLeaseByIndex[marker] = nil end
  for guid in pairs(markerByGuid) do markerByGuid[guid] = nil end
  if reconcile ~= false then self:ApplyKnownUnits() end
  local ui = ART.RaidMarksUI
  if ui and ui.RefreshPullTracker then ui:RefreshPullTracker() end
end

function LiveMarks:ClearWorldMarks()
  local removeRaidTargets = rawget(_G, "RemoveRaidTargets")
  skipRaidTargetRefresh = type(removeRaidTargets) == "function"
  if skipRaidTargetRefresh then removeRaidTargets() end
  for marker in pairs(markerLeaseByIndex) do markerLeaseByIndex[marker] = nil end
  for guid in pairs(markerByGuid) do markerByGuid[guid] = nil end
  for guid in pairs(artMarkerByGuid) do artMarkerByGuid[guid] = nil end
  return skipRaidTargetRefresh
end

function LiveMarks:OnPullSelected(step, pullIndex)
  local planner = ART.RaidPlanner
  local stepKey = runtimeStepKey(planner and planner.raid, step)
  local changed = trackingPullIndex ~= nil and pullIndex ~= trackingPullIndex
  if changed then self:ClearWorldMarks() end
  if stepKey ~= trackingStepKey or pullIndex ~= trackingPullIndex then
    resetPullTracking(planner and planner.raid, step, pullIndex)
  end
  self:OnPlanChanged(not changed)
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
    tryApply("mouseover")
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
      pullProgress:EachGuid(function(guid) deadGuids[guid] = nil end)
      resetPullTracking(planner and planner.raid, planner and planner:GetActiveStep(), planner and planner.lastPullIndex)
    end
  elseif event == "RAID_TARGET_UPDATE" then
    if skipRaidTargetRefresh then skipRaidTargetRefresh = false else LiveMarks:ApplyKnownUnits() end
  elseif event == "GROUP_ROSTER_UPDATE" then
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
  local playerX, playerY, _, playerInstance = UnitPosition("player")
  local playerMap = ART.Compat and ART.Compat:GetBestMapForUnit("player")
  local mapPosition = playerMap and C_Map and C_Map.GetPlayerMapPosition
      and C_Map.GetPlayerMapPosition(playerMap, "player")
  local mapX, mapY = mapPosition and mapPosition:GetXY()
  print(("- player: pos=%s,%s instance=%s map=%s mapPos=%s,%s"):format(
      tostring(playerX), tostring(playerY), tostring(playerInstance), tostring(playerMap),
      tostring(mapX), tostring(mapY)))
  for _, unitToken in ipairs({ "target", "mouseover" }) do
    local snapshot = LiveMarks:SnapshotUnit(unitToken)
    if not snapshot.npcId then
      print(("- %s: none"):format(unitToken))
    else
      local spawnKey, reason = LiveMarks:ResolveSpawnKey(unitToken)
      local applied, resultReason, result = ART.RaidMarks:ApplyUnit(unitToken)
      print(("- %s: guid=%s npc=%s pos=%.1f,%.1f map=%s -> spawn=%s (%s), apply=%s/%s"):format(
          unitToken, tostring(snapshot.guid), snapshot.npcId, snapshot.x or -1, snapshot.y or -1,
          tostring(snapshot.uiMapId),
          tostring(spawnKey), tostring(reason),
          tostring(applied), tostring(resultReason or result and result.reason)))
    end
  end
end

ART.LiveMarks = LiveMarks
