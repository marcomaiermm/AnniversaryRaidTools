-- Candidate client-map calibration; tune with Developer/MapCalibration.lua.
local _, ART = ...
local provenance = { source = "derived", confidence = "review-required", sourceRef = "derived-from:client-ui-map", observedAt = "2026-08-22T12:00:00Z" }
local transform = { schemaVersion = 1, raidKey = "sunwell-plateau", calibrations = {
  [1] = { mapId = 580, sublevel = 1, offsetX = 0, offsetY = 0, scaleX = 1, scaleY = 1, flipY = false, tolerance = 0.0005, provenance = provenance },
  [2] = { mapId = 580, sublevel = 2, offsetX = 0, offsetY = 0, scaleX = 1, scaleY = 1, flipY = false, tolerance = 0.0005, provenance = provenance },
} }
local function finite(value) return type(value) == "number" and value == value and value >= 0 and value <= 1 end
local function selectCalibration(mapId, sublevel, calibration)
  if mapId ~= 580 then return nil, "unknown-map-id" end
  calibration = calibration or transform.calibrations[sublevel]
  if type(calibration) ~= "table" or calibration.mapId ~= mapId or calibration.sublevel ~= sublevel then return nil, "calibration-identity-mismatch" end
  if type(calibration.offsetX) ~= "number" or type(calibration.offsetY) ~= "number" or type(calibration.scaleX) ~= "number" or type(calibration.scaleY) ~= "number" or calibration.scaleX <= 0 or calibration.scaleY <= 0 then return nil, "invalid-calibration" end
  return calibration
end
function transform.toPlanner(mapId, sublevel, x, y, calibration)
  local c, reason = selectCalibration(mapId, sublevel, calibration); if not c then return nil, reason end
  if not finite(x) or not finite(y) then return nil, "invalid-source-coordinate" end
  local px = x * c.scaleX + c.offsetX
  local py = ((c.flipY and 1 - y) or y) * c.scaleY + c.offsetY
  if not finite(px) or not finite(py) then return nil, "outside-normalized-coordinate-space" end
  return px, py
end
function transform.fromPlanner(mapId, sublevel, x, y, calibration)
  local c, reason = selectCalibration(mapId, sublevel, calibration); if not c then return nil, reason end
  if not finite(x) or not finite(y) then return nil, "invalid-planner-coordinate" end
  local sx, sy = (x - c.offsetX) / c.scaleX, (y - c.offsetY) / c.scaleY
  if c.flipY then sy = 1 - sy end
  if not finite(sx) or not finite(sy) then return nil, "outside-normalized-coordinate-space" end
  return sx, sy
end
function transform.getCalibration(mapId, sublevel) return selectCalibration(mapId, sublevel) end
ART.MapTransforms = ART.MapTransforms or {}
ART.MapTransforms[transform.raidKey] = transform
return transform
