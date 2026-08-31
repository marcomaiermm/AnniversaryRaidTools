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

function AutoMarksUI:CancelDrag()
  if self.dragSourceRow and self.dragSourceRow.frame then self.dragSourceRow.frame:SetAlpha(1) end
  if self.dragPreview then
    self.dragPreview:SetScript("OnUpdate", nil)
    self.dragPreview:Hide()
  end
  if self.dropIndicator then self.dropIndicator:Hide() end
  self.dragSourceRow, self.dragTargetNpcId = nil, nil
end

function AutoMarksUI:CaptureScrollStatus()
  local status = self.scrollWidget and self.scrollWidget.status or self.scrollStatus
  self.scrollStatus = {
    scrollvalue = status and status.scrollvalue or 0,
    offset = status and status.offset or 0,
  }
end

function AutoMarksUI:QueueRefresh()
  self:CaptureScrollStatus()
  self:CancelDrag()
  if self.refreshQueuedToken then return end
  local token, revision = {}, self.refreshRevision or 0
  local raidKey = ART.RaidPlanner and ART.RaidPlanner.raid and ART.RaidPlanner.raid.key
  self.refreshQueuedToken = token
  C_Timer.After(0, function()
    if self.refreshQueuedToken ~= token then return end
    self.refreshQueuedToken = nil
    local currentRaidKey = ART.RaidPlanner and ART.RaidPlanner.raid and ART.RaidPlanner.raid.key
    if self.refreshRevision ~= revision or currentRaidKey ~= raidKey then return end
    self:Refresh()
  end)
end

function AutoMarksUI:OnRaidChanged()
  self.scrollWidget, self.scrollRaidKey, self.scrollStatus = nil, nil, {}
  self:Refresh()
end

local function ensureDragVisual()
  if AutoMarksUI.dragPreview then return AutoMarksUI.dragPreview, AutoMarksUI.dropIndicator end

  local preview = CreateFrame("Frame", nil, UIParent)
  preview:SetSize(180, 32)
  preview:SetFrameStrata("TOOLTIP")
  local background = preview:CreateTexture(nil, "BACKGROUND")
  background:SetAllPoints()
  background:SetColorTexture(0.035, 0.04, 0.05, 0.94)
  local accent = preview:CreateTexture(nil, "BORDER")
  accent:SetPoint("BOTTOMLEFT")
  accent:SetPoint("BOTTOMRIGHT")
  accent:SetHeight(2)
  accent:SetColorTexture(1, 0.82, 0, 1)
  preview.portrait = preview:CreateTexture(nil, "ARTWORK")
  preview.portrait:SetSize(26, 26)
  preview.portrait:SetPoint("LEFT", 3, 0)
  preview.name = preview:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  preview.name:SetPoint("LEFT", preview.portrait, "RIGHT", 7, 0)
  preview.name:SetPoint("RIGHT", -8, 0)
  preview.name:SetJustifyH("LEFT")
  preview:Hide()

  local indicator = CreateFrame("Frame", nil, UIParent)
  indicator:SetHeight(3)
  indicator:SetFrameStrata("TOOLTIP")
  local line = indicator:CreateTexture(nil, "OVERLAY")
  line:SetAllPoints()
  line:SetColorTexture(1, 0.82, 0, 1)
  indicator:Hide()

  AutoMarksUI.dragPreview, AutoMarksUI.dropIndicator = preview, indicator
  return preview, indicator
end

local function updateDragVisual(preview, indicator, sourceRow, rows)
  local x, y = GetCursorPosition()
  local scale = UIParent:GetEffectiveScale()
  preview:ClearAllPoints()
  preview:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / scale + 16, y / scale + 16)

  AutoMarksUI.dragTargetNpcId = nil
  indicator:Hide()
  for _, target in ipairs(rows) do
    if target ~= sourceRow and target.frame:IsMouseOver() then
      AutoMarksUI.dragTargetNpcId = target.npcId
      indicator:ClearAllPoints()
      indicator:SetPoint("TOPLEFT", target.frame, "TOPLEFT", 0, 2)
      indicator:SetPoint("TOPRIGHT", target.frame, "TOPRIGHT", 0, 2)
      indicator:Show()
      break
    end
  end
end

