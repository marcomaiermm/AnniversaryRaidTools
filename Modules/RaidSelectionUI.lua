local _, ART = ...
local AceGUI = LibStub("AceGUI-3.0")

ART.knownRaids = ART.knownRaids or {}
ART.raidOrder = ART.raidOrder or {}

local db
local raidButtons = {}
local BUTTON_WIDTH, BUTTON_HEIGHT = 65, 40

function ART:UpdateRaidSelectVisibility(showMapControls)
  if showMapControls == nil then showMapControls = self:IsMapSectionActive() end
  for index, button in ipairs(raidButtons) do
    if showMapControls and index <= #self.raidOrder then button:Show() else button:Hide() end
  end

  local frame = self.main_frame
  local floors = db and self.raidFloors[db.currentRaidIndex]
  if not frame or not frame.sublevelSelectionGroup then return end
  local group = frame.sublevelSelectionGroup
  if showMapControls and floors and #floors > 1 then
    group.frame:Show()
    group.sublevelDropdown.frame:Show()
  else
    if group.sublevelDropdown.pullout then group.sublevelDropdown.pullout:Close() end
    group.sublevelDropdown.frame:Hide()
    group.frame:Hide()
  end
end

function ART:UpdateRaidSelectHighlight()
  for _, button in ipairs(raidButtons) do
    if button.raidIndex == db.currentRaidIndex then button.selectedTexture:Show() else button.selectedTexture:Hide() end
  end
end

function ART:UpdateRaidDropDown()
  db = db or self:GetDB()
  for index, raidIndex in ipairs(self.raidOrder) do
    local button = raidButtons[index]
    if not button then
      button = CreateFrame("Button", "ARTRaidButton"..index, self.main_frame)
      raidButtons[index] = button
      button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      button:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", (index - 1) * (BUTTON_WIDTH - 1), 0)
      button.texture = button:CreateTexture()
      button.texture:SetAllPoints()
      button.highlightTexture = button:CreateTexture()
      button:SetHighlightTexture(button.highlightTexture)
      button.highlightTexture:SetAtlas("bags-innerglow")
      button.selectedTexture = button:CreateTexture()
      button.selectedTexture:SetAllPoints()
      button.selectedTexture:SetAtlas("bags-glow-artifact")
      button.selectedTexture:SetDrawLayer("OVERLAY")
      button.shortText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      button.shortText:SetPoint("BOTTOM", 0, 2)
      button.shortText:SetFont(button.shortText:GetFont(), 9, "OUTLINE")
      button:SetScript("OnLeave", GameTooltip_Hide)
      button:RegisterForClicks("AnyDown", "AnyUp")
      button:SetFrameStrata("HIGH")
      button:SetFrameLevel(50)
    end

    local mapInfo = assert(self.mapInfo[raidIndex], "missing raid map info")
    local disabledReason = self.unsupportedRaids and self.unsupportedRaids[raidIndex]
    button.raidIndex = raidIndex
    button.texture:SetTexture(mapInfo.iconId or 134400)
    button.texture:SetTexCoord(unpack(mapInfo.iconTexCoords or { 0, 1, 0, 1 }))
    button.texture:SetDesaturated(disabledReason ~= nil)
    button.texture:SetAlpha(disabledReason and 0.4 or 1)
    button.shortText:SetText(mapInfo.iconTexCoords and "" or mapInfo.shortName)
    button.shortText:SetTextColor(disabledReason and 0.5 or 1, disabledReason and 0.5 or 1,
      disabledReason and 0.5 or 1)
    button:SetScript("OnClick", function()
      if not disabledReason then
        ART:UpdateToRaid(raidIndex)
        ART:UpdateRaidSelectHighlight()
      end
    end)
    button:SetScript("OnEnter", function()
      GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT", -button:GetWidth(), 0)
      GameTooltip:AddLine(ART.raidList[raidIndex], 1, 1, 1)
      if disabledReason then GameTooltip:AddLine(disabledReason, 0.7, 0.7, 0.7) end
      GameTooltip:Show()
    end)
    button:Show()
  end

  for index = #self.raidOrder + 1, #raidButtons do raidButtons[index]:Hide() end
  self:UpdateRaidSelectHighlight()

  local floors = self.raidFloors[db.currentRaidIndex]
  local group = self.main_frame.sublevelSelectionGroup
  local dropdown = group.sublevelDropdown
  dropdown:SetList(floors)
  dropdown:SetValue(db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentSublevel)
  dropdown:ClearFocus()
  self:UpdateRaidSelectVisibility()
end

function ART:CreateSublevelDropdown(frame)
  db = self:GetDB()
  frame.sublevelSelectionGroup = AceGUI:Create("SimpleGroup")
  local group = frame.sublevelSelectionGroup
  group.frame:SetParent(frame)
  group.frame:Hide()
  if not group.frame.SetBackdrop then Mixin(group.frame, BackdropTemplateMixin) end
  group.frame:SetBackdropColor(unpack(self.BackdropColor))
  group.frame:SetFrameStrata("HIGH")
  group.frame:SetFrameLevel(50)
  group:SetWidth(204)
  group:SetHeight(50)
  group:SetPoint("TOPLEFT", frame.topPanel, "TOPLEFT", 0, -68)
  group:SetLayout("List")
  group.sublevelDropdown = AceGUI:Create("Dropdown")
  group.sublevelDropdown.pullout.frame:SetParent(group.sublevelDropdown.frame)
  group.sublevelDropdown.text:SetJustifyH("LEFT")
  group.sublevelDropdown:SetCallback("OnValueChanged", function(_, _, floor)
    ART:SetCurrentSubLevel(floor)
    ART:UpdateMap()
  end)
  group:AddChild(group.sublevelDropdown)
end
