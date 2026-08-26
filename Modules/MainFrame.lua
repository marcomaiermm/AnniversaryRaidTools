local _, ART = ...
local L = ART.L
local mainFrameStrata = "HIGH"
local canvasDrawLayer = "BORDER"

local tinsert, CreateFrame, tonumber, max, min, abs, pairs, ipairs, GetCursorPosition, GameTooltip =
    table.insert, CreateFrame, tonumber, math.max, math.min, math.abs, pairs, ipairs, GetCursorPosition,
    GameTooltip

local sizex = 840
local sizey = 555
local defaultSavedVars = ART:GetDefaultSavedVariables()
local defaultNonFullscreenScale = defaultSavedVars.global.nonFullscreenScale
local minNonFullscreenScale = 0.9
local sidePanelWidth = 251
local panelHeight = 30
local screenEdgePadding = 10
local framesInitialized
local frameInitializedCallbacks = {}

local AceGUI = LibStub("AceGUI-3.0")
local db

function ART:RegisterMainFrameDragHandle(dragHandle, frame)
  frame = frame or ART.main_frame
  if not dragHandle or not frame then return end

  dragHandle:EnableMouse(true)
  dragHandle:RegisterForDrag("LeftButton")
  dragHandle:SetScript("OnDragStart", function()
    frame:SetMovable(true)
    frame:StartMoving()
  end)
  dragHandle:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    frame:SetMovable(false)
    if ART:IsFrameOffScreen() then
      ART:ResetMainFramePos(true)
    else
      local from, _, to, x, y = frame:GetPoint()
      db.anchorFrom = from
      db.anchorTo = to
      db.xoffset, db.yoffset = x, y
    end
  end)
end

function ART:ShowInterface(force)
  ART:Async(function() ART:ShowInterfaceInternal(force) end, "showInterface")
end

function ART:RunAfterFramesInitialized(callback)
  if framesInitialized then
    callback()
    return true
  end
  tinsert(frameInitializedCallbacks, callback)
  return false
end

function ART:AreFramesInitialized()
  return framesInitialized
end

function ART:ShowInterfaceInternal(force)
  if not self:IsCompatibleVersion() then
    self:ShowFallbackWindow()
    return
  end
  if self:CheckAddonConflicts() then
    self.ShowConflictFrame()
    return
  end
  ART:DisplayErrors()
  if not framesInitialized then ART:StartMainFrameInitialization() end
  if not framesInitialized then return end
  if self.main_frame:IsShown() and not force then
    ART:HideInterface()
  else
    self:CheckCurrentZone()
    self.main_frame:Show()
    ART:UpdateSectionVisibility()
    ART:RequestVersionCheck()
    ART:UpdateBottomText()
  end
end

function ART:InitializeFadeFrame()
  db = ART:GetDB()
  if self.fadeFrame then return end
  self.fadeFrame = CreateFrame("Frame")
  self.fadeFrame:SetScript("OnEvent", function(self, event)
    if not ART or not ART.main_frame or not db then return end
    if event == "PLAYER_REGEN_DISABLED" then
      ART.main_frame:SetAlpha(db.fadeOutAlpha or 0.5)
    elseif event == "PLAYER_REGEN_ENABLED" then
      ART.main_frame:SetAlpha(1)
    end
  end)
  self:UpdateFadeEventRegistration()
end

function ART:UpdateFadeEventRegistration()
  if not self.fadeFrame then return end
  if db and db.fadeOutDuringCombat then
    self.fadeFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    self.fadeFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
  else
    self.fadeFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
    self.fadeFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
    if self.main_frame then
      self.main_frame:SetAlpha(1)
    end
  end
end

function ART:HideInterface()
  if self.main_frame then
    self.main_frame:Hide()
  end
end

function ART:CreateMenu()
  -- Close button
  self.main_frame.closeButton = CreateFrame("Button", "ARTCloseButton", self.main_frame, "UIPanelCloseButton")
  self.main_frame.closeButton:ClearAllPoints()
  self.main_frame.closeButton:SetPoint("TOPRIGHT", self.main_frame.sidePanel, "TOPRIGHT", -1, -4)
  self.main_frame.closeButton:SetScript("OnClick", function() self:HideInterface() end)
  self.main_frame.closeButton:SetFrameLevel(4)
  self.main_frame.closeButton:SetSize(24, 24)

  --Maximize Button
  self.main_frame.maximizeButton = CreateFrame("Button", "ARTMaximizeButton", self.main_frame,
    "MaximizeMinimizeButtonFrameTemplate")
  self.main_frame.maximizeButton:ClearAllPoints()
  ---@diagnostic disable-next-line: param-type-mismatch
  self.main_frame.maximizeButton:SetPoint("RIGHT", self.main_frame.closeButton, "LEFT", 0, 0)
  self.main_frame.maximizeButton:SetFrameLevel(4)
  db.maximized = db.maximized or false
  if not db.maximized then self.main_frame.maximizeButton:Minimize() end
  self.main_frame.maximizeButton:SetOnMaximizedCallback(self.Maximize)
  self.main_frame.maximizeButton:SetOnMinimizedCallback(self.Minimize)
  self.main_frame.maximizeButton:SetSize(24, 24)

  --return to live preset
  self.main_frame.liveReturnButton = CreateFrame("Button", "ARTLiveReturnButton", self.main_frame, "UIPanelCloseButton")
  local liveReturnButton = self.main_frame.liveReturnButton
  liveReturnButton:ClearAllPoints()
  liveReturnButton:SetPoint("RIGHT", self.main_frame.topPanel, "RIGHT", 0, 0)
  liveReturnButton:Hide()
  liveReturnButton.Icon = liveReturnButton:CreateTexture(nil, "OVERLAY", nil, 0)
  liveReturnButton.Icon:SetTexture("Interface\\Buttons\\UI-RefreshButton")
  liveReturnButton.Icon:SetSize(16, 16)
  liveReturnButton.Icon:SetTexCoord(1, 0, 0, 1) --flipped image
  ---@diagnostic disable-next-line: param-type-mismatch
  liveReturnButton.Icon:SetPoint("CENTER", liveReturnButton, "CENTER")
  liveReturnButton:SetScript("OnClick", function() self:ReturnToLivePreset() end)
  liveReturnButton:SetFrameLevel(4)
  liveReturnButton.tooltip = L["Return to the live preset"]

  --set preset as new live preset
  self.main_frame.setLivePresetButton = CreateFrame("Button", "ARTSetLivePresetButton", self.main_frame,
    "UIPanelCloseButton")
  local setLivePresetButton = self.main_frame.setLivePresetButton
  setLivePresetButton:ClearAllPoints()
  ---@diagnostic disable-next-line: param-type-mismatch
  setLivePresetButton:SetPoint("RIGHT", liveReturnButton, "LEFT", 0, 0)
  setLivePresetButton:Hide()
  setLivePresetButton.Icon = setLivePresetButton:CreateTexture(nil, "OVERLAY", nil, 0)
  setLivePresetButton.Icon:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
  setLivePresetButton.Icon:SetSize(16, 16)
  ---@diagnostic disable-next-line: param-type-mismatch
  setLivePresetButton.Icon:SetPoint("CENTER", setLivePresetButton, "CENTER")
  setLivePresetButton:SetScript("OnClick", function() self:SetLivePreset() end)
  setLivePresetButton:SetFrameLevel(4)
  setLivePresetButton.tooltip = L["Make this preset the live preset"]

  --Resize Handle
  self.main_frame.resizer = CreateFrame("BUTTON", nil, self.main_frame.sidePanel)
  local resizer = self.main_frame.resizer
  resizer:SetPoint("BOTTOMRIGHT", self.main_frame.sidePanel, "BOTTOMRIGHT", 7, -7)
  resizer:SetSize(25, 25)
  resizer:EnableMouse()
  resizer:SetScript("OnMouseDown", function()
    self.main_frame:StartSizing("BOTTOMRIGHT")
    self:StartScaling()
    self:HideAllPresetObjects()
    self:ReleaseHullTextures()
    self.main_frame:SetScript("OnSizeChanged", function()
      local height = self.main_frame:GetHeight()
      self:SetScale(height / sizey)
    end)
  end)
  resizer:SetScript("OnMouseUp", function()
    self.main_frame:StopMovingOrSizing()
    self:UpdateEnemyInfoFrame()
    self:UpdateMap()
    self:UpdateBottomText()
    self.main_frame:SetScript("OnSizeChanged", nil)
  end)
  local normal = resizer:CreateTexture(nil, "OVERLAY", nil, 0)
  normal:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  normal:SetTexCoord(0, 1, 0, 1)
  normal:SetPoint("BOTTOMLEFT", resizer, 0, 6)
  normal:SetPoint("TOPRIGHT", resizer, -6, 0)
  resizer:SetNormalTexture(normal)
  local pushed = resizer:CreateTexture(nil, "OVERLAY", nil, 0)
  pushed:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
  pushed:SetTexCoord(0, 1, 0, 1)
  pushed:SetPoint("BOTTOMLEFT", resizer, 0, 6)
  pushed:SetPoint("TOPRIGHT", resizer, -6, 0)
  resizer:SetPushedTexture(pushed)
  local highlight = resizer:CreateTexture(nil, "OVERLAY", nil, 0)
  highlight:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
  highlight:SetTexCoord(0, 1, 0, 1)
  highlight:SetPoint("BOTTOMLEFT", resizer, 0, 6)
  highlight:SetPoint("TOPRIGHT", resizer, -6, 0)
  resizer:SetHighlightTexture(highlight)
