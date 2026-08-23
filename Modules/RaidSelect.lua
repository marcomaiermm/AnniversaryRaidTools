-- Made by Nnoggie, 2017-2025
-- Raid selection boundary; central registration belongs to ART-070.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local RaidSelect = ART.RaidSelect or {}
ART.RaidSelect = RaidSelect
if addon and addon.RaidSelect == nil then addon.RaidSelect = RaidSelect end

function RaidSelect:Initialize(dependencies)
  if self.initialized then return self end
  dependencies = dependencies or {}
  self.registry = dependencies.registry or dependencies.raidRegistry or ART.RaidRegistry
  self.planner = dependencies.planner or dependencies.raidPlanner or ART.RaidPlanner
  assert(type(self.registry) == "table", "RaidSelect requires RaidRegistry")
  self.initialized = true
  return self
end

function RaidSelect:GetRaids() return self.registry:GetAll() end

function RaidSelect:Select(raidKey)
  local raid = self.registry:Get(raidKey)
  if not raid then return nil, "unknown raid" end
  self.selectedRaidKey = raidKey
  if self.planner and self.planner.Create then return self.planner:Create(raidKey) end
  return raid
end

