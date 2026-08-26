local _, ART = ...
local L = ART.L

local defaultSavedVars = {
  global = {
    toolbarExpanded = true,
    scale = 1,
    nonFullscreenScale = 1.4,
    showPullButtonHealth = false,
    showPullTracker = true,
    autoPanToPull = true,
    autoMark = false,
    autoMarkModifier = "ALT",
    announceInstanceReset = false,
    xoffset = -80,
    yoffset = -100,
    anchorFrom = "TOP",
    anchorTo = "TOP",
    minimap = {
      hide = false,
    },
    toolbar = {
      color = { r = 1, g = 1, b = 1, a = 1 },
      brushSize = 3,
    },
    presets = {},
    currentPreset = {},
    alwaysOverwriteRoutesByUID = false,
    fadeOutDuringCombat = false,
    fadeOutAlpha = 0.5,
    combatLogging = {
      enabled = false,
    },
    colorPaletteInfo = {
      autoColoring = true,
      forceColorBlindMode = false,
      colorPaletteIdx = 4,
      customPaletteValues = {},
      numberCustomColors = 12,
    },
    currentRaidIndex = 160,
    currentSection = "maps",
  },
}

for i = 160, 167 do
  defaultSavedVars.global.presets[i] = {
    [1] = {
      text = L["Default"],
      value = {},
      objects = {},
      colorPaletteInfo = { autoColoring = true, colorPaletteIdx = 4 }
    },
    [2] = { text = L["<New Preset>"], value = 0 },
  }
  defaultSavedVars.global.currentPreset[i] = 1
end

local db
local raidRouteStore

local function initializeRaidRouteStore(global)
  if global.raidRoutes == nil then
    global.raidRoutes = { schemaVersion = 1, presets = {} }
  end
  local store = global.raidRoutes
  if type(store) ~= "table" or store.schemaVersion ~= 1 or type(store.presets) ~= "table" then return end
  return store
end

function ART:GetDefaultSavedVariables()
  return defaultSavedVars
end

function ART:InitializeSavedVariables()
  if db then return db end
  db = LibStub("AceDB-3.0"):New("AnniversaryRaidToolsDB", defaultSavedVars).global
  if not db then return end

  for raidIndex, presetIdx in pairs(db.currentPreset) do
    if presetIdx <= 0 then db.currentPreset[raidIndex] = 1 end
  end

  raidRouteStore = initializeRaidRouteStore(db)

  return db
end

function ART:GetDB()
  return db
end

function ART:GetRaidRouteStore()
  return raidRouteStore
end

function ART:ResetDataCache()
  db.raidEnemies = nil
  db.mapPOIs = nil
  ReloadUI()
end

function ART:HardReset()
  AnniversaryRaidToolsDB = nil
  ReloadUI()
end

ART:InitializeSavedVariables()