end

---GetDefaultMapPanelSize
function ART:GetDefaultMapPanelSize()
  return sizex, sizey
end

---GetScale
---Returns scale factor stored in db
function ART:GetScale()
  if not db.scale then db.scale = 1 end
  return db.scale
end

local oldScrollValues = {}
---StartScaling
---Stores values when we start scaling the frame
function ART:StartScaling()
  local f = self.main_frame
  oldScrollValues.oldScrollH = f.scrollFrame:GetHorizontalScroll()
  oldScrollValues.oldScrollV = f.scrollFrame:GetVerticalScroll()
  oldScrollValues.oldSizeX = f.scrollFrame:GetWidth()
  oldScrollValues.oldSizeY = f.scrollFrame:GetHeight()
  self:RaidEnemies_HideAllBlips()
  self:POI_HideAllPoints()
end

---SetScale
---Scales the map frame and it's sub frames to a factor and stores the scale in db
function ART:SetScale(scale)
  local f = self.main_frame
  local newSizex = sizex * scale
  local newSizey = sizey * scale
  f:SetSize(newSizex, newSizey)
  f.scrollFrame:SetSize(newSizex, newSizey)
  f.mapPanelFrame:SetSize(newSizex, newSizey)
  for i = 1, 12 do
    f["mapPanelTile"..i]:SetSize((newSizex / 4 + 5 * scale), (newSizex / 4 + 5 * scale))
  end
  for i = 1, 10 do
    for j = 1, 15 do
      local tile = f["largeMapPanelTile"..i..j]
      if tile then tile:SetSize(newSizex / 15, newSizex / 15) end
    end
  end
  f.scrollFrame:SetVerticalScroll(oldScrollValues.oldScrollV * (newSizey / oldScrollValues.oldSizeY))
  f.scrollFrame:SetHorizontalScroll(oldScrollValues.oldScrollH * (newSizex / oldScrollValues.oldSizeX))
  f.scrollFrame.cursorY = f.scrollFrame.cursorY * (newSizey / oldScrollValues.oldSizeY)
  f.scrollFrame.cursorX = f.scrollFrame.cursorX * (newSizex / oldScrollValues.oldSizeX)
  self:ZoomMap(0)
  db.scale = scale
  db.nonFullscreenScale = scale
end

function ART:GetFullScreenSizes()
  local newSizey = GetScreenHeight() - (panelHeight * 2)
  local newSizex = newSizey * (sizex / sizey)
  local navigationSidebarWidth = ART:GetNavigationSidebarWidth()
  local isNarrow
  if newSizex + sidePanelWidth + navigationSidebarWidth > GetScreenWidth() then
    newSizex = GetScreenWidth() - sidePanelWidth - navigationSidebarWidth
    newSizey = newSizex * (sizey / sizex)
    isNarrow = true
  end
  local scale = newSizey / sizey --use this for adjusting NPC / POI positions later
  return newSizex, newSizey, scale, isNarrow
end

function ART:GetDefaultNonFullscreenScale(xoffset, yoffset)
  xoffset = xoffset or defaultSavedVars.global.xoffset
  yoffset = yoffset or defaultSavedVars.global.yoffset

  local screenWidth = GetScreenWidth()
  local screenHeight = GetScreenHeight()
  if not screenWidth or not screenHeight or screenWidth <= 0 or screenHeight <= 0 then
    return defaultNonFullscreenScale
  end

  local navigationSidebarWidth = ART:GetNavigationSidebarWidth()
  local maxLeftScale = ((screenWidth / 2) + xoffset - navigationSidebarWidth - screenEdgePadding) * 2 / sizex
  local maxRightScale = ((screenWidth / 2) - sidePanelWidth - xoffset - screenEdgePadding) * 2 / sizex
  local maxHeightScale = (screenHeight + yoffset - panelHeight - screenEdgePadding) / sizey
  local maxScale = min(maxLeftScale, maxRightScale, maxHeightScale)

  return min(defaultNonFullscreenScale, max(minNonFullscreenScale, maxScale))
end

function ART:IsFrameOffScreen()
  local topPanel = ART.main_frame.topPanel
  local bottomPanel = ART.main_frame.bottomPanel
  local width = GetScreenWidth()
  local height = GetScreenHeight()
  local left = ART.main_frame.navigationSidebar and ART.main_frame.navigationSidebar:GetLeft() or topPanel:GetLeft() -->width
  local right = topPanel:GetRight()                                                                                  --<0
  local bottom = topPanel:GetBottom()                                                                                --<0
  local top = bottomPanel:GetTop()                                                                                   -->height
  return left > width or right < 0 or bottom < 0 or top > height
