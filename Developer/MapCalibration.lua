local _, ART = ...

local defaults = { enabled = false, alpha = 0.35, offsetX = 0, offsetY = 0, scaleX = 1, scaleY = 1, rotation = 0 }
local offlineOverlays = {
  ["black-temple"] = { [2] = "BlackTemple" },
  hyjal = "Hyjal",
  karazhan = "Karazhan",
  ["sunwell-plateau"] = "SunwellPlateau",
}

local function currentCalibration()
  local integration = ART:GetRaidIntegration()
  local raid = integration and integration.planner and integration.planner.raid
  local map = raid and ART.RaidMaps and ART.RaidMaps[raid.key]
  local floor = ART:GetCurrentSubLevel()
  local sublevel = map and map.sublevels[floor]
  if not sublevel then return end

  local db = ART:GetDB()
  db.mapCalibration = db.mapCalibration or {}
  db.mapCalibration[raid.key] = db.mapCalibration[raid.key] or {}
  local value = db.mapCalibration[raid.key][floor]
  if not value then
    value = {}
    for key, default in pairs(defaults) do value[key] = default end
    db.mapCalibration[raid.key][floor] = value
  end
  return value, sublevel.uiMapId, raid.key, floor
end

local function hideOverlay()
  local overlay = ART.main_frame and ART.main_frame.mapCalibrationOverlay
  if not overlay then return end
  for _, texture in ipairs(overlay.tiles) do texture:Hide() end
end

function ART:GetMapCalibration()
  return currentCalibration()
end

function ART:ResetMapCalibration()
  local value = currentCalibration()
  if not value then return end
  for key, default in pairs(defaults) do value[key] = default end
  value.enabled = true
  self:UpdateMapCalibrationOverlay()
end

function ART:UpdateMapCalibrationOverlay()
  hideOverlay()
  local value, uiMapId, raidKey, floor = currentCalibration()
  if not value or not value.enabled or not ART:GetDB().devMode then return end

  local frame = ART.main_frame
  local overlay = frame.mapCalibrationOverlay
  if not overlay then
    overlay = CreateFrame("Frame", nil, frame.mapPanelFrame)
    overlay.tiles = {}
    frame.mapCalibrationOverlay = overlay
  end

  local offline = offlineOverlays[raidKey]
  if type(offline) == "table" then offline = offline[floor] end
  if offline then
    local canvasWidth, canvasHeight = ART:GetDefaultMapPanelSize()
    local texture = overlay.tiles[1] or overlay:CreateTexture(nil, "ARTWORK", nil, 1)
    overlay.tiles[1] = texture
    texture:ClearAllPoints()
    texture:SetPoint("CENTER", frame.mapPanelTile1, "TOPLEFT",
      (0.5 + value.offsetX) * canvasWidth, -(0.5 + value.offsetY) * canvasHeight)
    texture:SetSize(canvasWidth * value.scaleX, canvasHeight * value.scaleY)
    texture:SetTexture(ART.AddonPath.."Raids\\TBC\\Calibration\\"..offline.."\\overlay.png")
    texture:SetRotation(math.rad(value.rotation))
    texture:SetAlpha(value.alpha)
    texture:Show()
    return
  end

  if not C_Map or not C_Map.GetMapArtLayers or not C_Map.GetMapArtLayerTextures then
    print("ART calibration: C_Map art API unavailable")
    value.enabled = false
    return
  end

  local layers = C_Map.GetMapArtLayers(uiMapId)
  local layer = layers and layers[1]
  local files = layer and C_Map.GetMapArtLayerTextures(uiMapId, 1)
  if not layer or not files then
    print("ART calibration: no UiMap art for "..tostring(uiMapId))
    value.enabled = false
    return
  end

  local canvasWidth, canvasHeight = ART:GetDefaultMapPanelSize()
  local columns = math.ceil(layer.layerWidth / layer.tileWidth)
  local angle = math.rad(value.rotation)
  local cos, sin = math.cos(angle), math.sin(angle)
  for index, file in ipairs(files) do
    local column, row = (index - 1) % columns, math.floor((index - 1) / columns)
    local tileWidth = math.min(layer.tileWidth, layer.layerWidth - column * layer.tileWidth)
    local tileHeight = math.min(layer.tileHeight, layer.layerHeight - row * layer.tileHeight)
    local x = ((column * layer.tileWidth + tileWidth / 2) / layer.layerWidth - 0.5) * value.scaleX
    local y = ((row * layer.tileHeight + tileHeight / 2) / layer.layerHeight - 0.5) * value.scaleY
    local rotatedX, rotatedY = x * cos - y * sin, x * sin + y * cos
    local texture = overlay.tiles[index] or overlay:CreateTexture(nil, "ARTWORK", nil, 1)
    overlay.tiles[index] = texture
    texture:ClearAllPoints()
    texture:SetPoint("CENTER", frame.mapPanelTile1, "TOPLEFT",
      (0.5 + value.offsetX + rotatedX) * canvasWidth,
      -(0.5 + value.offsetY + rotatedY) * canvasHeight)
    texture:SetSize(tileWidth / layer.layerWidth * canvasWidth * value.scaleX,
      tileHeight / layer.layerHeight * canvasHeight * value.scaleY)
    texture:SetTexture(file)
    texture:SetRotation(angle)
    texture:SetAlpha(value.alpha)
    texture:Show()
  end
end

function ART:PrintMapCalibration()
  local value, uiMapId, raidKey, floor = currentCalibration()
  if not value then return end
  print(string.format("ART calibration %s floor %d UiMap %d: offsetX=%.6f offsetY=%.6f scaleX=%.6f scaleY=%.6f rotation=%.3f alpha=%.2f",
    raidKey, floor, uiMapId, value.offsetX, value.offsetY, value.scaleX, value.scaleY, value.rotation, value.alpha))
end
