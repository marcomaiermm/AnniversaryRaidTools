-- Feature boundary for the pure raid mark resolver.

local _, ART = ...

local RaidMarks = ART.RaidMarks or {}
ART.RaidMarks = RaidMarks

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
  if not self.resolver then return nil, { reason = "not-initialized" } end
  return self.resolver:ResolveUnit(unitToken)
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
