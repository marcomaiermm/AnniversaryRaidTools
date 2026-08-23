-- Black Temple planner coordinates generated from LibMapData world rectangles.
local _, addon = ...
local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local worldBounds = {
  [1] = { 1252.2495784759521, 834.8330078125, -23.87053871154785, -240, -1276.1201171875, 594.8330078125 },
  [2] = { 427.08331298828, 949.99993896484, 366.66665649414, 1150 },
  [3] = { 975, 650, 176, 380, -799, 1030 },
  [4] = { 1005, 670, 191, 400, -814, 1070 },
  [5] = { 440.0009765625, 293.333984375, -134.99951171875, 343.3330078125, -575.00048828125, 636.6669921875 },
  [6] = { 670, 446.66668701171875, 70, 664.1636352539062, -600, 1110.830322265625 },
  [7] = { 705, 470, 67.5, 450, -637.5, 920 },
  [8] = { 355, 236.6666259765625, -137.5, 606.6666870117188, -492.5, 843.3333129882812 },
}

local provenance = {
  source = "client-data",
  confidence = "candidate",
  sourceRef = "UiMapAssignment 2.5.6.69110 uiMap 339 (Illidari Training Grounds); LibMapData map 796",
  observedAt = "2026-08-21T20:50:00Z",
}

local transform = { schemaVersion = 1, raidKey = "black-temple", calibrations = {} }
for sublevel = 1, 8 do
  transform.calibrations[sublevel] = {
    mapId = 564,
    sublevel = sublevel,
    offsetX = 0,
    offsetY = 0,
    scaleX = 1,
    scaleY = 1,
    flipX = false,
    flipY = true,
    tolerance = 0.0005,
    worldBounds = worldBounds[sublevel],
    provenance = provenance,
  }
end
transform.calibrations[2].offsetX = -0.004755035
transform.calibrations[2].offsetY = 0.000282953
transform.calibrations[2].scaleX = 1.003209118
transform.calibrations[2].scaleY = 0.993225521
transform.calibrations[2].flipX = true
transform.calibrations[2].flipY = false

local function finiteNormalized(value)
  return type(value) == "number" and value == value and value >= 0 and value <= 1
end

local function calibrationFor(mapId, sublevel, calibration)
  if mapId ~= 564 then return nil, "unknown-map-id" end
  if type(sublevel) ~= "number" or sublevel % 1 ~= 0 or sublevel < 1 or sublevel > 8 then
    return nil, "unknown-sublevel"
  end
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
  local plannerX = ((selected.flipX and (1 - x)) or x) * selected.scaleX + selected.offsetX
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
  if selected.flipX then sourceX = 1 - sourceX end
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
