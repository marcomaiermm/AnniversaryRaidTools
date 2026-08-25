local _, ART = ...
local L = ART.L
local mainFrameStrata = "HIGH"
local canvasDrawLayer = "BORDER"
local navigationSidebarWidth = 42
local panelHeight = 30
local defaultIconTexture = "Interface\\AddOns\\"..ART.AddonName.."\\Textures\\navigationSidebarIcons"

ART.navigationSections = {}
ART.navigationSectionLookup = {}

function ART:RegisterNavigationSection(section)
  assert(section.key, "Navigation section requires a key")
  assert(not self.navigationSectionLookup[section.key], "Duplicate navigation section: "..section.key)
  section.createContentFrame = section.createContentFrame ~= false
  section.createSidePanelFrame = section.createSidePanelFrame ~= false
  section.texture = section.texture or defaultIconTexture
  section.onShow = section.onShow or function() end
  self.navigationSectionLookup[section.key] = section
  table.insert(self.navigationSections, section)
  return section
end

function ART:GetNavigationSections()
  return self.navigationSections
end

function ART:GetNavigationSection(sectionKey)
  return self.navigationSectionLookup[sectionKey]
end

function ART:IsValidNavigationSection(sectionKey)
  return self:GetNavigationSection(sectionKey) ~= nil
end

ART:RegisterNavigationSection({
  key = "maps",
  tooltip = L["Maps"],
  texCoords = { 0, 0.25, 0, 0.25 },
  iconOffsetY = -0.5,
  createContentFrame = false,
  createSidePanelFrame = false,
})

function ART:GetNavigationSidebarWidth()
  return navigationSidebarWidth
end

function ART:GetCurrentSection()
  local db = ART:GetDB()
  if db then
    if not self:IsValidNavigationSection(db.currentSection) then db.currentSection = "maps" end
    return db.currentSection
  end
  if not self:IsValidNavigationSection(self.currentSection) then self.currentSection = "maps" end
  return self.currentSection
end

function ART:IsMapSectionActive()
  return self:GetCurrentSection() == "maps"
end

local function setShown(region, shown)
  local frame = region and (region.frame or region)
  if not frame then return end
  if shown then
    frame:Show()
  else
    frame:Hide()
  end
end

local function closeAceDropdown(widget)
  if not widget or not widget.pullout then return end
  widget.pullout:Close()
  if widget.pullout.frame then widget.pullout.frame:Hide() end
end

function ART:SetCurrentSection(sectionKey)
  if not self:IsValidNavigationSection(sectionKey) then sectionKey = "maps" end
  local db = ART:GetDB()
  if db then
    db.currentSection = sectionKey
  else
    self.currentSection = sectionKey
  end
  ART:UpdateSectionVisibility()
end

function ART:UpdateSectionVisibility()
  local frame = ART.main_frame
  if not frame then return end
  local db = ART:GetDB()
  local currentSection = ART:GetCurrentSection()
  local showMapControls = currentSection == "maps"

  if frame.navigationSidebar and frame.navigationSidebar.buttons then
    for sectionKey, button in pairs(frame.navigationSidebar.buttons) do
      local active = sectionKey == currentSection
      if button.activeTexture then setShown(button.activeTexture, active) end
    end
  end

  setShown(frame.scrollFrame, showMapControls)
  setShown(frame.mapPanelFrame, showMapControls)

  if frame.toolbar then
    setShown(frame.toolbar.toggleButton, showMapControls)
    if showMapControls and db and db.toolbarExpanded then
      frame.toolbar:Show()
    else
      frame.toolbar:Hide()
    end
  end

  if frame.sidePanel then
    setShown(frame.sidePanel.WidgetGroup, showMapControls)
    if frame.sidePanel.WidgetGroup then
      setShown(frame.sidePanel.WidgetGroup.PresetDropDown, showMapControls)
    end
    setShown(frame.sidePanelNewButton, showMapControls)
    setShown(frame.sidePanelRenameButton, showMapControls)
    setShown(frame.sidePanelDeleteButton, showMapControls)
    setShown(frame.sidePanelExportButton, showMapControls)
    setShown(frame.sidePanelImportButton, showMapControls)
    setShown(frame.LinkToChatButton, showMapControls)
    setShown(frame.LiveSessionButton, showMapControls)
    setShown(frame.sidePanel.middleLine, showMapControls)
    setShown(frame.sidePanel.PullButtonScrollGroup, showMapControls)
    if not showMapControls then
      closeAceDropdown(frame.sidePanel.WidgetGroup and frame.sidePanel.WidgetGroup.PresetDropDown)
    end
  end

  if frame.sublevelSelectionGroup then setShown(frame.sublevelSelectionGroup, showMapControls) end
  if not showMapControls then
    closeAceDropdown(frame.sublevelSelectionGroup and frame.sublevelSelectionGroup.sublevelDropdown)
  end
  if ART.UpdateRaidSelectVisibility then ART:UpdateRaidSelectVisibility(showMapControls) end

  if frame.sectionContentFrames then
    for sectionKey, sectionFrame in pairs(frame.sectionContentFrames) do
      setShown(sectionFrame, sectionKey == currentSection)
    end
  end
  if frame.sectionSidePanelFrames then
    for sectionKey, sectionFrame in pairs(frame.sectionSidePanelFrames) do
      setShown(sectionFrame, sectionKey == currentSection)
    end
  end

  local sectionChanged = frame.lastVisibleSection ~= currentSection
  frame.lastVisibleSection = currentSection
  local currentSectionConfig = ART:GetNavigationSection(currentSection)
  currentSectionConfig.onShow(sectionChanged)
