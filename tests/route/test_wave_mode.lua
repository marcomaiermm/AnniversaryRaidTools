local root = arg and arg[1] or "."
local ART = {
  StaticData = { raids = {} },
  L = setmetatable({}, { __index = function(_, key) return key end }),
}
_G.ART = ART

local map = assert(loadfile(root.."/Raids/TBC/Maps/Hyjal.lua"))("AnniversaryRaidTools", ART)
local raid = assert(loadfile(root.."/Raids/TBC/Generated/Hyjal.lua"))("AnniversaryRaidTools_UI", ART)
local preset = { routeSteps = {} }
for index, wave in ipairs(raid.waves) do
  preset.routeSteps[index] = { id = "wave-"..index, waveKey = wave.waveKey, packKeys = wave.packKeys, marks = {} }
end

ART.RaidPlanner = {
  raid = raid,
  preset = preset,
  GetStepNpcMarks = function() return {} end,
}
local current = { value = { currentPull = 1, artWaveRaid = "hyjal" } }
local instanceId, widgetText = 534, "Wave 1/8"
function GetInstanceInfo() return "Battle for Mount Hyjal", "raid", 1, "", 25, 0, false, instanceId end
C_UIWidgetManager = {
  GetTextWithStateWidgetVisualizationInfo = function(widgetId)
    assert(widgetId == 3121, "Hyjal runtime reads the Classic wave widget")
    return { shownState = 0, text = widgetText }
  end,
}
ART.mapInfo = { [162] = { mapID = 534 } }
function ART:GetDB() return { currentRaidIndex = 162 } end
function ART:GetCurrentPreset() return current end
function ART:GetDefaultMapPanelSize() return 1000, 1000 end
function ART:SetSelectionToPull(index) current.value.currentPull = index end
function ART:UpdateMap() end
function ART:MakePullSelectionButtons() end
local runtimeFrame = { events = {} }
function runtimeFrame:RegisterEvent(event) self.events[event] = true end
function runtimeFrame:UnregisterEvent(event) self.events[event] = nil end
function runtimeFrame:SetScript(_, callback) self.onEvent = callback end
function CreateFrame() return runtimeFrame end

