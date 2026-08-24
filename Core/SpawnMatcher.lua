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

local function pointDistanceSquared(px, py, ax, ay, bx, by)
  local dx, dy = bx - ax, by - ay
  local length = dx * dx + dy * dy
  local t = length > 0 and ((px - ax) * dx + (py - ay) * dy) / length or 0
  t = math.max(0, math.min(1, t))
  local x, y = ax + t * dx, ay + t * dy
  local ox, oy = px - x, py - y
  return ox * ox + oy * oy
end

local function candidateDistance(candidate, unit, allowDerived)
  local patrol = candidate.patrol
  if (allowDerived or candidate.patrolExact ~= false)
      and type(patrol) == "table" and #patrol > 0 then
    local best
    for index, point in ipairs(patrol) do
      if point.x ~= nil and point.y ~= nil then
        local distance
        local previous = patrol[index - 1]
        if previous and previous.x ~= nil and previous.y ~= nil then
          distance = pointDistanceSquared(unit.x, unit.y, previous.x, previous.y, point.x, point.y)
        else
          local dx, dy = unit.x - point.x, unit.y - point.y
          distance = dx * dx + dy * dy
        end
        if not best or distance < best then best = distance end
      end
    end
    if best then return best, "patrol-position" end
  end
  if (not allowDerived and candidate.originExact == false) or candidate.x == nil or candidate.y == nil then return nil end
  local dx, dy = unit.x - candidate.x, unit.y - candidate.y
  return dx * dx + dy * dy, "world-position"
end

local function matchesUnit(candidate, unit)
  local candidateUiMapId = candidate.uiMapId or candidate.sublevelMapId
  return candidate.npcId == unit.npcId
      and (candidate.instanceId == nil or unit.instanceId == nil or candidate.instanceId == unit.instanceId)
      and (candidateUiMapId == nil or unit.uiMapId == nil or candidateUiMapId == unit.uiMapId)
end

local function unresolved(unit, reason, candidateSpawnKeys)
  return {
    kind = "unresolved",
    confidence = "none",
    npcId = unit and unit.npcId or nil,
    candidateSpawnKeys = candidateSpawnKeys or {},
    reasons = { reason },
  }
end

-- Candidates: {spawnKey, npcId, packKey?, x?, y?, sublevelMapId?};
-- unit: {npcId, x?, y?, uiMapId?}. A match without a spawnKey is an
-- allocation hint, never a physical spawn identity.
function SpawnMatcher:ResolveMatch(candidates, unit, thresholds)
  thresholds = thresholds or {}
  local radius = tonumber(thresholds.radius) or DEFAULT_RADIUS_YARDS
  local margin = tonumber(thresholds.margin) or DEFAULT_MARGIN_YARDS
  if type(candidates) ~= "table" or type(unit) ~= "table" or unit.npcId == nil then
    return unresolved(unit, "invalid-input")
  end

  local pool = {}
  for _, candidate in ipairs(candidates) do
    if matchesUnit(candidate, unit) then pool[#pool + 1] = candidate end
  end
  if #pool == 0 then
    return unresolved(unit, "no-candidate")
  end

  local candidateSpawnKeys = {}
  local packKey, samePack, firstPack = nil, true, true
  for _, candidate in ipairs(pool) do
    candidateSpawnKeys[#candidateSpawnKeys + 1] = candidate.spawnKey
    if firstPack then packKey, firstPack = candidate.packKey, false
    elseif packKey ~= candidate.packKey then samePack = false end
  end
  if not samePack then packKey = nil end

  local function poolMatch(reason)
    return {
      kind = packKey and "packPool" or "unresolved",
      confidence = packKey and "strong" or "ambiguous",
      npcId = unit.npcId,
      packKey = packKey,
      allocationKey = packKey and (tostring(packKey)..":"..tostring(unit.npcId)) or nil,
      candidateSpawnKeys = candidateSpawnKeys,
      reasons = { reason, "physical-spawn-ambiguous" },
    }
  end

  local positioned = {}
  for _, candidate in ipairs(pool) do
    if unit.x ~= nil and unit.y ~= nil
        and ((candidate.x ~= nil and candidate.y ~= nil)
          or (type(candidate.patrol) == "table" and #candidate.patrol > 0)) then
      local distanceSquared, evidence = candidateDistance(candidate, unit, thresholds.allowDerived == true)
      if distanceSquared then
        positioned[#positioned + 1] = {
          candidate = candidate, distanceSquared = distanceSquared, evidence = evidence,
        }
      end
    end
  end

  if #positioned > 0 then
    table.sort(positioned, function(left, right) return left.distanceSquared < right.distanceSquared end)
    local best = positioned[1]
    if best.distanceSquared > radius * radius then
      return unresolved(unit, "out-of-range", candidateSpawnKeys)
    end
    if #positioned > 1 then
      local gap = (math.sqrt(positioned[2].distanceSquared) - math.sqrt(best.distanceSquared))
      if gap < margin then
        return poolMatch("position-margin")
      end
    end
    return {
      kind = "exact", confidence = "exact", npcId = unit.npcId,
      spawnKey = best.candidate.spawnKey, packKey = best.candidate.packKey,
      candidateSpawnKeys = { best.candidate.spawnKey }, reasons = { best.evidence },
      distance = math.sqrt(best.distanceSquared),
      runnerUpDistance = positioned[2] and math.sqrt(positioned[2].distanceSquared) or nil,
    }
  end

  if #pool == 1 then
    return {
      kind = "exact", confidence = "strong", npcId = unit.npcId,
      spawnKey = pool[1].spawnKey, packKey = pool[1].packKey,
      candidateSpawnKeys = { pool[1].spawnKey }, reasons = { "unique-candidate" },
    }
  end
  return poolMatch("no-spatial-evidence")
end

-- Backward-compatible exact-key facade. Callers that need allocation semantics
-- must use ResolveMatch so an ambiguous observation cannot become an identity.
function SpawnMatcher:Resolve(candidates, unit, thresholds)
  local match = self:ResolveMatch(candidates, unit, thresholds)
  if not match.spawnKey and match.reasons[2] == "physical-spawn-ambiguous" then
    return nil, "ambiguous"
  end
  return match.spawnKey, match.reasons[1]
end

-- Builds matcher candidates for one route step from raid data plus optional
-- per-spawn world coordinates (ART.MapWorldPositions[raidKey]). `instanceId`
-- and `uiMapId` stay separate; old records may still expose `sublevelMapId`.
function SpawnMatcher:CandidatesForStep(raid, step, worldPositions, mapDefinition)
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
    local mapSublevel = mapDefinition and mapDefinition.sublevels and mapDefinition.sublevels[spawn.sublevel]
    local coordinateKind = world and world.coordinateKind
    local patrolCoordinateKind = world and world.patrolCoordinateKind or coordinateKind
    list[#list + 1] = {
      spawnKey = spawnKey,
      npcId = tonumber(spawn.npcId),
      packKey = packKey or spawn.packKey,
      x = world and tonumber(world.x) or nil,
      y = world and tonumber(world.y) or nil,
      patrol = world and world.patrol or nil,
      originExact = coordinateKind ~= "derived-affine",
      patrolExact = patrolCoordinateKind ~= "derived-affine",
      instanceId = raid.instanceId or sublevel and sublevel.instanceId or nil,
      uiMapId = mapSublevel and (mapSublevel.uiMapId
          or mapSublevel.asset and mapSublevel.asset.uiMapId) or sublevel and sublevel.uiMapId or nil,
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
