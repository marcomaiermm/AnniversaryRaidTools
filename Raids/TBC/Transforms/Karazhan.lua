-- Karazhan's 17 client-floor world rectangles and normalized planner transforms.
local _, ART = ...

-- width, height, upper-left X/Y, lower-right X/Y; RZTI 532 in LibMapData.
local bounds = {
  {550.048828125,366.69921875,2225.0244140625,-11189.599609375,1674.9755859375,-10822.900390625},
  {257.85986328125,171.90625,2081.419921875,-11189.0029296875,1823.56005859375,-11017.0966796875},
  {345.1494140625,230.099609375,2132.57470703125,-11066.2998046875,1787.42529296875,-10836.2001953125},
  {520.048828125,346.69921875,2190.0244140625,-11119.599609375,1669.9755859375,-10772.900390625},
  {234.14990234375,156.099609375,1932.5799560546875,-10969.2998046875,1698.4300537109375,-10813.2001953125},
  {581.548828125,387.69921875,2205.7744140625,-11190.599609375,1624.2255859375,-10802.900390625},
  {191.548828125,127.69921875,2066.7744140625,-11115.599609375,1875.2255859375,-10987.900390625},
  {139.3505859375,92.900390625,2037.6802978515625,-11105.2001953125,1898.3297119140625,-11012.2998046875},
  {760.048828125,506.69921875,2270.0244140625,-11459.599609375,1509.9755859375,-10952.900390625},
  {450.25,300.166015625,2040.1300048828125,-11386.3330078125,1589.8800048828125,-11086.1669921875},
  {271.050048828125,180.69921875,1825.530029296875,-11285.099609375,1554.47998046875,-11104.400390625},
  {595.048828125,396.69921875,2182.5244140625,-11444.599609375,1587.4755859375,-11047.900390625},
  {529.048828125,352.69921875,1963.0244140625,-11339.099609375,1433.9755859375,-10986.400390625},
  {245.25,163.5,2032.6300048828125,-11143.0,1787.3800048828125,-10979.5},
  {211.14990234375,140.765625,2025.0799560546875,-11113.6328125,1813.9300537109375,-10972.8671875},
  {101.25,67.5,2020.1300048828125,-11097.0,1918.8800048828125,-11029.5},
  {341.25,227.5,2155.1298828125,-11102.0,1813.8798828125,-10874.5},
}

local provenance = {
  source = "derived",
  confidence = "candidate",
  sourceRef = "https://gist.github.com/Stanzilla/dd2085b9a4f9229dc0ac#mapData-799-rzti-532",
  observedAt = "2026-08-21T22:15:00Z",
}

local transform = { schemaVersion = 1, raidKey = "karazhan", calibrations = {}, flipX = true }
-- flipX: legacy Interface/WorldMap Karazhan textures are drawn west-left
-- (RZTI convention), while C_Map.GetMapPosFromWorldPos returns east-right x.
-- Modules/EnemyInfo mirrors the client result before toPlanner.
for sublevel, worldBounds in ipairs(bounds) do
  transform.calibrations[sublevel] = {
    mapId = 532, sublevel = sublevel,
    offsetX = 0, offsetY = 0, scaleX = 1, scaleY = 1, flipY = true,
    tolerance = 0.0005, worldBounds = worldBounds, provenance = provenance,
  }
end
transform.calibrations[3].offsetX = 0.001452875
transform.calibrations[3].offsetY = -0.190066416666667
transform.calibrations[4].offsetX = -0.01777375
transform.calibrations[4].offsetY = 0.066112166666667
transform.calibrations[9].offsetX = 0.021814875
transform.calibrations[9].offsetY = 0.087
transform.calibrations[11].offsetX = -0.0379805625
transform.calibrations[11].offsetY = -0.361806916666667

local function finite(value)
  return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function normalized(value)
  return finite(value) and value >= 0 and value <= 1
end

local function calibrationFor(mapId, sublevel, calibration)
  if mapId ~= 532 then return nil, "unknown-map-id" end
  if type(sublevel) ~= "number" or sublevel % 1 ~= 0 or not bounds[sublevel] then
    return nil, "unknown-sublevel"
  end
  calibration = calibration or transform.calibrations[sublevel]
  if type(calibration) ~= "table" or calibration.mapId ~= mapId or calibration.sublevel ~= sublevel then
    return nil, "calibration-identity-mismatch"
  end
  if not finite(calibration.offsetX) or not finite(calibration.offsetY)
      or not finite(calibration.scaleX) or not finite(calibration.scaleY)
      or calibration.scaleX <= 0 or calibration.scaleY <= 0 then
    return nil, "invalid-calibration"
  end
  return calibration
end

function transform.toPlanner(mapId, sublevel, x, y, calibration)
  local selected, reason = calibrationFor(mapId, sublevel, calibration)
  if not selected then return nil, reason end
  if not normalized(x) or not normalized(y) then return nil, "invalid-source-coordinate" end
  local plannerX = x * selected.scaleX + selected.offsetX
  local plannerY = ((selected.flipY and (1 - y)) or y) * selected.scaleY + selected.offsetY
  if not normalized(plannerX) or not normalized(plannerY) then
    return nil, "outside-normalized-coordinate-space"
  end
  return plannerX, plannerY
end

function transform.fromPlanner(mapId, sublevel, x, y, calibration)
  local selected, reason = calibrationFor(mapId, sublevel, calibration)
  if not selected then return nil, reason end
  if not normalized(x) or not normalized(y) then return nil, "invalid-planner-coordinate" end
  local sourceX = (x - selected.offsetX) / selected.scaleX
  local sourceY = (y - selected.offsetY) / selected.scaleY
  if selected.flipY then sourceY = 1 - sourceY end
  if not normalized(sourceX) or not normalized(sourceY) then
    return nil, "outside-normalized-coordinate-space"
  end
  return sourceX, sourceY
end

function transform.worldToPlanner(mapId, sublevel, worldX, worldY)
  local selected, reason = calibrationFor(mapId, sublevel)
  if not selected then return nil, reason end
  if not finite(worldX) or not finite(worldY) then return nil, "invalid-world-coordinate" end
  local b = selected.worldBounds
  local x = (-worldY - b[5]) / b[1]
  local y = (worldX - b[4]) / b[2]
  if not normalized(x) or not normalized(y) then return nil, "outside-world-bounds" end
  return transform.toPlanner(mapId, sublevel, x, y, selected)
end

function transform.plannerToWorld(mapId, sublevel, x, y)
  local selected, reason = calibrationFor(mapId, sublevel)
  if not selected then return nil, reason end
  if not normalized(x) or not normalized(y) then return nil, "invalid-planner-coordinate" end
  local b = selected.worldBounds
  local sourceX, sourceY = transform.fromPlanner(mapId, sublevel, x, y, selected)
  return b[4] + sourceY * b[2], -(b[5] + sourceX * b[1])
end

function transform.getCalibration(mapId, sublevel)
  return calibrationFor(mapId, sublevel)
end

ART.MapTransforms = ART.MapTransforms or {}
ART.MapTransforms[transform.raidKey] = transform
return transform
