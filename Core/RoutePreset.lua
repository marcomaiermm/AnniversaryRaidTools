-- Made by Nnoggie, 2017-2025
-- Pure route-preset validation and deterministic import/export.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local RoutePreset = ART.RoutePreset or {}
ART.RoutePreset = RoutePreset
if addon and addon.RoutePreset == nil then addon.RoutePreset = RoutePreset end

local function array(value)
  if type(value) ~= "table" then return false end
  for key in pairs(value) do
    if type(key) ~= "number" or key < 1 or key % 1 ~= 0 or key > #value then return false end
  end
  return true
end

local function copy(value, seen)
  if type(value) ~= "table" then return value end
  seen = seen or {}
  if seen[value] then error("cyclic preset table") end
  seen[value] = true
  local result = {}
  for key, item in pairs(value) do result[copy(key, seen)] = copy(item, seen) end
  seen[value] = nil
  return result
end

local function equalArray(left, right)
  if not array(left) or not array(right) or #left ~= #right then return false end
  for index = 1, #left do if left[index] ~= right[index] then return false end end
  return true
end

local function spawnIndex(raid)
  local result = {}
  for _, enemy in pairs(raid.enemies or {}) do
    for _, spawn in ipairs(enemy.spawns or {}) do result[spawn.key] = spawn end
  end
  return result
end

local function validMarker(marker)
  return type(marker) == "number" and marker % 1 == 0 and marker >= 1 and marker <= 8
end

local function validateMarking(marking, raid, spawns)
  if type(marking) ~= "table" or type(marking.npcDefaults) ~= "table" or type(marking.packOverrides) ~= "table" then
    return nil, "invalid marking profile"
  end
  for npcId, markers in pairs(marking.npcDefaults) do
    if type(npcId) ~= "number" or npcId % 1 ~= 0 or not raid.enemies[tostring(npcId)] or not array(markers) then
      return nil, "invalid NPC marking rule"
    end
    for _, marker in ipairs(markers) do if not validMarker(marker) then return nil, "invalid marker" end end
  end
  for packKey, override in pairs(marking.packOverrides) do
    if not raid.packs[packKey] or type(override) ~= "table" then return nil, "invalid pack marking override" end
    if override.npcDefaults ~= nil then
      if type(override.npcDefaults) ~= "table" then return nil, "invalid pack NPC rules" end
      for npcId, markers in pairs(override.npcDefaults) do
        if type(npcId) ~= "number" or not raid.enemies[tostring(npcId)] or not array(markers) then return nil, "invalid pack NPC rule" end
        for _, marker in ipairs(markers) do if not validMarker(marker) then return nil, "invalid marker" end end
      end
    end
    if override.spawns ~= nil then
      if type(override.spawns) ~= "table" then return nil, "invalid spawn overrides" end
      for spawnKey, marker in pairs(override.spawns) do
        if not spawns[spawnKey] or spawns[spawnKey].packKey ~= packKey or not validMarker(marker) then
          return nil, "invalid spawn marking override"
        end
      end
    end
  end
  return true
end

function RoutePreset:Validate(preset, raid)
  if type(preset) ~= "table" then return nil, "preset must be a table" end
  if type(raid) ~= "table" or raid.key ~= preset.raidKey then return nil, "unknown raid" end
  if preset.schemaVersion ~= 1 then return nil, "unsupported preset schemaVersion" end
  if type(preset.currentSublevel) ~= "number" or preset.currentSublevel % 1 ~= 0
      or not raid.sublevels[preset.currentSublevel] then return nil, "invalid currentSublevel" end
  if not array(preset.routeSteps) then return nil, "routeSteps must be an array" end

  local spawns, stepIds, waveKeys = spawnIndex(raid), {}, {}
  for index, step in ipairs(preset.routeSteps) do
    if type(step) ~= "table" or type(step.id) ~= "string" or step.id == "" or stepIds[step.id]
        or type(step.label) ~= "string" or not array(step.packKeys) or type(step.notes) ~= "string"
        or type(step.marks) ~= "table" then return nil, "invalid route step at index "..index end
    stepIds[step.id] = true
    local activePacks = {}
    for _, packKey in ipairs(step.packKeys) do
      if type(packKey) ~= "string" or activePacks[packKey] or not raid.packs[packKey] then
        return nil, "invalid pack reference in step "..step.id
      end
      activePacks[packKey] = true
    end
    for spawnKey, marker in pairs(step.marks) do
      local spawn = spawns[spawnKey]
      if type(spawnKey) ~= "string" or not spawn or not activePacks[spawn.packKey] or not validMarker(marker) then
        return nil, "invalid step mark in "..step.id
      end
    end
    if raid.mode == "route" then
      if step.waveKey ~= nil or step.camp ~= nil or step.tankAssignments ~= nil then return nil, "wave fields in route step" end
    else
      local wave = raid.waves[index]
      if not wave or step.waveKey ~= wave.waveKey or waveKeys[step.waveKey] or not equalArray(step.packKeys, wave.packKeys)
          or (step.camp ~= nil and step.camp ~= wave.camp)
          or (step.tankAssignments ~= nil and type(step.tankAssignments) ~= "table") then
        return nil, "wave composition/order/key mismatch at step "..index
      end
      waveKeys[step.waveKey] = true
    end
  end
  if raid.mode == "waves" and #preset.routeSteps ~= #raid.waves then return nil, "missing or extra wave steps" end
  return validateMarking(preset.marking, raid, spawns)
end

