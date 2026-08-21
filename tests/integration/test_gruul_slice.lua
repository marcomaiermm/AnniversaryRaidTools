local root = assert(arg[1])
local mode = arg[2] or "normal"
local function load(path, addon) return assert(loadfile(root..path))("MythicDungeonTools_UI", addon) end

local function read(path)
  local file = assert(io.open(root..path, "rb"))
  local value = file:read("*a")
  file:close()
  return value
end

local loader = read("/Modules/load_modules.xml")
local adapterPosition = assert(loader:find("<Script file='EnemyInfo.lua'/>", 1, true))
local enemyInfoDataPath = [[..\Data\EnemyInfo\GruulsLair.lua]]
local enemyInfoDataPosition = assert(loader:find("<Script file='"..enemyInfoDataPath.."'/>", 1, true))
assert(enemyInfoDataPosition < adapterPosition,
  enemyInfoDataPath..[[ must load before ..\Modules\EnemyInfo.lua]])
for _, raidFile in ipairs({ "GruulsLair.lua", "BlackTemple.lua", "Hyjal.lua" }) do
  for _, producerDir in ipairs({ "Generated", "Maps", "Transforms" }) do
    local path = [[..\Raids\TBC\]]..producerDir..[[\]]..raidFile
    local producerPosition = assert(loader:find("<Script file='"..path.."'/>", 1, true))
    assert(producerPosition < adapterPosition, path.." must load before Modules/EnemyInfo.lua")
  end
end

local localeKeys = { "Black Temple", "Battle for Mount Hyjal", "Karabor Sewers", "Sanctuary of Shadows",
  "Halls of Anguish", "Gorefiend's Vigil", "Den of Mortal Delights", "Chamber of Command",
  "Temple Summit", "Hyjal Summit" }
local enUS, zhCN = read("/Locales/enUS.lua"), read("/Locales/zhCN.lua")
for _, key in ipairs(localeKeys) do
  local assignment = "L["..string.format("%q", key).."]"
  assert(enUS:find(assignment, 1, true) and zhCN:find(assignment, 1, true), "locale parity missing: "..key)
end

_G.ART = { StaticData = { raids = {}, enemyInfo = {} } }
local saved = {
  currentDungeonIdx = 999,
  currentPreset = {},
  currentSection = "maps",
  presets = {},
  focusMarker = { preserveExistingTargetMarkers = true },
}
if mode == "invalid-store" then saved.raidRoutes = "legacy-value" end
if mode == "corrupt-route" then
  saved.raidRoutes = { schemaVersion = 1, presets = { ["gruuls-lair"] = "corrupt-route" } }
end
local addon = {
  ART = _G.ART,
  L = setmetatable({}, { __index = function(_, key) return key end }),
  API = {},
  dungeonEnemies = {},
  dungeonList = {},
  dungeonMaps = {},
  dungeonSubLevels = {},
  dungeonTotalCount = {},
  mapInfo = {},
  mapPOIs = {},
  scaleMultiplier = {},
  zoneIdToDungeonIdx = {},
  knownDungeons = {},
  seasonList = {},
  dungeonSelectionToIndex = {},
  navigationSectionLookup = {},
}
function addon:RegisterNavigationSection(section) self.navigationSectionLookup[section.key] = section return section end
function addon:GetNavigationSection(key) return self.navigationSectionLookup[key] end
function addon:SetCurrentSection(key) saved.currentSection = key end
function addon:GetDefaultMapPanelSize() return 840, 555 end
function addon:UpdateToDungeon(dungeonIdx) saved.currentDungeonIdx = dungeonIdx end
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

