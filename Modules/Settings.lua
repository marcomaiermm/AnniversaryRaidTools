local _, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local L = ART.L
local mainFrameStrata = "HIGH"
local panelHeight = 30

local AceGUI = LibStub("AceGUI-3.0")

---Dropdown menu items for color settings frame
local colorPaletteNames = {
  [1] = L["Rainbow"],
  [2] = L["Black and Yellow"],
  [3] = L["Red, Green and Blue"],
  [4] = L["High Contrast"],
  [5] = L["Color Blind Friendly"],
  [6] = L["Custom"],
}

ART:RegisterNavigationSection({
  key = "settings",
  name = L["Settings"],
  tooltip = L["Settings"],
  texture = "Interface\\AddOns\\"..ART.AddonName.."\\Textures\\icons",
  texCoords = { 0, 0.25, 0.25, 0.5 },
  iconSize = 25,
  iconOffsetX = 0.75,
  onShow = function()
    ART:Settings_RefreshLayout()
  end,
})

function ART:ToggleSettingsDialog()
  local db = ART:GetDB()
  if not db then return end

  if not ART.main_frame.settingsFrame then
    ART:MakeSettingsFrame(ART.main_frame)
  end
  ART:SetCurrentSection("settings")
  if db.colorPaletteInfo.colorPaletteIdx == 6 then
    ART:OpenCustomColorsDialog()
  end
end

function ART:OpenCustomColorsDialog()
  if not ART.main_frame.settingsFrame then
    ART:MakeSettingsFrame(ART.main_frame)
  end
  ART:SetCurrentSection("settings")
  ART:Settings_RefreshLayout()
end

function ART:Settings_RefreshLayout()
  local frame = ART.main_frame
  if not frame or not frame.settingsFrame then return end

  frame.settingsFrame.frame:Show()
  if frame.settingsGeneralColumn then
    frame.settingsGeneralColumn.frame:Show()
    frame.settingsGeneralColumn:DoLayout()
  end
  if frame.settingsColorsColumn then
    frame.settingsColorsColumn.frame:Show()
    frame.settingsColorsColumn:DoLayout()
  end
  if frame.settingsFrame.CustomColorFrame then
    frame.settingsFrame.CustomColorFrame.frame:Show()
    frame.settingsFrame.CustomColorFrame:DoLayout()
  end
end

---creates frame housing settings for user customized color palette
function ART:MakeCustomColorFrame(frame)
  local db = ART:GetDB()
  if not db then return end

  --Base frame for custom palette setup
  if not frame.CustomColorFrame then
    local customColorParent = frame.settingsColorsColumn or frame
    frame.CustomColorFrame = AceGUI:Create("InlineGroup")
    frame.CustomColorFrame:SetTitle(L["Custom Color Palette"])
    frame.CustomColorFrame:SetWidth(frame.settingWidth or 250)
    frame.CustomColorFrame:SetLayout("Flow")
    customColorParent:AddChild(frame.CustomColorFrame)
  end

  frame.CustomColorFrame:ReleaseChildren()
  frame.CustomColorFrame.ColorPicker = {}

  --Slider to adjust number of different colors and remake the frame OnMouseUp
  frame.CustomColorFrame.ColorSlider = AceGUI:Create("Slider")
  frame.CustomColorFrame.ColorSlider:SetSliderValues(2, 20, 1)
  frame.CustomColorFrame.ColorSlider:SetLabel(L["Choose number of colors"])
  frame.CustomColorFrame.ColorSlider:SetRelativeWidth(1)
  frame.CustomColorFrame:AddChild(frame.CustomColorFrame.ColorSlider)
  frame.CustomColorFrame.ColorSlider:SetValue(db.colorPaletteInfo.numberCustomColors)
  frame.CustomColorFrame.ColorSlider:SetCallback("OnMouseUp", function(event, callbackName, value)
    if value > 20 then
      db.colorPaletteInfo.numberCustomColors = 20
    elseif value < 2 then
      db.colorPaletteInfo.numberCustomColors = 2
    else
      db.colorPaletteInfo.numberCustomColors = value
    end
    ART:SetPresetColorPaletteInfo()
    ART:ReloadPullButtons()
    ART:MakeCustomColorFrame(frame)
    ART:OpenCustomColorsDialog()
  end)

  --Loop to create as many colorpickers as requested limited by db.colorPaletteInfo.numberCustomColors
  for i = 1, db.colorPaletteInfo.numberCustomColors do
    frame.CustomColorFrame.ColorPicker[i] = AceGUI:Create("ColorPicker")
    if db.colorPaletteInfo.customPaletteValues[i] then
      frame.CustomColorFrame.ColorPicker[i]:SetColor(db.colorPaletteInfo.customPaletteValues[i][1],
        db.colorPaletteInfo.customPaletteValues[i][2], db.colorPaletteInfo.customPaletteValues[i][3])
    else
      db.colorPaletteInfo.customPaletteValues[i] = { 1, 1, 1 }
      frame.CustomColorFrame.ColorPicker[i]:SetColor(db.colorPaletteInfo.customPaletteValues[i][1],
        db.colorPaletteInfo.customPaletteValues[i][2], db.colorPaletteInfo.customPaletteValues[i][3])
    end
    frame.CustomColorFrame.ColorPicker[i]:SetLabel(" "..i)
    frame.CustomColorFrame.ColorPicker[i]:SetRelativeWidth(0.25)
    frame.CustomColorFrame.ColorPicker[i]:SetHeight(15)
    frame.CustomColorFrame.ColorPicker[i]:SetCallback("OnValueChanged", function(widget, event, r, g, b)
      db.colorPaletteInfo.customPaletteValues[i] = { r, g, b }
      ART:SetPresetColorPaletteInfo()
      ART:ReloadPullButtons()
    end)
    frame.CustomColorFrame:AddChild(frame.CustomColorFrame.ColorPicker[i])
  end
  if frame.settingsColorsColumn then
    frame.settingsColorsColumn:DoLayout()
  end
