-- Made by Nnoggie, 2017-2025
-- AnniversaryRaidTools mark resolution is deliberately independent from the WoW UI.

local _, addon = ...

local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local MarkResolver = ART.MarkResolver or {}
ART.MarkResolver = MarkResolver
if addon and addon.MarkResolver == nil then addon.MarkResolver = MarkResolver end

local type, tonumber, tostring = type, tonumber, tostring
local ipairs, pairs = ipairs, pairs

local function clear(tableValue)
  for key in pairs(tableValue) do tableValue[key] = nil end
end

local function copyArray(values)
  local copy = {}
  if type(values) == "number" then values = { values } end
  if type(values) ~= "table" then return copy end
  for index, value in ipairs(values) do copy[index] = value end
  return copy
end

local function validMarker(marker)
  marker = tonumber(marker)
  return marker and marker >= 1 and marker <= 8 and marker % 1 == 0 and marker
end

local function addPackKey(packKeys, seen, packKey)
  if type(packKey) == "string" and not seen[packKey] then
    packKeys[#packKeys + 1] = packKey
    seen[packKey] = true
  end
end

local function findById(values, id)
  if type(values) ~= "table" then return end
  if values[id] then return values[id] end
  for _, value in ipairs(values) do
    if type(value) == "table" and value.id == id then return value end
  end
end

local function parseNpcId(guid)
  if type(guid) ~= "string" then return end
  -- Some clients expose the NPC id in the second-to-last GUID component.
  local previous, last
  for component in guid:gmatch("[^%-]+") do
    previous, last = last, component
  end
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
    activePackKeys = {},
    assignments = {},
    usedMarkers = {},
    spawnIndex = {},
  }, Resolver)

  local raid = self.raid
  if type(raid) == "table" and type(raid.enemies) == "table" then
    for npcKey, enemy in pairs(raid.enemies) do
      if type(enemy) == "table" and type(enemy.spawns) == "table" then
        for _, spawn in ipairs(enemy.spawns) do
          if type(spawn) == "table" and type(spawn.key) == "string" then
            self.spawnIndex[spawn.key] = spawn
            self.spawnIndex[spawn.key].npcId = self.spawnIndex[spawn.key].npcId or tonumber(npcKey)
          end
        end
      end
    end
  end
  if type(dependencies.spawns) == "table" then
    for spawnKey, spawn in pairs(dependencies.spawns) do self.spawnIndex[spawnKey] = spawn end
  end

  return self
end

Resolver.New = Resolver.new

function Resolver:_findRouteStep(routeStepId)
  local dependencies = self.dependencies
  if type(dependencies.getRouteStep) == "function" then
    return dependencies.getRouteStep(routeStepId)
  end
  local routeSteps = self.routeSteps
  if not routeSteps and type(dependencies.routePreset) == "table" then
    routeSteps = dependencies.routePreset.routeSteps
  end
  return findById(routeSteps, routeStepId)
end

function Resolver:_getSpawn(spawnKey)
  if type(spawnKey) ~= "string" then return end
  if type(self.dependencies.getSpawn) == "function" then
    return self.dependencies.getSpawn(spawnKey)
  end
  return self.spawnIndex[spawnKey]
end

function Resolver:_getPack(packKey)
  if type(self.dependencies.getPack) == "function" then
    return self.dependencies.getPack(packKey)
  end
  return (self.raid and self.raid.packs and self.raid.packs[packKey]) or (self.dependencies.packs and self.dependencies.packs[packKey])
end

function Resolver:_getActivePackKeys(step)
  local packKeys, seen = {}, {}
  if type(step) ~= "table" then return packKeys end
  if type(step.packKeys) == "table" then
    for _, packKey in ipairs(step.packKeys) do addPackKey(packKeys, seen, packKey) end
  end
  addPackKey(packKeys, seen, step.packKey)
  return packKeys
end

function Resolver:ActivateRouteStep(routeStepId)
  local step = self:_findRouteStep(routeStepId)
  if not step then
    self.activeRouteStepId, self.activeStep = nil, nil
    clear(self.activePackKeys)
    self:ResetActivePack()
    return false, "unknown-route-step"
  end

  self.activeRouteStepId = routeStepId
  self.activeStep = step
  clear(self.activePackKeys)
  local packKeys = self:_getActivePackKeys(step)
  for index, packKey in ipairs(packKeys) do self.activePackKeys[index] = packKey end
  self:ResetActivePack()
  return true, step
