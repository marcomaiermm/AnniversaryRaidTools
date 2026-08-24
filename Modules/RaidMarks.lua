-- Feature boundary for the pure raid mark resolver.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local RaidMarks = ART.RaidMarks or {}
ART.RaidMarks = RaidMarks
if addon and addon.RaidMarks == nil then addon.RaidMarks = RaidMarks end

function RaidMarks:Initialize(dependencies)
  if self.initialized then return self end
  dependencies = dependencies or {}
  local resolver = dependencies.resolver or dependencies.markResolver
  if not resolver and ART.MarkResolver then
    resolver = ART.MarkResolver.new(dependencies)
  end
  assert(type(resolver) == "table", "RaidMarks requires a mark resolver")
  self.resolver = resolver
  self.dependencies = dependencies
  self.initialized = true
  return self
end

function RaidMarks:ActivateRouteStep(routeStepId)
  return self.resolver and self.resolver:ActivateRouteStep(routeStepId)
end

function RaidMarks:ResolveUnit(unitToken)
  return self.resolver and self.resolver:ResolveUnit(unitToken)
end

function RaidMarks:ApplyUnit(unitToken)
  if not self.resolver then return false, "not-initialized" end
  return self.resolver:ApplyUnit(unitToken)
end

function RaidMarks:ResetActivePack()
  return self.resolver and self.resolver:ResetActivePack()
end

function RaidMarks:OnUnitDeath(unitGuid)
  return self.resolver and self.resolver:OnUnitDeath(unitGuid)
end

function RaidMarks:GetPreviewForPack(packKey)
  return self.resolver and self.resolver:GetPreviewForPack(packKey) or {}
end
