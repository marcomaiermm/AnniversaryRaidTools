-- Enemy metadata boundary for AnniversaryRaidTools.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local Repository = ART.EnemyInfoRepository or {}
ART.EnemyInfoRepository = Repository
if addon and addon.EnemyInfoRepository == nil then addon.EnemyInfoRepository = Repository end

local type, tonumber, tostring = type, tonumber, tostring
local pairs = pairs

local SOURCES = {
  azerothcore = true,
  ["live-observed"] = true,
  manual = true,
  ["client-data"] = true,
  derived = true,
}

local CONFIDENCE = {
  verified = 4,
  high = 3,
  candidate = 2,
  ["review-required"] = 1,
}

local FIELD_NAMES = {
  name = true,
  level = true,
  creatureType = true,
  maxHealth = true,
}

local function copy(value, seen)
  if type(value) ~= "table" then return value end
  seen = seen or {}
  if seen[value] then return seen[value] end
  local result = {}
  seen[value] = result
  for key, item in pairs(value) do result[copy(key, seen)] = copy(item, seen) end
  return result
end

local function validRaidKey(raidKey)
  return type(raidKey) == "string" and raidKey ~= "" and raidKey:match("^[a-z0-9][a-z0-9%-]*$") ~= nil
end

local function validNpcId(npcId)
  npcId = tonumber(npcId)
  return npcId and npcId > 0 and npcId % 1 == 0 and npcId
end

local function utcTimestamp(value)
  if type(value) ~= "string" then return false end
  if value:sub(-6) == "+00:00" then value = value:sub(1, -7).."Z" end
  local year, month, day, hour, minute, second = value:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)T(%d%d):(%d%d):(%d%d)Z$")
  if not year then
    year, month, day, hour, minute, second = value:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)T(%d%d):(%d%d):(%d%d%.%d+)Z$")
  end
  year, month, day, hour, minute, second = tonumber(year), tonumber(month), tonumber(day), tonumber(hour), tonumber(minute), tonumber(second)
  if not year or year < 1 or month < 1 or month > 12 or hour > 23 or minute > 59 or second >= 60 then return false end
  local monthDays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
  if month == 2 and (year % 400 == 0 or (year % 4 == 0 and year % 100 ~= 0)) then monthDays[2] = 29 end
  return day >= 1 and day <= monthDays[month]
end

local function sourceOrNil(source)
  if type(source) ~= "table" then return nil, "invalid-provenance" end
  if not SOURCES[source.source] or not CONFIDENCE[source.confidence] then return nil, "invalid-provenance" end
  if source.source == "azerothcore" and (source.confidence == "high" or source.confidence == "verified") then
    return nil, "azerothcore-confidence"
  end
  if source.sourceRef ~= nil and type(source.sourceRef) ~= "string" then return nil, "invalid-provenance" end
  if source.observedAt ~= nil and not utcTimestamp(source.observedAt) then return nil, "invalid-observedAt" end
  return {
    source = source.source,
    confidence = source.confidence,
    sourceRef = source.sourceRef,
    observedAt = source.observedAt,
  }
end

local function resolveSource(primary, fallback)
  if primary ~= nil then return sourceOrNil(primary) end
  if fallback ~= nil then return sourceOrNil(fallback) end
  return nil
end

local function fact(value, fallbackSource)
  if value == nil then return end
  if type(value) == "table" and value.value ~= nil then
    local source, reason = resolveSource(value.source, fallbackSource)
    if not source then return nil, reason end
    return { value = copy(value.value), source = source }
  end
  local source, reason = resolveSource(nil, fallbackSource)
  if not source then return nil, reason end
  return { value = copy(value), source = source }
end

local function better(existing, candidate)
  if not existing then return candidate end
  local oldRank = CONFIDENCE[existing.source and existing.source.confidence] or 0
  local newRank = CONFIDENCE[candidate.source and candidate.source.confidence] or 0
  if newRank > oldRank then return candidate end
  if newRank < oldRank then return existing end

  -- Live/manual facts win ties, but the selected provenance is never rewritten.
  local oldSource = existing.source and existing.source.source
  local newSource = candidate.source and candidate.source.source
  if (newSource == "live-observed" or newSource == "manual") and oldSource ~= newSource then
    return candidate
  end
  return existing
end

local function normalizeSpell(spellId, raw, fallbackSource)
  if type(raw) ~= "table" then return nil, "malformed" end
  spellId = tonumber(raw.spellId or spellId)
  if not spellId or spellId <= 0 or spellId % 1 ~= 0 then return nil, "malformed" end
  local source, reason = resolveSource(raw.source, fallbackSource)
  if not source then return nil, reason end

  local result = {
    spellId = spellId,
    events = {},
    interruptible = raw.interruptible,
    source = source,
  }
  if type(raw.events) == "table" then
    for event, count in pairs(raw.events) do
      if type(event) == "string" and tonumber(count) and tonumber(count) >= 0 then
        result.events[event] = math.floor(tonumber(count))
      end
    end
  end
  if type(raw.latest) == "table" then result.latest = copy(raw.latest) end
  if type(raw.latestEvidence) == "table" and not result.latest then result.latest = copy(raw.latestEvidence) end
  return result
end

local function mergeEvents(destination, incoming)
  for event, count in pairs(incoming.events or {}) do
    destination.events[event] = math.max(destination.events[event] or 0, count)
  end
  if incoming.latest then destination.latest = copy(incoming.latest) end
end

local Instance = {}
Instance.__index = Instance

function Instance:_diagnose(kind)
  local diagnostics = self.diagnostics
  diagnostics.total = math.min(self.maxDiagnostics, diagnostics.total + 1)
  diagnostics[kind] = math.min(self.maxDiagnostics, (diagnostics[kind] or 0) + 1)