load("/Core/SavedVariables.lua", addon)
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
  "/Raids/TBC/Generated/BlackTemple.lua", "/Raids/TBC/Maps/BlackTemple.lua",
  "/Raids/TBC/Transforms/BlackTemple.lua", "/Raids/TBC/Generated/Hyjal.lua",
  "/Raids/TBC/Maps/Hyjal.lua", "/Raids/TBC/Transforms/Hyjal.lua",
}) do load(path, addon) end
assert(_G.ART.StaticData.raids["gruuls-lair"] and _G.ART.StaticData.raids["black-temple"]
  and _G.ART.StaticData.raids.hyjal and _G.ART.StaticData.enemyInfo["gruuls-lair"])
if mode == "missing-enemy" then _G.ART.StaticData.enemyInfo["gruuls-lair"] = nil end
if mode == "invalid-enemy" then _G.ART.StaticData.enemyInfo["gruuls-lair"].source.confidence = "verified" end
load("/Modules/EnemyInfo.lua", addon)

local integration = assert(addon:GetRaidIntegration())
assert(integration == integration:Initialize())
assert(addon.RaidRegistry:Get("gruuls-lair"))
assert(addon.RaidRegistry:Get("black-temple") and addon.RaidRegistry:Get("hyjal"))
assert(addon:GetRaidMap().mapId == 565)
assert(saved.currentDungeonIdx == 160 and saved.currentSection == "maps")
assert(addon.dungeonMaps[160][1] == "GruulsLair1_" and addon.dungeonSubLevels[160][1] == "Gruul's Lair")
assert(addon.seasonList[1] == "Raid Planner")
assert(#addon.dungeonSelectionToIndex[1] == 3 and addon.dungeonSelectionToIndex[1][1] == 160
  and addon.dungeonSelectionToIndex[1][2] == 161 and addon.dungeonSelectionToIndex[1][3] == 162)
