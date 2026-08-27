-- Route/wave editing boundary; central registration belongs to ART-070.

local _, ART = ...

local Planner = ART.RaidPlanner or {}
ART.RaidPlanner = Planner

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
  if (marker == nil or marker == 0) and ART.CCAssignments and ART.GetCurrentPreset then
    local pullIndex = self.lastPullIndex
        or (type(self.getCurrentPullIndex) == "function" and self.getCurrentPullIndex())
    if pullIndex then
      ART.CCAssignments:ClearPullAssignment(ART:GetCurrentPreset(), pullIndex, spawnKey, true)
    end
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

local markerPriority = { [8] = 1, [7] = 2, [1] = 3, [5] = 4, [6] = 5, [3] = 6, [4] = 7, [2] = 8 }

local function stepNpcSpawnKeys(planner, step, npcId)
  local enemy = planner.raid and planner.raid.enemies and planner.raid.enemies[tostring(npcId)]
  if not enemy then return nil, "unknown npc" end
  local packs, keys = {}, {}
  for _, packKey in ipairs(step.packKeys) do packs[packKey] = true end
  for _, spawn in ipairs(enemy.spawns or {}) do
    if packs[spawn.packKey] then keys[#keys + 1] = spawn.key end
  end
  return keys
end

function Planner:GetStepNpcMarks(stepId, npcId)
  if not self.preset or not self.raid then return {} end
  local step = stepById(self.preset, stepId)
  if not step then return {} end
  local keys = stepNpcSpawnKeys(self, step, tonumber(npcId))
  local markers = {}
  for _, spawnKey in ipairs(keys or {}) do
    local marker = tonumber(step.marks[spawnKey])
    if marker then markers[#markers + 1] = marker end
  end
  table.sort(markers, function(left, right) return markerPriority[left] < markerPriority[right] end)
  return markers
end

function Planner:SetStepNpcMarks(stepId, npcId, markers)
  if not self.preset or not self.raid then return nil, "no active preset" end
  local step = stepById(self.preset, stepId)
  if not step then return nil, "unknown route step" end
  npcId = tonumber(npcId)
  local spawnKeys, reason = stepNpcSpawnKeys(self, step, npcId)
  if not spawnKeys then return nil, reason end
  if type(markers) ~= "table" then return nil, "invalid markers" end

  local normalized, seen = {}, {}
  for _, value in ipairs(markers) do
    local marker = tonumber(value)
    if not marker or marker < 1 or marker > 8 or marker % 1 ~= 0 then return nil, "invalid marker" end
    if not seen[marker] then normalized[#normalized + 1], seen[marker] = marker, true end
  end
  if #normalized > #spawnKeys then return nil, "too many markers" end

  local previous = {}
  for spawnKey, marker in pairs(step.marks) do previous[spawnKey] = marker end
  local assigned = {}
  for _, spawnKey in ipairs(spawnKeys) do
    local marker = tonumber(step.marks[spawnKey])
    if marker and seen[marker] and not assigned[marker] then
      assigned[marker] = spawnKey
    else
      step.marks[spawnKey] = nil
    end
  end
  for spawnKey, marker in pairs(step.marks) do
    if seen[marker] and assigned[marker] ~= spawnKey then step.marks[spawnKey] = nil end
  end
  local nextSpawn = 1
  for _, marker in ipairs(normalized) do
    if not assigned[marker] then
      while step.marks[spawnKeys[nextSpawn]] do nextSpawn = nextSpawn + 1 end
      step.marks[spawnKeys[nextSpawn]], assigned[marker] = marker, spawnKeys[nextSpawn]
    end
  end

  local valid, validationReason = self.presets:Validate(self.preset, self.raid)
  if not valid then
    for spawnKey in pairs(step.marks) do step.marks[spawnKey] = nil end
    for spawnKey, marker in pairs(previous) do step.marks[spawnKey] = marker end
    return nil, validationReason
  end
  commit(self)
  if ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
  return normalized
end

function Planner:GetNpcDefaultMarks(npcId)
  local sublevel = ART.GetCurrentSubLevel and ART:GetCurrentSubLevel()
      or self.preset and self.preset.currentSublevel
  local marking = self.preset and self.preset.marking
  local defaults = marking and marking.floorNpcDefaults and marking.floorNpcDefaults[tonumber(sublevel)]
  local markers = defaults and defaults[tonumber(npcId)]
  local result = {}
  for _, marker in ipairs(type(markers) == "table" and markers or {}) do
    result[#result + 1] = tonumber(marker)
  end
  return result
end

function Planner:SetNpcDefaultMarks(npcId, markers)
  if not self.preset or not self.raid then return nil, "no active preset" end
  npcId = tonumber(npcId)
  if not npcId or npcId % 1 ~= 0 or not self.raid.enemies[tostring(npcId)] then return nil, "unknown npc" end
  if type(markers) ~= "table" then return nil, "invalid markers" end

  local normalized, seen = {}, {}
  for _, value in ipairs(markers) do
    local marker = tonumber(value)
    if not marker or marker < 1 or marker > 8 or marker % 1 ~= 0 then return nil, "invalid marker" end
    if not seen[marker] then normalized[#normalized + 1], seen[marker] = marker, true end
  end

  local sublevel = ART.GetCurrentSubLevel and ART:GetCurrentSubLevel() or self.preset.currentSublevel
  sublevel = tonumber(sublevel)
  if not sublevel or not self.raid.sublevels[sublevel] then return nil, "invalid sublevel" end
  self.preset.marking.floorNpcDefaults = self.preset.marking.floorNpcDefaults or {}
  self.preset.marking.floorNpcDefaults[sublevel] = self.preset.marking.floorNpcDefaults[sublevel] or {}
  local defaults = self.preset.marking.floorNpcDefaults[sublevel]
  local previous = {}
  for otherNpcId, values in pairs(defaults) do
    previous[otherNpcId] = {}
    for index, value in ipairs(values) do previous[otherNpcId][index] = value end
  end
  for otherNpcId, values in pairs(defaults) do
    if otherNpcId ~= npcId then
      local kept = {}
      for _, value in ipairs(values) do if not seen[value] then kept[#kept + 1] = value end end
      defaults[otherNpcId] = #kept > 0 and kept or nil
    end
  end
  defaults[npcId] = #normalized > 0 and normalized or nil
  local valid, reason = self.presets:Validate(self.preset, self.raid)
  if not valid then
    for key in pairs(defaults) do defaults[key] = nil end
    for key, values in pairs(previous) do defaults[key] = values end
    return nil, reason
  end

  commit(self)
  if not self.onChange and ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
  return normalized
end

function Planner:ClearFloorDefaultMarks(sublevel)
  if not self.preset or not self.raid then return nil, "no active preset" end
  sublevel = tonumber(sublevel) or tonumber(ART.GetCurrentSubLevel and ART:GetCurrentSubLevel())
      or tonumber(self.preset.currentSublevel)
  if not sublevel or not self.raid.sublevels[sublevel] then return nil, "invalid sublevel" end
  local floors = self.preset.marking and self.preset.marking.floorNpcDefaults
  if type(floors) ~= "table" or floors[sublevel] == nil then return true end
  local previous = floors[sublevel]
  floors[sublevel] = nil
  local valid, reason = self.presets:Validate(self.preset, self.raid)
  if not valid then floors[sublevel] = previous return nil, reason end
  commit(self)
  if not self.onChange and ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
  return true
end

function Planner:GetNpcDefaultMark(npcId)
  return self:GetNpcDefaultMarks(npcId)[1]
end

function Planner:SetNpcDefaultMark(npcId, marker)
  if marker == nil or tonumber(marker) == 0 then
    local result, reason = self:SetNpcDefaultMarks(npcId, {})
    return result and 0 or nil, reason
  end
  local result, reason = self:SetNpcDefaultMarks(npcId, { marker })
  return result and result[1] or nil, reason
end
