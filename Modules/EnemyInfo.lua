-- Made by Nnoggie, 2017-2025
-- Multi-raid registration and sourced enemy-info UI adapter.

local _, MDT = ...
local ART = assert(rawget(_G, "ART"), "AnniversaryRaidTools bootstrap is required")
local L = MDT.L

local DEFAULT_RAID_KEY = "gruuls-lair"
local RAID_KEYS = { "gruuls-lair", "black-temple", "hyjal", "magtheridons-lair",
  "serpentshrine-cavern", "the-eye" }
local SHELL_INDICES = {
  ["gruuls-lair"] = 160, ["black-temple"] = 161, hyjal = 162, karazhan = 163,
  ["magtheridons-lair"] = 164,
  ["serpentshrine-cavern"] = 165, ["the-eye"] = 166, ["sunwell-plateau"] = 167,
}
local UNSUPPORTED_RAIDS = { [163] = "Karazhan", [167] = "Sunwell Plateau" }
local UNSUPPORTED_TOOLTIP = "Not supported yet."
local RAID_ICONS = {
  [160] = "LoadScreenGruulsLair", [161] = "LoadScreenBlackTemple", [162] = "LoadScreenHyjal",
  [163] = "LoadScreenKarazhan", [164] = "LoadScreenHellfireCitadelRaid",
  [165] = "LoadScreenCoilfang", [166] = "LoadScreenTempestKeep", [167] = "LoadScreenSunwell",
}
-- Retain the accepted TBC Teron Gorefiend variant instead of AzerothCore's
-- alternate display.
local DISPLAY_ID_OVERRIDES = { [22871] = 21262 }
-- Encounter actors pinned from mangos-tbc@adbc7f74 ScriptDevAI scripts.
-- Anything not explicitly listed is trash, even when it has only one spawn.
local BOSS_NPCS = {
  ["gruuls-lair"] = { [18831] = true, [18832] = true, [18834] = true, [18835] = true,
    [18836] = true, [19044] = true },
  ["black-temple"] = { [22841] = true, [22856] = true, [22871] = true, [22887] = true,
    [22898] = true, [22917] = true, [22947] = true, [22948] = true, [22949] = true,
    [22950] = true, [22951] = true, [22952] = true },
  hyjal = { [17767] = true, [17808] = true, [17842] = true, [17888] = true, [17968] = true },
  karazhan = { [15687] = true, [15688] = true, [15689] = true, [15690] = true,
    [15691] = true, [16151] = true, [16457] = true, [16524] = true },
  ["magtheridons-lair"] = { [17257] = true },
  ["serpentshrine-cavern"] = { [21212] = true, [21213] = true, [21214] = true,
    [21215] = true, [21216] = true, [21217] = true },
  ["the-eye"] = { [18805] = true, [19514] = true, [19516] = true, [19622] = true,
    [20060] = true, [20062] = true, [20063] = true, [20064] = true },
  ["sunwell-plateau"] = { [24850] = true, [24891] = true, [24892] = true,
    [24882] = true, [25038] = true, [25165] = true, [25166] = true,
    [25315] = true, [25608] = true, [25741] = true },
}
local Integration = ART.GruulsLairIntegration or { diagnostics = {}, status = {}, preserveStoredRoutes = {} }
ART.GruulsLairIntegration = Integration
ART.MultiRaidIntegration = Integration

local function localize(value) return L[value] or value end

