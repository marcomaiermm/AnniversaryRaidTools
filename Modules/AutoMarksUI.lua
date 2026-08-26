local _, ART = ...
local L = ART.L
local AceGUI = LibStub("AceGUI-3.0")

local AutoMarksUI = ART.AutoMarksUI or { selectedTab = "pulls" }
ART.AutoMarksUI = AutoMarksUI
AutoMarksUI.scrollStatus = AutoMarksUI.scrollStatus or {}

local markerOrder = { 8, 7, 1, 5, 6, 3, 4, 2 }

local modifierOptions = {
  NONE = L["None"], SHIFT = "Shift", CTRL = "Ctrl", ALT = "Alt",
}
local modifierOrder = { "NONE", "SHIFT", "CTRL", "ALT" }

local function raidIsActive()
  local planner, db = ART.RaidPlanner, ART:GetDB()
  if not (planner and planner.raid and db) then return false end
  local mapInfo = ART.mapInfo and ART.mapInfo[db.currentRaidIndex]
  return mapInfo and mapInfo.mapID == planner.raid.mapId
end

local function setButtonActive(button, active)
  if not button then return end
  if active then button:Disable() else button:Enable() end
end

local function showPullContent(sidePanel, shown)
  local waveMode = ART.WaveModeUI and ART.WaveModeUI:IsActive()
  sidePanel.PullButtonScrollGroup.frame:SetShown(shown and not waveMode)
  if sidePanel.WaveModeGroup then sidePanel.WaveModeGroup:SetShown(shown and waveMode) end
  if sidePanel.pullTabButton then sidePanel.pullTabButton:SetText(waveMode and L["Waves"] or L["Pulls"]) end
  if shown and waveMode then ART.WaveModeUI:Refresh() end
end

function AutoMarksUI:SetTab(tab)
  local sidePanel = ART.main_frame and ART.main_frame.sidePanel
  if not (sidePanel and sidePanel.AutoMarksGroup) then return end
  self.selectedTab = tab == "autoMarks" and "autoMarks" or "pulls"
  local autoMarks = self.selectedTab == "autoMarks"
  showPullContent(sidePanel, not autoMarks)
  sidePanel.AutoMarksGroup.frame:SetShown(autoMarks)
  setButtonActive(sidePanel.pullTabButton, not autoMarks)
  setButtonActive(sidePanel.autoMarksTabButton, autoMarks)
  if autoMarks then self:Refresh() end
end

local function addControls(container, planner)
  local db = ART:GetDB()
  local enabled = AceGUI:Create("CheckBox")
  enabled:SetLabel(L["Auto Mark"])
  enabled:SetFullWidth(true)
  enabled:SetValue(db.autoMark == true)
  enabled:SetCallback("OnValueChanged", function(_, _, value)
    db.autoMark = value == true
    if ART.LiveMarks then ART.LiveMarks:SetEnabled(db.autoMark) end
  end)
  container:AddChild(enabled)

  local modifier = AceGUI:Create("Dropdown")
  modifier:SetLabel(L["Mouseover modifier"])
  modifier:SetList(modifierOptions, modifierOrder)
  modifier:SetValue(db.autoMarkModifier or "ALT")
  modifier:SetFullWidth(true)
  modifier:SetCallback("OnValueChanged", function(_, _, value) db.autoMarkModifier = value end)
  container:AddChild(modifier)

  local note = AceGUI:Create("Label")
  note:SetText(L["Selected marks are tried left to right. Pull marks take priority. Existing marks are preserved."])
  note:SetColor(0.75, 0.75, 0.75)
  note:SetFullWidth(true)
  container:AddChild(note)

  local clear = AceGUI:Create("Button")
  clear:SetText(L["Clear All Marks"])
  clear:SetFullWidth(true)
  clear:SetCallback("OnClick", function()
    local sublevel = ART:GetCurrentSubLevel()
    planner:ClearFloorDefaultMarks(sublevel)
    if ART.CCAssignments then
      ART.CCAssignments:ClearFloorAssignments(ART:GetCurrentPreset(), sublevel)
    end
    AutoMarksUI:Refresh()
  end)
  container:AddChild(clear)
end

local function sortedEnemies(raid, sublevel)
  local enemies = {}
  for npcKey, enemy in pairs(raid and raid.enemies or {}) do
    for _, spawn in ipairs(enemy.spawns or {}) do
      if spawn.sublevel == sublevel then
        enemies[#enemies + 1] = {
          npcId = tonumber(enemy.npcId) or tonumber(npcKey),
          name = L[enemy.name] or enemy.name or tostring(npcKey),
          displayId = enemy.displayId,
          definition = enemy,
          tooltipData = {
            id = tonumber(enemy.npcId) or tonumber(npcKey),
            name = enemy.name,
            health = enemy.health,
            level = enemy.level,
            creatureType = enemy.creatureType,
            isBoss = enemy.isBoss,
          },
        }
        break
      end
    end
  end
  table.sort(enemies, function(left, right)
    if left.name == right.name then return left.npcId < right.npcId end
    return left.name < right.name
  end)
  return enemies
