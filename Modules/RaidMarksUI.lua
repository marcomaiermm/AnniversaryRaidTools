-- Made by Nnoggie, 2017-2025
-- UI adapter for raid marks. Central registration belongs to the integrator.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local RaidMarksUI = ART.RaidMarksUI or {}
ART.RaidMarksUI = RaidMarksUI
if addon and addon.RaidMarksUI == nil then addon.RaidMarksUI = RaidMarksUI end

function RaidMarksUI:Initialize(dependencies)
  if self.initialized then return self end
  dependencies = dependencies or {}
  self.marks = dependencies.raidMarks or dependencies.marks or ART.RaidMarks
  assert(type(self.marks) == "table", "RaidMarksUI requires RaidMarks")
  self.renderPreview = dependencies.renderPreview
  self.initialized = true
  return self
end

function RaidMarksUI:GetPreviewForPack(packKey)
  local preview = self.marks and self.marks:GetPreviewForPack(packKey) or {}
  if self.renderPreview then self.renderPreview(preview, packKey) end
  return preview
end

function RaidMarksUI:ApplyUnit(unitToken)
  if not self.marks then return false, "not-initialized" end
  return self.marks:ApplyUnit(unitToken)
end
