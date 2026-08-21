-- Made by Nnoggie, 2017-2025
-- Feature boundary for sourced enemy information and bounded live observations.
-- Central registration is intentionally owned by the integrator.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local RaidEnemyInfo = ART.RaidEnemyInfo or {}
ART.RaidEnemyInfo = RaidEnemyInfo
if addon and addon.RaidEnemyInfo == nil then addon.RaidEnemyInfo = RaidEnemyInfo end

local type, pcall, select, unpack = type, pcall, select, unpack

local function safeCall(fn, ...)
  if type(fn) ~= "function" then return false, "missing" end
  return pcall(fn, ...)
end

function RaidEnemyInfo:Initialize(dependencies)
  if self.initialized then return self end
  dependencies = dependencies or {}

  local repository = dependencies.repository
  if not repository then
    local repositoryAPI = ART.EnemyInfoRepository
    if not repositoryAPI or type(repositoryAPI.new) ~= "function" then
      return false, "repository-unavailable"
    end
    local ok, result = pcall(repositoryAPI.new, dependencies.repositoryDependencies or dependencies)
    if not ok then return false, "repository-failed" end
    repository = result
  end
  if type(repository.Get) ~= "function" and type(repository.Lookup) ~= "function" then
    return false, "repository-invalid"
  end

  local recorder = dependencies.recorder
  if not recorder then
    local recorderAPI = ART.RaidRecorder
    if not recorderAPI or type(recorderAPI.new) ~= "function" then
      return false, "recorder-unavailable"
    end
    local recorderDependencies = {}
    for key, value in pairs(dependencies) do recorderDependencies[key] = value end
    recorderDependencies.repository = repository
    if not recorderDependencies.getRaidKey then recorderDependencies.getRaidKey = dependencies.getCurrentRaidKey end
    local ok, result = pcall(recorderAPI.new, recorderDependencies)
    if not ok then return false, "recorder-failed" end
    recorder = result
  end
  if type(recorder.RecordEvent) ~= "function" and type(recorder.OnCombatLogEvent) ~= "function" then
    return false, "recorder-invalid"
  end

  self.dependencies = dependencies
  self.repository = repository
  self.recorder = recorder
  self.eventFrame = nil
  if dependencies.eventFrame and type(dependencies.eventFrame.RegisterEvent) == "function" then
    local frame = dependencies.eventFrame
    local getCombatLogEventInfo = dependencies.GetCombatLogEventInfo
    local ok = pcall(frame.RegisterEvent, frame, "COMBAT_LOG_EVENT_UNFILTERED")
    if ok and type(frame.SetScript) == "function" then
      local scriptOK = pcall(frame.SetScript, frame, "OnEvent", function(_, event, ...)
        if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then return end
        local handler = self.recorder.OnCombatLogEvent or self.recorder.RecordEvent
        if type(handler) ~= "function" then return end
        if select("#", ...) == 0 and type(getCombatLogEventInfo) == "function" then
          local payload = { pcall(getCombatLogEventInfo) }
          if not payload[1] then return end
          table.remove(payload, 1)
          if #payload == 0 then return end
          pcall(handler, self.recorder, unpack(payload))
          return
        end
        pcall(handler, self.recorder, ...)
      end)
      if scriptOK then self.eventFrame = frame end
    end
  end
  self.initialized = true
  return self
end

function RaidEnemyInfo:Get(raidKey, npcId)
  if not self.initialized then return nil, "not-initialized" end
  local getter = self.repository.Get or self.repository.Lookup
  return getter(self.repository, raidKey, npcId)
end

RaidEnemyInfo.Lookup = RaidEnemyInfo.Get
RaidEnemyInfo.GetEnemyInfo = RaidEnemyInfo.Get

function RaidEnemyInfo:RecordEvent(...)
  if not self.initialized then return false, "not-initialized" end
  local recorder = self.recorder
  local handler = recorder.RecordEvent or recorder.OnCombatLogEvent
  if type(handler) ~= "function" then return false, "recorder-invalid" end
  local ok, accepted, detail = pcall(handler, recorder, ...)
  if not ok then return false, "recorder-failed" end
  return accepted, detail
end

RaidEnemyInfo.Record = RaidEnemyInfo.RecordEvent
RaidEnemyInfo.OnCombatLogEvent = RaidEnemyInfo.RecordEvent

function RaidEnemyInfo:GetRecorder()
  return self.initialized and self.recorder
end

function RaidEnemyInfo:GetRepository()
  return self.initialized and self.repository
end

function RaidEnemyInfo:Shutdown()
  if self.eventFrame and type(self.eventFrame.UnregisterEvent) == "function" then
    safeCall(self.eventFrame.UnregisterEvent, self.eventFrame, "COMBAT_LOG_EVENT_UNFILTERED")
  end
  self.eventFrame = nil
  self.initialized = nil
end

return RaidEnemyInfo