assert(addon.dungeonMaps[161][1] == "BlackTemple1_" and addon.dungeonMaps[161][7] == "BlackTemple7_")
assert(#addon.dungeonSubLevels[161] == 7 and addon.dungeonSubLevels[161][7] == "Temple Summit")
assert(addon.dungeonMaps[162][1] == "CoTMountHyjal" and addon.dungeonSubLevels[162][1] == "Hyjal Summit")
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
for _, enemy in ipairs(addon.dungeonEnemies[160]) do
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
  for _, enemy in ipairs(addon.dungeonEnemies[shellIndex]) do
    spawns = spawns + #enemy.clones
    for _, clone in ipairs(enemy.clones) do if clone.patrol then patrols = patrols + 1 end end
  end
  return spawns, patrols
end
local btSpawns, btPatrols = projectedCounts(161)
local hyjalSpawns, hyjalPatrols = projectedCounts(162)
assert(btSpawns == 626 and btPatrols == 88)
assert(hyjalSpawns == 421 and hyjalPatrols == 396)
for _, shellIndex in ipairs({ 161, 162 }) do
  for _, enemy in ipairs(addon.dungeonEnemies[shellIndex]) do
    assert(enemy.displayId and enemy.displayId > 0, "missing pinned display ID for NPC "..enemy.id)
  end
end
local function enemyById(shellIndex, npcId)
  for _, enemy in ipairs(addon.dungeonEnemies[shellIndex]) do if enemy.id == npcId then return enemy end end
end
local najentus, battlelord = assert(enemyById(161, 22887)), assert(enemyById(161, 22844))
local archimonde, ghoul = assert(enemyById(162, 17968)), assert(enemyById(162, 17895))
assert(najentus.isBoss and najentus.displayId == 21174)
assert(not battlelord.isBoss and battlelord.displayId == 21115 and battlelord.displayId ~= najentus.displayId)
assert(archimonde.isBoss and archimonde.displayId == 20939)
assert(not ghoul.isBoss and ghoul.displayId == 571 and ghoul.displayId ~= archimonde.displayId)
assert(addon:GetRaidMap("black-temple").mapId == 564 and addon:GetRaidMapTransform("black-temple").raidKey == "black-temple")
assert(addon:GetRaidMap("hyjal").mapId == 534 and addon:GetRaidMapTransform("hyjal").raidKey == "hyjal")

addon:UpdateToDungeon(161)
assert(saved.currentDungeonIdx == 161 and addon.RaidPlanner.raid.key == "black-temple")
assert(addon:CreateRaidRoute("black-temple"))
assert(saved.currentDungeonIdx == 161 and addon.RaidPlanner.raid.key == "black-temple")
local blackTemple = addon.RaidRegistry:Get("black-temple")
local blackTemplePack = next(blackTemple.packs)
assert(integration.planner:AddRouteStep({ label = "Black Temple", packKeys = { blackTemplePack } }))
local blackTempleExport = assert(addon:SaveRaidRoute())
assert(addon:CreateRaidRoute("hyjal"))
assert(saved.currentDungeonIdx == 162 and addon.RaidPlanner.raid.key == "hyjal")
assert(#addon.RaidPlanner.preset.routeSteps == 37)
assert(not integration.planner:AddRouteStep({ label = "immutable", packKeys = {} }))
assert(not addon:GetRaidEnemyInfo("hyjal", 17767))
local hyjalExport = assert(addon:SaveRaidRoute())

saved.raidRoutes.presets["black-temple"] = hyjalExport
saved.raidRoutes.presets.hyjal = "hyjal-original"
assert(addon:OpenRaidRoute("black-temple"))
assert(addon.RaidPlanner.raid.key == "black-temple" and saved.currentDungeonIdx == 161)
assert(integration.status.storedRoute == "stored-route-raid-mismatch")
assert(saved.raidRoutes.presets["black-temple"] == hyjalExport)
assert(saved.raidRoutes.presets.hyjal == "hyjal-original")

assert(addon:OpenRaidRoute("gruuls-lair"))
assert(saved.currentDungeonIdx == 160 and addon.RaidPlanner.raid.key == "gruuls-lair")
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
addon.RaidPlanner.preset.marking.npcDefaults[18831] = { 1 }
assert(integration.planner:ReorderRouteStep(addon.RaidPlanner.preset.routeSteps[2].id, 1))
local maulgarStep = addon.RaidPlanner.preset.routeSteps[2]
assert(addon:ActivateRaidRouteStep(maulgarStep.id))
local preview = addon:GetRaidMarkPreview("gruuls-lair:pack:maulgar")
assert(preview[1] and preview[1].marker == 1)
assert(addon:ApplyRaidMark("target"))
assert(addon.applied and addon.applied[1] == "target" and addon.applied[2] == 1)
assert(addon:SaveRaidRoute())
local exported = assert(addon.RaidPlanner:Export())
assert(saved.raidRoutes.presets["gruuls-lair"] == exported)
assert(addon.RaidPlanner:Import(exported))
assert(addon.RaidPlanner:Export() == exported)

if mode == "missing-enemy" or mode == "invalid-enemy" then
  assert(integration.status.enemyInfo)
  assert(not addon:GetRaidEnemyInfo("gruuls-lair", 18831))
  assert(not addon:ShowEnemyInfoFrame({ npcId = 18831 }))
  print("ART-070 optional enemy info degradation: ok")
  return
end

local info = assert(addon:GetRaidEnemyInfo("gruuls-lair", 18831))
assert(info.name.source.source == "azerothcore" and info.name.source.confidence == "candidate")
local combatFrame
for _, frame in ipairs(eventFrames) do if frame.event == "COMBAT_LOG_EVENT_UNFILTERED" then combatFrame = frame end end
assert(combatFrame and combatFrame.scripts.OnEvent)
combatFrame.scripts.OnEvent(combatFrame, "COMBAT_LOG_EVENT_UNFILTERED")
local observed = assert(addon:GetRaidEnemyInfo("gruuls-lair", 18831))
assert(observed.spells[33152].events.SPELL_CAST_START == 1)
assert(observed.spells[33152].source.source == "live-observed")
print("ART-070 vertical slice UI: ok")
