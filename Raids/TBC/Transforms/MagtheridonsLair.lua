-- Pure normalized-coordinate transform for Magtheridon's Lair.
local _, addon = ...
local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local provenance = {
  source = "derived",
  confidence = "review-required",
  sourceRef = "https://gist.github.com/Stanzilla/5def6b67033a359610e6#WorldMapArea-779",
  observedAt = "2026-08-21T21:30:00Z",
}

local defaultCalibration = {
  mapId = 544,
  sublevel = 1,
  offsetX = 0,
  offsetY = 0,
  scaleX = 1,
  scaleY = 1,
  flipY = false,
  tolerance = 0.0005,
  provenance = provenance,
  worldBounds = {
    leftY = 385.5,
    rightY = -170.5,
    topX = 255.33334350585938,
    bottomX = -115.3333511352539,
  },
}

local transform = {
  schemaVersion = 1,
  raidKey = "magtheridons-lair",
  calibrations = { [1] = defaultCalibration },
}

local function finiteNormalized(value)
  return type(value) == "number" and value == value and value >= 0 and value <= 1
end

local function calibrationFor(mapId, sublevel, calibration)
  if mapId ~= 544 then return nil, "unknown-map-id" end
  if sublevel ~= 1 then return nil, "unknown-sublevel" end
  calibration = calibration or transform.calibrations[sublevel]
  if type(calibration) ~= "table" or calibration.mapId ~= mapId or calibration.sublevel ~= sublevel then
    return nil, "calibration-identity-mismatch"
  end
  if type(calibration.offsetX) ~= "number" or type(calibration.offsetY) ~= "number"
      or type(calibration.scaleX) ~= "number" or type(calibration.scaleY) ~= "number"
      or calibration.scaleX <= 0 or calibration.scaleY <= 0 then
    return nil, "invalid-calibration"
  end
  return calibration
end

function transform.toPlanner(mapId, sublevel, x, y, calibration)
  local selected, reason = calibrationFor(mapId, sublevel, calibration)
  if not selected then return nil, reason end
  if not finiteNormalized(x) or not finiteNormalized(y) then return nil, "invalid-source-coordinate" end
  local plannerX = x * selected.scaleX + selected.offsetX
  local plannerY = ((selected.flipY and (1 - y)) or y) * selected.scaleY + selected.offsetY
  if not finiteNormalized(plannerX) or not finiteNormalized(plannerY) then
    return nil, "outside-normalized-coordinate-space"
  end
  return plannerX, plannerY
end

function transform.fromPlanner(mapId, sublevel, x, y, calibration)
  local selected, reason = calibrationFor(mapId, sublevel, calibration)
  if not selected then return nil, reason end
  if not finiteNormalized(x) or not finiteNormalized(y) then return nil, "invalid-planner-coordinate" end
  local sourceX = (x - selected.offsetX) / selected.scaleX
  local sourceY = (y - selected.offsetY) / selected.scaleY
  if selected.flipY then sourceY = 1 - sourceY end
  if not finiteNormalized(sourceX) or not finiteNormalized(sourceY) then
    return nil, "outside-normalized-coordinate-space"
  end
  return sourceX, sourceY
end

function transform.getCalibration(mapId, sublevel)
  return calibrationFor(mapId, sublevel)
end

ART.MapTransforms = ART.MapTransforms or {}
ART.MapTransforms[transform.raidKey] = transform
return transform
