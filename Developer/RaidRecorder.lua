-- Made by Nnoggie, 2017-2025
-- Bounded combat-log observation recorder. It has no UI or registration side effects.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local RecorderAPI = ART.RaidRecorder or {}
ART.RaidRecorder = RecorderAPI
if addon and addon.RaidRecorder == nil then addon.RaidRecorder = RecorderAPI end

local type, tonumber, tostring = type, tonumber, tostring
local pairs, select = pairs, select

local EVENT_ALIASES = {
  SPELL_CAST_START = "SPELL_CAST_START",
  CAST_START = "SPELL_CAST_START",
  ["cast-start"] = "SPELL_CAST_START",
  SPELL_CAST_SUCCESS = "SPELL_CAST_SUCCESS",
  CAST_SUCCESS = "SPELL_CAST_SUCCESS",
  ["cast-success"] = "SPELL_CAST_SUCCESS",
  SPELL_AURA_APPLIED = "SPELL_AURA_APPLIED",
  AURA_APPLIED = "SPELL_AURA_APPLIED",
  ["aura-applied"] = "SPELL_AURA_APPLIED",
  SPELL_AURA_REMOVED = "SPELL_AURA_REMOVED",
  AURA_REMOVED = "SPELL_AURA_REMOVED",
  ["aura-removed"] = "SPELL_AURA_REMOVED",
  SPELL_INTERRUPT = "SPELL_INTERRUPT",
  INTERRUPT = "SPELL_INTERRUPT",
  interrupt = "SPELL_INTERRUPT",
  SPELL_DISPEL = "SPELL_DISPEL",
  DISPEL = "SPELL_DISPEL",
  dispel = "SPELL_DISPEL",
  UNIT_DIED = "UNIT_DIED",
  DEATH = "UNIT_DIED",
  death = "UNIT_DIED",
  PARTY_KILL = "PARTY_KILL",
  KILL = "PARTY_KILL",
  kill = "PARTY_KILL",
}

local SPELL_EVENTS = {
  SPELL_CAST_START = true,
  SPELL_CAST_SUCCESS = true,
  SPELL_AURA_APPLIED = true,
  SPELL_AURA_REMOVED = true,
  SPELL_INTERRUPT = true,
  SPELL_DISPEL = true,
}