end

local function showDefaultAssignment(icon, assignment)
  if not assignment then
    if icon.ccBadge then icon.ccBadge:Hide() end
    icon:SetCallback("OnEnter", nil)
    icon:SetCallback("OnLeave", nil)
    return
  end
  local badge = icon.ccBadge
  if not badge then
    badge = icon.frame:CreateTexture(nil, "OVERLAY")
    badge:SetSize(10, 10)
    badge:SetPoint("TOPRIGHT", icon.image, "TOPRIGHT", 3, 3)
    icon.ccBadge = badge
  end
  badge:SetTexture(ART.CCAssignments.catalog[assignment.ccKey].icon)
  badge:Show()
  icon:SetCallback("OnEnter", function()
    local color = RAID_CLASS_COLORS and RAID_CLASS_COLORS[assignment.assignee.classFile]
    local name = assignment.assignee.name:match("^[^-]+") or assignment.assignee.name
    GameTooltip:SetOwner(icon.frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(name, color and color.r or 1, color and color.g or 1, color and color.b or 1)
    GameTooltip:Show()
  end)
  icon:SetCallback("OnLeave", function() GameTooltip:Hide() end)
end

local function addEnemyRows(container, planner)
  local scroll = AceGUI:Create("ScrollFrame")
  scroll:SetLayout("List")
  scroll:SetFullWidth(true)
  scroll:SetHeight(300)
  scroll:SetStatusTable(AutoMarksUI.scrollStatus)
  container:AddChild(scroll)

  for _, enemy in ipairs(sortedEnemies(planner.raid, ART:GetCurrentSubLevel())) do
    local row = AceGUI:Create("SimpleGroup")
    row:SetLayout("Flow")
    row:SetFullWidth(true)
    row:SetHeight(34)

    local npcIcon = AceGUI:Create("Icon")
    npcIcon:SetImageSize(24, 24)
    npcIcon:SetWidth(32)
    npcIcon:SetHeight(32)
    SetPortraitTextureFromCreatureDisplayID(npcIcon.image, enemy.displayId)
    npcIcon.frame.data = enemy.tooltipData
    npcIcon.frame.clone, npcIcon.frame.cloneIdx = {}, ""
    npcIcon.frame.suppressEnemyInfoHint = true
    npcIcon:SetCallback("OnEnter", function()
      if ART.DisplayBlipTooltip then ART:DisplayBlipTooltip(npcIcon.frame, true) end
    end)
    npcIcon:SetCallback("OnLeave", function()
      if ART.DisplayBlipTooltip then ART:DisplayBlipTooltip(npcIcon.frame, false) end
    end)
    row:AddChild(npcIcon)

    local selected = {}
    for _, marker in ipairs(planner:GetNpcDefaultMarks(enemy.npcId)) do selected[marker] = true end
    local function persistMarkers()
      local markers = {}
      for _, candidate in ipairs(markerOrder) do
        if selected[candidate] then markers[#markers + 1] = candidate end
      end
      planner:SetNpcDefaultMarks(enemy.npcId, markers)
    end
    for _, marker in ipairs(markerOrder) do
      local icon = AceGUI:Create("Icon")
      icon:SetImage(("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(marker))
      icon:SetImageSize(20, 20)
      icon:SetWidth(24)
      icon:SetHeight(30)
      if icon.frame.RegisterForClicks then icon.frame:RegisterForClicks("LeftButtonUp", "RightButtonUp") end
      icon.image:SetAlpha(selected[marker] and 1 or 0.2)
      local default = ART.CCAssignments and ART.CCAssignments:GetDefaultAssignment(
          ART:GetCurrentPreset(), enemy.npcId, marker)
      if default and icon.frame.CreateTexture then
        showDefaultAssignment(icon, default)
      elseif icon.ccBadge then
        showDefaultAssignment(icon)
      end
      icon:SetCallback("OnClick", function(_, _, button)
        if button == "RightButton" and ART.CCAssignments then
          ART.CCAssignments:OpenDefaultMenu(icon.frame, enemy, marker, function(assignment)
            if assignment and not selected[marker] then
              selected[marker] = true
              icon.image:SetAlpha(1)
            end
            default = assignment
            showDefaultAssignment(icon, assignment)
          end)
          return
        end
        selected[marker] = not selected[marker]
        icon.image:SetAlpha(selected[marker] and 1 or 0.2)
        if not selected[marker] and default and ART.CCAssignments then
          ART.CCAssignments:ClearDefaultAssignment(ART:GetCurrentPreset(), enemy.npcId, marker)
          default = nil
          showDefaultAssignment(icon)
        end
        persistMarkers()
      end)
      row:AddChild(icon)
    end
    scroll:AddChild(row)
  end
end

function AutoMarksUI:Refresh()
  local sidePanel = ART.main_frame and ART.main_frame.sidePanel
  if not (sidePanel and sidePanel.AutoMarksGroup) then return end
  self:UpdateAvailability()
  if not raidIsActive() or self.selectedTab ~= "autoMarks" then return end
  local container, planner = sidePanel.AutoMarksGroup, ART.RaidPlanner
  if ART.CCAssignments then ART.CCAssignments:EnsureDefaultMarkers() end
  container:ReleaseChildren()
  addControls(container, planner)
  addEnemyRows(container, planner)
  container:DoLayout()
end

function AutoMarksUI:UpdateAvailability()
  local sidePanel = ART.main_frame and ART.main_frame.sidePanel
  if not (sidePanel and sidePanel.markingTabBar) then return end
  local available = ART:GetCurrentSection() == "maps" and raidIsActive()
  sidePanel.markingTabBar:SetShown(available)
  if available then
    local autoMarks = self.selectedTab == "autoMarks"
    showPullContent(sidePanel, not autoMarks)
    sidePanel.AutoMarksGroup.frame:SetShown(autoMarks)
    setButtonActive(sidePanel.pullTabButton, not autoMarks)
    setButtonActive(sidePanel.autoMarksTabButton, autoMarks)
  else
    sidePanel.AutoMarksGroup.frame:Hide()
    if sidePanel.WaveModeGroup then sidePanel.WaveModeGroup:Hide() end
    if ART:GetCurrentSection() == "maps" then showPullContent(sidePanel, true) end
  end
end

local function makeTab(parent, text, point, onClick)
  local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  button:SetSize(118, 24)
  button:SetPoint(point[1], point[2], point[3], point[4], point[5])
  button:SetText(text)
  button:SetScript("OnClick", onClick)
  return button
end

function AutoMarksUI:Create(sidePanel)
  if sidePanel.AutoMarksGroup then return end

  sidePanel.markingTabBar = CreateFrame("Frame", nil, sidePanel)
  sidePanel.markingTabBar:SetSize(248, 26)
  sidePanel.markingTabBar:SetPoint("BOTTOMLEFT", sidePanel.PullButtonScrollGroup.frame, "TOPLEFT", 0, 3)
  sidePanel.pullTabButton = makeTab(sidePanel.markingTabBar, L["Pulls"],
      { "LEFT", sidePanel.markingTabBar, "LEFT", 3, 0 }, function() AutoMarksUI:SetTab("pulls") end)
  sidePanel.autoMarksTabButton = makeTab(sidePanel.markingTabBar, L["Auto Marks"],
      { "RIGHT", sidePanel.markingTabBar, "RIGHT", -3, 0 }, function() AutoMarksUI:SetTab("autoMarks") end)

  sidePanel.AutoMarksGroup = AceGUI:Create("SimpleGroup")
  sidePanel.AutoMarksGroup.frame:SetParent(sidePanel)
  sidePanel.AutoMarksGroup.frame:SetAllPoints(sidePanel.PullButtonScrollGroup.frame)
  sidePanel.AutoMarksGroup:SetLayout("List")
  sidePanel.AutoMarksGroup.frame:Hide()

  local mainFrame, originalShow = ART.main_frame, ART.main_frame.Show
  function mainFrame:Show(...)
    local result = originalShow(self, ...)
    AutoMarksUI:UpdateAvailability()
    return result
  end
  self:UpdateAvailability()
end

local originalMakePullSelectionButtons = ART.MakePullSelectionButtons
function ART:MakePullSelectionButtons(sidePanel)
  originalMakePullSelectionButtons(self, sidePanel)
  AutoMarksUI:Create(sidePanel)
end

local originalUpdateSectionVisibility = ART.UpdateSectionVisibility
function ART:UpdateSectionVisibility(...)
  local result = originalUpdateSectionVisibility(self, ...)
  AutoMarksUI:UpdateAvailability()
  return result
end

local originalSetCurrentSubLevel = ART.SetCurrentSubLevel
function ART:SetCurrentSubLevel(...)
  local result = originalSetCurrentSubLevel(self, ...)
  AutoMarksUI:Refresh()
  if ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
  if ART.RaidMarksUI then ART.RaidMarksUI:ResetPullTracker() end
  return result
end
