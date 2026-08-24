-- Quick-mark input: hovering a planner blip plus keys 1-8 or the player's own
-- RAIDTARGET bindings assigns markers in the plan, never in the world.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local QuickMark = ART.QuickMark or {}
ART.QuickMark = QuickMark

local hoveredBlip
local captureFrame
local captureButtons = {}
local markerByNumberKey = { 8, 7, 1, 5, 6, 3, 4, 2 }

local function assignMarker(marker)
  if not hoveredBlip or not hoveredBlip.clone then return false end
  local planner = ART.RaidPlanner
  if not planner or not planner.initialized then return false end
  local clone = hoveredBlip.clone
  if not clone.artPackKey or not clone.artSpawnKey then return false end
  if #planner:FindStepsForPack(clone.artPackKey) > 0 then
    local applied, displaced = planner:SetSpawnMark(clone.artPackKey, clone.artSpawnKey, marker)
    if not applied then return false end
    ART:HideDisplacedSpawnMarks(displaced)
  else
    ART:SetLegacyBlipMark(hoveredBlip.enemyIdx, hoveredBlip.cloneIdx, marker)
  end
  hoveredBlip:SetUp(hoveredBlip.data, clone)
  return true
end

local function ensureCaptureFrame()
  if captureFrame then return captureFrame end
  captureFrame = CreateFrame("Frame", "MDTQuickMarkCapture", UIParent)
  captureFrame:SetSize(1, 1)
  captureFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -200, 200)
  captureFrame:SetAlpha(0)
  captureFrame:EnableMouse(false)
  for marker = 1, 8 do
    local marker = marker
    local button = CreateFrame("Button", "MDTQuickMarkButton"..marker, captureFrame)
    button:SetScript("OnClick", function() assignMarker(marker) end)
    captureButtons[marker] = button
  end
  return captureFrame
end

function QuickMark:Arm(blip)
  hoveredBlip = blip
  local frame = ensureCaptureFrame()
  ClearOverrideBindings(frame)
  for marker, button in ipairs(captureButtons) do
    for _, key in pairs({ GetBindingKey("RAIDTARGET"..marker) }) do
      SetOverrideBindingClick(frame, true, key, button:GetName())
    end
  end
  for key, marker in ipairs(markerByNumberKey) do
    SetOverrideBindingClick(frame, true, tostring(key), captureButtons[marker]:GetName())
  end
end

function QuickMark:Disarm(blip)
  if blip and hoveredBlip ~= blip then return end
  hoveredBlip = nil
  if captureFrame then ClearOverrideBindings(captureFrame) end
end

ART.QuickMark = QuickMark
