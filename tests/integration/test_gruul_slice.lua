local root = assert(arg[1])
local mode = arg[2] or "normal"
local function load(path, addon) return assert(loadfile(root..path))("AnniversaryRaidTools_UI", addon) end

local function read(path)
  local file = assert(io.open(root..path, "rb"))
  local value = file:read("*a")
  file:close()
  return value
end

local loader = read("/Modules/load_modules.xml")
local resolverPosition = assert(loader:find("<Script file='..\\Core\\MarkResolver.lua'/>", 1, true))
local autoMarksUIPosition = assert(loader:find("<Script file='AutoMarksUI.lua'/>", 1, true))
local liveMarksPosition = assert(loader:find("<Script file='LiveMarks.lua'/>", 1, true))
assert(resolverPosition < liveMarksPosition and autoMarksUIPosition < liveMarksPosition,
  "mark resolver and Auto Marks UI must load before LiveMarks.lua")
local autoMarksUISource = read("/Modules/AutoMarksUI.lua")
assert(autoMarksUISource:find('L["Pulls"]', 1, true)
  and autoMarksUISource:find('L["Auto Marks"]', 1, true)
  and autoMarksUISource:find("PullButtonScrollGroup", 1, true)
  and autoMarksUISource:find("SetNpcDefaultMark", 1, true),
  "Auto Marks must reuse the pull side panel and persist NPC defaults")
local adapterPosition = assert(loader:find("<Script file='EnemyInfo.lua'/>", 1, true))
local uiPosition = assert(loader:find("<Script file='EnemyInfoUI.lua'/>", 1, true))
assert(adapterPosition < uiPosition, "EnemyInfoUI.lua must replace the fallback frame after raid data publication")
local enemyInfoUI = read("/Modules/EnemyInfoUI.lua")
assert(enemyInfoUI:find("data.characteristics", 1, true)
  and enemyInfoUI:find("data.spells", 1, true)
  and enemyInfoUI:find('AceGUI:Create("ARTSpellButton")', 1, true),
  "restored Enemy Info UI must render projected characteristics and spells")
local spellWidget = read("/AceGUIWidgets/AceGUIWidget-AnniversaryRaidToolsSpellButton.lua")
assert(spellWidget:find('self.expandVertical:SetShown(not self.expanded)', 1, true)
  and spellWidget:find('self.descriptionText:SetShown(self.expanded)', 1, true)
  and spellWidget:find('self.expandToggle:SetShown(not not self.description)', 1, true)
  and spellWidget:find('self.parent:DoLayout()', 1, true),
  "spell descriptions must expand below the compact spell row")
local enemyInfoSource = read("/Modules/EnemyInfo.lua")
assert(enemyInfoSource:find("appendMapLinks", 1, true)
  and enemyInfoSource:find('arrowAtlas = "Garr_LevelUpgradeArrow"', 1, true)
  and enemyInfoSource:find('type = "mapLink"', 1, true),
  "raid floors must publish configured map links as clickable transition arrows")
local enemyInfoDataPath = [[..\Data\EnemyInfo\GruulsLair.lua]]
local enemyInfoDataPosition = assert(loader:find("<Script file='"..enemyInfoDataPath.."'/>", 1, true))
assert(enemyInfoDataPosition < adapterPosition,
  enemyInfoDataPath..[[ must load before ..\Modules\EnemyInfo.lua]])
local previousProducerPosition, producerCount, producerPaths = 0, 0, {}
for _, raidFile in ipairs({ "GruulsLair.lua", "BlackTemple.lua", "Hyjal.lua", "MagtheridonsLair.lua" }) do
  for _, producerDir in ipairs({ "Generated", "Maps", "Transforms" }) do
    local path = [[..\Raids\TBC\]]..producerDir..[[\]]..raidFile
    local producerPosition = assert(loader:find("<Script file='"..path.."'/>", 1, true))
    assert(producerPosition < adapterPosition, path.." must load before Modules/EnemyInfo.lua")
    assert(not producerPaths[path], "duplicate producer path: "..path)
    assert(producerPosition > previousProducerPosition, "global producer load order: "..path)
    producerPaths[path], previousProducerPosition, producerCount = true, producerPosition, producerCount + 1
  end
end
assert(producerCount == 12)
local worldPositionPath = [[..\Raids\TBC\Generated\BlackTempleWorldPositions.lua]]
local worldPositionPosition = assert(loader:find("<Script file='"..worldPositionPath.."'/>", 1, true))
assert(worldPositionPosition < adapterPosition, worldPositionPath.." must load before Modules/EnemyInfo.lua")

local localeKeys = { "Black Temple", "Battle for Mount Hyjal", "Karabor Sewers", "Illidari Training Grounds", "Sanctuary of Shadows",
  "Halls of Anguish", "Gorefiend's Vigil", "Den of Mortal Delights", "Chamber of Command",
  "Temple Summit", "Hyjal Summit", "Karazhan", "Servant's Quarters", "Upper Livery Stables",
  "The Banquet Hall", "The Guest Chambers", "Opera Hall Balcony", "Master's Terrace",
  "Lower Broken Stair", "Upper Broken Stair", "The Menagerie", "Guardian's Library",
  "The Repository", "Upper Library", "The Celestial Watch", "Gamesman's Hall",
  "Medivh's Chambers", "The Power Station", "Netherspace", "Magtheridon's Lair" }
