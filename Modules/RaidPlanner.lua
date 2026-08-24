-- Route/wave editing boundary; central registration belongs to ART-070.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local Planner = ART.RaidPlanner or {}
ART.RaidPlanner = Planner
if addon and addon.RaidPlanner == nil then addon.RaidPlanner = Planner end

function Planner:Initialize(dependencies)
  if self.initialized then return self end
  dependencies = dependencies or {}
  self.registry = dependencies.registry or dependencies.raidRegistry or ART.RaidRegistry
  self.presets = dependencies.routePreset or ART.RoutePreset
  assert(type(self.registry) == "table", "RaidPlanner requires RaidRegistry")
  assert(type(self.presets) == "table", "RaidPlanner requires RoutePreset")
  self.onChange = dependencies.onChange
  self.getPullPackKeys = dependencies.getPullPackKeys
  self.getPullStep = dependencies.getPullStep
  self.getMarkedStep = dependencies.getMarkedStep
  self.getCurrentPullIndex = dependencies.getCurrentPullIndex
  self.lastPullIndex = nil
  self.initialized = true
  return self
end

function Planner:Create(raidKey)
  local raid = self.registry:Get(raidKey)
  if not raid then return nil, "unknown raid" end
  self.raid, self.preset = raid, self.presets:Create(raid)
  self.lastPullIndex, self.pullStep = nil, nil
  if self.onChange then self.onChange(self.preset, raid) end
  return self.preset
end

function Planner:Import(value)
  local preset, reason = self.presets:Import(value, self.registry)
  if not preset then return nil, reason end
  self.raid, self.preset = self.registry:Get(preset.raidKey), preset
  self.lastPullIndex, self.pullStep = nil, nil
  if self.onChange then self.onChange(preset, self.raid) end
  return preset
end

function Planner:Export()
  if not self.preset or not self.raid then return nil, "no active preset" end
  return self.presets:Export(self.preset, self.raid)
end

