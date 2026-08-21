-- Made by Nnoggie, 2017-2025
-- Gruul vertical-slice registration and sourced enemy-info UI adapter.

local _, MDT = ...
local ART = assert(rawget(_G, "ART"), "AnniversaryRaidTools bootstrap is required")
local L = MDT.L

local RAID_KEY = "gruuls-lair"
local SHELL_INDEX = 160
-- AzerothCore creature_template_model at 015976f5298ad374c4e6f8a8d22665946cb4ec32.
local DISPLAY_IDS = {
  [18831] = 18649, [18832] = 20194, [18834] = 20195, [18835] = 12472,
  [18836] = 11585, [19044] = 18698, [19389] = 18356, [21350] = 20241,
}
local Integration = ART.GruulsLairIntegration or { diagnostics = {}, status = {}, preserveStoredRoutes = {} }
ART.GruulsLairIntegration = Integration

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

local function projectRaidEnemies(raid)
  local canvasWidth, canvasHeight = MDT:GetDefaultMapPanelSize()
  local npcKeys, packGroups, packKeys = {}, {}, {}
  for npcKey in pairs(raid.enemies) do npcKeys[#npcKeys + 1] = npcKey end
  for packKey in pairs(raid.packs) do packKeys[#packKeys + 1] = packKey end
  table.sort(npcKeys)
  table.sort(packKeys)
  for index, packKey in ipairs(packKeys) do packGroups[packKey] = index end

  local enemies, spawnLookup = {}, {}
  for enemyIdx, npcKey in ipairs(npcKeys) do
    local enemy, clones = raid.enemies[npcKey], {}
    for cloneIdx, spawn in ipairs(enemy.spawns) do
      local patrol
      if spawn.patrol then
        patrol = {}
        for pointIdx, point in ipairs(spawn.patrol) do
          patrol[pointIdx] = { x = point.x * canvasWidth, y = -point.y * canvasHeight }
        end
      end
      clones[cloneIdx] = {
        x = spawn.x * canvasWidth,
        y = -spawn.y * canvasHeight,
        sublevel = spawn.sublevel,
        g = packGroups[spawn.packKey],
        patrol = patrol,
        artSpawnKey = spawn.key,
        artPackKey = spawn.packKey,
      }
      spawnLookup[spawn.key] = { enemyIdx = enemyIdx, cloneIdx = cloneIdx, packKey = spawn.packKey }
    end
    enemies[enemyIdx] = {
      name = L[enemy.name],
      id = enemy.npcId,
      count = 0,
      health = 1,
      level = 73,
      creatureType = "Humanoid",
      scale = 1,
      isBoss = npcKey ~= "19389" and npcKey ~= "21350",
      displayId = DISPLAY_IDS[enemy.npcId],
      clones = clones,
    }
  end
  return enemies, spawnLookup
end

local function publishShellData(raid, map, db)
  local textureFolder = map.sublevels[1].asset.textureFolder
  MDT.dungeonList[SHELL_INDEX] = L[raid.name]
  MDT.mapInfo[SHELL_INDEX] = {
    shortName = L[raid.name], englishName = raid.name, mapID = raid.mapId, tileFormat = { [1] = 4 },
  }
  MDT.dungeonMaps[SHELL_INDEX] = { [0] = textureFolder, [1] = textureFolder.."1_" }
  MDT.dungeonSubLevels[SHELL_INDEX] = { [1] = L[map.sublevels[1].name] }
  MDT.dungeonTotalCount[SHELL_INDEX] = { normal = 0 }
  MDT.dungeonEnemies[SHELL_INDEX], Integration.spawnLookup = projectRaidEnemies(raid)
  MDT.mapPOIs[SHELL_INDEX] = { [1] = {} }
  MDT.scaleMultiplier[SHELL_INDEX] = 1
  MDT.zoneIdToDungeonIdx[raid.mapId] = SHELL_INDEX
  MDT.knownDungeons[SHELL_INDEX] = raid.name
  MDT.seasonList[1] = L["Raid Planner"]
  MDT.dungeonSelectionToIndex[1] = { SHELL_INDEX }
  if not MDT.dungeonMaps[db.currentDungeonIdx] then db.currentDungeonIdx = SHELL_INDEX end
  if db.currentSection == nil or db.currentSection == "raids" then db.currentSection = "maps" end
  db.selectedDungeonList = 1
end

function Integration:Initialize()
  if self.initialized then return self end

  local static = ART.StaticData or {}
  local raid = static.raids and static.raids[RAID_KEY]
  local enemyData = static.enemyInfo and static.enemyInfo[RAID_KEY]
  if type(raid) ~= "table" then return diagnose("missing-raid-data") end

  local registry = ART.RaidRegistry.new({ diagnostics = function(reason) diagnose(reason) end })
  local registered, reason = registry:Register(raid)
  if not registered then return diagnose(reason) end

  local map = ART.MapDefinitions and ART.MapDefinitions[RAID_KEY]
  local transform = ART.MapTransforms and ART.MapTransforms[RAID_KEY]
  local mapOK, mapReason = validateMap(raid, map, transform)
  if not mapOK then return diagnose(mapReason) end

  local routePreset = ART.RoutePreset.new({ registry = registry })
  local db = MDT:GetDB()
  local routeStore = MDT:GetRaidRouteStore()
  publishShellData(raid, map, db)
  local planner

  local function wireMarks(preset, activeRaid)
    local resolver = ART.MarkResolver.new(markDependencies(preset, activeRaid or raid, db))
    ART.RaidMarks:Initialize({ resolver = resolver })
    ART.RaidMarks.resolver = resolver
    ART.RaidMarksUI:Initialize({ raidMarks = ART.RaidMarks })
  end

  local function persist(preset, activeRaid)
    wireMarks(preset, activeRaid)
    if not routeStore or self.preserveStoredRoutes[activeRaid.key] then return end
    local exported = routePreset:Export(preset, activeRaid)
    if exported then routeStore.presets[activeRaid.key] = exported end
  end

  planner = ART.RaidPlanner:Initialize({
    registry = registry,
    routePreset = routePreset,
    onChange = persist,
  })
  local raidSelect = ART.RaidSelect:Initialize({ registry = registry, planner = planner })
  wireMarks(nil, raid)

  local enemyInfo
  local enemyOK, enemyResult, enemyReason = pcall(function()
    local repository = ART.EnemyInfoRepository.new()
    if type(enemyData) ~= "table" or enemyData.raidKey ~= RAID_KEY then
      diagnose("missing-enemy-info", "enemyInfo")
    else
      local merged, mergeReason = repository:Merge(enemyData)
      if not merged then
        diagnose(mergeReason or "invalid-enemy-info", "enemyInfo")
        repository = ART.EnemyInfoRepository.new()
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

  MDT.RaidRegistry = registry
  MDT.RoutePreset = routePreset
  MDT.RaidPlanner = planner
  MDT.RaidSelect = raidSelect
  MDT.RaidMarks = self.raidMarks
  MDT.RaidMarksUI = self.raidMarksUI
  MDT.RaidEnemyInfo = enemyInfo
  MDT.RaidMaps = self.maps
  MDT.RaidMapTransforms = self.transforms
  return self
end

function MDT:GetRaidIntegration()
  return Integration.initialized and Integration or nil, MDT.RaidIntegrationError
end

function MDT:CreateRaidRoute(raidKey)
  if not Integration.initialized then return nil, MDT.RaidIntegrationError or "not-initialized" end
  raidKey = raidKey or RAID_KEY
  Integration.preserveStoredRoutes[raidKey] = nil
  Integration.status.storedRoute = nil
  return Integration.raidSelect:Select(raidKey)
end

function MDT:OpenRaidRoute(raidKey)
  if not Integration.initialized then return nil, MDT.RaidIntegrationError or "not-initialized" end
  raidKey = raidKey or RAID_KEY
  local store = MDT:GetRaidRouteStore()
  local saved = store and store.presets[raidKey]
  if saved ~= nil then
    local preset, reason = Integration.planner:Import(saved)
    if preset then Integration.status.storedRoute = nil return preset end
    Integration.preserveStoredRoutes[raidKey] = true
    diagnose(reason or "invalid-stored-route", "storedRoute")
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
  return Integration.maps and Integration.maps[raidKey or RAID_KEY]
end

function MDT:GetRaidMapTransform(raidKey)
  return Integration.transforms and Integration.transforms[raidKey or RAID_KEY]
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
  return Integration.enemyInfo:Get(raidKey or RAID_KEY, npcId)
end

local lastEnemySelector
local lastEnemyNpcId

local function npcIdFromSelector(selector)
  if type(selector) == "table" then
    return tonumber(selector.npcId or selector.id or (selector.data and (selector.data.npcId or selector.data.id)))
  end
  local npcId = tonumber(selector)
  if Integration.enemyInfo and npcId and Integration.enemyInfo:Get(RAID_KEY, npcId) then return npcId end
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
  local info, reason = self:GetRaidEnemyInfo(RAID_KEY, lastEnemyNpcId)
  if not info then return nil, reason end
  local frame = ensureEnemyInfoFrame()
  if frame then
    local name = info.name and info.name.value or L["Unknown enemy"]
    local source = info.name and info.name.source or {}
    frame.title:SetText(L[name])
    frame.details:SetText((L["NPC ID: %d"]):format(info.npcId).."\n"..
      (L["Source: %s (%s)"]):format(L[source.source or "-"], L[source.confidence or "-"]))
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