local DESTINATION_EVENTS = {
  SPELL_INTERRUPT = true,
  SPELL_DISPEL = true,
  UNIT_DIED = true,
  PARTY_KILL = true,
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

local function validSpellId(spellId)
  spellId = tonumber(spellId)
  return spellId and spellId > 0 and spellId % 1 == 0 and spellId
end

local function npcIdFromGuid(guid)
  if type(guid) ~= "string" then return end
  local kind, components = guid:match("^([%a]+)%-(.*)$")
  if kind ~= "Creature" and kind ~= "Vehicle" then return end
  components = components or ""
  local values = {}
  for component in components:gmatch("[^%-]+") do values[#values + 1] = component end
  if #values < 2 then return end
  return validNpcId(values[#values - 1])
end

local function utcNow(dependencies)
  local now = dependencies.utcNow or dependencies.now
  if type(now) == "function" then
    local ok, value = pcall(now)
    if ok and value ~= nil then
      if type(value) == "string" then return value end
      local os = rawget(_G, "os")
      if os and os.date then return os.date("!%Y-%m-%dT%H:%M:%SZ", value) end
    end
  end
  local date = rawget(_G, "date")
  if type(date) == "function" then return date("!%Y-%m-%dT%H:%M:%SZ") end
  local os = rawget(_G, "os")
  if os and os.date then return os.date("!%Y-%m-%dT%H:%M:%SZ") end
  return "1970-01-01T00:00:00Z"
end

local Instance = {}
Instance.__index = Instance

function Instance:_diagnose(kind)
  local diagnostics = self.diagnostics
  diagnostics.total = math.min(self.maxDiagnostics, diagnostics.total + 1)
  diagnostics[kind] = math.min(self.maxDiagnostics, (diagnostics[kind] or 0) + 1)
  self.stats.ignored = self.stats.ignored + 1
end

function Instance:_seen(signature)
  return self.seen[signature] == true
end

function Instance:_remember(signature)
  self.seen[signature] = true
  self.seenOrder[#self.seenOrder + 1] = signature
  if #self.seenOrder > self.maxSeen then
    self.seen[self.seenOrder[1]] = nil
    table.remove(self.seenOrder, 1)
  end
end

function Instance:_raidKey(event)
  if event.raidKey ~= nil then return event.raidKey end
  if type(self.dependencies.getRaidKey) == "function" then
    local ok, raidKey = pcall(self.dependencies.getRaidKey, event)
    if ok then return raidKey end
  end
  return self.dependencies.raidKey
end

function Instance:_npcId(event, guid)
  local explicit = validNpcId(event.npcId)
  local parsed = npcIdFromGuid(guid)
  if guid and not parsed then return nil, "malformed-guid" end
  if explicit and parsed and explicit ~= parsed then return nil, "npc-mismatch" end
  if explicit then return explicit end
  if parsed then return parsed end
  if type(self.dependencies.getNpcId) == "function" then
    local ok, npcId = pcall(self.dependencies.getNpcId, guid, event)
    if ok then return validNpcId(npcId) end
  end
end

function Instance:_observation(event)
  local subevent = EVENT_ALIASES[event.subevent or event.event or event.eventType]
  if not subevent then return nil, "unknown-event" end
  local guid
  if event.guid then
    guid = event.guid
  elseif DESTINATION_EVENTS[subevent] then
    guid = event.destGUID or event.unitGuid
  elseif (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REMOVED") and npcIdFromGuid(event.destGUID) then
    -- Aura events can describe a player applying an aura to an enemy.
    guid = event.destGUID
  else
    guid = event.sourceGUID or event.unitGuid
  end
  local npcId, npcError = self:_npcId(event, guid)
  if not npcId then return nil, npcError or "malformed-guid" end

  local raidKey = self:_raidKey(event)
  if not validRaidKey(raidKey) then return nil, "unknown-raid" end
  local spellId = validSpellId(event.spellId)
  if SPELL_EVENTS[subevent] and not spellId then return nil, "malformed-spell" end

  local observedAt = event.observedAt or utcNow(self.dependencies)
  local sourceRef = event.sourceRef or self.dependencies.sourceRef or "combat-log"
  local source = {
    source = "live-observed",
    confidence = "verified",
    sourceRef = sourceRef,
    observedAt = observedAt,
  }
  local identity = table.concat({
    raidKey,
    tostring(npcId),
    subevent,
    tostring(spellId or ""),
    tostring(event.sourceGUID or ""),
    tostring(event.destGUID or event.guid or ""),
    tostring(event.timestamp or event.sequence or ""),
  }, "|")
  return {
    raidKey = raidKey,
    npcId = npcId,
    spellId = spellId,
    event = subevent,
    guid = guid,
    timestamp = event.timestamp,
    source = source,
    sourceRef = sourceRef,
    observedAt = observedAt,
    interruptible = event.interruptible,
    identity = identity,
  }
end

function Instance:_store(observation)
  local byRaid = self.observations[observation.raidKey]
  if not byRaid then
    if self.enemyCount >= self.maxEnemies then self:_diagnose("bounded") return false, "bounded" end
    byRaid = {}
    self.observations[observation.raidKey] = byRaid
    self.enemyCount = self.enemyCount + 1
  end
  local enemy = byRaid[observation.npcId]
  if not enemy then
    if self.npcCount >= self.maxNpcs then self:_diagnose("bounded") return false, "bounded" end
    enemy = { raidKey = observation.raidKey, npcId = observation.npcId, spells = {}, events = {} }
    byRaid[observation.npcId] = enemy
    self.npcCount = self.npcCount + 1
  end

  local spell = observation.spellId and enemy.spells[observation.spellId]
  if observation.spellId and not spell then
    local count = 0
    for _ in pairs(enemy.spells) do count = count + 1 end
    if count >= self.maxSpells then
      self:_diagnose("bounded")
      return false, "bounded"
    end
  end

  local event = observation.event
  enemy.events[event] = math.min(self.maxCount, (enemy.events[event] or 0) + 1)
  enemy.latest = {
    event = event,
    spellId = observation.spellId,
    guid = observation.guid,
    source = copy(observation.source),
  }
  if observation.spellId then
    if not spell then
      spell = {
        spellId = observation.spellId,
        events = {},
        interruptible = observation.interruptible,
        source = copy(observation.source),
      }
      enemy.spells[observation.spellId] = spell
    end
    spell.events[event] = math.min(self.maxCount, (spell.events[event] or 0) + 1)
    if observation.interruptible ~= nil then spell.interruptible = observation.interruptible end
    spell.source = copy(observation.source)
    spell.latest = {
      event = event,
      observedAt = observation.observedAt,
      timestamp = observation.timestamp,
      guid = observation.guid,
      source = copy(observation.source),
    }
    spell.latestEvidence = spell.latest
  end
  return true, enemy
end

function Instance:RecordEvent(event, data, ...)
  if type(event) ~= "table" then
    if type(data) == "table" then
      local subevent = event
      event = copy(data)
      event.subevent = event.subevent or event.event or event.eventType or subevent
    else
      event = {
        subevent = event,
        raidKey = data,
        npcId = select(1, ...),
        spellId = select(2, ...),
        guid = select(3, ...),
        timestamp = select(4, ...),
      }
    end
  end
  local observation, reason = self:_observation(event)
  if not observation then self:_diagnose(reason or "malformed") return false, reason end
  if self:_seen(observation.identity) then
    self.stats.duplicates = self.stats.duplicates + 1
    return false, "duplicate"
  end
  local ok, result, storeReason = pcall(self._store, self, observation)
  if not ok then
    self.stats.failures = self.stats.failures + 1
    self:_diagnose("failure")
    return false, "failure"
  end
  if not result then return false, storeReason or result end
  self:_remember(observation.identity)
  self.stats.accepted = self.stats.accepted + 1

  if self.repository and type(self.repository.MergeObservation) == "function" then
    local merged, mergeError = pcall(self.repository.MergeObservation, self.repository,
      observation.raidKey, observation.npcId, self.observations[observation.raidKey][observation.npcId])
    if not merged then
      self.stats.failures = self.stats.failures + 1
      -- A recorder failure must never reach the planner or raid registration.
    elseif mergeError == false then
      self.stats.failures = self.stats.failures + 1
    end
  end
  return true, copy(observation)
end

function Instance:OnCombatLogEvent(...)
  local first = select(1, ...)
  if type(first) == "table" then return self:RecordEvent(first) end
  local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
      destGUID, destName, destFlags, destRaidFlags, spellId = ...
  if type(subevent) ~= "string" then
    return false, "unknown-event"
  end
  return self:RecordEvent({
    timestamp = timestamp,
    subevent = subevent,
    sourceGUID = sourceGUID,
    sourceName = sourceName,
    sourceFlags = sourceFlags,
    sourceRaidFlags = sourceRaidFlags,
    destGUID = destGUID,
    destName = destName,
    destFlags = destFlags,
    destRaidFlags = destRaidFlags,
    spellId = spellId,
  })
end

Instance.Record = Instance.RecordEvent
Instance.HandleEvent = Instance.OnCombatLogEvent

function Instance:Get(raidKey, npcId)
  local enemy = self.observations[raidKey] and self.observations[raidKey][validNpcId(npcId)]
  return enemy and copy(enemy)
end

Instance.GetObservations = Instance.Get

function Instance:GetDiagnostics()
  return copy(self.diagnostics)
end

function Instance:GetStats()
  return copy(self.stats)
end

function RecorderAPI.new(dependencies)
  dependencies = dependencies or {}
  return setmetatable({
    dependencies = dependencies,
    repository = dependencies.repository,
    observations = {},
    seen = {},
    seenOrder = {},
    diagnostics = { total = 0 },
    stats = { accepted = 0, duplicates = 0, ignored = 0, failures = 0 },
    maxCount = math.max(1, tonumber(dependencies.maxCount) or 100),
    maxSpells = math.max(1, tonumber(dependencies.maxSpells) or 128),
    maxSeen = math.max(1, tonumber(dependencies.maxSeen) or 1024),
    maxEnemies = math.max(1, tonumber(dependencies.maxEnemies) or 64),
    maxNpcs = math.max(1, tonumber(dependencies.maxNpcs) or 256),
    maxDiagnostics = math.max(1, tonumber(dependencies.maxDiagnostics) or 64),
    enemyCount = 0,
    npcCount = 0,
  }, Instance)
end

RecorderAPI.New = RecorderAPI.new
RecorderAPI.Instance = Instance
RecorderAPI.Events = copy(EVENT_ALIASES)
RecorderAPI.ParseNpcId = npcIdFromGuid

return RecorderAPI
