-- Made by Nnoggie, 2017-2025
-- AnniversaryRaidTools spawn matching is deliberately independent from the WoW UI.

local _, addon = ...

local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local SpawnMatcher = ART.SpawnMatcher or {}
ART.SpawnMatcher = SpawnMatcher
if addon and addon.SpawnMatcher == nil then addon.SpawnMatcher = SpawnMatcher end

local ipairs, tonumber = ipairs, tonumber
local DEFAULT_RADIUS_YARDS = 30
local DEFAULT_MARGIN_YARDS = 10

-- Candidates: {spawnKey, npcId, x?, y?, sublevelMapId?}; unit: {npcId, x?, y?, uiMapId?}.
-- Position matching runs only when both sides provide coordinates; otherwise an
-- unambiguous single NPC instance is matched by id (fail-closed everywhere else).
function SpawnMatcher:Resolve(candidates, unit, thresholds)  thresholds = thresholds or {}
  local radius = tonumber(thresholds.radius) or DEFAULT_RADIUS_YARDS
  local margin = tonumber(thresholds.margin) or DEFAULT_MARGIN_YARDS
  if type(candidates) ~= "table" or type(unit) ~= "table" or unit.npcId == nil then
    return nil, "invalid-input"
  end

  local pool = {}
  for _, candidate in ipairs(candidates) do
    if candidate.npcId == unit.npcId
        and (candidate.sublevelMapId == nil or unit.uiMapId == nil or candidate.sublevelMapId == unit.uiMapId) then
      pool[#pool + 1] = candidate
    end
  end
  if #pool == 0 then return nil, "no-candidate" end

  local positioned = {}
  for _, candidate in ipairs(pool) do
    if candidate.x ~= nil and candidate.y ~= nil and unit.x ~= nil and unit.y ~= nil then
      local dx, dy = unit.x - candidate.x, unit.y - candidate.y
      positioned[#positioned + 1] = { candidate = candidate, distanceSquared = dx * dx + dy * dy }
    end
  end

  if #positioned > 0 then
    table.sort(positioned, function(left, right) return left.distanceSquared < right.distanceSquared end)
    local best = positioned[1]
    if #positioned > 1 then
      local gap = (math.sqrt(positioned[2].distanceSquared) - math.sqrt(best.distanceSquared))
      if gap < margin then return nil, "ambiguous" end
    end
    if best.distanceSquared > radius * radius then return nil, "out-of-range" end
    return best.candidate.spawnKey
  end

  if #pool == 1 then return pool[1].spawnKey end
  return nil, "ambiguous"
end

-- Builds matcher candidates for one route step from raid data plus optional
-- per-spawn world coordinates (ART.MapWorldPositions[raidKey]).
function SpawnMatcher:CandidatesForStep(raid, step, worldPositions)
  local list = {}
  if type(raid) ~= "table" or type(step) ~= "table" then return list end
  local spawnByKey = {}
  for _, enemy in pairs(raid.enemies or {}) do
    for _, spawn in ipairs(enemy.spawns or {}) do spawnByKey[spawn.key] = spawn end
  end

  local function append(spawnKey, packKey)
    local spawn = spawnByKey[spawnKey]
    if not spawn then return end
    local world = worldPositions and worldPositions[spawnKey]
    local sublevel = raid.sublevels and raid.sublevels[spawn.sublevel]
    list[#list + 1] = {
      spawnKey = spawnKey,
      npcId = tonumber(spawn.npcId),
      packKey = packKey or spawn.packKey,
      x = world and tonumber(world.x) or nil,
      y = world and tonumber(world.y) or nil,
      sublevelMapId = sublevel and sublevel.mapId or nil,
    }
  end

  -- Runtime pulls carry their exact clone membership. Static route steps keep
  -- using pack membership because they deliberately describe whole packs.
  if type(step.spawnKeys) == "table" then
    for _, spawnKey in ipairs(step.spawnKeys) do append(spawnKey) end
    return list
  end

  for _, packKey in ipairs(step.packKeys or {}) do
    local pack = raid.packs and raid.packs[packKey]
    for _, spawnKey in ipairs(pack and pack.spawnKeys or {}) do
      append(spawnKey, packKey)
    end
  end
  return list
end