local enUS, zhCN = read("/Locales/enUS.lua"), read("/Locales/zhCN.lua")
for _, key in ipairs(localeKeys) do
  local assignment = "L["..string.format("%q", key).."]"
  assert(enUS:find(assignment, 1, true) and zhCN:find(assignment, 1, true), "locale parity missing: "..key)
end

local saved = {
  currentRaidIndex = 999,
  currentPreset = {},
  currentSection = "maps",
  presets = {},
}
if mode == "invalid-store" then saved.raidRoutes = "legacy-value" end
if mode == "corrupt-route" then
  saved.raidRoutes = { schemaVersion = 1, presets = { ["gruuls-lair"] = "corrupt-route" } }
end
local addon = {
  StaticData = { raids = {}, enemyInfo = {} },
  L = setmetatable({}, { __index = function(_, key) return key end }),
  API = {},
  raidEnemies = {},
  raidList = {},
  raidMaps = {},
  raidFloors = {},
  mapInfo = {},
  mapPOIs = {},
  scaleMultiplier = {},
  zoneIdToRaidIndex = {},
  knownRaids = {},
  navigationSectionLookup = {},
}
_G.ART = addon
function addon:RegisterNavigationSection(section) self.navigationSectionLookup[section.key] = section return section end
function addon:GetNavigationSection(key) return self.navigationSectionLookup[key] end
function addon:SetCurrentSection(key) saved.currentSection = key end
function addon:GetDefaultMapPanelSize() return 840, 555 end
function addon:FormatEnemyHealth(amount) return tostring(amount) end
function addon:UpdateToRaid(raidIndex) saved.currentRaidIndex = raidIndex end
function addon:GetCurrentPreset()
  local raid = saved.currentRaidIndex
  saved.currentPreset[raid] = saved.currentPreset[raid] or 1
  saved.presets[raid] = saved.presets[raid] or { { value = { pulls = { {} }, currentPull = 1, selection = { 1 } } } }
  return saved.presets[raid][saved.currentPreset[raid]]
end
function addon:SetSelectionToPull(pull) self:GetCurrentPreset().value.currentPull = pull end
function addon:ImportPreset(preset) self.importedPreset = preset return true end
for _, methodName in ipairs({
    "AddPull", "ClearPull", "MovePullUp", "MovePullDown", "DeletePull", "ClearPreset",
    "PresetsAddPull", "PresetsDeletePull", "PresetsSwapPulls", "PresetsMergePulls",
    "RaidEnemies_AddOrRemoveBlipToCurrentPull",
  }) do
  addon[methodName] = function() return true end
end
function addon:Async(callback) callback() end
function addon:RaidEnemies_UpdateEnemiesAsync() self.waveRefreshes = (self.waveRefreshes or 0) + 1 end
LibStub = function(name) assert(name == "AceDB-3.0"); return { New = function() return { global = saved } end } end
ReloadUI = function() end

local function region()
  local value = {}
  for _, name in ipairs({ "ClearAllPoints", "SetAllPoints", "SetColorTexture", "SetPoint", "SetJustifyH", "SetWidth", "SetSize", "SetFrameStrata", "SetTexCoord", "SetVertexColor", "Show", "Hide" }) do
    value[name] = function() end
  end
  function value:SetTexture(texture) self.texture = texture end
  function value:SetText(text) self.text = text end
  function value:SetScript(event, callback) self.scripts = self.scripts or {}; self.scripts[event] = callback end
  function value:CreateTexture() return region() end
  function value:CreateFontString() return region() end
  function value:RegisterEvent(event) self.event = event end
  function value:UnregisterEvent(event) if self.event == event then self.event = nil end end
  return value