end

function Resolver:ResetActivePack()
  clear(self.assignments)
  clear(self.usedMarkers)
end

function Resolver:OnUnitDeath(unitGuid)
  if unitGuid == nil then return false end
  local assignment = self.assignments[unitGuid]
  if not assignment then return false end
  self.assignments[unitGuid] = nil
  if assignment.marker then self.usedMarkers[assignment.marker] = nil end
  return true
end

function Resolver:_unitInfo(unitToken)
  local dependencies = self.dependencies
  local info
  if type(unitToken) == "table" then
    info = unitToken
    unitToken = info.unitToken or info.token
  elseif type(dependencies.getUnitInfo) == "function" then
    info = dependencies.getUnitInfo(unitToken)
  elseif type(dependencies.resolveUnit) == "function" then
    info = dependencies.resolveUnit(unitToken)
  elseif type(dependencies.units) == "table" then
    info = dependencies.units[unitToken]
  end
  if type(info) ~= "table" then info = {} end

  local get = function(name, fallback)
    if info[name] ~= nil then return info[name] end
    if type(fallback) == "function" then return fallback(unitToken) end
    return fallback
  end

  info = {
    unitToken = unitToken,
    guid = get("guid", dependencies.getUnitGUID or rawget(_G, "UnitGUID")),
    npcId = get("npcId", info.id or dependencies.getNpcId),
    spawnKey = get("spawnKey", dependencies.getSpawnKey),
    packKey = get("packKey", dependencies.getPackKey),
    exists = info.exists,
    friendly = info.friendly,
    dead = info.dead,
    currentMarker = info.currentMarker,
  }
  info.guid = info.guid or unitToken
  info.npcId = tonumber(info.npcId) or parseNpcId(info.guid)
  if info.spawnKey == nil and type(dependencies.getSpawnKeyForGuid) == "function" then
    info.spawnKey = dependencies.getSpawnKeyForGuid(info.guid, unitToken)
  end
  if info.packKey == nil and type(dependencies.getPackKeyForSpawn) == "function" then
    info.packKey = dependencies.getPackKeyForSpawn(info.spawnKey)
  end
  return info
end

function Resolver:_unitExists(info)
  if info.exists ~= nil then return info.exists == true end
  if type(self.dependencies.unitExists) == "function" then return self.dependencies.unitExists(info.unitToken) == true end
  local UnitExists = rawget(_G, "UnitExists")
  return not UnitExists or UnitExists(info.unitToken) == true
end

function Resolver:_unitFriendly(info)
  if info.friendly ~= nil then return info.friendly == true end
  if type(self.dependencies.unitFriendly) == "function" then return self.dependencies.unitFriendly(info.unitToken) == true end
  local UnitCanAttack = rawget(_G, "UnitCanAttack")
  if UnitCanAttack then return not UnitCanAttack("player", info.unitToken) end
  return false
end

function Resolver:_unitDead(info)
  if info.dead ~= nil then return info.dead == true end
  if type(self.dependencies.unitDead) == "function" then return self.dependencies.unitDead(info.unitToken) == true end
  local UnitIsDeadOrGhost = rawget(_G, "UnitIsDeadOrGhost")
  if UnitIsDeadOrGhost then return UnitIsDeadOrGhost(info.unitToken) == true end
  local UnitIsDead = rawget(_G, "UnitIsDead")
  return UnitIsDead and UnitIsDead(info.unitToken) == true or false
end

function Resolver:_currentMarker(info)
  if info.currentMarker ~= nil then return tonumber(info.currentMarker) or 0 end
  if type(self.dependencies.getRaidTargetIndex) == "function" then
    return tonumber(self.dependencies.getRaidTargetIndex(info.unitToken)) or 0
  end
  local GetRaidTargetIndex = rawget(_G, "GetRaidTargetIndex")
  return GetRaidTargetIndex and (tonumber(GetRaidTargetIndex(info.unitToken)) or 0) or 0
end

function Resolver:_packContainsSpawn(packKey, spawnKey)
  local pack = self:_getPack(packKey)
  if type(pack) ~= "table" or type(pack.spawnKeys) ~= "table" then return false end
  for _, key in ipairs(pack.spawnKeys) do
    if key == spawnKey then return true end
  end
  return false
end