end

local bottomTips = {
  [1] = L["Hold CTRL to single-select enemies."],
  [3] = L["Hold SHIFT to create a new pull while selecting enemies."],
  [4] = L["Hold SHIFT to delete all presets with the delete preset button."],
  [5] = L["Right click a pull for more options."],
  [6] = L["Right click an enemy to open the enemy info window."],
  [7] = L["Drag the bottom right edge to resize ART."],
  [8] = L["Click the fullscreen button for a maximized view of ART."],
  [9] = L["Use /art reset to restore the default position and scale of ART."],
  [10] = L["Mouseover the Live button while in a group to learn more about Live mode."],
  [11] = L["You are using ART. You rock!"],
  [12] = L["You can choose from different color palettes in the automatic pull coloring settings menu."],
  [13] = L["You can cycle through different floors by holding CTRL and using the mousewheel."],
  [14] = L["altKeyGroupsTip"],
  [15] = L["Mouseover a patrolling enemy with a blue border to view the patrol path."],
  [16] = L["Expand the top toolbar to gain access to drawing and note features."],
  [17] = L["ConnectedTip"],
  [18] = L["enemyDragToPullTip"],
}

function ART:UpdateBottomText()
  local f = self.main_frame.bottomPanelString
  if db.scale < 1 then
    f:SetText("")
    return
  end
  f:SetText(bottomTips[math.random(#bottomTips)])
end

function ART:MakeTopBottomTextures(frame)
  frame:SetMovable(true)
  if frame.topPanel == nil then
    frame.topPanel = CreateFrame("Frame", "ARTTopPanel", frame)
    frame.topPanelTex = frame.topPanel:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.topPanelTex:SetAllPoints()
    frame.topPanelTex:SetDrawLayer(canvasDrawLayer, -5)
    frame.topPanelTex:SetColorTexture(unpack(ART.BackdropColor))
    frame.topPanelString = frame.topPanel:CreateFontString("ART name")
    frame.topPanelString:SetFontObject(GameFontNormalMed3)
    frame.topPanelString:SetTextColor(1, 1, 1, 1)
    frame.topPanelString:SetJustifyH("CENTER")
    frame.topPanelString:SetJustifyV("MIDDLE")
    --frame.topPanelString:SetWidth(600)
    frame.topPanelString:SetHeight(20)
    frame.topPanelString:SetText("Anniversary Raid Tools")
    frame.topPanelString:ClearAllPoints()
    frame.topPanelString:SetPoint("CENTER", frame.topPanel, "CENTER", 10, 0)
    frame.topPanelString:Show()
    frame.topPanelString:SetFont(frame.topPanelString:GetFont() or '', 20, '')
    frame.topPanelLogo = frame.topPanel:CreateTexture(nil, "ARTWORK", nil, 7)
    frame.topPanelLogo:SetTexture("Interface\\AddOns\\"..ART.AddonName.."\\Textures\\ARTLogo")
    frame.topPanelLogo:SetWidth(30)
    frame.topPanelLogo:SetHeight(30)
    frame.topPanelLogo:SetPoint("RIGHT", frame.topPanelString, "LEFT", -5, -1)
    frame.topPanelLogo:Show()
  end

  frame.topPanel:ClearAllPoints()
  frame.topPanel:SetHeight(30)
  frame.topPanel:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
  frame.topPanel:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT")

  ART:RegisterMainFrameDragHandle(frame.topPanel, frame)

  if frame.bottomPanel == nil then
    frame.bottomPanel = CreateFrame("Frame", "ARTBottomPanel", frame)
    frame.bottomPanelTex = frame.bottomPanel:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.bottomPanelTex:SetAllPoints()
    frame.bottomPanelTex:SetDrawLayer(canvasDrawLayer, -5)
    frame.bottomPanelTex:SetColorTexture(unpack(ART.BackdropColor))
  end

  frame.bottomPanel:ClearAllPoints()
  frame.bottomPanel:SetHeight(30)
  frame.bottomPanel:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", -ART:GetNavigationSidebarWidth(), 0)
  frame.bottomPanel:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT")

  frame.bottomPanelString = frame.bottomPanel:CreateFontString("ARTMid")
  frame.bottomPanelString:SetFontObject(GameFontNormalSmall)
  frame.bottomPanelString:SetJustifyH("CENTER")
  frame.bottomPanelString:SetJustifyV("MIDDLE")
  frame.bottomPanelString:SetPoint("CENTER", frame.bottomPanel, "CENTER", 0, 0)
  frame.bottomPanelString:SetTextColor(1, 1, 1, 1)
  frame.bottomPanelString:Show()

  frame.bottomLeftPanelString = frame.bottomPanel:CreateFontString("ARTVersion")
  frame.bottomLeftPanelString:SetFontObject(GameFontNormalSmall)
  frame.bottomLeftPanelString:SetJustifyH("LEFT")
  frame.bottomLeftPanelString:SetJustifyV("MIDDLE")
  frame.bottomLeftPanelString:SetPoint("LEFT", frame.bottomPanel, "LEFT", 0, 0)
  frame.bottomLeftPanelString:SetTextColor(1, 1, 1, 1)
  ---@diagnostic disable-next-line: redundant-parameter
  frame.bottomLeftPanelString:SetText(" v"..(ART.Compat:GetAddOnMetadata(ART.AddonName, "Version") or ""))
  frame.bottomLeftPanelString:Show()
  --add clickarea
  frame.bottomLeftPanelString.clickArea = CreateFrame("Button", "ARTBottomLeftPanelClickArea", frame)
  local clickArea = frame.bottomLeftPanelString.clickArea
  clickArea:Show()
  clickArea:SetHeight(frame.bottomPanel:GetHeight())
  clickArea:SetWidth(50)
  clickArea:SetPoint("LEFT", frame.bottomPanel, "LEFT", 0, 0)
  clickArea:SetFrameStrata("HIGH")
  clickArea:SetFrameLevel(5)
  clickArea:SetScript("OnClick", function(self, button, down)
    ART:ToggleVersionCheckFrame()
    ART:ToggleToolbarTooltip(false)
  end)
  clickArea.tooltipText = L["Open changelog / version check"]
  clickArea:SetScript("OnEnter", function()
    local widget = {
      frame = clickArea,
      tooltipText = clickArea.tooltipText,
      type = "button",
    }
    ART:ToggleToolbarTooltip(true, widget, "ANCHOR_TOPLEFT")
  end)
  clickArea:SetScript("OnLeave", function()
    ART:ToggleToolbarTooltip(false)
  end)
  ART:UpdateVersionCheckDisplay()

  frame.statusString = frame.bottomPanel:CreateFontString("ARTStatusLabel")
  frame.statusString:SetFontObject(GameFontNormalSmall)
  frame.statusString:SetJustifyH("RIGHT")
  frame.statusString:SetJustifyV("MIDDLE")
  frame.statusString:SetPoint("RIGHT", frame.bottomPanel, "RIGHT", 0, 0)
  frame.statusString:SetTextColor(1, 1, 1, 1)
  frame.statusString:Hide()

  ART:RegisterMainFrameDragHandle(frame.bottomPanel, frame)
end

function ART:MakeCopyHelper(frame)
  if ART.copyHelper then
    ART.copyHelper:SetParent(frame)
    return ART.copyHelper
  end
  ART.copyHelper = CreateFrame("Frame", "ARTCopyHelper", frame)
  ART.copyHelper:SetFrameStrata("TOOLTIP")
  ART.copyHelper:SetFrameLevel(200)
  ART.copyHelper:SetHeight(100)
  ART.copyHelper:SetWidth(300)
  ART.copyHelper.tex = ART.copyHelper:CreateTexture(nil, "BACKGROUND", nil, 0)
  ART.copyHelper.tex:SetAllPoints()
  ART.copyHelper.tex:SetColorTexture(unpack(ART.BackdropColor))
  ART.copyHelper.text = ART.copyHelper:CreateFontString("ART name")
  ART.copyHelper.text:SetFontObject(GameFontNormalMed3)
  ART.copyHelper.text:SetJustifyH("CENTER")
  ART.copyHelper.text:SetJustifyV("MIDDLE")
  ART.copyHelper.text:SetText(L["errorLabel3"])
  ART.copyHelper.text:ClearAllPoints()
  ART.copyHelper.text:SetPoint("CENTER", ART.copyHelper, "CENTER")
  ART.copyHelper.text:Show()
  ART.copyHelper.text:SetFont(ART.copyHelper.text:GetFont() or '', 20, '')
  ART.copyHelper.text:SetTextColor(1, 1, 0)
  function ART.copyHelper:SmartFadeOut(seconds)
    seconds = seconds or 0.3
    ART.copyHelper.isFading = true
    ART.copyHelper:SetAlpha(1)
    ART.copyHelper:Show()
    UIFrameFadeOut(ART.copyHelper, seconds, 1, 0)
    ART.copyHelper.text:SetText(L["copiedToClipboard"])
    ART.copyHelper.text:SetTextColor(1, 1, 1)
    ART.copyHelper:SetScript("OnUpdate", nil)
    C_Timer.After(seconds, function()
      ART.copyHelper.text:SetText(L["errorLabel3"])
      ART.copyHelper.text:SetTextColor(1, 1, 0)
      ART.copyHelper:Hide()
      ART.copyHelper.isFading = false
    end)
  end

  function ART.copyHelper:SmartShow(anchorFrame, x, y)
    ART.copyHelper:ClearAllPoints()
    ART.copyHelper:SetPoint("CENTER", anchorFrame, "CENTER", x, y)
    ART.copyHelper:SetFrameStrata("TOOLTIP")
    ART.copyHelper:SetFrameLevel(200)
    ART.copyHelper:SetAlpha(1)
    ART.copyHelper:Show()
    ART.copyHelper:SetScript("OnUpdate", function()
      if IsControlKeyDown() then
        ART.lastCtrlDown = GetTime()
      end
    end)
  end

  function ART.copyHelper:SmartHide()
    if not ART.copyHelper.isFading then ART.copyHelper:Hide() end
  end

  --ctrl+c works when ctrl was released up to 0.5s before the c key
  function ART.copyHelper:WasControlKeyDown()
    if IsControlKeyDown() then return true end
    if not ART.lastCtrlDown then return false end
    return (GetTime() - ART.lastCtrlDown) < 0.5
  end
end

function ART:MakeSidePanel(frame)
  if frame.sidePanel == nil then
    frame.sidePanel = CreateFrame("Frame", "ARTSidePanel", frame)
    frame.sidePanelTex = frame.sidePanel:CreateTexture(nil, "BACKGROUND", nil, 0)
    frame.sidePanelTex:SetAllPoints()
    frame.sidePanelTex:SetDrawLayer(canvasDrawLayer, -5)
    frame.sidePanelTex:SetColorTexture(unpack(ART.BackdropColor))
    frame.sidePanelTex:Show()
  end
  ART:RegisterMainFrameDragHandle(frame.sidePanel, frame)

  frame.sidePanel:ClearAllPoints()
  frame.sidePanel:SetWidth(sidePanelWidth)
  frame.sidePanel:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, 30)
  frame.sidePanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, -30)

  frame.sidePanelString = frame.sidePanel:CreateFontString("ARTSidePanelText")
  frame.sidePanelString:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
  frame.sidePanelString:SetTextColor(1, 1, 1, 1)
  frame.sidePanelString:SetJustifyH("LEFT")
  frame.sidePanelString:SetJustifyV("TOP")
  frame.sidePanelString:SetWidth(200)
  frame.sidePanelString:SetHeight(500)
  frame.sidePanelString:SetText("")
  frame.sidePanelString:ClearAllPoints()
  frame.sidePanelString:SetPoint("TOPLEFT", frame.sidePanel, "TOPLEFT", 33, -120 - 30 - 25)
  frame.sidePanelString:Hide()

  frame.sidePanel.WidgetGroup = AceGUI:Create("SimpleGroup")
  frame.sidePanel.WidgetGroup.frame:SetParent(frame.sidePanel)
  frame.sidePanel.WidgetGroup:SetWidth(245)
  frame.sidePanel.WidgetGroup:SetHeight(frame:GetHeight() + (frame.topPanel:GetHeight() * 2) - 31)
  frame.sidePanel.WidgetGroup:SetPoint("TOP", frame.sidePanel, "TOP", 3, 5)
  frame.sidePanel.WidgetGroup:SetLayout("Flow")

  frame.sidePanel.WidgetGroup.frame:SetFrameStrata(mainFrameStrata)
  ART:RegisterMainFrameDragHandle(frame.sidePanel.WidgetGroup.frame, frame)
  if not frame.sidePanel.WidgetGroup.frame.SetBackdrop then
    Mixin(frame.sidePanel.WidgetGroup.frame, BackdropTemplateMixin)
  end
  frame.sidePanel.WidgetGroup.frame:SetBackdropColor(1, 1, 1, 0)
  frame.sidePanel.WidgetGroup.frame:Hide()

  --dirty hook to make widgetgroup show/hide
  local originalShow, originalHide = frame.Show, frame.Hide
  function frame:Show(...)
    frame.sidePanel.WidgetGroup.frame:Show()
    return originalShow(self, ...)
  end

  function frame:Hide(...)
    frame.sidePanel.WidgetGroup.frame:Hide()
    ART.pullTooltip:Hide()
    return originalHide(self, ...)
  end

  --preset selection
  frame.sidePanel.WidgetGroup.PresetDropDown = AceGUI:Create("Dropdown")
  frame.sidePanel.WidgetGroup.PresetDropDown.pullout.frame:SetParent(frame.sidePanel.WidgetGroup.PresetDropDown.frame)
  local dropdown = frame.sidePanel.WidgetGroup.PresetDropDown
  dropdown.frame:SetWidth(170)
  dropdown.text:SetJustifyH("LEFT")
  dropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
    if db.presets[db.currentRaidIndex][key].value == 0 then
      ART:OpenNewPresetDialog()
      ART.main_frame.sidePanelDeleteButton:SetDisabled(true)
      ART.main_frame.sidePanelDeleteButton.text:SetTextColor(0.5, 0.5, 0.5)
    else
      if key == 1 then
        ART.main_frame.sidePanelDeleteButton:SetDisabled(true)
        ART.main_frame.sidePanelDeleteButton.text:SetTextColor(0.5, 0.5, 0.5)
      else
        if not ART.liveSessionActive then
          ART.main_frame.sidePanelDeleteButton:SetDisabled(false)
          ART.main_frame.sidePanelDeleteButton.text:SetTextColor(1, 0.8196, 0)
        else
          ART.main_frame.sidePanelDeleteButton:SetDisabled(true)
          ART.main_frame.sidePanelDeleteButton.text:SetTextColor(0.5, 0.5, 0.5)
        end
      end
      db.currentPreset[db.currentRaidIndex] = key
      ART:UpdateMap()
    end
  end)
  ART:UpdatePresetDropDown()
  frame.sidePanel.WidgetGroup:AddChild(dropdown)

  local function anchorTooltip(anchorFrame)
    GameTooltip:SetOwner(anchorFrame, "ANCHOR_BOTTOMLEFT", -7, anchorFrame:GetHeight() + 3)
  end

  local function closeIfShown(dialog)
    if dialog and dialog:IsShown() then
      dialog:Hide()
      if ART.copyHelper then ART.copyHelper:SmartHide() end
      return true
    end
    return false
  end

  ---new profile,rename,export,delete
  local buttonWidth = 75
  frame.sidePanelNewButton = AceGUI:Create("Button")
  frame.sidePanelNewButton:SetText(L["New"])
  frame.sidePanelNewButton:SetWidth(buttonWidth)
  --button fontInstance
  local fontInstance = CreateFont("ARTButtonFont")
  if not fontInstance then return end
  fontInstance:CopyFontObject(frame.sidePanelNewButton.frame:GetNormalFontObject())
  local fontName, height = fontInstance:GetFont()
  fontInstance:SetFont(fontName, 10, "")
  frame.sidePanelNewButton.frame:SetNormalFontObject(fontInstance)
  frame.sidePanelNewButton.frame:SetHighlightFontObject(fontInstance)
  frame.sidePanelNewButton.frame:SetDisabledFontObject(fontInstance)
  frame.sidePanelNewButton:SetCallback("OnClick", function(widget, callbackName, value)
    if closeIfShown(ART.main_frame.presetCreationFrame) then return end
    ART:OpenNewPresetDialog()
  end)
  frame.sidePanelNewButton.frame:SetScript("OnEnter", function()
    anchorTooltip(frame.sidePanelNewButton.frame)
    GameTooltip:AddLine(L["Create a new preset"], 1, 1, 1)
    GameTooltip:Show()
  end)
  frame.sidePanelNewButton.frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  frame.sidePanelRenameButton = AceGUI:Create("Button")
  frame.sidePanelRenameButton:SetWidth(buttonWidth)
  frame.sidePanelRenameButton:SetText(L["Rename"])
  frame.sidePanelRenameButton.frame:SetNormalFontObject(fontInstance)
  frame.sidePanelRenameButton.frame:SetHighlightFontObject(fontInstance)
  frame.sidePanelRenameButton.frame:SetDisabledFontObject(fontInstance)
  frame.sidePanelRenameButton:SetCallback("OnClick", function(widget, callbackName, value)
    if closeIfShown(ART.main_frame.RenameFrame) then return end
    ART:HideAllDialogs()
    local currentPresetName = db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].text
    ART.main_frame.RenameFrame:Show()
    ART.main_frame.RenameFrame.RenameButton:SetDisabled(true)
    ART.main_frame.RenameFrame.RenameButton.text:SetTextColor(0.5, 0.5, 0.5)
    ART.main_frame.RenameFrame:ClearAllPoints()
    ART.main_frame.RenameFrame:SetPoint("CENTER", ART.main_frame, "CENTER", 0, 50)
    ART.main_frame.RenameFrame.TakeOwnershipCheckbox:SetValue(false)
    ART.main_frame.RenameFrame.Editbox:SetText(currentPresetName)
    ART.main_frame.RenameFrame.Editbox:HighlightText(0, string.len(currentPresetName))
    ART.main_frame.RenameFrame.Editbox:SetFocus()
  end)
  frame.sidePanelRenameButton.frame:SetScript("OnEnter", function()
    anchorTooltip(frame.sidePanelNewButton.frame)
    GameTooltip:AddLine(L["Rename the preset"], 1, 1, 1)
    GameTooltip:Show()
  end)
  frame.sidePanelRenameButton.frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  frame.sidePanelImportButton = AceGUI:Create("Button")
  frame.sidePanelImportButton:SetText(L["Import"])
  frame.sidePanelImportButton:SetWidth(buttonWidth)
  frame.sidePanelImportButton.frame:SetNormalFontObject(fontInstance)
  frame.sidePanelImportButton.frame:SetHighlightFontObject(fontInstance)
  frame.sidePanelImportButton.frame:SetDisabledFontObject(fontInstance)
  frame.sidePanelImportButton:SetCallback("OnClick", function(widget, callbackName, value)
    if InCombatLockdown() then
      print('ART: '..L["Cannot import while in combat"])
      return
    end
    if closeIfShown(ART.main_frame.presetImportFrame) then return end
    ART:OpenImportPresetDialog()
  end)
  frame.sidePanelImportButton.frame:SetScript("OnEnter", function()
    anchorTooltip(frame.LinkToChatButton.frame)
    GameTooltip:AddLine(L["Import a preset from a text string"], 1, 1, 1)
    GameTooltip:Show()
  end)
  frame.sidePanelImportButton.frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  frame.sidePanelExportButton = AceGUI:Create("Button")
  frame.sidePanelExportButton:SetText(L["Export"])
  frame.sidePanelExportButton:SetWidth(buttonWidth)
  frame.sidePanelExportButton.frame:SetNormalFontObject(fontInstance)
  frame.sidePanelExportButton.frame:SetHighlightFontObject(fontInstance)
  frame.sidePanelExportButton.frame:SetDisabledFontObject(fontInstance)
  frame.sidePanelExportButton:SetCallback("OnClick", function(widget, callbackName, value)
    if InCombatLockdown() then
      print('ART: '..L["Cannot export while in combat"])
      return
    end
    if closeIfShown(ART.main_frame.ExportFrame) then return end
    if db.colorPaletteInfo.forceColorBlindMode then ART:ColorAllPulls(_, _, _, true) end
    local preset = ART:GetCurrentPreset()
    ART:SetUniqueID(preset)
    ART:EnsurePresetCreatedBy(preset)
    preset.addonVersion = db.version
    local export = ART:TableToString(preset)
    ART:HideAllDialogs()
    ART.main_frame.ExportFrame:Show()
    ART.main_frame.ExportFrame:ClearAllPoints()
    ART.main_frame.ExportFrame:SetPoint("CENTER", ART.main_frame, "CENTER", 0, 50)
    ART.main_frame.ExportFrameEditbox:SetText(export)
    ART.main_frame.ExportFrameEditbox:HighlightText(0, string.len(export))
    ART.main_frame.ExportFrameEditbox:SetFocus()
    ART.main_frame.ExportFrameEditbox:SetLabel(preset.text.." "..string.len(export))
    ART.copyHelper:SmartShow(ART.main_frame, 0, 50)
    if db.colorPaletteInfo.forceColorBlindMode then ART:ColorAllPulls() end
  end)
  frame.sidePanelExportButton.frame:SetScript("OnEnter", function()
    anchorTooltip(frame.LinkToChatButton.frame)
    GameTooltip:AddLine(L["Export the preset as a text string"], 1, 1, 1)
    GameTooltip:AddLine(L["stringShareExternalWebsite"], 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  frame.sidePanelExportButton.frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  frame.sidePanelDeleteButton = AceGUI:Create("Button")
  frame.sidePanelDeleteButton:SetText(L["Delete"])
  frame.sidePanelDeleteButton:SetWidth(buttonWidth)
  frame.sidePanelDeleteButton.frame:SetScript("OnEnter", function()
    anchorTooltip(frame.sidePanelNewButton.frame)
    GameTooltip:AddLine(L["Delete this preset"], 1, 1, 1)
    GameTooltip:AddLine(L["Shift-Click to delete all presets for this raid"], 1, 1, 1)
    GameTooltip:Show()
  end)
  frame.sidePanelDeleteButton.frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
  frame.sidePanelDeleteButton.frame:SetNormalFontObject(fontInstance)
  frame.sidePanelDeleteButton.frame:SetHighlightFontObject(fontInstance)
  frame.sidePanelDeleteButton.frame:SetDisabledFontObject(fontInstance)
  frame.sidePanelDeleteButton:SetCallback("OnClick", function(widget, callbackName, value)
    if not widget.frame:IsEnabled() then return end
    if closeIfShown(frame.DeleteConfirmationFrame) then return end
    if IsShiftKeyDown() then
      --delete all profiles
      local numPresets = self:CountPresets()
      local prompt = string.format(L["deleteAllWarning"], "\n", "\n", numPresets, "\n")
      ART:OpenConfirmationFrame(450, 150, L["Delete ALL presets"], L["Delete"], prompt, ART.DeleteAllPresets)
    else
      ART:HideAllDialogs()
      frame.DeleteConfirmationFrame:ClearAllPoints()
      frame.DeleteConfirmationFrame:SetPoint("CENTER", ART.main_frame, "CENTER", 0, 50)
      local currentPresetName = db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].text
      frame.DeleteConfirmationFrame.label:SetText(string.format(L["Delete %s?"], currentPresetName))
      frame.DeleteConfirmationFrame:Show()
    end
  end)

  frame.LinkToChatButton = AceGUI:Create("Button")
  frame.LinkToChatButton:SetText(L["Share"])
  frame.LinkToChatButton:SetWidth(buttonWidth)
  frame.LinkToChatButton.frame:SetNormalFontObject(fontInstance)
  frame.LinkToChatButton.frame:SetHighlightFontObject(fontInstance)
  frame.LinkToChatButton.frame:SetDisabledFontObject(fontInstance)
  frame.LinkToChatButton:SetCallback("OnClick", function(widget, callbackName, value)
    if ART:IsInRestrictedEnvironment(true) then return end
    local distribution = ART:IsPlayerInGroup()
    if not distribution then return end
    local callback = function()
      frame.LinkToChatButton:SetDisabled(true)
      frame.LinkToChatButton.text:SetTextColor(0.5, 0.5, 0.5)
      frame.LiveSessionButton:SetDisabled(true)
      frame.LiveSessionButton.text:SetTextColor(0.5, 0.5, 0.5)
      frame.LinkToChatButton:SetText("...")
      frame.LiveSessionButton:SetText("...")
      ART:SendToGroup(distribution)
    end
    ART:CheckPresetSize(callback)
  end)
  frame.LinkToChatButton.frame:SetScript("OnEnter", function()
    anchorTooltip(frame.LinkToChatButton.frame)
    GameTooltip:AddLine(L["Share the preset with your party members"], 1, 1, 1)
    GameTooltip:Show()
  end)
  frame.LinkToChatButton.frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
  local inGroup = UnitInRaid("player") or IsInGroup()
  ART.main_frame.LinkToChatButton:SetDisabled(not inGroup)
  if inGroup then
    ART.main_frame.LinkToChatButton.text:SetTextColor(1, 0.8196, 0)
  else
    ART.main_frame.LinkToChatButton.text:SetTextColor(0.5, 0.5, 0.5)
  end

  frame.LiveSessionButton = AceGUI:Create("Button")
  frame.LiveSessionButton:SetText(L["Live"])
  frame.LiveSessionButton:SetWidth(buttonWidth)
  frame.LiveSessionButton.frame:SetNormalFontObject(fontInstance)
  frame.LiveSessionButton.frame:SetHighlightFontObject(fontInstance)
  frame.LiveSessionButton.frame:SetDisabledFontObject(fontInstance)
  local c1, c2, c3 = frame.LiveSessionButton.text:GetTextColor()
  frame.LiveSessionButton.normalTextColor = { r = c1, g = c2, b = c3, }
  frame.LiveSessionButton:SetCallback("OnClick", function(widget, callbackName, value)
    if ART:IsInRestrictedEnvironment(true) then return end
    if ART.liveSessionActive then
      ART:LiveSession_Disable()
    else
      ART:LiveSession_Enable()
    end
  end)
  frame.LiveSessionButton.frame:SetScript("OnEnter", function()
    anchorTooltip(frame.LinkToChatButton.frame)
    GameTooltip:AddLine(L["Start or join the current |cFF00FF00Live Session|r"], 1, 1, 1)
    GameTooltip:AddLine(L[
    "Clicking this button will attempt to join the ongoing Live Session of your group or create a new one if none is found"
    ], 1, 1, 1, 1)
    GameTooltip:AddLine(L[
    "The preset will continuously synchronize between all party members participating in the Live Session"], 1, 1, 1, 1)
    GameTooltip:AddLine(L[
    "Players can join the live session by either clicking this button or the Live Session chat link"], 1, 1, 1, 1)
    GameTooltip:AddLine(L[
    "To share a different preset while the live session is active simply navigate to the preferred preset and click the new 'Set to Live' Button next to the preset-dropdown"
    ], 1, 1, 1, 1)
    GameTooltip:AddLine(L[
    "You can always return to the current Live Session preset by clicking the 'Return to Live' button next to the preset-dropdown"
    ], 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  frame.LiveSessionButton.frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
  ART.main_frame.LiveSessionButton:SetDisabled(not inGroup)
  if inGroup then
    ART.main_frame.LiveSessionButton.text:SetTextColor(1, 0.8196, 0)
  else
    ART.main_frame.LiveSessionButton.text:SetTextColor(0.5, 0.5, 0.5)
  end

  frame.sidePanel.WidgetGroup:AddChild(frame.sidePanelNewButton)
  frame.sidePanel.WidgetGroup:AddChild(frame.sidePanelRenameButton)
  frame.sidePanel.WidgetGroup:AddChild(frame.sidePanelDeleteButton)
  frame.sidePanel.WidgetGroup:AddChild(frame.LinkToChatButton)
  frame.sidePanel.WidgetGroup:AddChild(frame.sidePanelExportButton)
  frame.sidePanel.WidgetGroup:AddChild(frame.sidePanelImportButton)
  frame.sidePanel.WidgetGroup:AddChild(frame.LiveSessionButton)

  frame.sidePanel.middleLine = AceGUI:Create("Heading")
  frame.sidePanel.middleLine:SetWidth(240)
  frame.sidePanel.WidgetGroup:AddChild(frame.sidePanel.middleLine)
  frame.sidePanel.WidgetGroup.frame:SetFrameLevel(3)

end

function ART:FixAceGUIShowHide(widget, frame, isFrame, hideOnly)
  frame = frame or ART.main_frame
  local originalShow, originalHide = frame.Show, frame.Hide
  if not isFrame then
    widget = widget.frame
  end
  function frame:Hide(...)
    widget:Hide()
    return originalHide(self, ...)
  end

  if hideOnly then return end
  function frame:Show(...)
    widget:Show()
    return originalShow(self, ...)
  end
end

function ART:ResetMainFramePos(soft)
  ART:Async(function()
    --soft reset just redraws the window with existing coordinates from db
    if not framesInitialized then ART:StartMainFrameInitialization() end
    local f = self.main_frame
    if not soft then
      db.maximized = false
      if not framesInitialized then ART:StartMainFrameInitialization() end
      if not framesInitialized then return end
      db.xoffset = defaultSavedVars.global.xoffset
      db.yoffset = defaultSavedVars.global.yoffset
      db.anchorFrom = "TOP"
      db.anchorTo = "TOP"
      db.nonFullscreenScale = ART:GetDefaultNonFullscreenScale(db.xoffset, db.yoffset)
      db.scale = db.nonFullscreenScale
      f.maximizeButton:Minimize()
    end
    f:ClearAllPoints()
    f:SetPoint(db.anchorTo, UIParent, db.anchorFrom, db.xoffset, db.yoffset)
  end, 'resetMainFramePos')
end

function ART:ShowSpinner(timeout)
  if not ART.initSpinner then return end
  ART.initSpinner:Show()
  ART.initSpinner.Anim:Play()
  if timeout then
    C_Timer.After(timeout, function()
      ART:HideSpinner()
    end)
  end
end

function ART:HideSpinner()
  if not ART.initSpinner then return end
  ART.initSpinner:Hide()
  ART.initSpinner.Anim:Stop()
end

function ART:InitializeMainFrame()
  local initSpinner = CreateFrame("Frame", "ARTInitSpinner", UIParent)
  initSpinner:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
  initSpinner:SetFrameStrata("DIALOG")
  initSpinner:SetSize(60, 60)
  initSpinner:Show()
  initSpinner.Anim = { Play = function() end, Stop = function() end }
  initSpinner.Anim:Play()
  ART.initSpinner = initSpinner

  local main_frame = CreateFrame("frame", "ARTFrame", UIParent)
  main_frame:SetToplevel(true)
  ART:SetUpModifiers(main_frame)
  main_frame:Hide()
  tinsert(UISpecialFrames, "ARTFrame")

  --cache raid data to not lose data during reloads
  if db.devMode and db.loadCache then
    if db.raidEnemies then
      ART.raidEnemies = db.raidEnemies
    else
      db.raidEnemies = ART.raidEnemies
    end
    if db.mapPOIs then
      ART.mapPOIs = db.mapPOIs
    else
      db.mapPOIs = ART.mapPOIs
    end
  end

  db.nonFullscreenScale = db.nonFullscreenScale or ART:GetDefaultNonFullscreenScale(db.xoffset, db.yoffset)
  if db.nonFullscreenScale == defaultNonFullscreenScale and db.anchorFrom == "TOP" and db.anchorTo == "TOP" then
    db.nonFullscreenScale = ART:GetDefaultNonFullscreenScale(db.xoffset, db.yoffset)
  end
  if not db.maximized then db.scale = db.nonFullscreenScale end
  main_frame:SetFrameStrata(mainFrameStrata)
  main_frame:SetFrameLevel(1)
  ART:RegisterMainFrameDragHandle(main_frame, main_frame)
  main_frame.background = main_frame:CreateTexture(nil, "BACKGROUND", nil, 0)
  main_frame.background:SetAllPoints()
  main_frame.background:SetDrawLayer(canvasDrawLayer, 1)
  main_frame.background:SetColorTexture(unpack(ART.BackdropColor))
  main_frame.background:SetAlpha(0)
  main_frame:SetSize(sizex * db.scale, sizey * db.scale)
  main_frame:SetResizable(true)
  local _, _, fullscreenScale = ART:GetFullScreenSizes()
  main_frame:SetResizeBounds(sizex * 0.9, sizey * 0.9, sizex * fullscreenScale, sizey * fullscreenScale)
  ART.main_frame = main_frame

  main_frame.mainFrametex = main_frame:CreateTexture(nil, "BACKGROUND", nil, 0)
  main_frame.mainFrametex:SetAllPoints()
  main_frame.mainFrametex:SetDrawLayer(canvasDrawLayer, -5)
  main_frame.mainFrametex:SetColorTexture(unpack(ART.BackdropColor))

  ---@diagnostic disable-next-line: redundant-parameter
  local version = (ART.Compat:GetAddOnMetadata(ART.AddonName, "Version") or "0"):gsub("%.", "")
  db.version = tonumber(version)
  -- Set frame position
  main_frame:ClearAllPoints()
  main_frame:SetPoint(db.anchorTo, UIParent, db.anchorFrom, db.xoffset, db.yoffset)
  main_frame.contextDropdown = CreateFrame("frame", "ARTContextDropDown", nil, "UIDropDownMenuTemplate")
  ART:CheckCurrentZone(true)
  ART:EnsureDBTables()
  ART:MakeTopBottomTextures(main_frame)
  ART:MakeNavigationSidebar(main_frame)
  ART:MakeCopyHelper(main_frame)
  coroutine.yield()
  ART:MakeMapTexture(main_frame)
  coroutine.yield()
  ART:MakeSidePanel(main_frame)
  ART:MakeSectionFrames(main_frame)
  ART:MakeSettingsFrame(main_frame)
  coroutine.yield()
  ART:CreateMenu()
  coroutine.yield()
  ART:MakePresetCreationFrame(main_frame)
  coroutine.yield()
  ART:MakePresetImportFrame(main_frame)
  coroutine.yield()
  ART:RaidEnemies_CreateFramePools()
  ART:CreateSublevelDropdown(main_frame)
  coroutine.yield()
  ART:MakePullSelectionButtons(main_frame.sidePanel)
  coroutine.yield()
  ART:MakeExportFrame(main_frame)
  coroutine.yield()
  ART:MakeRenameFrame(main_frame)
  coroutine.yield()
  ART:MakeDeleteConfirmationFrame(main_frame)
  coroutine.yield()
  ART:MakeClearConfirmationFrame(main_frame)
  coroutine.yield()
  ART:POI_CreateFramePools()
  ART:MakeSendingStatusBar(main_frame)
  --devMode
  if db.devMode and ART.CreateDevPanel then
    ART:CreateDevPanel(ART.main_frame)
  end

  --tooltip new
  do
    ART.tooltip = CreateFrame("Frame", "ARTModelTooltip", UIParent, "TooltipBorderedFrameTemplate")
    local tooltip = ART.tooltip
    tooltip:SetClampedToScreen(true)
    tooltip:SetFrameStrata("TOOLTIP")
    tooltip.mySizes = { x = 290, y = 120 }
    tooltip:SetSize(tooltip.mySizes.x, tooltip.mySizes.y)
    tooltip.Model = CreateFrame("PlayerModel", nil, tooltip)
    tooltip.Model:SetFrameLevel(1)
    tooltip.Model:SetSize(100, 100)
    tooltip.Model.fac = 0
    tooltip.Model:SetScript("OnUpdate", function(self, elapsed)
      self.fac = self.fac + 0.5
      if self.fac >= 360 then
        self.fac = 0
      end
      self:SetFacing(PI * 2 / 360 * self.fac)
    end)
    ---@diagnostic disable-next-line: param-type-mismatch
    tooltip.Model:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 7, -7)
    tooltip.String = tooltip:CreateFontString("ARTToolTipString")
    tooltip.String:SetFontObject(GameFontNormalSmall)
    tooltip.String:SetFont(tooltip.String:GetFont() or '', 10, '')
    tooltip.String:SetTextColor(1, 1, 1, 1)
    tooltip.String:SetJustifyH("LEFT")
    --tooltip.String:SetJustifyV("MIDDLE")
    tooltip.String:SetWidth(tooltip:GetWidth())
    tooltip.String:SetHeight(90)
    tooltip.String:SetWidth(175)
    tooltip.String:SetText(" ")
    ---@diagnostic disable-next-line: param-type-mismatch
    tooltip.String:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 110, -10)
    tooltip.String:Show()
  end

  --pullTooltip
  do
    ART.pullTooltip = CreateFrame("Frame", "ARTPullTooltip", UIParent, "TooltipBorderedFrameTemplate")
    --ART.pullTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    ART.pullTooltip:SetClampedToScreen(true)
    ART.pullTooltip:SetFrameStrata("TOOLTIP")
    ART.pullTooltip.myHeight = 180
    ART.pullTooltip:SetSize(250, ART.pullTooltip.myHeight)
    ART.pullTooltip.Model = CreateFrame("PlayerModel", nil, ART.pullTooltip)
    ART.pullTooltip.Model:SetFrameLevel(1)
    ART.pullTooltip.Model.fac = 0
    if true then
      ART.pullTooltip.Model:SetScript("OnUpdate", function(self, elapsed)
        self.fac = self.fac + 0.5
        if self.fac >= 360 then
          self.fac = 0
        end
        self:SetFacing(PI * 2 / 360 * self.fac)
      end)
    else
      ART.pullTooltip.Model:SetPortraitZoom(1)
      ART.pullTooltip.Model:SetFacing(PI * 2 / 360 * 2)
    end

    ART.pullTooltip.Model:SetSize(110, 110)
    ---@diagnostic disable-next-line: param-type-mismatch
    ART.pullTooltip.Model:SetPoint("TOPLEFT", ART.pullTooltip, "TOPLEFT", 7, -7)

    ART.pullTooltip.topString = ART.pullTooltip:CreateFontString("ARTToolTipString")
    ART.pullTooltip.topString:SetFontObject(GameFontNormalSmall)
    ART.pullTooltip.topString:SetFont(ART.pullTooltip.topString:GetFont() or '', 10, '')
    ART.pullTooltip.topString:SetTextColor(1, 1, 1, 1)
    ART.pullTooltip.topString:SetJustifyH("LEFT")
    ART.pullTooltip.topString:SetJustifyV("TOP")
    ART.pullTooltip.topString:SetHeight(110)
    ART.pullTooltip.topString:SetWidth(130)
    ---@diagnostic disable-next-line: param-type-mismatch
    ART.pullTooltip.topString:SetPoint("TOPLEFT", ART.pullTooltip, "TOPLEFT", 110, -7)
    ART.pullTooltip.topString:Hide()

    local heading = ART.pullTooltip:CreateTexture(nil, "OVERLAY", nil, 0)
    heading:SetHeight(8)
    heading:SetPoint("LEFT", 12, -30)
    ---@diagnostic disable-next-line: param-type-mismatch
    heading:SetPoint("RIGHT", ART.pullTooltip, "RIGHT", -12, -30)
    heading:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
    heading:SetTexCoord(0.81, 0.94, 0.5, 1)
    heading:Show()

    ART.pullTooltip.botString = ART.pullTooltip:CreateFontString("ARTToolTipString")
    local botString = ART.pullTooltip.botString
    botString:SetFontObject(GameFontNormalSmall)
    botString:SetFont(ART.pullTooltip.topString:GetFont() or '', 10, '')
    botString:SetTextColor(1, 1, 1, 1)
    botString:SetJustifyH("CENTER")
    botString:SetJustifyV("TOP")
    botString:SetHeight(40)
    botString:SetWidth(250)
    botString:SetPoint("TOPLEFT", heading, "LEFT", -12, -7)
    botString:Hide()
  end

  coroutine.yield()
  ART:initToolbar(main_frame)
  coroutine.yield()
  if db.toolbarExpanded then
    main_frame.toolbar.toggleButton:Click()
    main_frame.toolbar.widgetGroup.frame:Hide()
  end
  ART:UpdateSectionVisibility()

  --ping
  --ART.ping = CreateFrame("PlayerModel", nil, ART.main_frame.mapPanelFrame)
  --local ping = ART.ping
  --ping:SetModel("interface/minimap/ping/minimapping.m2")
  --ping:SetModel(120590)
  --ping:SetPortraitZoom(1)
  --ping:SetCamera(1)
  -- ping:SetFrameLevel(50)
  -- ping:SetFrameStrata("DIALOG")
  -- ping.mySize = 45
  -- ping:SetSize(ping.mySize, ping.mySize)
  -- ping:Hide()

  ART:UpdateMap()
  ART:UpdateSectionVisibility()
  coroutine.yield()

  if ART:IsFrameOffScreen() then
    ART:ResetMainFramePos()
  end

  framesInitialized = true
  --Maximize if needed
  if db.maximized then ART:Maximize() end
  initSpinner:Hide()
  initSpinner.Anim:Stop()
  local callbacks = frameInitializedCallbacks
  frameInitializedCallbacks = {}
  for _, callback in ipairs(callbacks) do
    callback()
  end
end