end
local eventFrames = {}
CreateFrame = function() local frame = region(); eventFrames[#eventFrames + 1] = frame; return frame end
SetRaidTarget = function(unit, marker) addon.applied = { unit, marker } return true end
UnitGUID = function() return "Creature-0-0-0-0-18831-0000000001" end
UnitExists = function() return true end
UnitCanAttack = function() return true end
UnitIsDeadOrGhost = function() return false end
GetRaidTargetIndex = function() return 0 end
CombatLogGetCurrentEventInfo = function()
  return 1, "SPELL_CAST_START", false,
    "Creature-0-0-0-0-18831-0000000001", "Maulgar", 0, 0,
    nil, nil, 0, 0, 33152
end
UIParent = region()
CreateVector2D = function(x, y) return { x = x, y = y } end
local hyjalMapProjectionCalls = 0
C_Map = {
  GetMapPosFromWorldPos = function(instanceId, worldPosition, uiMapId)
    if instanceId == 534 then
      assert(uiMapId == 329)
      hyjalMapProjectionCalls = hyjalMapProjectionCalls + 1
      return uiMapId, { x = 0.050998, y = 0.750242 }
    end
    if instanceId == 532 then
      assert(uiMapId >= 350 and uiMapId <= 366)
      return uiMapId, { x = 0.25, y = 0.75 }
    end
    if instanceId == 548 then assert(uiMapId == 332) end
    if instanceId == 550 then assert(uiMapId == 334) end
    if instanceId == 580 then assert(uiMapId == 335 or uiMapId == 336) end
    assert(instanceId == 564 or instanceId == 548 or instanceId == 550 or instanceId == 580)
    return uiMapId, { x = worldPosition.x / 1000, y = worldPosition.y / 1200 }
  end,
}

load("/Core/SavedVariables.lua", addon)
assert(addon:GetDefaultSavedVariables().global.autoMark == false, "auto marking must default to disabled")
assert(addon:GetDefaultSavedVariables().global.autoMarkModifier == "ALT", "auto marking must default to Alt")
if mode == "invalid-store" then
  assert(saved.raidRoutes == "legacy-value" and addon:GetRaidRouteStore() == nil)
else
  assert(type(saved.raidRoutes) == "table" and saved.raidRoutes.schemaVersion == 1)
  assert(addon:GetRaidRouteStore() == saved.raidRoutes)
end
load("/Core/Compat.lua", addon)

for _, path in ipairs({
  "/Core/RaidRegistry.lua", "/Core/RoutePreset.lua", "/Core/EnemyInfoRepository.lua", "/Core/MarkResolver.lua",
  "/Developer/RaidRecorder.lua", "/Modules/RaidPlanner.lua", "/Modules/RaidSelect.lua",
  "/Modules/RaidMarks.lua", "/Modules/RaidMarksUI.lua", "/Modules/RaidEnemyInfo.lua",
  "/Raids/TBC/Generated/GruulsLair.lua", "/Raids/TBC/Maps/GruulsLair.lua",
  "/Raids/TBC/Transforms/GruulsLair.lua", "/Data/EnemyInfo/GruulsLair.lua",
  "/Raids/TBC/Generated/BlackTemple.lua", "/Raids/TBC/Generated/BlackTempleWorldPositions.lua",
  "/Raids/TBC/Maps/BlackTemple.lua",
  "/Raids/TBC/Transforms/BlackTemple.lua", "/Raids/TBC/Generated/Hyjal.lua",
  "/Raids/TBC/Generated/HyjalWorldPositions.lua",
  "/Raids/TBC/Maps/Hyjal.lua", "/Raids/TBC/Transforms/Hyjal.lua",
  "/Raids/TBC/Generated/MagtheridonsLair.lua",
  "/Raids/TBC/Maps/MagtheridonsLair.lua", "/Raids/TBC/Transforms/MagtheridonsLair.lua",
  "/Raids/TBC/Generated/SerpentshrineCavern.lua", "/Raids/TBC/Generated/SerpentshrineCavernWorldPositions.lua",
  "/Raids/TBC/Maps/SerpentshrineCavern.lua", "/Raids/TBC/Transforms/SerpentshrineCavern.lua",
  "/Raids/TBC/Generated/TheEye.lua", "/Raids/TBC/Generated/TheEyeWorldPositions.lua",
  "/Raids/TBC/Maps/TheEye.lua", "/Raids/TBC/Transforms/TheEye.lua",
}) do load(path, addon) end
assert(_G.ART.StaticData.raids["gruuls-lair"] and _G.ART.StaticData.raids["black-temple"]
  and _G.ART.StaticData.raids.hyjal and not _G.ART.StaticData.raids.karazhan
  and _G.ART.StaticData.raids["magtheridons-lair"]
  and _G.ART.StaticData.raids["serpentshrine-cavern"] and _G.ART.StaticData.raids["the-eye"]
  and not _G.ART.StaticData.raids["sunwell-plateau"] and _G.ART.StaticData.enemyInfo["gruuls-lair"])
for _, raid in pairs(_G.ART.StaticData.raids) do
  for _, floorPOIs in pairs(raid.pois or {}) do
    for _, poi in ipairs(floorPOIs) do
      local assignment = "L["..string.format("%q", poi.label).."]"
      assert(enUS:find(assignment, 1, true) and zhCN:find(assignment, 1, true), "POI locale parity missing: "..poi.label)
    end
  end
end
if mode == "missing-enemy" then _G.ART.StaticData.enemyInfo["gruuls-lair"] = nil end
if mode == "invalid-enemy" then _G.ART.StaticData.enemyInfo["gruuls-lair"].source.confidence = "verified" end
load("/Modules/EnemyInfo.lua", addon)

local integration = assert(addon:GetRaidIntegration())
assert(integration == integration:Initialize())
assert(addon.RaidRegistry:Get("gruuls-lair"))
assert(addon.RaidRegistry:Get("black-temple") and addon.RaidRegistry:Get("hyjal"))
assert(not addon.RaidRegistry:Get("karazhan") and addon.RaidRegistry:Get("magtheridons-lair"))
assert(addon.RaidRegistry:Get("serpentshrine-cavern") and addon.RaidRegistry:Get("the-eye"))
assert(not addon.RaidRegistry:Get("sunwell-plateau"))
assert(addon:GetRaidMap().mapId == 565)
assert(saved.currentRaidIndex == 160 and saved.currentSection == "maps")
assert(addon.raidMaps[160][1] == "GruulsLair1_" and addon.raidFloors[160][1] == "Gruul's Lair")
assert(#addon.raidOrder == 8 and addon.raidOrder[1] == 160 and addon.raidOrder[8] == 167)
assert(addon.raidMaps[161][1] == "BlackTemple1_" and addon.raidMaps[161][8] == "BlackTemple7_")
assert(type(addon.raidMaps[161][2]) == "table"
  and addon.raidMaps[161][2].customTextures:match("BlackTempleTrainingGrounds$"))
assert(#addon.raidFloors[161] == 8 and addon.raidFloors[161][2] == "Illidari Training Grounds"
  and addon.raidFloors[161][8] == "Temple Summit")
for sublevel, uiMapId in ipairs({ 340, 339, 341, 342, 343, 344, 345, 346 }) do
  assert(addon.zoneIdToRaidIndex[uiMapId] == 161 and addon.zoneIdToSublevel[uiMapId] == sublevel,
    "Black Temple UiMap floor lookup missing")
end
assert(#addon.mapPOIs[161][1] == 1 and #addon.mapPOIs[161][2] == 2
  and #addon.mapPOIs[161][3] == 4 and #addon.mapPOIs[161][4] == 1
  and #addon.mapPOIs[161][5] == 1 and #addon.mapPOIs[161][6] == 2
  and #addon.mapPOIs[161][7] == 2 and #addon.mapPOIs[161][8] == 1
  and addon.mapPOIs[161][3][1].type == "mapLink"
  and addon.mapPOIs[161][3][1].target == 6 and addon.mapPOIs[161][3][1].direction == 1
  and addon.mapPOIs[161][3][1].arrowAtlas == "Garr_LevelUpgradeArrow"
  and addon.mapPOIs[161][3][1].arrowRotation == math.pi)
assert(addon.raidMaps[162][1] == "CoTMountHyjal" and addon.raidFloors[162][1] == "Hyjal Summit")
assert(addon.raidMaps[163] == nil and addon.raidMaps[167] == nil)
assert(addon.unsupportedRaids[163] == "Not supported yet."
  and addon.unsupportedRaids[167] == "Not supported yet.")
assert(addon.raidList[163] == "Karazhan" and addon.raidList[167] == "Sunwell Plateau")
for shellIndex, loadingScreen in pairs({
    [160] = "LoadScreenGruulsLair", [161] = "LoadScreenBlackTemple", [162] = "LoadScreenHyjal",
    [163] = "LoadScreenKarazhan", [164] = "LoadScreenHellfireCitadelRaid",
    [165] = "LoadScreenCoilfang", [166] = "LoadScreenTempestKeep", [167] = "LoadScreenSunwell",
  }) do
  local mapInfo = addon.mapInfo[shellIndex]
  assert(mapInfo.iconId == "Interface\\Glues\\LoadingScreens\\"..loadingScreen)
  assert(mapInfo.iconTexCoords[1] == 0.12 and mapInfo.iconTexCoords[2] == 0.88
    and mapInfo.iconTexCoords[3] == 0.30 and mapInfo.iconTexCoords[4] == 0.92)
end
assert(addon.raidMaps[164][1] == "MagtheridonsLair1_"
  and addon.raidFloors[164][1] == "Magtheridon's Lair")
assert(addon.raidMaps[165][1] == "CoilfangReservoir1_" and addon.raidMaps[166][1] == "TempestKeep1_")
assert(not addon:GetNavigationSection("raids"))

if mode == "invalid-store" then
  assert(addon:CreateRaidRoute("black-temple") and addon.RaidPlanner.raid.key == "black-temple")
  assert(addon:OpenRaidRoute("hyjal") and addon.RaidPlanner.raid.key == "hyjal")
  local exported, reason = addon:SaveRaidRoute()
  assert(exported == nil and reason == "route store unavailable" and saved.raidRoutes == "legacy-value")
  print("ART-090 invalid route-store degradation: ok")
  return
end

local cloneCount, patrolCount, gruulClone, gruulDisplayId, gruulCreatureType, entrancePatrol = 0, 0
for _, enemy in ipairs(addon.raidEnemies[160]) do
  cloneCount = cloneCount + #enemy.clones
  for _, clone in ipairs(enemy.clones) do
    if clone.patrol then patrolCount = patrolCount + 1 end
    if clone.artSpawnKey == "gruuls-lair:spawn:19389:entrance-brute" then entrancePatrol = clone.patrol end
  end
  if enemy.id == 19044 then
    gruulClone, gruulDisplayId, gruulCreatureType = enemy.clones[1], enemy.displayId, enemy.creatureType
  end
end
assert(cloneCount == 18 and patrolCount == 3 and gruulClone and gruulDisplayId == 18698 and gruulCreatureType == "Humanoid")
assert(math.abs(gruulClone.x - (0.199 * 840)) < 0.001)
assert(math.abs(gruulClone.y + (0.283 * 555)) < 0.001)
assert(#entrancePatrol == 6)
assert(math.abs(entrancePatrol[1].x - (0.675152 * 840)) < 0.001)
assert(math.abs(entrancePatrol[1].y + (0.764071 * 555)) < 0.001)
local x, y = addon:GetRaidMapTransform().toPlanner(565, 1, 0.199, 0.283)
assert(x == 0.199 and y == 0.283)

local function projectedCounts(shellIndex)
  local spawns, patrols = 0, 0
  for _, enemy in ipairs(addon.raidEnemies[shellIndex]) do
    spawns = spawns + #enemy.clones
    for _, clone in ipairs(enemy.clones) do if clone.patrol then patrols = patrols + 1 end end
  end
  return spawns, patrols
end
local btSpawns, btPatrols = projectedCounts(161)
local hyjalSpawns, hyjalPatrols = projectedCounts(162)
local magtheridonSpawns, magtheridonPatrols = projectedCounts(164)
local sscSpawns, sscPatrols = projectedCounts(165)
local eyeSpawns, eyePatrols = projectedCounts(166)
assert(btSpawns == 626 and btPatrols == 88)
local hiddenSkyStalkers = 0
for _, enemy in ipairs(addon.raidEnemies[161]) do
  for _, clone in ipairs(enemy.clones) do
    if clone.hidden then hiddenSkyStalkers = hiddenSkyStalkers + 1 end
  end
end
assert(hiddenSkyStalkers == 6)
assert(hyjalSpawns == 421 and hyjalPatrols == 396)
assert(magtheridonSpawns == 18 and magtheridonPatrols == 3)
assert(sscSpawns == 194 and sscPatrols == 66)
assert(eyeSpawns == 187 and eyePatrols == 14)
for _, shellIndex in ipairs({ 160, 161, 162, 164, 165, 166 }) do
  for _, enemy in ipairs(addon.raidEnemies[shellIndex]) do
    assert(enemy.displayId and enemy.displayId > 0, "missing pinned display ID for NPC "..enemy.id)
    assert(enemy.health and enemy.health > 1, "missing AzerothCore health for NPC "..enemy.id)
    assert(enemy.level and enemy.level >= 70, "missing AzerothCore level for NPC "..enemy.id)
    assert(type(enemy.creatureType) == "string" and enemy.creatureType ~= "",
      "missing AzerothCore creature type for NPC "..enemy.id)
    assert(enemy.scale and enemy.scale > 0, "missing AzerothCore scale for NPC "..enemy.id)
  end
end
local function enemyById(shellIndex, npcId)
  for _, enemy in ipairs(addon.raidEnemies[shellIndex]) do if enemy.id == npcId then return enemy end end
end
local najentus, battlelord = assert(enemyById(161, 22887)), assert(enemyById(161, 22844))
local feralSpirit = assert(enemyById(161, 22849))
local archimonde, ghoul = assert(enemyById(162, 17968)), assert(enemyById(162, 17895))
local gruul, lairBrute = assert(enemyById(160, 19044)), assert(enemyById(160, 19389))
local magtheridon, channeler = assert(enemyById(164, 17257)), assert(enemyById(164, 17256))
assert(najentus.isBoss and najentus.displayId == 21174)
-- Black Temple uses the pinned map transform instead of the incompatible
-- Anniversary C_Map projection mocked above.
assert(math.abs(najentus.clones[1].x - (0.428721 * 840)) < 0.001)
assert(math.abs(najentus.clones[1].y + (0.191523 * 555)) < 0.001)
assert(not battlelord.isBoss and battlelord.displayId == 21115 and battlelord.displayId ~= najentus.displayId)
assert(feralSpirit.stealthDetect and not feralSpirit.spells[18950])
assert(archimonde.isBoss and archimonde.displayId == 20939)
assert(not ghoul.isBoss and ghoul.displayId == 571 and ghoul.displayId ~= archimonde.displayId)
assert(math.abs(ghoul.clones[1].patrol[1].x - (0.050998 * 840)) < 0.001,
  "Hyjal patrols must project CMaNGOS world positions onto the mirrored client map")
assert(hyjalMapProjectionCalls == 0, "Hyjal must not depend on client map projection orientation")
assert(gruul.isBoss and gruul.displayId == 18698)
assert(gruul.health == 3414600 and gruul.level == 73 and gruul.creatureType == "Humanoid")
assert(gruul.spells[33525] and not gruul.spells[33525].interruptible and gruul.spells[36300]
  and next(gruul.characteristics) == nil)
local olm = assert(enemyById(160, 18834))
assert(olm.spells[33129] and olm.spells[33131] and not olm.spells[33131].interruptible)
local krosh = assert(enemyById(160, 18836))
assert(krosh.characteristics.Stun and krosh.spells[33144].interruptible)
assert(not lairBrute.isBoss and lairBrute.displayId == 18356)
assert(lairBrute.health == 298298 and lairBrute.level == 72)
assert(magtheridon.isBoss and magtheridon.displayId == 18527)
assert(not channeler.isBoss and channeler.displayId == 9865)
for _, enemy in ipairs(addon.raidEnemies[164]) do
  assert(enemy.isBoss == (enemy.id == 17257), "Magtheridon boss classification: "..enemy.id)
end
assert(addon:GetRaidMap("black-temple").mapId == 564 and addon:GetRaidMapTransform("black-temple").raidKey == "black-temple")
assert(addon:GetRaidMap("hyjal").mapId == 534 and addon:GetRaidMapTransform("hyjal").raidKey == "hyjal")
assert(addon:GetRaidMap("karazhan") == nil and addon:GetRaidMapTransform("karazhan") == nil)
assert(addon:GetRaidMap("magtheridons-lair").mapId == 544
  and addon:GetRaidMapTransform("magtheridons-lair").raidKey == "magtheridons-lair")
assert(addon:GetRaidMap("serpentshrine-cavern").mapId == 548
  and addon:GetRaidMapTransform("serpentshrine-cavern").raidKey == "serpentshrine-cavern")
assert(addon:GetRaidMap("the-eye").mapId == 550 and addon:GetRaidMap("sunwell-plateau") == nil)

assert(#addon.mapPOIs[164][1] == 1 and addon.mapPOIs[164][1][1].type == "generalNote")
local blackTempleMapLinks = { 1, 2, 4, 1, 1, 2, 2, 1 }
for raidKey, shellIndex in pairs({ ["gruuls-lair"] = 160, ["black-temple"] = 161, hyjal = 162,
    ["magtheridons-lair"] = 164, ["serpentshrine-cavern"] = 165,
    ["the-eye"] = 166 }) do
  local raid = addon.RaidRegistry:Get(raidKey)
  for sublevel = 1, #raid.sublevels do
    local sourcePOIs, projectedPOIs = raid.pois[sublevel] or {}, addon.mapPOIs[shellIndex][sublevel]
    local mapLinks = raidKey == "black-temple" and blackTempleMapLinks[sublevel] or 0
    assert(#projectedPOIs == #sourcePOIs + mapLinks)
    for index, poi in ipairs(sourcePOIs) do
      local projected = projectedPOIs[index]
      assert(projected.template == "MapLinkPinTemplate" and projected.type == "generalNote"
        and projected.text == poi.label)
      assert(math.abs(projected.x - (poi.x * 840)) < 0.001)
      assert(math.abs(projected.y + (poi.y * 555)) < 0.001)
    end
  end
end
local currentRaid = addon.RaidPlanner.raid.key
local selected, reason = addon:UpdateToRaid(163)
assert(selected == nil and reason == "unsupported-raid" and saved.currentRaidIndex == 160
  and addon.RaidPlanner.raid.key == currentRaid)
selected, reason = addon:UpdateToRaid(167)
assert(selected == nil and reason == "unsupported-raid" and saved.currentRaidIndex == 160
  and addon.RaidPlanner.raid.key == currentRaid)
addon:UpdateToRaid(164)
assert(saved.currentRaidIndex == 164 and addon.RaidPlanner.raid.key == "magtheridons-lair")
addon:UpdateToRaid(161)
assert(saved.currentRaidIndex == 161 and addon.RaidPlanner.raid.key == "black-temple")
assert(addon:CreateRaidRoute("black-temple"))
assert(saved.currentRaidIndex == 161 and addon.RaidPlanner.raid.key == "black-temple")
local blackTemple = addon.RaidRegistry:Get("black-temple")
local blackTemplePack = "black-temple:pack:group-5640046"
assert(blackTemple.packs[blackTemplePack])
assert(integration.planner:AddRouteStep({ label = "Black Temple", packKeys = { blackTemplePack } }))
local blackTempleExport = assert(addon:SaveRaidRoute())
assert(addon:CreateRaidRoute("hyjal"))
assert(saved.currentRaidIndex == 162 and addon.RaidPlanner.raid.key == "hyjal")
assert(#addon.RaidPlanner.preset.routeSteps == 37)
assert(#addon:GetCurrentPreset().value.pulls == 37 and addon:GetCurrentPreset().value.artWaveRaid == "hyjal")
for _, methodName in ipairs({
    "AddPull", "ClearPull", "MovePullUp", "MovePullDown", "DeletePull", "ClearPreset",
    "PresetsAddPull", "PresetsDeletePull", "PresetsSwapPulls",
    "RaidEnemies_AddOrRemoveBlipToCurrentPull",
  }) do
  assert(not addon[methodName](addon), methodName.." mutated immutable Hyjal waves")
end
assert(addon:PresetsMergePulls() == 1, "blocked wave merge returned an invalid selection")
local function pullSignature(pull)
  local signature = {}
  for enemyIdx, clones in pairs(pull) do
    if type(enemyIdx) == "number" then
      for _, cloneIdx in ipairs(clones) do signature[#signature + 1] = enemyIdx..":"..cloneIdx end
    end
  end
  table.sort(signature)
  return table.concat(signature, ",")
end
local hyjal = addon.RaidRegistry:Get("hyjal")
for waveIndex, wave in ipairs(hyjal.waves) do
  local expected = {}
  for _, packKey in ipairs(wave.packKeys) do
    for _, spawnKey in ipairs(hyjal.packs[packKey].spawnKeys) do
      local clone = integration.spawnLookup.hyjal[spawnKey]
      expected[clone.enemyIdx] = expected[clone.enemyIdx] or {}
      expected[clone.enemyIdx][#expected[clone.enemyIdx] + 1] = clone.cloneIdx
    end
  end
  assert(pullSignature(addon:GetCurrentPreset().value.pulls[waveIndex]) == pullSignature(expected),
    "Hyjal wave projection mismatch: "..wave.waveKey)
end
local importedHyjal = { value = { currentRaidIndex = 162, pulls = { {} }, currentPull = 99 } }
assert(addon:ImportPreset(importedHyjal) and addon.importedPreset == importedHyjal)
assert(#importedHyjal.value.pulls == 37 and importedHyjal.value.currentPull == 37
  and importedHyjal.value.artWaveRaid == "hyjal")
addon:SetSelectionToPull(99)
assert(addon:GetCurrentPreset().value.currentPull == 37)
addon:SetSelectionToPull(2)
assert(addon:GetCurrentPreset().value.currentPull == 2 and addon.waveRefreshes == 2)
addon.RaidPlanner.lastPullIndex = 1
addon:SetSelectionToPull(2, nil, true)
assert(addon.RaidPlanner.lastPullIndex == 1, "passive map refresh must not advance the planner pull")
assert(not integration.planner:AddRouteStep({ label = "immutable", packKeys = {} }))
local winterchillInfo = assert(addon:GetRaidEnemyInfo("hyjal", 17767))
assert(winterchillInfo.maxHealth.value == 4249000 and winterchillInfo.level.value == 73
  and winterchillInfo.creatureType.value == "Undead")
local hyjalExport = assert(addon:SaveRaidRoute())

assert(not addon:ClearPreset(importedHyjal, true))
assert(addon:CreateRaidRoute("magtheridons-lair"))
assert(saved.currentRaidIndex == 164 and addon.RaidPlanner.raid.key == "magtheridons-lair")
assert(addon.RaidPlanner.lastPullIndex == nil, "raid changes must discard the previous raid's pull index")
local encounterPack = "magtheridons-lair:pack:magtheridon-encounter"
local encounterSpawnKeys = addon.RaidRegistry:Get("magtheridons-lair").packs[encounterPack].spawnKeys
for index, expected in ipairs({
    "magtheridons-lair:spawn:17256:guid-5440003",
    "magtheridons-lair:spawn:17256:guid-5440004",
    "magtheridons-lair:spawn:17256:guid-5440005",
    "magtheridons-lair:spawn:17256:guid-5440006",
    "magtheridons-lair:spawn:17256:guid-5440007",
    "magtheridons-lair:spawn:17257:guid-5440008",
  }) do assert(encounterSpawnKeys[index] == expected) end
assert(#encounterSpawnKeys == 6)
local channelerLookup = assert(integration.spawnLookup["magtheridons-lair"][encounterSpawnKeys[1]])
local outsideLookup = assert(integration.spawnLookup["magtheridons-lair"][encounterSpawnKeys[2]])
local magtheridonPreset = addon:GetCurrentPreset()
magtheridonPreset.value.pulls[1] = { [channelerLookup.enemyIdx] = { channelerLookup.cloneIdx } }
magtheridonPreset.value.enemyAssignments = {
  [channelerLookup.enemyIdx] = { [channelerLookup.cloneIdx] = 8, [outsideLookup.cloneIdx] = 7 },
}
addon:SetSelectionToPull(1)
local plannedPull = assert(addon.RaidPlanner:GetActiveStep(), "planned pull must be active without routeSteps")
assert(#addon.RaidPlanner.preset.routeSteps == 0, "planned pull must not duplicate routeSteps")
assert(plannedPull.packKeys[1] == encounterPack and plannedPull.marks[encounterSpawnKeys[1]] == 8,
  "planned pull must expose pre-pull marks by stable spawn key")
assert(#plannedPull.spawnKeys == 1 and plannedPull.spawnKeys[1] == encounterSpawnKeys[1],
  "planned pull must expose its configured spawn membership")
assert(integration.planner:AddRouteStep({ label = "Magtheridon", packKeys = { encounterPack } }))
local magtheridonExport = assert(addon:SaveRaidRoute())
assert(addon:OpenRaidRoute("magtheridons-lair") and addon.RaidPlanner.raid.key == "magtheridons-lair")
assert(addon.RaidPlanner:Export() == magtheridonExport)
assert(addon:OpenRaidRoute("magtheridons-lair") and addon.RaidPlanner:Export() == magtheridonExport)
assert(saved.raidRoutes.presets["magtheridons-lair"] == magtheridonExport)

saved.raidRoutes.presets["black-temple"] = hyjalExport
saved.raidRoutes.presets.hyjal = "hyjal-original"
assert(addon:OpenRaidRoute("black-temple"))
assert(addon.RaidPlanner.raid.key == "black-temple" and saved.currentRaidIndex == 161)
assert(integration.status.storedRoute == "stored-route-raid-mismatch")
assert(saved.raidRoutes.presets["black-temple"] == hyjalExport)
assert(saved.raidRoutes.presets.hyjal == "hyjal-original")
assert(saved.raidRoutes.presets["magtheridons-lair"] == magtheridonExport)

assert(addon:OpenRaidRoute("gruuls-lair"))
assert(saved.currentRaidIndex == 160 and addon.RaidPlanner.raid.key == "gruuls-lair")
assert(blackTempleExport ~= hyjalExport and saved.raidRoutes.presets["black-temple"] == hyjalExport)
assert(saved.raidRoutes.presets.hyjal == "hyjal-original")

if mode == "corrupt-route" then
  assert(saved.raidRoutes.presets["gruuls-lair"] == "corrupt-route")
  assert(integration.status.storedRoute)
  assert(integration.planner:AddRouteStep({ label = "High King Maulgar", packKeys = { "gruuls-lair:pack:maulgar" } }))
  assert(saved.raidRoutes.presets["gruuls-lair"] == "corrupt-route")
  assert(addon:SaveRaidRoute())
  assert(saved.raidRoutes.presets["gruuls-lair"] ~= "corrupt-route")
  print("ART-070 corrupt route fallback: ok")
  return
end

assert(integration.planner:AddRouteStep({ label = "High King Maulgar", packKeys = { "gruuls-lair:pack:maulgar" } }))
assert(integration.planner:AddRouteStep({ label = "Gruul the Dragonkiller", packKeys = { "gruuls-lair:pack:gruul" } }))
assert(#addon.RaidPlanner.preset.routeSteps == 2)
assert(addon.RaidPlanner:SetNpcDefaultMark(18831, 1) == 1)
assert(addon.RaidPlanner:GetNpcDefaultMark(18831) == 1)
assert(integration.planner:ReorderRouteStep(addon.RaidPlanner.preset.routeSteps[2].id, 1))
local maulgarStep = addon.RaidPlanner.preset.routeSteps[2]
assert(addon:ActivateRaidRouteStep(maulgarStep.id))
local preview = addon:GetRaidMarkPreview("gruuls-lair:pack:maulgar")
assert(preview[1] and preview[1].marker == 1)
local applied, reason = addon:ApplyRaidMark("target")
assert(applied == false and reason == "mouseover-only", "public application is mouseover-only")
assert(addon:SaveRaidRoute())
local exported = assert(addon.RaidPlanner:Export())
assert(saved.raidRoutes.presets["gruuls-lair"] == exported)
assert(addon.RaidPlanner:Import(exported))
assert(addon.RaidPlanner:Export() == exported)

if mode == "missing-enemy" or mode == "invalid-enemy" then
  assert(integration.status.enemyInfo)
  local fallback = assert(addon:GetRaidEnemyInfo("gruuls-lair", 18831))
  assert(fallback.maxHealth.value == 758800 and fallback.level.value == 73)
  print("ART-070 optional enemy info degradation: ok")
  return
end

local info = assert(addon:GetRaidEnemyInfo("gruuls-lair", 18831))
assert(info.name.source.source == "azerothcore" and info.name.source.confidence == "candidate")
assert(info.maxHealth.value == 758800 and info.level.value == 73 and info.creatureType.value == "Humanoid")
assert(addon:ShowEnemyInfoFrame({ npcId = 18831 }))
assert(addon.RaidEnemyInfoFrame.details.text:find("Level 73 Humanoid", 1, true)
  and addon.RaidEnemyInfoFrame.details.text:find("758800 HP", 1, true))
local combatFrame
for _, frame in ipairs(eventFrames) do if frame.event == "COMBAT_LOG_EVENT_UNFILTERED" then combatFrame = frame end end
assert(combatFrame and combatFrame.scripts.OnEvent)
combatFrame.scripts.OnEvent(combatFrame, "COMBAT_LOG_EVENT_UNFILTERED")
local observed = assert(addon:GetRaidEnemyInfo("gruuls-lair", 18831))
assert(observed.spells[33152].events.SPELL_CAST_START == 1)
assert(observed.spells[33152].source.source == "live-observed")
print("ART-070 vertical slice UI: ok")
