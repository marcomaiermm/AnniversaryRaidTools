-- Made by Nnoggie, 2017-2025
-- Multi-raid registration and sourced enemy-info UI adapter.

local _, MDT = ...
local ART = assert(rawget(_G, "ART"), "AnniversaryRaidTools bootstrap is required")
local L = MDT.L

local DEFAULT_RAID_KEY = "gruuls-lair"
local RAID_KEYS = { "gruuls-lair", "black-temple", "hyjal" }
local SHELL_INDICES = { ["gruuls-lair"] = 160, ["black-temple"] = 161, hyjal = 162 }
-- Gruul display IDs are retained from the accepted vertical slice; Black Temple
-- and Hyjal use the first CMaNGOS TBC DisplayId at tbc-db@7060a217.
local DISPLAY_IDS = {
  [18831] = 18649, [18832] = 20194, [18834] = 20195, [18835] = 12472,
  [18836] = 11585, [19044] = 18698, [19389] = 18356, [21350] = 20241,
  [17767] = 17444, [17808] = 21069, [17842] = 18526, [17888] = 17886,
  [17895] = 571, [17897] = 17308, [17898] = 12818, [17899] = 17537,
  [17905] = 8783, [17906] = 17311, [17907] = 16919, [17908] = 14520,
  [17916] = 17321, [17968] = 20939, [22841] = 21357, [22844] = 21115,
  [22845] = 21116, [22846] = 21118, [22847] = 21117, [22848] = 5187,
  [22849] = 21114, [22853] = 11335, [22855] = 19991, [22856] = 21146,
  [22869] = 21120, [22871] = 21262, [22873] = 21159, [22874] = 21161,
  [22875] = 21162, [22876] = 21164, [22877] = 21165, [22878] = 20609,
  [22879] = 21369, [22880] = 21367, [22882] = 21373, [22883] = 5492,
  [22884] = 17528, [22885] = 21457, [22887] = 21174, [22898] = 21145,
  [22917] = 21135, [22939] = 21449, [22945] = 21372, [22946] = 14334,
  [22947] = 21252, [22948] = 21443, [22949] = 21416, [22950] = 21417,
  [22951] = 21419, [22952] = 21418, [22953] = 21151, [22954] = 18753,
  [22955] = 21452, [22956] = 21456, [22957] = 21503, [22959] = 21530,
  [22960] = 21216, [22962] = 21502, [22963] = 21535, [22964] = 19199,
  [22965] = 21196, [23018] = 21378, [23028] = 21538, [23030] = 21543,
  [23047] = 21383, [23049] = 21380, [23147] = 21375, [23172] = 20381,
  [23196] = 21490, [23222] = 21549, [23223] = 21284, [23232] = 21355,
  [23235] = 21555, [23236] = 21553, [23237] = 21552, [23239] = 21550,
  [23330] = 21546, [23337] = 18251, [23339] = 11342, [23374] = 21442,
  [23394] = 21460, [23397] = 21560, [23398] = 1126, [23399] = 16255,
  [23400] = 21564, [23401] = 21587, [23402] = 21468, [23403] = 21568,
}
-- Encounter actors from mangos-tbc@adbc7f74 ScriptDevAI Black Temple and Hyjal scripts.
-- Anything not explicitly listed is trash, even when it has only one spawn.
local BOSS_NPCS = {
  ["gruuls-lair"] = { [18831] = true, [18832] = true, [18834] = true, [18835] = true,
    [18836] = true, [19044] = true },
  ["black-temple"] = { [22841] = true, [22856] = true, [22871] = true, [22887] = true,
    [22898] = true, [22917] = true, [22947] = true, [22948] = true, [22949] = true,
    [22950] = true, [22951] = true, [22952] = true },
  hyjal = { [17767] = true, [17808] = true, [17842] = true, [17888] = true, [17968] = true },
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
      name = localize(enemy.name),
      id = enemy.npcId,
      count = 0,
      health = 1,
      level = 73,
      creatureType = "Humanoid",
      scale = 1,
      isBoss = BOSS_NPCS[raid.key] and BOSS_NPCS[raid.key][enemy.npcId] or false,
      displayId = DISPLAY_IDS[enemy.npcId],
      clones = clones,
    }
  end
  return enemies, spawnLookup
end

local function publishShellData(raid, map)
  local shellIndex = SHELL_INDICES[raid.key]
  local dungeonMaps, sublevels, tileFormat, pois = {}, {}, {}, {}
  dungeonMaps[0] = map.sublevels[1].asset.textureFolder
  for index, sublevel in ipairs(map.sublevels) do
    local asset = sublevel.asset
    dungeonMaps[index] = asset.texturePrefix
        or (asset.noFloorPrefix and (asset.tilePrefix or asset.textureFolder))
        or asset.textureFolder..index.."_"
    sublevels[index], tileFormat[index], pois[index] = localize(sublevel.name), 4, {}
  end
  MDT.dungeonList[shellIndex] = localize(raid.name)
  MDT.mapInfo[shellIndex] = {
    shortName = localize(raid.name), englishName = raid.name, mapID = raid.mapId, tileFormat = tileFormat,
  }
  MDT.dungeonMaps[shellIndex] = dungeonMaps
  MDT.dungeonSubLevels[shellIndex] = sublevels
  MDT.dungeonTotalCount[shellIndex] = { normal = 0 }
  Integration.spawnLookup[raid.key] = {}
  MDT.dungeonEnemies[shellIndex], Integration.spawnLookup[raid.key] = projectRaidEnemies(raid)
  MDT.mapPOIs[shellIndex] = pois
  MDT.scaleMultiplier[shellIndex] = 1
  MDT.zoneIdToDungeonIdx[raid.mapId] = shellIndex
  MDT.knownDungeons[shellIndex] = raid.name
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
  publishRaidList(db)
  local planner

  local function wireMarks(preset, activeRaid)
    local resolver = ART.MarkResolver.new(markDependencies(preset, activeRaid or raids[DEFAULT_RAID_KEY], db))
    ART.RaidMarks:Initialize({ resolver = resolver })
    ART.RaidMarks.resolver = resolver
    ART.RaidMarksUI:Initialize({ raidMarks = ART.RaidMarks })
  end

  local function persist(preset, activeRaid)
    selectShell(activeRaid.key, db)
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
  wireMarks(nil, raids[DEFAULT_RAID_KEY])

  local enemyInfo
  local enemyOK, enemyResult, enemyReason = pcall(function()
    local repository = ART.EnemyInfoRepository.new()
    local enemyData = static.enemyInfo and static.enemyInfo[DEFAULT_RAID_KEY]
    if type(enemyData) ~= "table" or enemyData.raidKey ~= DEFAULT_RAID_KEY then
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
  wireMapSelection()

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
