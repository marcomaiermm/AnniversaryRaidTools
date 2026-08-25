-- Raid selection boundary; central registration belongs to ART-070.

local _, ART = ...

local RaidSelect = ART.RaidSelect or {}
ART.RaidSelect = RaidSelect

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
