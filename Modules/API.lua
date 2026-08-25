-- Stable raid-domain API for addon consumers.

local _, ART = ...

function ART:GetRaidDefinition(raidKey)
  return self.RaidRegistry and self.RaidRegistry:Get(raidKey)
end

function ART:GetRaidDefinitions()
  return self.RaidRegistry and self.RaidRegistry:GetAll() or {}
end

function ART:ValidateRoutePreset(preset)
  local raid = type(preset) == "table" and self:GetRaidDefinition(preset.raidKey)
  if not raid or not self.RoutePreset then return nil, "unknown raid" end
  return self.RoutePreset:Validate(preset, raid)
end
