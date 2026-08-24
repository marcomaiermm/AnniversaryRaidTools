-- Pure exact-spawn and allocation-pool pull progress.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local PullProgress = ART.PullProgress or {}
ART.PullProgress = PullProgress

local State = {}
State.__index = State

local function contains(values, expected)
  for _, value in ipairs(values or {}) do
    if value == expected then return true end
  end
  return false
end

function State:Reset()
  self.bindings = {}
  self.guidBySpawn = {}
  self.deadExact = {}
  self.pools = {}
  self.poolBySpawn = {}
end

local function forgetBinding(self, guid)
  local binding = self.bindings[guid]
  if binding and binding.kind == "exact" and self.guidBySpawn[binding.spawnKey] == guid then
    self.guidBySpawn[binding.spawnKey] = nil
  end
end

local function addPool(self, match)
  local key = match.allocationKey
  local pool = self.pools[key]
  if not pool then
    pool = { required = 0, candidates = {}, transferred = {}, deadCount = 0 }
    self.pools[key] = pool
  end
  local candidates = match.candidateSpawnKeys or {}
  if #candidates > pool.required then pool.required = #candidates end
  for _, spawnKey in ipairs(candidates) do
    pool.candidates[spawnKey], self.poolBySpawn[spawnKey] = true, key
    if self.deadExact[spawnKey] and not pool.transferred[spawnKey] then
      pool.transferred[spawnKey] = true
      pool.deadCount = pool.deadCount + 1
      self.deadExact[spawnKey] = nil
    end
  end
  for _, binding in pairs(self.bindings) do
    if binding.kind == "exact" and pool.candidates[binding.spawnKey] then
      binding.kind, binding.poolKey = "pool", key
      self.guidBySpawn[binding.spawnKey] = nil
    end
  end
end

function State:Track(guid, match, step)
  if not guid or type(match) ~= "table" then return false end
  if self.bindings[guid] and self.bindings[guid].dead then return false end
  local binding
  if match.kind == "packPool" and match.allocationKey then
    addPool(self, match)
    binding = { kind = "pool", poolKey = match.allocationKey }
  elseif match.kind == "exact" and match.spawnKey and contains(step and step.spawnKeys, match.spawnKey) then
    local poolKey = self.poolBySpawn[match.spawnKey]
    binding = { kind = poolKey and "pool" or "exact", poolKey = poolKey, spawnKey = match.spawnKey }
  else
    return false
  end

  forgetBinding(self, guid)
  if binding.kind == "exact" then
    local previousGuid = self.guidBySpawn[binding.spawnKey]
    if previousGuid and previousGuid ~= guid then self.bindings[previousGuid] = nil end
    self.guidBySpawn[binding.spawnKey] = guid
  end
  self.bindings[guid] = binding
  return true
end

function State:MarkDead(guid)
  local binding = self.bindings[guid]
  if not binding or binding.dead then return false end
  binding.dead = true
  if binding.kind == "exact" then
    self.deadExact[binding.spawnKey] = true
  else
    local pool = self.pools[binding.poolKey]
    if not pool then return false end
    pool.deadCount = pool.deadCount + 1
  end
  return true
end

function State:IsComplete(step)
  if type(step) ~= "table" or type(step.spawnKeys) ~= "table" or #step.spawnKeys == 0 then return false end
  for _, spawnKey in ipairs(step.spawnKeys) do
    if not self.poolBySpawn[spawnKey] and not self.deadExact[spawnKey] then return false end
  end
  for _, pool in pairs(self.pools) do
    if pool.deadCount < pool.required then return false end
  end
  return true
end

function State:EachGuid(callback)
  for guid in pairs(self.bindings) do callback(guid) end
end

function PullProgress.new()
  local state = setmetatable({}, State)
  state:Reset()
  return state
end