function Resolver:_findPack(info)
  local active = self.activePackKeys
  if info.packKey then
    for _, packKey in ipairs(active) do
      if packKey == info.packKey then return packKey end
    end
  end
  if info.spawnKey then
    for _, packKey in ipairs(active) do
      if self:_packContainsSpawn(packKey, info.spawnKey) then return packKey end
    end
    local spawn = self:_getSpawn(info.spawnKey)
    if spawn and spawn.packKey then
      for _, packKey in ipairs(active) do
        if packKey == spawn.packKey then return packKey end
      end
      local fallback = self.dependencies.getSpawnMarker
      if self.dependencies.allowOutsideActiveStep and type(fallback) == "function"
          and validMarker(fallback(info.spawnKey)) then
        return spawn.packKey
      end
    end
  end
  -- A unit with a known but unmatched stable key is outside the active step;
  -- only keyless test/API inputs may use the single-pack fallback.
  if #active == 1 and not info.packKey and not info.spawnKey then return active[1] end
end

function Resolver:_specificMarker(step, packKey, spawnKey)
  if type(step) == "table" and type(step.marks) == "table" then
    local marker = validMarker(step.marks[spawnKey])
    if marker then return marker, "route-step-spawn" end
  end
  local global = self.dependencies.getSpawnMarker
  if type(global) == "function" then
    local marker = validMarker(global(spawnKey))
    if marker then return marker, "preset-spawn" end
  end
  local override = self.profile.packOverrides and self.profile.packOverrides[packKey]
  if type(override) == "table" and type(override.spawns) == "table" then
    local marker = validMarker(override.spawns[spawnKey])
    if marker then return marker, "pack-spawn" end
  end
end

function Resolver:_markerRule(packKey, npcId)
  local override = self.profile.packOverrides and self.profile.packOverrides[packKey]
  if type(override) == "table" and type(override.npcDefaults) == "table" and override.npcDefaults[npcId] ~= nil then
    return copyArray(override.npcDefaults[npcId]), "pack-npc"
  end
  local defaults = self.profile.npcDefaults
  if type(defaults) == "table" and defaults[npcId] ~= nil then
    return copyArray(defaults[npcId]), "preset-npc"
  end
  return {}, "none"
end

function Resolver:_resolve(info, commit)
  if not self.activeStep then return nil, { reason = "outside-active-step", info = info } end
  local packKey = self:_findPack(info)
  if not packKey then return nil, { reason = "outside-active-step", info = info } end
  local spawnKey = info.spawnKey
  local spawn = self:_getSpawn(spawnKey)
  local npcId = tonumber(info.npcId) or (spawn and tonumber(spawn.npcId))
  if not npcId then return nil, { reason = "unknown-npc", info = info, packKey = packKey } end

  local assignmentKey = info.guid or info.unitToken
  if assignmentKey and self.assignments[assignmentKey] then
    local assignment = self.assignments[assignmentKey]
    return assignment.marker, {
      marker = assignment.marker,
      source = assignment.source,
      guid = info.guid,
      npcId = npcId,
      spawnKey = spawnKey,
      packKey = assignment.packKey or packKey,
      reused = true,
    }
  end

  local marker, source = self:_specificMarker(self.activeStep, packKey, spawnKey)
  if marker then
    if self.usedMarkers[marker] then
      return nil, { reason = "slots-exhausted", source = source, info = info, packKey = packKey, npcId = npcId }
    end
  else
    local rule, hasCandidate = nil, false
    rule, source = self:_markerRule(packKey, npcId)
    for _, candidate in ipairs(rule) do
      candidate = validMarker(candidate)
      if candidate then
        hasCandidate = true
        if not self.usedMarkers[candidate] then
          marker = candidate
          break
        end
      end
    end
    if not marker and not hasCandidate then
      return nil, { reason = "no-mark", source = source, info = info, packKey = packKey, npcId = npcId }
    end
  end
  if not marker then
    return nil, { reason = "slots-exhausted", source = source, info = info, packKey = packKey, npcId = npcId }
  end

  local result = {
    marker = marker,
    source = source,
    guid = info.guid,
    npcId = npcId,
    spawnKey = spawnKey,
    packKey = packKey,
  }
  if commit and assignmentKey then
    self.assignments[assignmentKey] = result
    self.usedMarkers[marker] = assignmentKey
  end
  return marker, result
end

function Resolver:ResolveUnit(unitToken)
  local info = self:_unitInfo(unitToken)
  return self:_resolve(info, true)
