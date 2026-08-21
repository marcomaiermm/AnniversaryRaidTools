-- Identity transforms for normalized Black Temple candidate coordinates.
local _, addon = ...
local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local bounds = {
  [1] = { 187.080150, 858.824850, 660.705748, 1109.049296 },
  [2] = { 430.626001, 847.944000, 332.085155, 1004.071850 },
  [3] = { 407.437457, 967.085550, -3.894115, 468.155820 },
  [4] = { 379.550447, 957.260550, 172.597654, 577.603350 },
  [5] = { 749.472150, 989.356853, 37.632015, 579.256285 },
  [6] = { 516.523600, 720.912400, 108.414655, 369.562335 },
  [7] = { 700.731995, 710.731995, 299.988007, 309.988007 },
}

local provenance = {
  source = "derived",
  confidence = "review-required",
  sourceRef = "cmangos-tbc:7060a217bcf7c454db570e842cd5e2179444d768/map-564; nearest-encounter floor assignment; 5-percent padded world extents",
  observedAt = "2026-08-21T20:50:00Z",
}

local transform = { schemaVersion = 1, raidKey = "black-temple", calibrations = {} }
for sublevel = 1, 7 do
  transform.calibrations[sublevel] = {
    mapId = 564,
    sublevel = sublevel,
    offsetX = 0,
    offsetY = 0,
    scaleX = 1,
    scaleY = 1,
    flipY = false,
    tolerance = 0.0005,
    worldBounds = bounds[sublevel],
    provenance = provenance,
  }
end

local function finiteNormalized(value)
  return type(value) == "number" and value == value and value >= 0 and value <= 1
end

local function calibrationFor(mapId, sublevel, calibration)
  if mapId ~= 564 then return nil, "unknown-map-id" end
  if type(sublevel) ~= "number" or sublevel % 1 ~= 0 or sublevel < 1 or sublevel > 7 then
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
