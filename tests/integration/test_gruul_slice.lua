local root = assert(arg[1])
local mode = arg[2] or "normal"
local function load(path, addon) return assert(loadfile(root..path))("MythicDungeonTools_UI", addon) end

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
  print("ART-070 invalid migration preservation: ok")
  return
end
assert(type(saved.raidRoutes) == "table" and saved.raidRoutes.schemaVersion == 1)
assert(addon:GetRaidRouteStore() == saved.raidRoutes)
load("/Core/Compat.lua", addon)

for _, path in ipairs({
  "/Core/RaidRegistry.lua", "/Core/RoutePreset.lua", "/Core/EnemyInfoRepository.lua", "/Core/MarkResolver.lua",
  "/Developer/RaidRecorder.lua", "/Modules/RaidPlanner.lua", "/Modules/RaidSelect.lua",
  "/Modules/RaidMarks.lua", "/Modules/RaidMarksUI.lua", "/Modules/RaidEnemyInfo.lua",
  "/Raids/TBC/Generated/GruulsLair.lua", "/Raids/TBC/Maps/GruulsLair.lua",
  "/Raids/TBC/Transforms/GruulsLair.lua", "/Data/EnemyInfo/GruulsLair.lua",
}) do load(path, addon) end
assert(_G.ART.StaticData.raids["gruuls-lair"] and _G.ART.StaticData.enemyInfo["gruuls-lair"])
if mode == "missing-enemy" then _G.ART.StaticData.enemyInfo["gruuls-lair"] = nil end
if mode == "invalid-enemy" then _G.ART.StaticData.enemyInfo["gruuls-lair"].source.confidence = "verified" end
load("/Modules/EnemyInfo.lua", addon)

local integration = assert(addon:GetRaidIntegration())
assert(integration == integration:Initialize())
assert(addon.RaidRegistry:Get("gruuls-lair"))
assert(addon:GetRaidMap().mapId == 565)
assert(saved.currentDungeonIdx == 160 and saved.currentSection == "maps")
assert(addon.dungeonMaps[160][1] == "GruulsLair1_" and addon.dungeonSubLevels[160][1] == "Gruul's Lair")
assert(not addon:GetNavigationSection("raids"))
local cloneCount, gruulClone, gruulDisplayId, gruulCreatureType, entrancePatrol = 0
for _, enemy in ipairs(addon.dungeonEnemies[160]) do
  cloneCount = cloneCount + #enemy.clones
  for _, clone in ipairs(enemy.clones) do
    if clone.artSpawnKey == "gruuls-lair:spawn:19389:entrance-brute" then entrancePatrol = clone.patrol end
  end
  if enemy.id == 19044 then
    gruulClone, gruulDisplayId, gruulCreatureType = enemy.clones[1], enemy.displayId, enemy.creatureType
  end
end
assert(cloneCount == 18 and gruulClone and gruulDisplayId == 18698 and gruulCreatureType == "Humanoid")
assert(math.abs(gruulClone.x - (0.199 * 840)) < 0.001)
assert(math.abs(gruulClone.y + (0.283 * 555)) < 0.001)
assert(#entrancePatrol == 6)
assert(math.abs(entrancePatrol[1].x - (0.675152 * 840)) < 0.001)
assert(math.abs(entrancePatrol[1].y + (0.764071 * 555)) < 0.001)
local x, y = addon:GetRaidMapTransform().toPlanner(565, 1, 0.199, 0.283)
assert(x == 0.199 and y == 0.283)

assert(addon:OpenRaidRoute("gruuls-lair"))
assert(addon.RaidPlanner.raid.key == "gruuls-lair")

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