local function addDragHandle(parent, row, enemy, rows, enemies, planner)
  local handle = parent.dragHandle
  if not handle then
    handle = CreateFrame("Button", nil, parent.frame)
    handle:SetSize(24, 30)
    handle:SetPoint("LEFT")
    handle.gripLines = {}
    for index = 1, 3 do
      local line = handle:CreateTexture(nil, "ARTWORK")
      line:SetSize(12, 2)
      line:SetPoint("CENTER", 0, (index - 2) * 4)
      line:SetColorTexture(0.65, 0.65, 0.65, 1)
      handle.gripLines[index] = line
    end
    parent.dragHandle = handle
  end
  handle:Show()

  local function colorGrip(red, green, blue)
    for _, line in ipairs(handle.gripLines) do line:SetColorTexture(red, green, blue, 1) end
  end

  handle:RegisterForDrag("LeftButton")
  handle:SetScript("OnEnter", function()
    colorGrip(1, 0.82, 0)
    GameTooltip:SetOwner(handle, "ANCHOR_LEFT")
    GameTooltip:AddLine(L["Drag to change mark priority"], 1, 1, 1)
    GameTooltip:Show()
  end)
  handle:SetScript("OnLeave", function()
    colorGrip(0.65, 0.65, 0.65)
    GameTooltip:Hide()
  end)
  handle:SetScript("OnDragStart", function()
    local preview, indicator = ensureDragVisual()
    row.frame:SetAlpha(0.2)
    AutoMarksUI.dragSourceRow = row
    SetPortraitTextureFromCreatureDisplayID(preview.portrait, enemy.displayId)
    preview.name:SetText(enemy.name)
    preview:Show()
    preview:SetScript("OnUpdate", function() updateDragVisual(preview, indicator, row, rows) end)
    updateDragVisual(preview, indicator, row, rows)
  end)
  handle:SetScript("OnDragStop", function()
    local preview, indicator = ensureDragVisual()
    updateDragVisual(preview, indicator, row, rows)
    local targetNpcId = AutoMarksUI.dragTargetNpcId
    AutoMarksUI:CancelDrag()
    if not targetNpcId then return end
    local order, moving = {}, enemy.npcId
    for _, candidate in ipairs(enemies) do
      if candidate.npcId ~= moving then order[#order + 1] = candidate.npcId end
    end
    local destination = #order + 1
    for index, npcId in ipairs(order) do
      if npcId == targetNpcId then destination = index break end
    end
    table.insert(order, destination, moving)
    if planner:SetFloorNpcPriority(order) then AutoMarksUI:QueueRefresh() end
  end)
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
    AutoMarksUI:QueueRefresh()
  end)
  container:AddChild(clear)
end

local function sortedEnemies(raid, sublevel, priority)
  local enemies, rank, bossNpcIds = {}, {}, {}
  local db = ART:GetDB()
  for _, enemy in pairs(ART.raidEnemies and db and ART.raidEnemies[db.currentRaidIndex] or {}) do
    local npcId = tonumber(enemy.id)
    if enemy.isBoss and npcId then bossNpcIds[npcId] = true end
  end
  for index, npcId in ipairs(type(priority) == "table" and priority or {}) do
    rank[tonumber(npcId)] = index
  end
  for npcKey, enemy in pairs(raid and raid.enemies or {}) do
    local npcId = tonumber(enemy.npcId) or tonumber(npcKey)
    if not enemy.isBoss and not bossNpcIds[npcId] then
      for _, spawn in ipairs(enemy.spawns or {}) do
        if spawn.sublevel == sublevel then
          enemies[#enemies + 1] = {
            npcId = npcId,
            name = L[enemy.name] or enemy.name or tostring(npcKey),
            displayId = enemy.displayId,
            definition = enemy,
            tooltipData = {
              id = npcId,
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
  end
  table.sort(enemies, function(left, right)
    local leftRank, rightRank = rank[left.npcId] or math.huge, rank[right.npcId] or math.huge
    if leftRank ~= rightRank then return leftRank < rightRank end
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
  local scrollvalue = AutoMarksUI.scrollStatus.scrollvalue or 0
  scroll:SetStatusTable(AutoMarksUI.scrollStatus)
  container:AddChild(scroll)
  AutoMarksUI.scrollWidget = scroll

  local enemies = sortedEnemies(planner.raid, ART:GetCurrentSubLevel(), planner:GetFloorNpcPriority())
  local rows = {}
  for _, enemy in ipairs(enemies) do
    local row = AceGUI:Create("SimpleGroup")
    row:SetLayout("Flow")
    row:SetFullWidth(true)
    row:SetHeight(34)
    row.npcId = enemy.npcId
    rows[#rows + 1] = row

    local npcIcon = AceGUI:Create("Icon")
    npcIcon:SetImageSize(24, 24)
    npcIcon:SetWidth(48)
    npcIcon:SetHeight(32)
    SetPortraitTextureFromCreatureDisplayID(npcIcon.image, enemy.displayId)
    npcIcon.image:ClearAllPoints()
    npcIcon.image:SetPoint("RIGHT", npcIcon.frame, "RIGHT", 0, 0)
    addDragHandle(npcIcon, row, enemy, rows, enemies, planner)
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
      if icon.dragHandle then icon.dragHandle:Hide() end
      icon.image:ClearAllPoints()
      icon.image:SetPoint("TOP", 0, -5)
      icon:SetImage(("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(marker))
      icon:SetImageSize(20, 20)
      icon:SetWidth(22)
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
  scroll:DoLayout()
  return scroll, scrollvalue
end

function AutoMarksUI:Refresh()
  self.refreshRevision = (self.refreshRevision or 0) + 1
  self.refreshQueuedToken = nil
  local raidKey = ART.RaidPlanner and ART.RaidPlanner.raid and ART.RaidPlanner.raid.key
  if self.scrollRaidKey ~= raidKey then
    self.scrollWidget, self.scrollStatus, self.scrollRaidKey = nil, {}, raidKey
  else
    self:CaptureScrollStatus()
  end
  self:CancelDrag()
  local sidePanel = ART.main_frame and ART.main_frame.sidePanel
  if not (sidePanel and sidePanel.AutoMarksGroup) then return end
  self:UpdateAvailability()
  if not raidIsActive() or self.selectedTab ~= "autoMarks" then return end
  local container, planner = sidePanel.AutoMarksGroup, ART.RaidPlanner
  if ART.CCAssignments then ART.CCAssignments:EnsureDefaultMarkers() end
  container:ReleaseChildren()
  addControls(container, planner)
  local scroll, scrollvalue = addEnemyRows(container, planner)
  container:DoLayout()
  scroll:DoLayout()
  scroll:SetScroll(scrollvalue)
  if scroll.scrollbar then scroll.scrollbar:SetValue(scrollvalue) end
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
