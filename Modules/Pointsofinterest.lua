local _, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local L = ART.L
local db
local tinsert, pairs, twipe = table.insert, pairs, table.wipe

local points = {}

function ART:POI_CreateFramePools()
  ART.CreateFramePool("Button", ART.main_frame.mapPanelFrame, "MapLinkPinTemplate")
end

local function formatPoiString(formattedText)
  return string.format(L[formattedText[1]], unpack(formattedText, 2))
end

local function POI_SetDevOptions(frame, poi)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" and not self.isMoving then
      self:StartMoving()
      self.isMoving = true
    elseif button == "RightButton" then
      table.remove(ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()], self.poiIdx)
      ART:UpdateMap()
    end
  end)
  frame:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" and self.isMoving then
      self.isMoving = false
      self:StopMovingOrSizing()
      local x, y = ART:GetCursorPosition()
      local scale = ART:GetScale()
      local poiData = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()][self.poiIdx]
      poiData.x, poiData.y = x / scale, y / scale
      self:ClearAllPoints()
      ART:UpdateMap()
    end
  end)
  frame:SetScript("OnClick", nil)
end

local function POI_SetOptions(frame, poiType, poi)
  frame.poi = nil
  frame:SetMovable(false)
  frame:SetScript("OnMouseDown", nil)
  frame:SetScript("OnMouseUp", nil)
  frame:SetScript("OnClick", nil)
  frame:SetFrameLevel(4)
  if frame.HighlightTexture then
    frame.Texture:SetRotation(0)
    frame.HighlightTexture:SetRotation(0)
    frame.HighlightTexture:SetDrawLayer("HIGHLIGHT")
    frame.HighlightTexture:Show()
    frame.Texture:SetVertexColor(1, 1, 1, 1)
    frame.HighlightTexture:SetVertexColor(1, 1, 1, 1)
    frame.Texture:SetDesaturated(false)
    frame.HighlightTexture:SetDesaturated(false)
  end
  if frame.textString then frame.textString:Hide() end

  if poiType == "mapLink" then
    local poiScale = poi.scale or 1
    frame:SetSize(22 * poiScale, 22 * poiScale)
    frame.Texture:SetSize(22 * poiScale, 22 * poiScale)
    frame.HighlightTexture:SetSize(22 * poiScale, 22 * poiScale)
    frame.HighlightTexture:SetDrawLayer("ARTWORK")
    frame.HighlightTexture:Hide()
    frame.poi = poi
    local directionToAtlas = {
      [-1] = "poi-door-down",
      [1] = "poi-door-up",
      [-2] = "poi-door-left",
      [2] = "poi-door-right",
    }
    local atlas = poi.arrowAtlas or directionToAtlas[poi.direction]
    frame.HighlightTexture:SetAtlas(atlas)
    frame.Texture:SetAtlas(atlas)
    frame.HighlightTexture:SetRotation(poi.arrowRotation or 0)
    frame.Texture:SetRotation(poi.arrowRotation or 0)
    if poi.arrowAtlas then
      frame.Texture:SetVertexColor(0.2, 1, 0.2, 1)
      frame.HighlightTexture:SetVertexColor(0.4, 1, 0.4, 1)
    end
    frame:SetScript("OnClick", function()
      ART:SetCurrentSubLevel(poi.target)
      ART:UpdateMap()
    end)
    frame:SetScript("OnEnter", function()
      GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
      GameTooltip:AddLine(ART:GetRaidFloors()[db.currentRaidIndex][poi.target], 1, 1, 1, 1)
      if db.devMode then GameTooltip:AddLine(frame.poi.connectionIndex, 1, 1, 1, 1) end
      GameTooltip:Show()
      frame.HighlightTexture:Show()
    end)
    frame:SetScript("OnLeave", function()
      GameTooltip:Hide()
      frame.HighlightTexture:Hide()
    end)
  elseif poiType == "generalNote" then
    local size = 10 * (poi.scale or 1)
    frame:SetSize(size, size)
    frame.Texture:SetSize(size, size)
    frame.HighlightTexture:SetSize(size, size)
    frame.HighlightTexture:SetAtlas("QuestNormal")
    frame.Texture:SetAtlas("QuestNormal")
    frame:SetScript("OnEnter", function()
      GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
      GameTooltip:AddLine((poi.text and L[poi.text]) or (poi.formattedText and formatPoiString(poi.formattedText)) or "", 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
  end

  local scale = ART:GetScale()
  frame:SetSize(frame:GetWidth() * scale, frame:GetHeight() * scale)
  if frame.Texture then frame.Texture:SetSize(frame.Texture:GetWidth() * scale, frame.Texture:GetHeight() * scale) end
  if frame.HighlightTexture then
    frame.HighlightTexture:SetSize(frame.HighlightTexture:GetWidth() * scale, frame.HighlightTexture:GetHeight() * scale)
  end
  if db.devMode then POI_SetDevOptions(frame, poi) end
end

function ART:POI_HideAllPoints()
  for _, poiFrame in pairs(points) do poiFrame:Hide() end
end

---POI_UpdateAll
function ART:POI_UpdateAll()
  twipe(points)
  db = ART:GetDB()
  ART.GetFramePool("MapLinkPinTemplate"):ReleaseAll()
  if not ART.mapPOIs[db.currentRaidIndex] then return end
  local currentSublevel = ART:GetCurrentSubLevel()
  local pois = ART.mapPOIs[db.currentRaidIndex][currentSublevel]
  if not pois then return end
  local scale = ART:GetScale()
  for poiIdx, poi in pairs(pois) do
    local poiFrame = ART.GetFramePool(poi.template or "MapLinkPinTemplate"):Acquire()
    poiFrame.poiIdx = poiIdx
    POI_SetOptions(poiFrame, poi.type, poi)
    poiFrame.x = poi.x
    poiFrame.y = poi.y
    poiFrame:ClearAllPoints()
    poiFrame:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", poi.x * scale, poi.y * scale)
    poiFrame:Show()
    tinsert(points, poiFrame)
  end
end
