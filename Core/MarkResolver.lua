-- Pure pull/global NPC mark resolution. Live unit discovery belongs to LiveMarks.

local _, ART = ...

local MarkResolver = ART.MarkResolver or {}
ART.MarkResolver = MarkResolver

local MARKER_ORDER = { 8, 7, 1, 5, 6, 3, 4, 2 }
local MARKER_PRIORITY = {}
for priority, marker in ipairs(MARKER_ORDER) do MARKER_PRIORITY[marker] = priority end

local function clear(values)
  for key in pairs(values) do values[key] = nil end
end

local function validMarker(marker)
  marker = tonumber(marker)
  return marker and marker >= 1 and marker <= 8 and marker % 1 == 0 and marker or nil
end

local function copyMarkers(values)
  if type(values) == "number" then values = { values } end
  local result, seen = {}, {}
  for _, value in ipairs(type(values) == "table" and values or {}) do
    local marker = validMarker(value)
    if marker and not seen[marker] then
      result[#result + 1], seen[marker] = marker, true
    end
  end
  return result
end

local function findById(values, id)
  if type(values) ~= "table" then return nil end
  if values[id] then return values[id] end
  for _, value in ipairs(values) do
    if type(value) == "table" and value.id == id then return value end
  end
end

local function parseNpcId(guid)
  if type(guid) ~= "string" then return nil end
  local kind = guid:match("^([^%-]+)")
  if kind ~= "Creature" and kind ~= "Vehicle" then return nil end
  local previous, last
  for component in guid:gmatch("[^%-]+") do previous, last = last, component end
  return tonumber(previous)
end

local Resolver = {}
Resolver.__index = Resolver

function Resolver.new(first, second)
  local dependencies = second or first or {}
  local self = setmetatable({
    dependencies = dependencies,
    profile = dependencies.profile or dependencies.marking or {},
    raid = dependencies.raid or dependencies.raidDefinition,
    routeSteps = dependencies.routeSteps,
    activeRouteStepId = nil,
    activeStep = nil,
    assignments = {},
    usedMarkers = {},
    spawnIndex = {},
  }, Resolver)

  for npcKey, enemy in pairs(self.raid and self.raid.enemies or {}) do
    for _, spawn in ipairs(type(enemy) == "table" and enemy.spawns or {}) do
      if type(spawn) == "table" and type(spawn.key) == "string" then
        self.spawnIndex[spawn.key] = spawn
        spawn.npcId = spawn.npcId or tonumber(npcKey)
      end
    end
  end
  for spawnKey, spawn in pairs(dependencies.spawns or {}) do self.spawnIndex[spawnKey] = spawn end
  return self
end

Resolver.New = Resolver.new

function Resolver:_findRouteStep(routeStepId)
  if type(self.dependencies.getRouteStep) == "function" then
    return self.dependencies.getRouteStep(routeStepId)
  end
  local routeSteps = self.routeSteps
  if not routeSteps and type(self.dependencies.routePreset) == "table" then
    routeSteps = self.dependencies.routePreset.routeSteps
  end
  return findById(routeSteps, routeStepId)
end

function Resolver:ActivateRouteStep(routeStepId)
  local step = self:_findRouteStep(routeStepId)
  self:ResetActivePack()
  if not step then
    self.activeRouteStepId, self.activeStep = nil, nil
    return false, "unknown-route-step"
  end
  self.activeRouteStepId, self.activeStep = routeStepId, step
  return true, step
end

function Resolver:ResetActivePack()
  clear(self.assignments)
  clear(self.usedMarkers)
end

function Resolver:OnUnitDeath(unitGuid)
  local assignment = unitGuid and self.assignments[unitGuid]
  if not assignment then return false end
  self.assignments[unitGuid] = nil
  if self.usedMarkers[assignment.marker] == unitGuid then self.usedMarkers[assignment.marker] = nil end
  return true
end

function Resolver:_unitInfo(unitToken)
  local dependencies, source = self.dependencies
  if type(unitToken) == "table" then
    source, unitToken = unitToken, unitToken.unitToken or unitToken.token
  elseif type(dependencies.getUnitInfo) == "function" then
    source = dependencies.getUnitInfo(unitToken)
  elseif type(dependencies.units) == "table" then
    source = dependencies.units[unitToken]
  end
  source = type(source) == "table" and source or {}

  local function get(name, fallback)
    if source[name] ~= nil then return source[name] end
    if type(fallback) == "function" then return fallback(unitToken) end
    return fallback
  end

  local info = {
    unitToken = unitToken,
    guid = get("guid", dependencies.getUnitGUID or rawget(_G, "UnitGUID")),
    npcId = get("npcId", source.id or dependencies.getNpcId),
    exists = source.exists,
    friendly = source.friendly,
    dead = source.dead,
    currentMarker = source.currentMarker,
  }
  info.guid = info.guid or unitToken
  info.npcId = tonumber(info.npcId) or parseNpcId(info.guid)
  return info
end

function Resolver:GetRuleForNpcId(npcId)
  npcId = tonumber(npcId)
  if not npcId then return {}, "none" end

  local pullMarkers, seen = {}, {}
  for spawnKey, value in pairs(self.activeStep and self.activeStep.marks or {}) do
    local spawn, marker = self.spawnIndex[spawnKey], validMarker(value)
    if spawn and tonumber(spawn.npcId) == npcId and marker and not seen[marker] then
      pullMarkers[#pullMarkers + 1], seen[marker] = marker, true
    end
  end
  if #pullMarkers > 0 then
    table.sort(pullMarkers, function(left, right)
      return MARKER_PRIORITY[left] < MARKER_PRIORITY[right]
    end)
    return pullMarkers, "pull"
  end

  local defaults = self.profile and self.profile.npcDefaults
  local globalMarkers = copyMarkers(type(defaults) == "table" and defaults[npcId] or nil)
  if #globalMarkers > 0 then return globalMarkers, "global" end
  return {}, "none"
end

function Resolver:_resolve(info, commit)
  local npcId = tonumber(info.npcId)
  if not npcId then return nil, { reason = "unknown-npc", info = info, candidates = {} } end

  local assignmentKey = info.guid or info.unitToken
  local assigned = assignmentKey and self.assignments[assignmentKey]
  if assigned then
    return assigned.marker, {
      marker = assigned.marker, source = assigned.source, guid = info.guid,
      npcId = npcId, candidates = copyMarkers(assigned.candidates), reused = true,
    }
  end

  local candidates, source = self:GetRuleForNpcId(npcId)
  if #candidates == 0 then
    return nil, { reason = "no-mark", source = source, info = info, npcId = npcId, candidates = candidates }
  end

  local markerAvailable = self.dependencies.markerAvailable
  local marker
  for _, candidate in ipairs(candidates) do
    local available = not self.usedMarkers[candidate]
    if available and type(markerAvailable) == "function" then
      available = markerAvailable(candidate, info.guid, info.unitToken) == true
    end
    if available then marker = candidate break end
  end
  if not marker then
    return nil, {
      reason = "slots-exhausted", source = source, info = info,
      npcId = npcId, candidates = candidates,
    }
  end

  local result = {
    marker = marker, source = source, guid = info.guid,
    npcId = npcId, candidates = copyMarkers(candidates),
  }
  if commit and assignmentKey then
    self.assignments[assignmentKey] = result
    self.usedMarkers[marker] = assignmentKey
  end
  return marker, result
end

function Resolver:ResolveUnit(unitToken)
  return self:_resolve(self:_unitInfo(unitToken), true)
end

function Resolver:GetPreviewForPack(packKey)
  local pack = self.raid and self.raid.packs and self.raid.packs[packKey]
  if type(pack) ~= "table" or type(pack.spawnKeys) ~= "table" then return {} end
  local preview = { packKey = packKey, entries = {}, markers = {} }
  for _, spawnKey in ipairs(pack.spawnKeys) do
    local spawn = self.spawnIndex[spawnKey] or {}
    local marker = validMarker(self.activeStep and self.activeStep.marks and self.activeStep.marks[spawnKey])
    local source = marker and "pull" or "none"
    if not marker then
      local rule
      rule, source = self:GetRuleForNpcId(spawn.npcId)
      if source == "global" then marker = rule[1] end
    end
    local entry = { spawnKey = spawnKey, npcId = tonumber(spawn.npcId), marker = marker, source = source }
    preview[#preview + 1] = entry
    preview.entries[#preview.entries + 1] = entry
    preview.markers[spawnKey], preview[spawnKey] = marker, entry
  end
  return preview
end

local singleton = MarkResolver._singleton or Resolver.new()
MarkResolver._singleton = singleton

function MarkResolver.new(dependencies) return Resolver.new(dependencies) end
function MarkResolver:Initialize(dependencies) self._singleton = Resolver.new(dependencies); return self._singleton end
function MarkResolver:ActivateRouteStep(routeStepId) return self._singleton:ActivateRouteStep(routeStepId) end
function MarkResolver:ResolveUnit(unitToken) return self._singleton:ResolveUnit(unitToken) end
function MarkResolver:ResetActivePack() return self._singleton:ResetActivePack() end
function MarkResolver:OnUnitDeath(unitGuid) return self._singleton:OnUnitDeath(unitGuid) end
function MarkResolver:GetPreviewForPack(packKey) return self._singleton:GetPreviewForPack(packKey) end
function MarkResolver:GetRuleForNpcId(npcId) return self._singleton:GetRuleForNpcId(npcId) end

ART.MarkResolverClass = Resolver