end

function ART:MakeNavigationSidebar(frame)
  if frame.navigationSidebar == nil then
    frame.navigationSidebar = CreateFrame("Frame", "ARTNavigationSidebar", frame)
    frame.navigationSidebar:SetFrameStrata(mainFrameStrata)
    frame.navigationSidebar:SetFrameLevel(4)
    frame.navigationSidebar.tex = frame.navigationSidebar:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.navigationSidebar.tex:SetAllPoints()
    frame.navigationSidebar.tex:SetDrawLayer(canvasDrawLayer, -5)
    frame.navigationSidebar.tex:SetColorTexture(unpack(ART.BackdropColor))
    frame.navigationSidebar.buttons = {}
    ART:RegisterMainFrameDragHandle(frame.navigationSidebar, frame)

    local sections = ART:GetNavigationSections()
    local buttonSize = 36
    local iconSize = 31
    local firstButtonTopOffset = -panelHeight

    for idx, section in ipairs(sections) do
      local button = CreateFrame("Button", "ARTNavigationSidebarButton"..idx, frame.navigationSidebar)
      button.frame = button
      button.type = "button"
      button.sectionKey = section.key
      button.tooltipText = section.tooltip
      button:SetSize(buttonSize, buttonSize)
      button:SetPoint("TOP", frame.navigationSidebar, "TOP", 0, firstButtonTopOffset - ((idx - 1) * (buttonSize + 6)))
      button:RegisterForClicks("AnyUp")

      local active = button:CreateTexture(nil, "BACKGROUND", nil, 1)
      active:SetAllPoints()
      active:SetColorTexture(1, 1, 1, 0.14)
      active:Hide()
      button.activeTexture = active

      local icon = button:CreateTexture(nil, "ARTWORK", nil, 0)
      icon:SetTexture(section.texture)
      icon:SetTexCoord(unpack(section.texCoords))
      icon:SetSize(section.iconSize or iconSize, section.iconSize or iconSize)
      icon:SetPoint("CENTER", button, "CENTER", section.iconOffsetX or 0, section.iconOffsetY or 0)
      icon:SetVertexColor(1, 1, 1, 0.9)
      button:SetNormalTexture(icon)

      local pushed = button:CreateTexture(nil, "ARTWORK", nil, 0)
      pushed:SetTexture(section.texture)
      pushed:SetTexCoord(unpack(section.texCoords))
      pushed:SetSize(section.iconSize or iconSize, section.iconSize or iconSize)
      pushed:SetPoint("CENTER", button, "CENTER", (section.iconOffsetX or 0) + 1, (section.iconOffsetY or 0) - 1)
      pushed:SetVertexColor(0.85, 0.85, 0.85, 0.9)
      button:SetPushedTexture(pushed)

      local highlight = button:CreateTexture(nil, "HIGHLIGHT", nil, 0)
      highlight:SetAllPoints()
      highlight:SetColorTexture(1, 1, 1, 0.08)
      button:SetHighlightTexture(highlight)

      button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(button, "ANCHOR_NONE")
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("LEFT", button, "RIGHT", 4, 0)
        GameTooltip:SetText(button.tooltipText, 1, 1, 1, 1)
        GameTooltip:Show()
      end)
      button:SetScript("OnLeave", function()
        ART:ToggleToolbarTooltip(false)
      end)
      button:SetScript("OnClick", function()
        ART:SetCurrentSection(section.key)
      end)

      frame.navigationSidebar.buttons[section.key] = button
    end
  end

  frame.navigationSidebar:ClearAllPoints()
  frame.navigationSidebar:SetWidth(navigationSidebarWidth)
  frame.navigationSidebar:SetPoint("TOPRIGHT", frame, "TOPLEFT", 0, panelHeight)
  frame.navigationSidebar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT")
end

function ART:MakeSectionFrames(frame)
  frame.sectionContentFrames = frame.sectionContentFrames or {}
  frame.sectionSidePanelFrames = frame.sectionSidePanelFrames or {}

  for _, section in ipairs(ART:GetNavigationSections()) do
    local sectionKey = section.key
    if section.createContentFrame and not frame.sectionContentFrames[sectionKey] then
      local contentFrame = CreateFrame("Frame", "ART"..sectionKey.."SectionContentFrame", frame)
      contentFrame:SetAllPoints(frame)
      contentFrame:SetFrameStrata(mainFrameStrata)
      contentFrame:SetFrameLevel(2)
      ART:RegisterMainFrameDragHandle(contentFrame, frame)
      contentFrame:Hide()
      frame.sectionContentFrames[sectionKey] = contentFrame
    end

    if section.createSidePanelFrame and not frame.sectionSidePanelFrames[sectionKey] then
      local sidePanelFrame = CreateFrame("Frame", "ART"..sectionKey.."SectionSidePanelFrame", frame.sidePanel)
      sidePanelFrame:SetAllPoints(frame.sidePanel)
      sidePanelFrame:SetFrameStrata(mainFrameStrata)
      sidePanelFrame:SetFrameLevel(3)
      ART:RegisterMainFrameDragHandle(sidePanelFrame, frame)
      sidePanelFrame:Hide()
      frame.sectionSidePanelFrames[sectionKey] = sidePanelFrame
    end
  end
end
