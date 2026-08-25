-- Pure normalized-coordinate transform for the candidate Gruul's Lair map.
-- The affine knobs are intentionally explicit: client calibration may replace them
-- after manual checks on Anniversary clients 20505 and 20506.
local _, ART = ...

local provenance = {
  source = "derived",
  confidence = "review-required",
  sourceRef = "derived-from:fixture://azerothcore/gruuls-lair-v1#map",
  observedAt = "2026-08-21T00:00:00Z",
}

local defaultCalibration = {
  mapId = 565,
  sublevel = 1,
  offsetX = 0,
  offsetY = 0,
  scaleX = 1,
  scaleY = 1,
  flipY = false,
  tolerance = 0.0005,
  provenance = provenance,
}

local transform = {
  schemaVersion = 1,
  raidKey = "gruuls-lair",
  calibrations = { [1] = defaultCalibration },
}

local function finiteNormalized(value)
  return type(value) == "number" and value == value and value >= 0 and value <= 1
end

local function calibrationFor(mapId, sublevel, calibration)
  if mapId ~= 565 then return nil, "unknown-map-id" end
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
  local plannerX = (x * selected.scaleX) + selected.offsetX
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
  local selected, reason = calibrationFor(mapId, sublevel)
  if not selected then return nil, reason end
  return selected
end

ART.MapTransforms = ART.MapTransforms or {}
ART.MapTransforms[transform.raidKey] = transform
return transform
