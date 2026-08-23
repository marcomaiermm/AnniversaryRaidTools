-- Made by Nnoggie, 2017-2025
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
  self.initialized = true
  return self
end

function Planner:Create(raidKey)
  local raid = self.registry:Get(raidKey)
  if not raid then return nil, "unknown raid" end
  self.raid, self.preset = raid, self.presets:Create(raid)
  if self.onChange then self.onChange(self.preset, raid) end
  return self.preset
end

function Planner:Import(value)
  local preset, reason = self.presets:Import(value, self.registry)
  if not preset then return nil, reason end
  self.raid, self.preset = self.registry:Get(preset.raidKey), preset
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

