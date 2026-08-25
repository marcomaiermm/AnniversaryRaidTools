-- Offline CASC overlays must work without raid C_Map art.
local root = arg and arg[1] or "."
local texture = {}
for _, method in ipairs({ "Hide", "Show", "ClearAllPoints", "SetPoint", "SetSize", "SetRotation", "SetAlpha" }) do
  texture[method] = function(self, ...) self[method] = { ... } end
end
texture.SetTexture = function(self, path) self.path = path end
CreateFrame = function() return { tiles = {}, CreateTexture = function() return texture end } end

local db = { devMode = true }
local currentFloor = 2
local ART = {
  AddonPath = "Interface\\AddOns\\AnniversaryRaidTools\\",
  RaidMaps = { ["black-temple"] = { sublevels = { { uiMapId = 343 }, { uiMapId = 339 } } } },
  main_frame = { mapPanelFrame = {}, mapPanelTile1 = {} },
  GetDB = function() return db end,
  GetRaidIntegration = function() return { planner = { raid = { key = "black-temple" } } } end,
  GetCurrentSubLevel = function() return currentFloor end,
  GetDefaultMapPanelSize = function() return 840, 555 end,
}
assert(loadfile(root.."/Developer/MapCalibration.lua"))("AnniversaryRaidTools", ART)
local calibration = ART:GetMapCalibration()
calibration.enabled = true
ART:UpdateMapCalibrationOverlay()
assert(texture.path == ART.AddonPath.."Raids\\TBC\\Calibration\\BlackTemple\\overlay.png")
assert(texture.Show and texture.SetSize[1] == 840 and texture.SetSize[2] == 555)

currentFloor = 1
C_Map = { GetMapArtLayers = function() end, GetMapArtLayerTextures = function() end }
local unavailable = ART:GetMapCalibration()
unavailable.enabled = true
ART:UpdateMapCalibrationOverlay()
assert(unavailable.enabled == false)
print("Offline map calibration overlay: ok")