local function diagnose(reason, feature)
  if #Integration.diagnostics < 32 then
    Integration.diagnostics[#Integration.diagnostics + 1] = { reason = reason, feature = feature }
  end
  if feature then
    Integration.status[feature] = reason
  else
    MDT.RaidIntegrationError = reason
  end
  return false, reason
end

local function validateMap(raid, map, transform)
  if type(map) ~= "table" or map.schemaVersion ~= 1 or map.raidKey ~= raid.key
      or map.instanceId ~= raid.instanceId or map.mapId ~= raid.mapId or type(map.sublevels) ~= "table" then
    return false, "invalid-map-definition"
  end
  if type(transform) ~= "table" or transform.schemaVersion ~= 1 or transform.raidKey ~= raid.key
      or type(transform.toPlanner) ~= "function" or type(transform.fromPlanner) ~= "function" then
    return false, "invalid-map-transform"
  end
  for index, sublevel in ipairs(raid.sublevels) do
    local mapSublevel = map.sublevels[index]
    local calibration = transform.calibrations and transform.calibrations[index]
    if type(mapSublevel) ~= "table" or mapSublevel.mapId ~= sublevel.mapId
        or type(calibration) ~= "table" or calibration.mapId ~= sublevel.mapId or calibration.sublevel ~= index then
      return false, "map-sublevel-mismatch"
    end
  end
  return true
end

local function markDependencies(preset, raid, db)
  return {
    raid = raid,
    routeSteps = preset and preset.routeSteps or {},
    profile = preset and preset.marking or { npcDefaults = {}, packOverrides = {} },
    settings = db and db.focusMarker,
  }
end

local function repositoryMetadata(raid)
  local metadata = { raidKey = raid.key, source = raid.enemyMetadataSource, enemies = {} }
  for _, enemy in pairs(raid.enemies) do
    metadata.enemies[enemy.npcId] = {
      name = enemy.name,
      level = enemy.level,
      creatureType = enemy.creatureType,
      maxHealth = enemy.health,
    }
  end
  return metadata
end

local function mapPosition(raid, map, sublevel, raw)
  local uiMapId = map.sublevels[sublevel] and map.sublevels[sublevel].uiMapId
  if not raw or not uiMapId then return end
  local position = MDT.Compat:GetMapPositionFromWorld(raid.instanceId, raw.x, raw.y, uiMapId)
  if not position then return end
  local x, y = position.x, position.y
  local transform = ART.MapTransforms and ART.MapTransforms[raid.key]
  -- Legacy dungeon textures (Karazhan) are west-left; the Anniversary C_Map
  -- projection returns east-right x. Mirror before the planner transform.
  if transform and transform.flipX then x = 1 - x end
  if transform then x, y = transform.toPlanner(raid.mapId, sublevel, x, y) end
  if type(x) ~= "number" or type(y) ~= "number" or x < 0 or x > 1 or y < 0 or y > 1 then return end
  return x, y
end

local function projectRaidEnemies(raid, map)
  local canvasWidth, canvasHeight = MDT:GetDefaultMapPanelSize()
  local useStaticCoordinates = raid.key == "black-temple"
  local npcKeys, packGroups, packKeys, packWaves = {}, {}, {}, {}
  for npcKey in pairs(raid.enemies) do npcKeys[#npcKeys + 1] = npcKey end
  for packKey in pairs(raid.packs) do packKeys[#packKeys + 1] = packKey end
  for waveIndex, wave in ipairs(raid.waves or {}) do
    for _, packKey in ipairs(wave.packKeys) do packWaves[packKey] = waveIndex end
  end
  table.sort(npcKeys)
  table.sort(packKeys)
  for index, packKey in ipairs(packKeys) do packGroups[packKey] = index end

  local enemies, spawnLookup = {}, {}
  for enemyIdx, npcKey in ipairs(npcKeys) do
    local enemy, clones = raid.enemies[npcKey], {}
    for cloneIdx, spawn in ipairs(enemy.spawns) do
      local raw = ART.MapWorldPositions and ART.MapWorldPositions[raid.key]
          and ART.MapWorldPositions[raid.key][spawn.key]
      local normalizedX, normalizedY
      if useStaticCoordinates then
        normalizedX, normalizedY = ART.MapTransforms[raid.key].toPlanner(
          raid.mapId, spawn.sublevel, spawn.x, spawn.y)
      else
        normalizedX, normalizedY = mapPosition(raid, map, spawn.sublevel, raw)
      end
      normalizedX, normalizedY = normalizedX or spawn.x, normalizedY or spawn.y
      local patrol
      if spawn.patrol then
        patrol = {}
        for pointIdx, point in ipairs(spawn.patrol) do
          local patrolX, patrolY
          if useStaticCoordinates then
            patrolX, patrolY = ART.MapTransforms[raid.key].toPlanner(
              raid.mapId, spawn.sublevel, point.x, point.y)
          else
            patrolX, patrolY = mapPosition(raid, map, spawn.sublevel, raw and raw.patrol and raw.patrol[pointIdx])
          end
          patrol[pointIdx] = { x = (patrolX or point.x) * canvasWidth, y = -(patrolY or point.y) * canvasHeight }
        end
      end
      clones[cloneIdx] = {
        x = normalizedX * canvasWidth,
        y = -normalizedY * canvasHeight,
        sublevel = spawn.sublevel,
        hidden = spawn.hidden,
        g = packGroups[spawn.packKey],
        patrol = patrol,
        artSpawnKey = spawn.key,
        artPackKey = spawn.packKey,
        artPullGroup = raid.packs[spawn.packKey] and raid.packs[spawn.packKey].pullGroup,
        artWave = packWaves[spawn.packKey],
      }
      spawnLookup[spawn.key] = { enemyIdx = enemyIdx, cloneIdx = cloneIdx, packKey = spawn.packKey }
    end
    enemies[enemyIdx] = {
      name = localize(enemy.name),
      id = enemy.npcId,
      count = 0,
      health = assert(enemy.health, "missing enemy health: "..enemy.npcId),
      level = assert(enemy.level, "missing enemy level: "..enemy.npcId),
      creatureType = assert(enemy.creatureType, "missing enemy creature type: "..enemy.npcId),
      scale = assert(enemy.scale, "missing enemy scale: "..enemy.npcId),
      isBoss = BOSS_NPCS[raid.key] and BOSS_NPCS[raid.key][enemy.npcId] or false,
      displayId = DISPLAY_ID_OVERRIDES[enemy.npcId]
          or assert(enemy.displayId, "missing enemy display ID: "..enemy.npcId),
      spells = enemy.spells,
      characteristics = enemy.characteristics,
      stealthDetect = enemy.stealthDetect,
      clones = clones,
    }
  end
  return enemies, spawnLookup
end

local function appendMapLinks(map, pois, canvasWidth, canvasHeight)
  local rotations = { [-2] = -math.pi / 2, [-1] = math.pi, [1] = 0, [2] = math.pi / 2 }
  for sublevel, links in pairs(map.links or {}) do
    for index, link in ipairs(links) do
      pois[sublevel][#pois[sublevel] + 1] = {
        x = link.x * canvasWidth,
        y = -link.y * canvasHeight,
        target = link.target,
        direction = link.direction,
        arrowAtlas = "Garr_LevelUpgradeArrow",
        arrowRotation = (rotations[link.direction] or 0) + math.pi,
        connectionIndex = index,
        template = "MapLinkPinTemplate",
        type = "mapLink",
      }
    end
  end
end

local function publishShellData(raid, map)
  local shellIndex = SHELL_INDICES[raid.key]
  local dungeonMaps, sublevels, tileFormat, pois = {}, {}, {}, {}
  local canvasWidth, canvasHeight = MDT:GetDefaultMapPanelSize()
  dungeonMaps[0] = map.sublevels[1].asset.textureFolder
  for index, sublevel in ipairs(map.sublevels) do
    local asset = sublevel.asset
    dungeonMaps[index] = asset.customTextures and { customTextures = asset.customTextures }
        or asset.useUiMapArt and { uiMapId = asset.uiMapId } or asset.texturePrefix
        or (asset.noFloorPrefix and (asset.tilePrefix or asset.textureFolder))
        or asset.textureFolder..index.."_"
    sublevels[index], tileFormat[index], pois[index] = localize(sublevel.name), 4, {}
  end
  for sublevel, raidPOIs in pairs(raid.pois or {}) do
    for index, poi in ipairs(raidPOIs) do
      pois[sublevel][index] = {
        x = poi.x * canvasWidth, y = -poi.y * canvasHeight,
        template = "MapLinkPinTemplate", type = "generalNote", text = localize(poi.label or ""),
      }
    end
  end
  appendMapLinks(map, pois, canvasWidth, canvasHeight)
  MDT.dungeonList[shellIndex] = localize(raid.name)
  MDT.mapInfo[shellIndex] = {
    shortName = localize(raid.name), englishName = raid.name, mapID = raid.mapId, tileFormat = tileFormat,
    iconId = "Interface\\Glues\\LoadingScreens\\"..RAID_ICONS[shellIndex],
    iconTexCoords = { 0.12, 0.88, 0.30, 0.92 },
  }
  MDT.dungeonMaps[shellIndex] = dungeonMaps
  MDT.dungeonSubLevels[shellIndex] = sublevels
  MDT.dungeonTotalCount[shellIndex] = { normal = 0 }
  Integration.spawnLookup[raid.key] = {}
  MDT.dungeonEnemies[shellIndex], Integration.spawnLookup[raid.key] = projectRaidEnemies(raid, map)
  MDT.mapPOIs[shellIndex] = pois
  MDT.scaleMultiplier[shellIndex] = 1
  MDT.zoneIdToDungeonIdx[raid.mapId] = shellIndex
  MDT.knownDungeons[shellIndex] = raid.name
end

local function publishUnsupportedRaids()
  MDT.unsupportedDungeons = {}
  for shellIndex, raidName in pairs(UNSUPPORTED_RAIDS) do
    MDT.dungeonList[shellIndex] = localize(raidName)
    MDT.mapInfo[shellIndex] = {
      shortName = localize(raidName), englishName = raidName,
      iconId = "Interface\\Glues\\LoadingScreens\\"..RAID_ICONS[shellIndex],
      iconTexCoords = { 0.12, 0.88, 0.30, 0.92 },
    }
    MDT.knownDungeons[shellIndex] = raidName
    MDT.unsupportedDungeons[shellIndex] = UNSUPPORTED_TOOLTIP
  end
end

local function configureWavePulls(raid, preset)
  if raid.mode ~= "waves" then return end
  preset = preset or MDT:GetCurrentPreset()
  local pulls, lookup = {}, Integration.spawnLookup[raid.key]
  for waveIndex, wave in ipairs(raid.waves) do
    local pull = {}
    for _, packKey in ipairs(wave.packKeys) do
      for _, spawnKey in ipairs(raid.packs[packKey].spawnKeys) do
        local clone = lookup[spawnKey]
        if clone then
          pull[clone.enemyIdx] = pull[clone.enemyIdx] or {}
          pull[clone.enemyIdx][#pull[clone.enemyIdx] + 1] = clone.cloneIdx
        end
      end
    end
    pulls[waveIndex] = pull
  end
  preset.value.pulls = pulls
  preset.value.currentPull = math.min(math.max(preset.value.currentPull or 1, 1), #pulls)
  preset.value.selection = { preset.value.currentPull }
  preset.value.artWaveRaid = raid.key
end

local function selectShell(raidKey, db)
  local shellIndex = SHELL_INDICES[raidKey]
  if not shellIndex then return nil, "unknown raid" end
  db.currentDungeonIdx = shellIndex
  db.selectedDungeonList = 1
  return shellIndex
end

local function publishRaidList(db)
  MDT.seasonList[1] = L["Raid Planner"]
  MDT.dungeonSelectionToIndex[1] = {
    SHELL_INDICES["gruuls-lair"], SHELL_INDICES["black-temple"], SHELL_INDICES.hyjal,
    SHELL_INDICES.karazhan, SHELL_INDICES["magtheridons-lair"],
    SHELL_INDICES["serpentshrine-cavern"], SHELL_INDICES["the-eye"],
    SHELL_INDICES["sunwell-plateau"],
  }
  if not MDT.dungeonMaps[db.currentDungeonIdx] then selectShell(DEFAULT_RAID_KEY, db) end
  if db.currentSection == nil or db.currentSection == "raids" then db.currentSection = "maps" end
  db.selectedDungeonList = 1
end

local function raidKeyForShell(shellIndex)
  for raidKey, candidate in pairs(SHELL_INDICES) do
    if candidate == shellIndex then return raidKey end
  end
end

local function wireMapSelection()
  if Integration.originalUpdateToDungeon or type(MDT.UpdateToDungeon) ~= "function" then return end
  Integration.originalUpdateToDungeon = MDT.UpdateToDungeon
  function MDT:UpdateToDungeon(dungeonIdx, ...)
    if self.unsupportedDungeons[dungeonIdx] then return nil, "unsupported-raid" end
    local result = Integration.originalUpdateToDungeon(self, dungeonIdx, ...)
    local raidKey = raidKeyForShell(dungeonIdx)
    if raidKey and (not Integration.planner.raid or Integration.planner.raid.key ~= raidKey) then
      self:OpenRaidRoute(raidKey)
    end
    return result
  end
end

function Integration:Initialize()
  if self.initialized then return self end

  local static = ART.StaticData or {}
  local registry = ART.RaidRegistry.new({ diagnostics = function(reason) diagnose(reason) end })
  local raids, maps = {}, {}
  for _, raidKey in ipairs(RAID_KEYS) do
    local raid = static.raids and static.raids[raidKey]
    if type(raid) ~= "table" then return diagnose("missing-raid-data:"..raidKey) end
    local registered, reason = registry:Register(raid)
    if not registered then return diagnose(reason) end
    local map = ART.MapDefinitions and ART.MapDefinitions[raidKey]
    local transform = ART.MapTransforms and ART.MapTransforms[raidKey]
    local mapOK, mapReason = validateMap(raid, map, transform)
    if not mapOK then return diagnose(mapReason..":"..raidKey) end
    raids[raidKey], maps[raidKey] = raid, map
  end

  local routePreset = ART.RoutePreset.new({ registry = registry })
  local db = MDT:GetDB()
  local routeStore = MDT:GetRaidRouteStore()
  self.spawnLookup = {}
  for _, raidKey in ipairs(RAID_KEYS) do publishShellData(raids[raidKey], maps[raidKey]) end
  publishUnsupportedRaids()
  publishRaidList(db)
  local planner

  local function canMarkUnits()
    -- Guarded globals keep the dependency usable in headless test harnesses.
    if not (_G.IsInRaid and _G.IsInRaid()) then return true end
    local leader = _G.UnitIsGroupLeader and _G.UnitIsGroupLeader("player")
    local assist = _G.UnitIsGroupAssistant and _G.UnitIsGroupAssistant("player")
    return (leader or assist) == true
  end

  local function markedStep()
    local currentPreset = MDT:GetCurrentPreset()
    local assignments = currentPreset and currentPreset.value.enemyAssignments or {}
    local enemies = MDT.dungeonEnemies[db.currentDungeonIdx]
    local step = { id = "preset-marks", label = "Preset marks", packKeys = {}, spawnKeys = {}, marks = {} }
    local seenPacks = {}
    for enemyIdx, enemyMarks in pairs(assignments) do
      local data = enemies and enemies[tonumber(enemyIdx)]
      for cloneIdx, marker in pairs(type(enemyMarks) == "table" and enemyMarks or {}) do
        local clone = data and data.clones and data.clones[tonumber(cloneIdx)]
        marker = tonumber(marker)
        if clone and clone.artSpawnKey and clone.artPackKey and marker
            and marker >= 1 and marker <= 8 and marker % 1 == 0 then
          step.spawnKeys[#step.spawnKeys + 1] = clone.artSpawnKey
          step.marks[clone.artSpawnKey] = marker
          if not seenPacks[clone.artPackKey] then
            seenPacks[clone.artPackKey] = true
            step.packKeys[#step.packKeys + 1] = clone.artPackKey
          end
        end
      end
    end
    table.sort(step.packKeys)
    table.sort(step.spawnKeys)
    return #step.spawnKeys > 0 and step or nil
  end

  local function wireMarks(preset, activeRaid)
    local dependencies = markDependencies(preset, activeRaid or raids[DEFAULT_RAID_KEY], db)
    -- Only raid leaders/assistants may set raid targets inside a raid group.
    dependencies.canMark = canMarkUnits
    -- Map live units onto planned spawn instances (position-first, id fallback).
    dependencies.getSpawnKeyForGuid = function(_, unitToken)
      if not ART.LiveMarks then return nil end
      return ART.LiveMarks:ResolveSpawnKey(unitToken)
    end
    dependencies.allowOutsideActiveStep = true
    dependencies.getSpawnMarker = function(spawnKey)
      local step = markedStep()
      return step and step.marks[spawnKey]
    end
    dependencies.getRouteStep = function(routeStepId)
      local step = planner and planner.GetActiveStep and planner:GetActiveStep()
      if step and step.id == routeStepId then return step end
      for _, routeStep in ipairs(preset and preset.routeSteps or {}) do
        if routeStep.id == routeStepId then return routeStep end
      end
    end
    local resolver = ART.MarkResolver.new(dependencies)
    ART.RaidMarks:Initialize({ resolver = resolver })
    ART.RaidMarks.resolver = resolver
    ART.RaidMarksUI:Initialize({ raidMarks = ART.RaidMarks })
    -- The fresh resolver starts without an active step; restore the planned one.
    local activeStep = planner and planner.GetActiveStep and planner:GetActiveStep()
    if activeStep then ART.RaidMarks:ActivateRouteStep(activeStep.id) end
  end

  local function pullPackKeys(pullIndex)
    local currentPreset = MDT:GetCurrentPreset()
    local pull = currentPreset.value.pulls and currentPreset.value.pulls[pullIndex]
    if type(pull) ~= "table" then return {} end
    local enemies = MDT.dungeonEnemies[db.currentDungeonIdx]
    local packKeys, seen = {}, {}
    for enemyIdx, clones in pairs(pull) do
      -- Pulls carry non-enemy metadata keys; only numeric indexes are enemies.
      local data = tonumber(enemyIdx) and enemies and enemies[tonumber(enemyIdx)]
      if type(clones) == "table" and data then
        for _, cloneIdx in ipairs(clones) do
          local clone = data.clones and data.clones[cloneIdx]
          local packKey = clone and clone.artPackKey
          if packKey and not seen[packKey] then
            seen[packKey] = true
            packKeys[#packKeys + 1] = packKey
          end
        end
      end
    end
    return packKeys
  end

  local function pullStep(pullIndex)
    local currentPreset = MDT:GetCurrentPreset()
    local pull = currentPreset.value.pulls and currentPreset.value.pulls[pullIndex]
    local packKeys = pullPackKeys(pullIndex)
    if type(pull) ~= "table" or #packKeys == 0 then return nil end
    local enemies = MDT.dungeonEnemies[db.currentDungeonIdx]
    local assignments, marks, spawnKeys = currentPreset.value.enemyAssignments or {}, {}, {}
    for enemyIdx, clones in pairs(pull) do
      local index = tonumber(enemyIdx)
      local data = index and enemies and enemies[index]
      local enemyMarks = assignments[enemyIdx] or (index and assignments[index])
      for _, cloneIdx in ipairs(type(clones) == "table" and clones or {}) do
        local clone = data and data.clones and data.clones[cloneIdx]
        local marker = enemyMarks and tonumber(enemyMarks[cloneIdx])
        if clone and clone.artSpawnKey then spawnKeys[#spawnKeys + 1] = clone.artSpawnKey end
        if clone and clone.artSpawnKey and marker and marker >= 1 and marker <= 8 and marker % 1 == 0 then
          marks[clone.artSpawnKey] = marker
        end
      end
    end
    return {
      id = "pull-"..pullIndex, label = "Pull "..pullIndex,
      packKeys = packKeys, spawnKeys = spawnKeys, marks = marks,
    }
  end

  local function persist(preset, activeRaid)
    selectShell(activeRaid.key, db)
    configureWavePulls(activeRaid)
    if activeRaid.mode == "route" and MDT.EnablePullsPerSublevel then MDT:EnablePullsPerSublevel() end
    wireMarks(preset, activeRaid)
    if not routeStore or self.preserveStoredRoutes[activeRaid.key] then return end
    local exported = routePreset:Export(preset, activeRaid)
    if exported then routeStore.presets[activeRaid.key] = exported end
  end

  planner = ART.RaidPlanner:Initialize({
    registry = registry,
    routePreset = routePreset,
    onChange = persist,
    getPullPackKeys = pullPackKeys,
    getPullStep = pullStep,
    getMarkedStep = markedStep,
    getCurrentPullIndex = function() return MDT:GetCurrentPreset().value.currentPull end,
  })
  local raidSelect = ART.RaidSelect:Initialize({ registry = registry, planner = planner })
  wireMarks(nil, raids[DEFAULT_RAID_KEY])

  local enemyInfo
  local enemyOK, enemyResult, enemyReason = pcall(function()
    local repository = ART.EnemyInfoRepository.new()
    for _, raidKey in ipairs(RAID_KEYS) do
      local merged, mergeReason = repository:Merge(repositoryMetadata(raids[raidKey]))
      if not merged then error(mergeReason or "invalid-generated-enemy-info") end
    end
    local enemyData = static.enemyInfo and static.enemyInfo[DEFAULT_RAID_KEY]
    if type(enemyData) ~= "table" or enemyData.raidKey ~= DEFAULT_RAID_KEY then
      diagnose("missing-enemy-info", "enemyInfo")
    else
      local merged, mergeReason = repository:Merge(enemyData)
      if not merged then
        diagnose(mergeReason or "invalid-enemy-info", "enemyInfo")
      end
    end

    local eventFrame = type(CreateFrame) == "function" and CreateFrame("Frame") or nil
    return ART.RaidEnemyInfo:Initialize({
      repository = repository,
      eventFrame = eventFrame,
      getCurrentRaidKey = function()
        return planner.raid and planner.raid.key or raidSelect.selectedRaidKey
      end,
      GetCombatLogEventInfo = function()
        return MDT.Compat:GetCombatLogEventInfo()
      end,
      sourceRef = "combat-log:tbc-anniversary",
    })
  end)
  if enemyOK and enemyResult then
    enemyInfo = enemyResult
  else
    diagnose((enemyOK and enemyReason or enemyResult) or "enemy-info-initialization-failed", "enemyInfo")
  end

  self.registry = registry
  self.routePreset = routePreset
  self.planner = planner
  self.raidSelect = raidSelect
  self.raidMarks = ART.RaidMarks
  self.raidMarksUI = ART.RaidMarksUI
  self.enemyInfo = enemyInfo
  self.maps = ART.MapDefinitions
  self.transforms = ART.MapTransforms
  self.initialized = true
  wireMapSelection()

  local originalSetSelectionToPull = MDT.SetSelectionToPull
  function MDT:SetSelectionToPull(pull, ...)
    local current = self:GetCurrentPreset()
    if current and current.value.artWaveRaid and type(pull) == "number" then
      pull = math.min(math.max(pull, 1), #current.value.pulls)
    end
    local result = originalSetSelectionToPull(self, pull, ...)
    current = self:GetCurrentPreset()
    if current and current.value.artWaveRaid and type(pull) == "number" then
      self:Async(function() self:DungeonEnemies_UpdateEnemiesAsync() end, "ARTWaveSelection", true)
    end
    local step
    if type(pull) == "number" and planner.SyncStepFromPull then step = planner:SyncStepFromPull(pull) end
    if type(pull) == "number" and ART.LiveMarks and ART.LiveMarks.OnPullSelected then
      ART.LiveMarks:OnPullSelected(step or planner:GetActiveStep(), pull)
    end
    return result
  end

  local waveMutators = {
    "AddPull", "ClearPull", "MovePullUp", "MovePullDown", "DeletePull", "ClearPreset",
    "PresetsAddPull", "PresetsDeletePull", "PresetsSwapPulls", "PresetsMergePulls",
    "DungeonEnemies_AddOrRemoveBlipToCurrentPull",
  }
  local explicitPresetArgument = { ClearPreset = 1, PresetsAddPull = 3, PresetsDeletePull = 2 }
  for _, methodName in ipairs(waveMutators) do
    local original = MDT[methodName]
    if type(original) == "function" then
      MDT[methodName] = function(self, ...)
        local target = explicitPresetArgument[methodName] and select(explicitPresetArgument[methodName], ...)
            or self:GetCurrentPreset()
        if target and target.value and target.value.artWaveRaid then
          if methodName == "PresetsMergePulls" then return target.value.currentPull end
          return false, "wave-composition-immutable"
        end
        return original(self, ...)
      end
    end
  end

  local originalImportPreset = MDT.ImportPreset
  if type(originalImportPreset) == "function" then
    function MDT:ImportPreset(preset, ...)
      if preset and preset.value and preset.value.currentDungeonIdx == SHELL_INDICES.hyjal then
        configureWavePulls(raids.hyjal, preset)
      end
      return originalImportPreset(self, preset, ...)
    end
  end

  MDT.RaidRegistry = registry
  MDT.RoutePreset = routePreset
  MDT.RaidPlanner = planner
  MDT.RaidSelect = raidSelect
  MDT.RaidMarks = self.raidMarks
  MDT.RaidMarksUI = self.raidMarksUI
  MDT.RaidEnemyInfo = enemyInfo
  MDT.RaidMaps = self.maps
  MDT.RaidMapTransforms = self.transforms
  local selectedRaidKey = raidKeyForShell(db.currentDungeonIdx)
  if selectedRaidKey then MDT:OpenRaidRoute(selectedRaidKey) end
  return self
end

function MDT:GetRaidIntegration()
  return Integration.initialized and Integration or nil, MDT.RaidIntegrationError
end

function MDT:CreateRaidRoute(raidKey)
  if not Integration.initialized then return nil, MDT.RaidIntegrationError or "not-initialized" end
  raidKey = raidKey or DEFAULT_RAID_KEY
  Integration.preserveStoredRoutes[raidKey] = nil
  Integration.status.storedRoute = nil
  return Integration.raidSelect:Select(raidKey)
end

function MDT:OpenRaidRoute(raidKey)
  if not Integration.initialized then return nil, MDT.RaidIntegrationError or "not-initialized" end
  raidKey = raidKey or DEFAULT_RAID_KEY
  local store = MDT:GetRaidRouteStore()
  local saved = store and store.presets[raidKey]
  if saved ~= nil then
    local preset, reason = Integration.routePreset:Import(saved, Integration.registry)
    if preset and preset.raidKey == raidKey then
      preset, reason = Integration.planner:Import(saved)
      if preset then Integration.status.storedRoute = nil return preset end
    end
    Integration.preserveStoredRoutes[raidKey] = true
    diagnose((preset and "stored-route-raid-mismatch") or reason or "invalid-stored-route", "storedRoute")
  end
  return Integration.raidSelect:Select(raidKey)
end

function MDT:SaveRaidRoute()
  local planner = Integration.planner
  if not planner or not planner.preset or not planner.raid then return nil, "no active preset" end
  local store = self:GetRaidRouteStore()
  if not store then return nil, "route store unavailable" end
  local exported, reason = planner:Export()
  if not exported then return nil, reason end
  Integration.preserveStoredRoutes[planner.raid.key] = nil
  Integration.status.storedRoute = nil
  store.presets[planner.raid.key] = exported
  return exported
end

function MDT:GetRaidMap(raidKey)
  raidKey = raidKey or (Integration.planner and Integration.planner.raid and Integration.planner.raid.key) or DEFAULT_RAID_KEY
  return Integration.maps and Integration.maps[raidKey]
end

function MDT:GetRaidMapTransform(raidKey)
  raidKey = raidKey or (Integration.planner and Integration.planner.raid and Integration.planner.raid.key) or DEFAULT_RAID_KEY
  return Integration.transforms and Integration.transforms[raidKey]
end

function MDT:ActivateRaidRouteStep(routeStepId)
  return Integration.raidMarks and Integration.raidMarks:ActivateRouteStep(routeStepId)
end

function MDT:GetRaidMarkPreview(packKey)
  return Integration.raidMarksUI and Integration.raidMarksUI:GetPreviewForPack(packKey) or {}
end

function MDT:ApplyRaidMark(unitToken)
  if not Integration.raidMarksUI then return false, "not-initialized" end
  return Integration.raidMarksUI:ApplyUnit(unitToken)
end

function MDT:GetRaidEnemyInfo(raidKey, npcId)
  if not Integration.enemyInfo then return nil, "not-initialized" end
  raidKey = raidKey or (Integration.planner and Integration.planner.raid and Integration.planner.raid.key) or DEFAULT_RAID_KEY
  return Integration.enemyInfo:Get(raidKey, npcId)
end

local lastEnemySelector
local lastEnemyNpcId

local function npcIdFromSelector(selector)
  if type(selector) == "table" then
    return tonumber(selector.npcId or selector.id or (selector.data and (selector.data.npcId or selector.data.id)))
  end
  local npcId = tonumber(selector)
  local raidKey = Integration.planner and Integration.planner.raid and Integration.planner.raid.key or DEFAULT_RAID_KEY
  if Integration.enemyInfo and npcId and Integration.enemyInfo:Get(raidKey, npcId) then return npcId end
  local db = MDT:GetDB()
  local enemy = db and MDT.dungeonEnemies and MDT.dungeonEnemies[db.currentDungeonIdx]
      and MDT.dungeonEnemies[db.currentDungeonIdx][npcId]
  return enemy and tonumber(enemy.id)
end

local function ensureEnemyInfoFrame()
  if MDT.RaidEnemyInfoFrame or type(CreateFrame) ~= "function" then return MDT.RaidEnemyInfoFrame end
  local frame = CreateFrame("Frame", "ARTRaidEnemyInfoFrame", MDT.main_frame or UIParent)
  frame:SetSize(360, 180)
  frame:SetPoint("CENTER")
  frame:SetFrameStrata("DIALOG")
  local background = frame:CreateTexture(nil, "BACKGROUND")
  background:SetAllPoints()
  background:SetColorTexture(0.06, 0.06, 0.06, 0.96)
  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.title:SetPoint("TOPLEFT", 16, -16)
  frame.details = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.details:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -12)
  frame.details:SetPoint("RIGHT", -16, 0)
  frame.details:SetJustifyH("LEFT")
  local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -3, -3)
  MDT.RaidEnemyInfoFrame = frame
  return frame
end

function MDT:GetEnemyInfoEnemyIdx()
  return lastEnemySelector
end

function MDT:ShowEnemyInfoFrame(selector)
  lastEnemySelector = selector or lastEnemySelector
  lastEnemyNpcId = npcIdFromSelector(lastEnemySelector) or lastEnemyNpcId
  if not lastEnemyNpcId then return nil, "unknown-enemy" end
  local info, reason = self:GetRaidEnemyInfo(nil, lastEnemyNpcId)
  if not info then return nil, reason end
  local frame = ensureEnemyInfoFrame()
  if frame then
    local name = info.name and info.name.value or L["Unknown enemy"]
    local source = info.maxHealth and info.maxHealth.source or info.name and info.name.source or {}
    local details = { (L["NPC ID: %d"]):format(info.npcId) }
    if info.level and info.creatureType then
      details[#details + 1] = (L["Level %d %s"]):format(info.level.value, L[info.creatureType.value])
    end
    if info.maxHealth then details[#details + 1] = (L["%s HP"]):format(MDT:FormatEnemyHealth(info.maxHealth.value)) end
    details[#details + 1] = (L["Source: %s (%s)"]):format(L[source.source or "-"], L[source.confidence or "-"])
    frame.title:SetText(L[name])
    frame.details:SetText(table.concat(details, "\n"))
    frame:Show()
  end
  return info
end

function MDT:UpdateEnemyInfoFrame(selector)
  if selector ~= nil then lastEnemySelector = selector end
  if not lastEnemySelector and not lastEnemyNpcId then return end
  return self:ShowEnemyInfoFrame(lastEnemySelector or lastEnemyNpcId)
end

local ok, result, reason = pcall(Integration.Initialize, Integration)
if not ok then
  diagnose(result)
elseif not result then
  diagnose(reason or "initialization-failed")
end