end

function ART:MakeSettingsFrame(frame)
  if frame.settingsFrame then return end

  local db = ART:GetDB()
  if not db then return end

  local parentFrame = frame.sectionContentFrames and frame.sectionContentFrames.settings or frame
  frame.settingsFrame = AceGUI:Create("SimpleGroup")
  frame.settingsFrame.frame:SetParent(parentFrame)
  frame.settingsFrame.frame:SetFrameStrata(mainFrameStrata)
  frame.settingsFrame.frame:SetFrameLevel(3)
  local columnWidth = 325
  local columnGap = 36
  local columnHeight = 450
  local frameWidth = (columnWidth * 2) + columnGap
  local settingWidth = columnWidth - 10
  frame.settingsFrame:SetWidth(frameWidth)
  frame.settingsFrame:SetHeight(columnHeight)
  frame.settingsFrame:SetAutoAdjustHeight(false)
  frame.settingsFrame.settingWidth = settingWidth
  frame.settingsFrame:SetLayout("Flow")
  frame.settingsFrame.frame:ClearAllPoints()
  frame.settingsFrame.frame:SetPoint("TOP", parentFrame, "TOP", 0, -(panelHeight + 15))

  local function createSettingsColumn(point, relativeTo, relativePoint, xOffset)
    local column = AceGUI:Create("SimpleGroup")
    column:SetParent(frame.settingsFrame)
    column.frame:SetFrameStrata(mainFrameStrata)
    column.frame:SetFrameLevel(frame.settingsFrame.frame:GetFrameLevel() + 1)
    column:SetWidth(columnWidth)
    column:SetHeight(columnHeight)
    column:SetLayout("Flow")
    column:SetAutoAdjustHeight(false)
    column.alignoffset = 0
    column.frame:ClearAllPoints()
    column.frame:SetPoint(point, relativeTo, relativePoint, xOffset, 0)
    column.frame:Show()
    return column
  end

  frame.settingsGeneralColumn = createSettingsColumn("TOPLEFT", frame.settingsFrame.content, "TOPLEFT", 0)
  frame.settingsColorsColumn = createSettingsColumn("TOPLEFT", frame.settingsGeneralColumn.frame, "TOPRIGHT", columnGap)
  frame.settingsFrame.settingsColorsColumn = frame.settingsColorsColumn

  frame.settingsHeading = AceGUI:Create("Heading")
  frame.settingsHeading:SetText(L["General"])
  frame.settingsHeading:SetFullWidth(true)
  frame.settingsGeneralColumn:AddChild(frame.settingsHeading)

  frame.minimapCheckbox = AceGUI:Create("CheckBox")
  frame.minimapCheckbox:SetLabel(L["Enable Minimap Button"])
  frame.minimapCheckbox:SetWidth(settingWidth)
  frame.minimapCheckbox:SetValue(not db.minimap.hide)
  frame.minimapCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
    if value then ART:ShowMinimapButton() else ART:HideMinimapButton() end
  end)
  frame.settingsGeneralColumn:AddChild(frame.minimapCheckbox)

  frame.combatLoggingCheckbox = AceGUI:Create("CheckBox")
  frame.combatLoggingCheckbox:SetLabel(L["Automatic combat logging in raids"])
  frame.combatLoggingCheckbox:SetWidth(settingWidth)
  frame.combatLoggingCheckbox:SetValue(db.combatLogging.enabled == true)
  frame.combatLoggingCheckbox:SetCallback("OnValueChanged", function(_, _, value)
    ART:CombatLogging_SetEnabled(value)
  end)
  frame.settingsGeneralColumn:AddChild(frame.combatLoggingCheckbox)

  frame.pullButtonHealthCheckbox = AceGUI:Create("CheckBox")
  frame.pullButtonHealthCheckbox:SetLabel(L["Show pull health"])
  frame.pullButtonHealthCheckbox:SetWidth(settingWidth)
  frame.pullButtonHealthCheckbox:SetValue(db.showPullButtonHealth)
  frame.pullButtonHealthCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
    db.showPullButtonHealth = value
    ART:ReloadPullButtons()
  end)
  frame.settingsGeneralColumn:AddChild(frame.pullButtonHealthCheckbox)

  frame.pullTrackerCheckbox = AceGUI:Create("CheckBox")
  frame.pullTrackerCheckbox:SetLabel("Show current pull widget")
  frame.pullTrackerCheckbox:SetWidth(settingWidth)
  frame.pullTrackerCheckbox:SetValue(db.showPullTracker ~= false)
  frame.pullTrackerCheckbox:SetCallback("OnValueChanged", function(_, _, value)
    if ART.RaidMarksUI then ART.RaidMarksUI:SetPullTrackerShown(value) end
  end)
  frame.settingsGeneralColumn:AddChild(frame.pullTrackerCheckbox)

  frame.autoPanToPullCheckbox = AceGUI:Create("CheckBox")
  frame.autoPanToPullCheckbox:SetLabel(L["Auto pan to selected pull"])
  frame.autoPanToPullCheckbox:SetWidth(settingWidth)
  frame.autoPanToPullCheckbox:SetValue(db.autoPanToPull ~= false)
  frame.autoPanToPullCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
    db.autoPanToPull = value
  end)
  frame.settingsGeneralColumn:AddChild(frame.autoPanToPullCheckbox)

  frame.alwaysOverwriteRoutesByUIDCheckbox = AceGUI:Create("CheckBox")
  frame.alwaysOverwriteRoutesByUIDCheckbox:SetLabel(L["Always overwrite matching routes on import"])
  frame.alwaysOverwriteRoutesByUIDCheckbox:SetWidth(settingWidth)
  frame.alwaysOverwriteRoutesByUIDCheckbox:SetValue(db.alwaysOverwriteRoutesByUID)
  frame.alwaysOverwriteRoutesByUIDCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
    db.alwaysOverwriteRoutesByUID = value
  end)
  frame.settingsGeneralColumn:AddChild(frame.alwaysOverwriteRoutesByUIDCheckbox)

  frame.announceInstanceResetCheckbox = AceGUI:Create("CheckBox")
  frame.announceInstanceResetCheckbox:SetLabel(L["announceInstanceReset"])
  frame.announceInstanceResetCheckbox:SetWidth(settingWidth)
  frame.announceInstanceResetCheckbox:SetValue(db.announceInstanceReset == true)
  frame.announceInstanceResetCheckbox:SetCallback("OnValueChanged", function(_, _, value)
    db.announceInstanceReset = value
    if value then ART:EnableInstanceResetAnnounceHook() end
  end)
  frame.settingsGeneralColumn:AddChild(frame.announceInstanceResetCheckbox)

  frame.fadeOutCheckbox = AceGUI:Create("CheckBox")
  frame.fadeOutCheckbox:SetLabel(L["Make window transparent in combat"])
  frame.fadeOutCheckbox:SetWidth(settingWidth)
  frame.fadeOutCheckbox:SetValue(db.fadeOutDuringCombat)
  frame.fadeOutCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
    db.fadeOutDuringCombat = value
    frame.fadeOutAlphaSlider:SetDisabled(not value)
    ART:UpdateFadeEventRegistration()
  end)
  frame.settingsGeneralColumn:AddChild(frame.fadeOutCheckbox)

  frame.fadeOutAlphaSlider = AceGUI:Create("Slider")
  frame.fadeOutAlphaSlider:SetLabel(L["Combat Transparency"])
  frame.fadeOutAlphaSlider:SetWidth(settingWidth)
  frame.fadeOutAlphaSlider:SetSliderValues(0.1, 1.0, 0.1)
  frame.fadeOutAlphaSlider:SetValue(db.fadeOutAlpha)
  frame.fadeOutAlphaSlider:SetDisabled(not db.fadeOutDuringCombat)
  frame.fadeOutAlphaSlider:SetCallback("OnValueChanged", function(widget, callbackName, value)
    db.fadeOutAlpha = value
  end)
  frame.settingsGeneralColumn:AddChild(frame.fadeOutAlphaSlider)

  frame.colorsHeading = AceGUI:Create("Heading")
  frame.colorsHeading:SetText(L["Colors"])
  frame.colorsHeading:SetFullWidth(true)
  frame.settingsColorsColumn:AddChild(frame.colorsHeading)

  frame.AutomaticColorsCheck = AceGUI:Create("CheckBox")
  frame.AutomaticColorsCheck:SetLabel(L["Automatically color pulls"])
  frame.AutomaticColorsCheck:SetWidth(settingWidth)
  frame.AutomaticColorsCheck:SetValue(db.colorPaletteInfo.autoColoring)
  frame.AutomaticColorsCheck:SetCallback("OnValueChanged", function(widget, callbackName, value)
    db.colorPaletteInfo.autoColoring = value
    ART:SetPresetColorPaletteInfo()
    frame.toggleForceColorBlindMode:SetDisabled(not value)
    if value then
      ART:ReloadPullButtons(true)
    end
  end)
  frame.settingsColorsColumn:AddChild(frame.AutomaticColorsCheck)

  --Toggle local color blind mode
  frame.toggleForceColorBlindMode = AceGUI:Create("CheckBox")
  frame.toggleForceColorBlindMode:SetLabel(L["Local color blind mode"])
  frame.toggleForceColorBlindMode:SetWidth(settingWidth)
  frame.toggleForceColorBlindMode:SetValue(db.colorPaletteInfo.forceColorBlindMode)
  frame.toggleForceColorBlindMode:SetCallback("OnValueChanged", function(widget, callbackName, value)
    db.colorPaletteInfo.forceColorBlindMode = value
    ART:SetPresetColorPaletteInfo()
    ART:ReloadPullButtons(true)
  end)
  frame.settingsColorsColumn:AddChild(frame.toggleForceColorBlindMode)

  frame.PaletteSelectDropdown = AceGUI:Create("Dropdown")
  frame.PaletteSelectDropdown:SetList(colorPaletteNames)
  frame.PaletteSelectDropdown:SetLabel(L["Choose preferred color palette"])
  frame.PaletteSelectDropdown:SetWidth(settingWidth)
  frame.PaletteSelectDropdown:SetValue(db.colorPaletteInfo.colorPaletteIdx)
  frame.PaletteSelectDropdown:SetCallback("OnValueChanged", function(widget, callbackName, value)
    if value == 6 then
      db.colorPaletteInfo.colorPaletteIdx = value
      ART:OpenCustomColorsDialog()
    else
      db.colorPaletteInfo.colorPaletteIdx = value
    end
    ART:SetPresetColorPaletteInfo()
    ART:ReloadPullButtons(true)
  end)
  frame.settingsColorsColumn:AddChild(frame.PaletteSelectDropdown)

  -- The reason this button exists is to allow altering colorPaletteInfo of an imported preset
  -- Without the need to untoggle/toggle or swap back and forth in the PaletteSelectDropdown
  frame.button = AceGUI:Create("Button")
  frame.button:SetText(L["Apply to preset"])
  frame.button:SetWidth(settingWidth)
  frame.button:SetCallback("OnClick", function(widget, callbackName)
    if not db.colorPaletteInfo.autoColoring then
      db.colorPaletteInfo.autoColoring = true
      frame.AutomaticColorsCheck:SetValue(db.colorPaletteInfo.autoColoring)
      frame.toggleForceColorBlindMode:SetDisabled(false)
    end
    ART:SetPresetColorPaletteInfo()
    ART:ReloadPullButtons(true)
  end)
  frame.settingsColorsColumn:AddChild(frame.button)

  ART:MakeCustomColorFrame(frame.settingsFrame)

  -- Language switching is not supported yet.
  --[[
  frame.localeHeading = AceGUI:Create("Heading")
  frame.localeHeading:SetText(L["Language"])
  frame.localeHeading:SetFullWidth(true)
  frame.settingsGeneralColumn:AddChild(frame.localeHeading)

  frame.localeButton = AceGUI:Create("Button")
  frame.localeButton:SetText(L["Change Language"])
  frame.localeButton:SetWidth(settingWidth)
  local slashToFire = _G.SlashCmdList["ADDONLOCALE"]
  if not slashToFire then
    frame.localeButton:SetDisabled(true)
  else
    frame.localeButton:SetCallback("OnClick", function(widget, callbackName)
      slashToFire("")
    end)
  end
  frame.settingsGeneralColumn:AddChild(frame.localeButton)

  frame.localeLabel = AceGUI:Create("Label")
  if not slashToFire then
    frame.localeLabel:SetText("|cff808080"..L["localeButtonTooltip1"].."|r")
  else
    frame.localeLabel:SetText(L["localeButtonTooltip2"])
  end
  frame.settingsGeneralColumn:AddChild(frame.localeLabel)
  ]]

  ART:Settings_RefreshLayout()
end