end

function Instance:_mergeEnemy(raidKey, npcId, raw, defaultSource)
  if type(raw) ~= "table" then self:_diagnose("malformed") return false, "malformed" end
  local enemySource, sourceReason = resolveSource(raw.source, defaultSource)
  if not enemySource and (raw.source ~= nil or defaultSource ~= nil) then
    self:_diagnose(sourceReason or "invalid-provenance")
    return false, sourceReason or "invalid-provenance"
  end
  for field in pairs(FIELD_NAMES) do
    if raw[field] ~= nil then
      local candidate, factReason = fact(raw[field], enemySource)
      if not candidate then
        self:_diagnose(factReason or "invalid-provenance")
        return false, factReason or "invalid-provenance"
      end
    end
  end
  if type(raw.spells) == "table" then
    for spellId, rawSpell in pairs(raw.spells) do
      local incoming, spellReason = normalizeSpell(spellId, rawSpell, enemySource)
      if not incoming then
        self:_diagnose(spellReason or "malformed")
        return false, spellReason or "malformed"
      end
    end
  end
  local enemies = self.facts[raidKey]
  local enemy = enemies[npcId] or { raidKey = raidKey, npcId = npcId, spells = {} }
  enemies[npcId] = enemy

  for field in pairs(FIELD_NAMES) do
    local candidate, factReason = fact(raw[field], enemySource)
    if candidate then enemy[field] = better(enemy[field], candidate) end
    if not candidate and factReason then self:_diagnose(factReason) end
  end

  if type(raw.events) == "table" then
    enemy.events = enemy.events or {}
    for event, count in pairs(raw.events) do
      if type(event) == "string" and tonumber(count) and tonumber(count) >= 0 then
        enemy.events[event] = math.max(enemy.events[event] or 0, math.floor(tonumber(count)))
      end
    end
  end
  if raw.latest then enemy.latest = copy(raw.latest) end

  if type(raw.spells) == "table" then
    for spellId, rawSpell in pairs(raw.spells) do
      local incoming, spellReason = normalizeSpell(spellId, rawSpell, enemySource)
      if incoming then
        local current = enemy.spells[incoming.spellId]
        if not current then
          enemy.spells[incoming.spellId] = incoming
        else
          current.source = better({ value = true, source = current.source }, { value = true, source = incoming.source }).source
          current.interruptible = incoming.interruptible ~= nil and incoming.interruptible or current.interruptible
          mergeEvents(current, incoming)
          if incoming.latest then current.latestEvidence = current.latest end
        end
      else
        self:_diagnose(spellReason or "malformed")
      end
    end
  end
  return true, enemy
end

function Instance:_mergeRaid(raidKey, raw, defaultSource)
  if not validRaidKey(raidKey) or type(raw) ~= "table" then
    self:_diagnose("malformed")
    return false, "malformed"
  end
  if type(raw.enemies) ~= "table" then
    self:_diagnose("malformed")
    return false, "malformed"
  end
  local raidSource, sourceReason = resolveSource(raw.source, defaultSource)
  if not raidSource and (raw.source ~= nil or defaultSource ~= nil) then
    self:_diagnose(sourceReason or "invalid-provenance")
    return false, sourceReason or "invalid-provenance"
  end
  self.facts[raidKey] = self.facts[raidKey] or {}
  for npcId, enemy in pairs(raw.enemies) do
    npcId = validNpcId(npcId)
    if npcId then
      self:_mergeEnemy(raidKey, npcId, enemy, raidSource)
    else
      self:_diagnose("malformed")
    end
  end
  return true
end

function Instance:Merge(source, sourceRef)
  if type(source) ~= "table" then self:_diagnose("malformed") return false, "malformed" end
  local defaultSource = source.source or sourceRef
  if source.raidKey then return self:_mergeRaid(source.raidKey, source, defaultSource) end

  local merged = false
  for raidKey, raid in pairs(source) do
    if type(raid) == "table" and raid.enemies then
      local ok = self:_mergeRaid(raid.raidKey or raidKey, raid, defaultSource)
      merged = merged or ok == true
    end
  end
  if not merged then self:_diagnose("malformed") end
  return merged
end

function Instance:MergeObservation(raidKey, npcId, observation)
  npcId = validNpcId(npcId)
  if not validRaidKey(raidKey) or not npcId or type(observation) ~= "table" then
    self:_diagnose("malformed")
    return false, "malformed"
  end
  return self:_mergeEnemy(raidKey, npcId, observation, observation.source)
end

function Instance:Get(raidKey, npcId)
  npcId = validNpcId(npcId)
  if not validRaidKey(raidKey) or not npcId then
    self:_diagnose("malformed")
    return nil, "malformed"
  end
  local enemy = self.facts[raidKey] and self.facts[raidKey][npcId]
  if not enemy then
    self:_diagnose("unknown")
    return nil, "unknown"
  end
  return copy(enemy)
end

Instance.Lookup = Instance.Get
Instance.GetEnemyInfo = Instance.Get

function Instance:GetDiagnostics()
  return copy(self.diagnostics)
end

function Instance:Initialize(dependencies)
  if self.initialized then return self end
  dependencies = dependencies or {}
  self.initialized = true
  if dependencies.data then self:Merge(dependencies.data) end
  if dependencies.sources then self:Merge(dependencies.sources) end
  return self
end

function Repository.new(dependencies)
  dependencies = dependencies or {}
  local instance = setmetatable({
    facts = {},
    diagnostics = { total = 0, malformed = 0, unknown = 0 },
    maxDiagnostics = tonumber(dependencies.maxDiagnostics) or 64,
  }, Instance)
  instance:Initialize(dependencies)
  return instance
end

Repository.New = Repository.new
Repository.Instance = Instance

return Repository