function Planner:AddRouteStep(step)
  if not self.preset or not self.raid then return nil, "no active preset" end
  if self.raid.mode ~= "route" then return nil, "wave composition is immutable" end
  step = step or {}
  if step.id == nil then
    local used, suffix = {}, 1
    for _, existing in ipairs(self.preset.routeSteps) do used[existing.id] = true end
    while used["route-step-"..suffix] do suffix = suffix + 1 end
    step.id = "route-step-"..suffix
  end
  step.label, step.packKeys, step.notes, step.marks = step.label or "", step.packKeys or {}, step.notes or "", step.marks or {}
  self.preset.routeSteps[#self.preset.routeSteps + 1] = step
  local valid, reason = self.presets:Validate(self.preset, self.raid)
  if not valid then table.remove(self.preset.routeSteps); return nil, reason end
  if self.onChange then self.onChange(self.preset, self.raid) end
  return step
end

function Planner:ReorderRouteStep(stepId, destination)
  if not self.preset or not self.raid then return nil, "no active preset" end
  local result, reason = self.presets:Reorder(self.preset, stepId, destination, self.raid)
  if result and self.onChange then self.onChange(self.preset, self.raid) end
  return result, reason
end

local function stepById(preset, stepId)
  for _, step in ipairs(preset.routeSteps) do
    if step.id == stepId then return step end
  end
end

local function stepsForPack(preset, packKey)
  local matches = {}
  for _, step in ipairs(preset.routeSteps) do
    for _, key in ipairs(step.packKeys) do
      if key == packKey then matches[#matches + 1] = step break end
    end
  end
  return matches
end

local function commit(planner)
  if planner.onChange then planner.onChange(planner.preset, planner.raid) end
end

local function currentPullStep(planner)
  if type(planner.getPullStep) ~= "function" then return nil end
  local pullIndex = planner.lastPullIndex
      or (type(planner.getCurrentPullIndex) == "function" and planner.getCurrentPullIndex())
  local fresh = pullIndex and planner.getPullStep(pullIndex)
  if type(fresh) ~= "table" then planner.pullStep = nil return nil end
  if planner.pullStep and planner.pullStep.id == fresh.id then
    for key in pairs(planner.pullStep) do planner.pullStep[key] = nil end
    for key, value in pairs(fresh) do planner.pullStep[key] = value end
  else
    planner.pullStep = fresh
  end
  return planner.pullStep
end

function Planner:GetActiveStep()
  if not self.preset then return nil end
  if not self.preset.currentStepPinned then
    local step = currentPullStep(self)
    if step then return step end
  end
  return stepById(self.preset, self.preset.currentStepId)
end

function Planner:GetMarkedStep()
  if type(self.getMarkedStep) ~= "function" then return nil end
  return self.getMarkedStep()
end

function Planner:GetPullStep(pullIndex)
  if type(self.getPullStep) ~= "function" then return nil end
  return self.getPullStep(pullIndex)
end

function Planner:IsStepPinned()
  return self.preset ~= nil and self.preset.currentStepPinned == true
end

function Planner:SelectStep(stepId)
  if not self.preset or not self.raid then return nil, "no active preset" end
  local step = stepById(self.preset, stepId)
  if not step then return nil, "unknown route step" end
  self.preset.currentStepId, self.preset.currentStepPinned = step.id, true
  commit(self)
  return step
end

function Planner:UnpinStep()
  if not self.preset or not self.raid then return nil, "no active preset" end
  self.preset.currentStepPinned = false
  if self.lastPullIndex then self:SyncStepFromPull(self.lastPullIndex) end
  commit(self)
  return true
end

function Planner:SyncStepFromPull(pullIndex)
  if not self.preset or not self.raid then return nil, "no active preset" end
  if type(pullIndex) ~= "number" or pullIndex % 1 ~= 0 then return nil, "invalid pull index" end
  if self.preset.currentStepPinned then return nil, "step-pinned" end
  self.lastPullIndex = pullIndex
  if self.raid.mode == "route" and type(self.getPullStep) == "function" then
    local step = currentPullStep(self)
    if not step then return nil, "empty pull" end
    commit(self)
    return step
  end
  if type(self.getPullPackKeys) ~= "function" then return nil, "unsupported" end
  local pullPackKeys = self.getPullPackKeys(pullIndex)
  if type(pullPackKeys) ~= "table" or #pullPackKeys == 0 then return nil, "empty pull" end

  -- Hysteresis: the active step wins only when it also contains one of the packs.
  local active = self:GetActiveStep()
  local activeMatches, candidates, seen = false, {}, {}
  for _, packKey in ipairs(pullPackKeys) do
    for _, step in ipairs(stepsForPack(self.preset, packKey)) do
      if not seen[step.id] then
        seen[step.id] = true
        if active and step.id == active.id then
          activeMatches = true
        else
          candidates[#candidates + 1] = step
        end
      end
    end
  end

  local resolved = activeMatches and active or candidates[1]
  if not resolved or (active and resolved.id == active.id) then return active end
  self.preset.currentStepId = resolved.id
  commit(self)
  return resolved
end

function Planner:SetSpawnMark(packKey, spawnKey, marker)
  if not self.preset or not self.raid then return nil, "no active preset" end
  marker = tonumber(marker)
  if marker ~= nil and (marker < 0 or marker > 8 or marker % 1 ~= 0) then return nil, "invalid marker" end

  local matches = stepsForPack(self.preset, packKey)
  if #matches == 0 then return nil, "pack-without-step" end
  local active = self:GetActiveStep()
  local target = matches[1]
  if active then
    for _, step in ipairs(matches) do
      if step.id == active.id then target = step break end
    end
  end

  local previous = target.marks[spawnKey]
  local displaced = {}
  if marker == nil or marker == 0 then
    target.marks[spawnKey] = nil
  else
    for key, assignedMarker in pairs(target.marks) do
      if key ~= spawnKey and assignedMarker == marker then
        displaced[#displaced + 1] = key
        target.marks[key] = nil
      end
    end
    target.marks[spawnKey] = marker
  end
  local valid, reason = self.presets:Validate(self.preset, self.raid)
  if not valid then
    target.marks[spawnKey] = previous
    for _, key in ipairs(displaced) do target.marks[key] = marker end
    return nil, reason
  end
  commit(self)
  if ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
  return marker, displaced
end

function Planner:FindStepsForPack(packKey)
  if not self.preset then return {} end
  if not self.preset.currentStepPinned and currentPullStep(self) then return {} end
  return stepsForPack(self.preset, packKey)
end

function Planner:ClearAllSpawnMarks()
  if not self.preset or not self.raid then return nil, "no active preset" end
  for _, step in ipairs(self.preset.routeSteps) do
    for key in pairs(step.marks) do step.marks[key] = nil end
  end
  commit(self)
  if ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
  return true
end

function Planner:GetSpawnMark(packKey, spawnKey)
  if not self.preset then return nil end
  local matches = stepsForPack(self.preset, packKey)
  local active = self:GetActiveStep()
  -- Prefer the active step so the blip reflects what live marking will apply.
  if active then
    for _, step in ipairs(matches) do
      if step.id == active.id then
        local marker = step.marks[spawnKey]
        if marker then return marker, step end
      end
    end
  end
  for _, step in ipairs(matches) do
    local marker = step.marks[spawnKey]
    if marker then return marker, step end
  end
end