ART.raidEnemies = { [162] = {} }
ART.MultiRaidIntegration = { spawnLookup = { hyjal = {} } }
local enemyIdx = 0
for _, enemy in pairs(raid.enemies) do
  enemyIdx = enemyIdx + 1
  local clones = {}
  ART.raidEnemies[162][enemyIdx] = { clones = clones }
  for cloneIdx, spawn in ipairs(enemy.spawns) do
    local patrol = {}
    for _, point in ipairs(spawn.patrol or {}) do
      patrol[#patrol + 1] = { x = (1 - point.x) * 1000, y = -point.y * 1000 }
    end
    ART.MultiRaidIntegration.spawnLookup.hyjal[spawn.key] = { enemyIdx = enemyIdx, cloneIdx = cloneIdx }
    clones[cloneIdx] = { patrol = patrol }
  end
end
for _, spawn in ipairs(raid.enemies["17895"].spawns) do
  local reference = ART.MultiRaidIntegration.spawnLookup.hyjal[spawn.key]
  ART.raidEnemies[162][reference.enemyIdx].clones[reference.cloneIdx].patrol = {
    { x = 61, y = -742 }, { x = 118, y = -681 },
  }
end

assert(loadfile(root.."/Modules/WaveModeUI.lua"))("AnniversaryRaidTools", ART)
local ui = ART.WaveModeUI
assert(ui:IsActive(), "Hyjal wave mode activates from raid mode and map metadata")
assert(runtimeFrame.events.COMBAT_LOG_EVENT_UNFILTERED,
    "Hyjal combat logging activates only for the active runtime")

local model = assert(ui:BuildModel())
assert(model.waveIndex == 1 and model.group.label == "Rage Winterchill" and model.groupWave == 1)
assert(#model.enemies == 1 and model.enemies[1].npcId == 17895 and model.enemies[1].count == 10,
    "wave composition aggregates identical NPCs")
assert(#model.paths == 1 and model.paths[1].occurrences == 10, "identical wave paths are deduplicated")
local alliancePath = model.paths[1].points
assert(alliancePath[1].x == 0.061 and alliancePath[1].y == 0.742
    and alliancePath[#alliancePath].x == 0.118 and alliancePath[#alliancePath].y == 0.681,
    "wave routes reuse the patrol projection used by the map")
assert(model.camp.label == "Alliance Base", "wave camp resolves through raid POIs")
assert(math.abs(model.camp.x - 0.128277) < 0.000001, "Alliance camp uses the displayed map orientation")

current.value.currentPull = 20
model = assert(ui:BuildModel())
assert(model.group.label == "Kaz'rogal" and model.groupWave == 2 and #model.paths == 2,
    "mixed ground and aerial routes remain distinct")

current.value.currentPull = 37
model = assert(ui:BuildModel())
assert(model.group.label == "Archimonde" and model.groupWave == 1 and model.groupWaves == 1)

ART.RaidPlanner.raid = raid
current.value.currentPull = 1
ui:ResetHyjalRuntime()
widgetText = "Wave 3/8"
assert(ui:ReadHyjalWave() and current.value.currentPull == 3,
    "visible widget text selects the matching global wave")
assert(not ui:ReadHyjalWave(), "duplicate widget updates are idempotent")
assert(ui:HandleHyjalBoss(17767, false) and current.value.currentPull == 9,
    "boss activity selects the boss step")
assert(not ui:HandleHyjalBoss(17767, true) and current.value.currentPull == 9,
    "boss death waits for the next wave widget")
widgetText = "Wave 1/8"
assert(ui:ReadHyjalWave() and current.value.currentPull == 10,
    "the next boss group starts at its first global wave")
widgetText = "Wave 4/8"
assert(ui:ReadHyjalWave() and current.value.currentPull == 13)
widgetText = "Wave 1/8"
assert(ui:ReadHyjalWave() and current.value.currentPull == 10,
    "a lower widget wave resets progress within the same group after a wipe")

assert(ui:HandleHyjalBoss(17808, false) and current.value.currentPull == 18)
ui:HandleHyjalBoss(17808, true)
widgetText = "Wave 2/8"
assert(ui:ReadHyjalWave() and current.value.currentPull == 20)
assert(ui:HandleHyjalBoss(17888, false) and current.value.currentPull == 27)
ui:HandleHyjalBoss(17888, true)
widgetText = "Wave 8/8"
assert(not ui:ReadHyjalWave() and current.value.currentPull == 27, "stale final-wave updates are ignored")
widgetText = "Wave 1/8"
assert(ui:ReadHyjalWave() and current.value.currentPull == 28)
assert(ui:HandleHyjalBoss(17842, false) and current.value.currentPull == 36)
assert(ui:HandleHyjalBoss(17842, true) and current.value.currentPull == 37,
    "Azgalor death advances directly to Archimonde")

current.value.currentPull = 5
instanceId = 544
widgetText = "Wave 6/8"
assert(not ui:ReadHyjalWave() and current.value.currentPull == 5,
    "the Hyjal widget never changes a route outside the Hyjal instance")
ui:RefreshEventRegistration()
assert(not runtimeFrame.events.COMBAT_LOG_EVENT_UNFILTERED,
    "Hyjal combat logging unregisters outside the raid")
instanceId = 534
ui:RefreshEventRegistration()
widgetText = "invalid"
assert(not ui:ReadHyjalWave() and current.value.currentPull == 5, "malformed widget text is ignored")

current.value.currentPull = 4
widgetText = "Wave 6/8"
ui:ResetHyjalRuntime()
ART.main_frame = { IsShown = function() return true end }
function ART:IsMapSectionActive() return true end
assert(not ui:ReadHyjalWave() and current.value.currentPull == 4,
    "automatic runtime progress must not override manual Hyjal map planning")
ART.main_frame = nil
assert(ui:ReadHyjalWave() and current.value.currentPull == 6,
    "automatic progress catches up after map planning closes")

ART.RaidPlanner.raid = { mode = "route", mapId = 565 }
assert(not ui:IsActive(), "normal route raids never enter wave mode")

local loader = assert(io.open(root.."/Modules/load_modules.xml", "rb"))
local loaderSource = loader:read("*a")
loader:close()
assert(loaderSource:find("WaveModeUI.lua", 1, true) < loaderSource:find("AutoMarksUI.lua", 1, true),
    "wave mode must load before the shared side-panel tabs")
local enemies = assert(io.open(root.."/Modules/RaidEnemies.lua", "rb"))
local enemySource = enemies:read("*a")
enemies:close()
assert(enemySource:find("and not waveMode", 1, true), "wave raids must suppress normal enemy blips")
local integration = assert(io.open(root.."/Modules/EnemyInfo.lua", "rb"))
local integrationSource = integration:read("*a")
integration:close()
assert(integrationSource:find("previousPulls[waveIndex].artCCAssignments", 1, true),
    "immutable Hyjal pull rebuilds must retain wave CC assignments")
local waveUI = assert(io.open(root.."/Modules/WaveModeUI.lua", "rb"))
local waveSource = waveUI:read("*a")
waveUI:close()
assert(waveSource:find("ART.LiveMarks:ClearWorldMarks()", 1, true), "wave card must expose clear world marks")
assert(waveSource:find('HYJAL_WAVE_WIDGET_ID = 534, 3121', 1, true)
    and waveSource:find('RegisterEvent("UPDATE_UI_WIDGET")', 1, true),
    "Hyjal wave mode must listen to the Classic wave widget")
local core = assert(io.open(root.."/AnniversaryRaidTools.lua", "rb"))
local coreSource = core:read("*a")
core:close()
assert(coreSource:find("if preset.value.artWaveRaid then", 1, true)
    and coreSource:find("ART:ReleaseHullTextures()", 1, true), "wave raids must suppress pull hulls")

print("wave mode checks passed")