function RoutePreset:Create(raid)
  assert(type(raid) == "table", "RoutePreset.Create requires a raid")
  local preset = { schemaVersion = 1, raidKey = raid.key, currentSublevel = 1, routeSteps = {}, marking = { npcDefaults = {}, packOverrides = {} } }
  if raid.mode == "waves" then
    for index, wave in ipairs(raid.waves) do
      preset.routeSteps[index] = {
        id = "wave-"..wave.waveKey, label = wave.waveKey, packKeys = copy(wave.packKeys), notes = "", marks = {},
        waveKey = wave.waveKey, camp = wave.camp,
      }
    end
  end
  return preset
end

function RoutePreset:Reorder(preset, stepId, destination, raid)
  local valid, reason = self:Validate(preset, raid)
  if not valid then return nil, reason end
  if raid.mode == "waves" then return nil, "wave order is immutable" end
  if type(destination) ~= "number" or destination % 1 ~= 0 or destination < 1 or destination > #preset.routeSteps then
    return nil, "invalid destination"
  end
  local source
  for index, step in ipairs(preset.routeSteps) do if step.id == stepId then source = index break end end
  if not source then return nil, "unknown route step" end
  local step = table.remove(preset.routeSteps, source)
  table.insert(preset.routeSteps, destination, step)
  return preset
end

local function escaped(value)
  return '"'..value:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")..'"'
end

local function keyOrder(left, right)
  local lt, rt = type(left), type(right)
  if lt ~= rt then return lt < rt end
  if lt == "number" or lt == "string" then return left < right end
  return tostring(left) < tostring(right)
end

local function encode(value, stack)
  local kind = type(value)
  if kind == "nil" then return "nil" end
  if kind == "boolean" then return tostring(value) end
  if kind == "number" then
    if value ~= value or value == math.huge or value == -math.huge then error("non-finite preset number") end
    return tostring(value)
  end
  if kind == "string" then return escaped(value) end
  if kind ~= "table" then error("unsupported preset value type: "..kind) end
  stack = stack or {}
  if stack[value] then error("cyclic preset table") end
  stack[value] = true
  local keys = {}
  for key in pairs(value) do
    if type(key) ~= "number" and type(key) ~= "string" then error("unsupported preset key type") end
    keys[#keys + 1] = key
  end
  table.sort(keys, keyOrder)
  local result = { "{" }
  for _, key in ipairs(keys) do
    result[#result + 1] = "["..encode(key, stack).."]="..encode(value[key], stack).."," 
  end
  result[#result + 1] = "}"
  stack[value] = nil
  return table.concat(result)
end

local function decode(text)
  if type(text) ~= "string" then return nil, "import must be a string or table" end
  local position, length = 1, #text
  local function skip() while position <= length and text:sub(position, position):match("%s") do position = position + 1 end end
  local value
  local function parseString()
    position = position + 1
    local result = {}
    while position <= length do
      local char = text:sub(position, position)
      position = position + 1
      if char == '"' then return table.concat(result) end
      if char == "\\" then
        local escape = text:sub(position, position); position = position + 1
        local mapped = ({ n = "\n", r = "\r", t = "\t", ['"'] = '"', ["\\"] = "\\" })[escape]
        if not mapped then error("invalid string escape") end
        char = mapped
      end
      result[#result + 1] = char
    end
    error("unterminated string")
  end
  local function parseValue()
    skip()
    local char = text:sub(position, position)
    if char == '"' then return parseString() end
    if char == "{" then
      position = position + 1
      local result = {}
      skip()
      while text:sub(position, position) ~= "}" do
        if text:sub(position, position) ~= "[" then error("expected table key") end
        position = position + 1
        local key = parseValue(); skip()
        if text:sub(position, position) ~= "]" then error("expected ]") end
        position = position + 1; skip()
        if text:sub(position, position) ~= "=" then error("expected =") end
        position = position + 1
        if result[key] ~= nil then error("duplicate table key") end
        result[key] = parseValue(); skip()
        if text:sub(position, position) ~= "," then error("expected ,") end
        position = position + 1; skip()
      end
      position = position + 1
      return result
    end
    local token = text:match("^[^,%]%}%s]+", position)
    if not token then error("expected value") end
    position = position + #token
    if token == "true" then return true elseif token == "false" then return false elseif token == "nil" then return nil end
    local number = tonumber(token)
    if not number then error("invalid token") end
    return number
  end
  local ok, result = pcall(parseValue)
  if not ok then return nil, result end
  skip()
  if position <= length then return nil, "trailing import data" end
  return result
end

function RoutePreset:Export(preset, raid)
  local valid, reason = self:Validate(preset, raid)
  if not valid then return nil, reason end
  local ok, result = pcall(encode, preset)
  if not ok then return nil, result end
  return result
end

function RoutePreset:Import(value, registry)
  local candidate, reason
  if type(value) == "table" then
    local ok
    ok, candidate = pcall(copy, value)
    if not ok then return nil, candidate end
  else
    candidate, reason = decode(value)
    if candidate == nil then return nil, reason or "preset must be a table" end
  end
  if type(candidate) ~= "table" then return nil, "preset must be a table" end
  local raid = registry and registry.Get and registry:Get(candidate.raidKey)
  if not raid then return nil, "unknown raid" end
  local valid
  valid, reason = self:Validate(candidate, raid)
  if not valid then return nil, reason end
  return candidate
end

function RoutePreset:Initialize(dependencies)
  if self.initialized then return self end
  dependencies = dependencies or {}
  self.registry = dependencies.registry or dependencies.raidRegistry or ART.RaidRegistry
  assert(type(self.registry) == "table", "RoutePreset requires RaidRegistry")
  self.initialized = true
  return self
end

function RoutePreset.new(first, second)
  local dependencies = second or (first ~= RoutePreset and first or nil)
  local instance = setmetatable({}, { __index = RoutePreset })
  return instance:Initialize(dependencies)
end
RoutePreset.New = RoutePreset.new