end

function Resolver:ApplyUnit(unitToken)
  if unitToken == nil then return false, "missing", { reason = "missing" } end
  local info = self:_unitInfo(unitToken)
  if not self:_unitExists(info) then return false, "missing", { info = info } end
  if self:_unitFriendly(info) then return false, "friendly", { info = info } end
  if self:_unitDead(info) then return false, "dead", { info = info } end
  if not self.activeStep or not self:_findPack(info) then return false, "outside-active-step", { info = info } end

  local dependencies = self.dependencies
  if dependencies.canMark == false or (type(dependencies.canMark) == "function" and not dependencies.canMark(info.unitToken)) then
    return false, "permission", { info = info }
  end
  if dependencies.inCombat == true or (type(dependencies.inCombat) == "function" and dependencies.inCombat()) then
    return false, "combat", { info = info }
  end
  if dependencies.apiAllowsMarking == false or (type(dependencies.apiAllowsMarking) == "function" and not dependencies.apiAllowsMarking(info.unitToken)) then
    return false, "api-forbidden", { info = info }
  end

  local preserve = dependencies.preserveExistingMarkers
  if preserve == nil and type(dependencies.settings) == "table" then preserve = dependencies.settings.preserveExistingTargetMarkers end
  local currentMarker = self:_currentMarker(info)
  if preserve ~= false and currentMarker > 0 then
    return false, "existing-marker", { info = info, marker = currentMarker }
  end

  local marker, result = self:_resolve(info, true)
  if not marker then return false, result and result.reason or "no-mark", result end

  local setRaidTarget = dependencies.setRaidTarget or rawget(_G, "SetRaidTarget")
  if type(setRaidTarget) ~= "function" then
    self:OnUnitDeath(info.guid or info.unitToken)
    return false, "api-forbidden", result
  end
  local ok = setRaidTarget(info.unitToken, marker)
  if ok == false then
    self:OnUnitDeath(info.guid or info.unitToken)
    return false, "api-failed", result
  end
  return true, marker, result
end

function Resolver:GetPreviewForPack(packKey)
  local pack = self:_getPack(packKey)
  if type(pack) ~= "table" or type(pack.spawnKeys) ~= "table" then return {} end
  local preview, used = { packKey = packKey, entries = {}, markers = {} }, {}
  local step = self.activeStep
  for _, spawnKey in ipairs(pack.spawnKeys) do
    local spawn = self:_getSpawn(spawnKey) or {}
    local npcId = tonumber(spawn.npcId)
    local marker, source = self:_specificMarker(step, packKey, spawnKey)
    if marker and used[marker] then
      marker = nil
    elseif not marker then
      local rule
      rule, source = self:_markerRule(packKey, npcId)
      for _, candidate in ipairs(rule) do
        candidate = validMarker(candidate)
        if candidate and not used[candidate] then marker = candidate break end
      end
    end
    if marker and not used[marker] then used[marker] = true end
    local entry = { spawnKey = spawnKey, npcId = npcId, marker = marker, source = source }
    preview[#preview + 1] = entry
    preview.entries[#preview.entries + 1] = entry
    preview.markers[spawnKey] = marker
    preview[spawnKey] = entry
  end
  return preview
end

-- Keep one contract-shaped facade for callers that do not need their own state.
local singleton = MarkResolver._singleton
if not singleton then
  singleton = Resolver.new()
  MarkResolver._singleton = singleton
end

function MarkResolver.new(first, second) return Resolver.new(second or first) end
MarkResolver.New = MarkResolver.new
function MarkResolver:Initialize(dependencies)
  self._singleton = Resolver.new(dependencies)
  return self._singleton
end
function MarkResolver:ActivateRouteStep(routeStepId) return self._singleton:ActivateRouteStep(routeStepId) end
function MarkResolver:ResolveUnit(unitToken) return self._singleton:ResolveUnit(unitToken) end
function MarkResolver:ApplyUnit(unitToken) return self._singleton:ApplyUnit(unitToken) end
function MarkResolver:ResetActivePack() return self._singleton:ResetActivePack() end
function MarkResolver:OnUnitDeath(unitGuid) return self._singleton:OnUnitDeath(unitGuid) end
function MarkResolver:GetPreviewForPack(packKey) return self._singleton:GetPreviewForPack(packKey) end

ART.MarkResolverClass = Resolver
