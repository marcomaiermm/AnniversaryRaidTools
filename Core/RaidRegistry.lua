-- Made by Nnoggie, 2017-2025
-- Validated, stable-keyed raid definition registry.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local Registry = ART.RaidRegistry or {}
ART.RaidRegistry = Registry
if addon and addon.RaidRegistry == nil then addon.RaidRegistry = Registry end

local sources = { azerothcore = true, ["live-observed"] = true, manual = true, ["client-data"] = true, derived = true }
local confidence = { verified = true, high = true, candidate = true, ["review-required"] = true }

local function finite(value)
  return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function positiveInteger(value)
  return type(value) == "number" and value > 0 and value % 1 == 0
end

local function raidKey(value)
  return type(value) == "string" and value ~= "" and value:match("^[a-z0-9%-]+$") ~= nil
      and value:sub(1, 1) ~= "-" and value:sub(-1) ~= "-" and not value:find("--", 1, true)
end

local function stableId(value)
  return type(value) == "string" and value:match("^[a-z0-9][a-z0-9_%-]*$") ~= nil
end

local function stablePackKey(value, key)
  local prefix = key..":pack:"
  return type(value) == "string" and value:sub(1, #prefix) == prefix and stableId(value:sub(#prefix + 1))
end

local function stablePullGroup(value, key)
  local prefix = key..":pull-group:"
  return type(value) == "string" and value:sub(1, #prefix) == prefix and stableId(value:sub(#prefix + 1))
end

local function stableSpawnKey(value, key, npcId)
  local prefix = key..":spawn:"..npcId..":"
  return type(value) == "string" and value:sub(1, #prefix) == prefix and stableId(value:sub(#prefix + 1))
end

local function array(value)
  if type(value) ~= "table" then return false end
  for key in pairs(value) do
    if type(key) ~= "number" or key < 1 or key % 1 ~= 0 or key > #value then return false end
  end
  return true
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

local function provenance(value)
  return type(value) == "table" and sources[value.source] and confidence[value.confidence]
      and (value.source ~= "azerothcore" or value.confidence == "candidate" or value.confidence == "review-required")
      and (value.sourceRef == nil or type(value.sourceRef) == "string")
      and (value.observedAt == nil or utcTimestamp(value.observedAt))
end

local function fail(message) return nil, message end

function Registry:Validate(raid)
  if type(raid) ~= "table" then return fail("raid must be a table") end
  if raid.schemaVersion ~= 1 then return fail("unsupported raid schemaVersion") end
  if not raidKey(raid.key) then return fail("invalid raid key") end
  if type(raid.name) ~= "string" or raid.name == "" then return fail("invalid raid name") end
  if raid.expansion ~= "TBC" then return fail("raid expansion must be TBC") end
  if not positiveInteger(raid.instanceId) then return fail("invalid instanceId") end
  if not positiveInteger(raid.mapId) then return fail("invalid mapId") end
  if raid.mode ~= "route" and raid.mode ~= "waves" then return fail("invalid raid mode") end
  if not array(raid.sublevels) or #raid.sublevels == 0 then return fail("invalid sublevels") end
  for index, level in ipairs(raid.sublevels) do
    if type(level) ~= "table" or level.index ~= index or type(level.name) ~= "string" or level.name == ""
        or not positiveInteger(level.mapId) then
      return fail("invalid sublevel at index "..index)
    end
  end
  if type(raid.enemies) ~= "table" or type(raid.packs) ~= "table" or type(raid.pois) ~= "table" then
    return fail("enemies, packs, and pois are required")
  end

  local spawns = {}
  for npcKey, enemy in pairs(raid.enemies) do
    if type(npcKey) ~= "string" or not npcKey:match("^%d+$") or type(enemy) ~= "table"
        or not positiveInteger(enemy.npcId) or tostring(enemy.npcId) ~= npcKey or type(enemy.name) ~= "string"
        or enemy.name == "" or not array(enemy.spawns) or #enemy.spawns == 0
        or not provenance(enemy.source) then
      return fail("invalid enemy "..tostring(npcKey))
    end
    for _, spawn in ipairs(enemy.spawns) do
      if type(spawn) ~= "table" or type(spawn.key) ~= "string" or spawns[spawn.key]
          or spawn.npcId ~= enemy.npcId or not finite(spawn.x) or spawn.x < 0 or spawn.x > 1
          or not finite(spawn.y) or spawn.y < 0 or spawn.y > 1
          or type(spawn.sublevel) ~= "number" or spawn.sublevel % 1 ~= 0 or not raid.sublevels[spawn.sublevel]
          or (spawn.packKey ~= nil and type(spawn.packKey) ~= "string") or not provenance(spawn.source) then
        return fail("invalid spawn for enemy "..npcKey)
      end
      if not stableSpawnKey(spawn.key, raid.key, enemy.npcId) then return fail("invalid stable spawn key") end
      if spawn.patrol ~= nil then
        if not array(spawn.patrol) then return fail("invalid patrol for "..spawn.key) end
        for _, point in ipairs(spawn.patrol) do
          if type(point) ~= "table" or not finite(point.x) or point.x < 0 or point.x > 1
              or not finite(point.y) or point.y < 0 or point.y > 1 then return fail("invalid patrol point") end
        end
      end
      spawns[spawn.key] = spawn
    end
  end

  local membership = {}
  for packKey, pack in pairs(raid.packs) do
    if not stablePackKey(packKey, raid.key) or type(pack) ~= "table"
        or pack.key ~= packKey or not array(pack.spawnKeys) or #pack.spawnKeys == 0 or not provenance(pack.source)
        or (pack.label ~= nil and type(pack.label) ~= "string")
        or (pack.pullGroup ~= nil and not stablePullGroup(pack.pullGroup, raid.key)) then
      return fail("invalid pack "..tostring(packKey))
    end
    local members = {}
    for _, spawnKey in ipairs(pack.spawnKeys) do
      if type(spawnKey) ~= "string" or members[spawnKey] or membership[spawnKey] or not spawns[spawnKey]
          or (spawns[spawnKey].packKey ~= nil and spawns[spawnKey].packKey ~= packKey) then
        return fail("invalid pack member "..tostring(spawnKey))
      end
      members[spawnKey] = true
      membership[spawnKey] = packKey
    end
  end
  for spawnKey, spawn in pairs(spawns) do
    if spawn.packKey and (not raid.packs[spawn.packKey] or membership[spawnKey] ~= spawn.packKey) then
      return fail("pack membership mismatch on "..spawnKey)
    end
  end
  for index, pois in pairs(raid.pois) do
    if not positiveInteger(index) or not raid.sublevels[index] or not array(pois) then
      return fail("invalid POI bucket "..tostring(index))
    end
    for _, poi in ipairs(pois) do
      if type(poi) ~= "table" or not finite(poi.x) or poi.x < 0 or poi.x > 1
          or not finite(poi.y) or poi.y < 0 or poi.y > 1 or poi.sublevel ~= index
          or (poi.label ~= nil and type(poi.label) ~= "string") or not provenance(poi.source) then return fail("invalid POI") end
    end
  end

  if raid.mode == "waves" then
    if not array(raid.waves) or #raid.waves == 0 then return fail("waves raid requires waves") end
    local keys = {}
    for _, wave in ipairs(raid.waves) do
      if type(wave) ~= "table" or type(wave.waveKey) ~= "string" or keys[wave.waveKey]
          or not array(wave.packKeys) or (wave.camp ~= nil and type(wave.camp) ~= "string")
          or not provenance(wave.source) then return fail("invalid wave") end
      keys[wave.waveKey] = true
      local wavePacks = {}
      for _, packKey in ipairs(wave.packKeys) do
        if wavePacks[packKey] or not raid.packs[packKey] then return fail("invalid wave pack "..tostring(packKey)) end
        wavePacks[packKey] = true
      end
    end
  elseif raid.waves ~= nil then
    return fail("route raid cannot define waves")
  end
  return true
end

function Registry:Initialize(dependencies)
  if self.initialized then return self end
  self.raids = {}
  self.diagnostics = (dependencies or {}).diagnostics
  self.initialized = true
  return self
end

function Registry.new(first, second)
  local dependencies = second or (first ~= Registry and first or nil)
  local instance = setmetatable({}, { __index = Registry })
  return instance:Initialize(dependencies)
end
Registry.New = Registry.new

function Registry:Register(raid)
  if not self.initialized then self:Initialize() end
  local valid, reason = self:Validate(raid)
  if not valid then
    if self.diagnostics then self.diagnostics(reason, raid) end
    return nil, reason
  end
  if self.raids[raid.key] then return nil, "duplicate raid key "..raid.key end
  self.raids[raid.key] = raid
  return raid
end

function Registry:Get(key) return self.raids and self.raids[key] end

function Registry:GetAll()
  local result = {}
  for _, raid in pairs(self.raids or {}) do result[#result + 1] = raid end
  table.sort(result, function(left, right) return left.key < right.key end)
  return result
end
