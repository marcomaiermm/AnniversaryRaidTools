local _, ART = ...
local L = ART.L

local WaveModeUI = ART.WaveModeUI or {}
ART.WaveModeUI = WaveModeUI

local markerOrder = { 8, 7, 1, 5, 6, 3, 4, 2 }
local HYJAL_INSTANCE_ID, HYJAL_WAVE_WIDGET_ID = 534, 3121
local hyjalBossGroup = { [17767] = 1, [17808] = 2, [17888] = 3, [17842] = 4, [17968] = 5 }
local runtimeGroup, pendingGroup, previousLocalWave

local function slug(value)
  return tostring(value or ""):lower():gsub("[^%w]+", "-"):gsub("^%-", ""):gsub("%-$", "")
end

local function activeMap()
  local planner, db = ART.RaidPlanner, ART.GetDB and ART:GetDB()
  if not (planner and planner.raid and db) then return end
  local mapInfo = ART.mapInfo and ART.mapInfo[db.currentRaidIndex]
  if not mapInfo or mapInfo.mapID ~= planner.raid.mapId then return end
  return ART.MapDefinitions and ART.MapDefinitions[planner.raid.key]
end

function WaveModeUI:IsActive()
  local planner, map = ART.RaidPlanner, activeMap()
  return planner and planner.raid and planner.raid.mode == "waves" and map and map.waveMode ~= nil
end

local function groupFor(groups, waveIndex)
  for index, group in ipairs(groups or {}) do
    if waveIndex >= group.firstWave and waveIndex <= group.lastWave then return group, index end
  end
end

local function npcIdFromGuid(guid)
  if type(guid) ~= "string" then return end
  local previous, last
  for component in guid:gmatch("[^%-]+") do previous, last = last, component end
  return tonumber(previous)
end

function WaveModeUI:IsHyjalRuntimeActive()
  if type(GetInstanceInfo) ~= "function" or select(8, GetInstanceInfo()) ~= HYJAL_INSTANCE_ID
      or not self:IsActive() then return false end
  local preset = ART.GetCurrentPreset and ART:GetCurrentPreset()
  return preset and preset.value and preset.value.artWaveRaid == "hyjal"
end

function WaveModeUI:ResetHyjalRuntime()
  runtimeGroup, pendingGroup, previousLocalWave = nil, nil, nil
end

local function mapPlanningOpen()
  local frame = ART.main_frame
  return frame and type(frame.IsShown) == "function" and frame:IsShown()
      and (not ART.IsMapSectionActive or ART:IsMapSectionActive())
end

local function selectRuntimeWave(index)
  if mapPlanningOpen() then return false end
  local preset = ART:GetCurrentPreset()
  if tonumber(preset.value.currentPull) == index then return false end
  ART:SetSelectionToPull(index)
  return true
end

function WaveModeUI:HandleHyjalWave(localWave)
  localWave = tonumber(localWave)
  if not self:IsHyjalRuntimeActive() or not localWave or localWave % 1 ~= 0
      or localWave < 1 or localWave > 8 then return false end
  local groups = activeMap().waveMode.groups
  local currentWave = tonumber(ART:GetCurrentPreset().value.currentPull) or 1
  local currentGroup, currentGroupIndex = groupFor(groups, currentWave)
  if not runtimeGroup then
    runtimeGroup = currentGroupIndex or 1
    if currentGroup and currentWave == currentGroup.lastWave and localWave == 1
        and runtimeGroup < #groups and groups[runtimeGroup + 1].firstWave < groups[runtimeGroup + 1].lastWave then
      runtimeGroup = runtimeGroup + 1
    end
  end
  if pendingGroup then
    if previousLocalWave and localWave >= previousLocalWave then return false end
    runtimeGroup, pendingGroup = pendingGroup, nil
  end
  previousLocalWave = localWave
  local group = groups[runtimeGroup]
  if not group or group.firstWave == group.lastWave then return false end
  local index = group.firstWave + localWave - 1
  if index >= group.lastWave then return false end
  return selectRuntimeWave(index)
end

function WaveModeUI:ReadHyjalWave()
  if not self:IsHyjalRuntimeActive() or not C_UIWidgetManager
      or type(C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo) ~= "function" then return false end
  local info = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(HYJAL_WAVE_WIDGET_ID)
  local wave = info and tostring(info.text or ""):match("(%d+)")
  return self:HandleHyjalWave(wave)
end

function WaveModeUI:HandleHyjalBoss(npcId, died)
  local groupIndex = hyjalBossGroup[tonumber(npcId)]
  if not groupIndex or not self:IsHyjalRuntimeActive() then return false end
  local groups = activeMap().waveMode.groups
  local group = groups[groupIndex]
  runtimeGroup, pendingGroup = groupIndex, nil
  local changed = selectRuntimeWave(group.lastWave)
  if died and groupIndex < #groups then
    local nextGroup = groups[groupIndex + 1]
    if nextGroup.firstWave == nextGroup.lastWave then
      runtimeGroup = groupIndex + 1
      changed = selectRuntimeWave(nextGroup.firstWave) or changed
    else
      pendingGroup, previousLocalWave = groupIndex + 1, 8
    end
  end
  return changed
end

local function pathSignature(points)
  local values = {}
  for _, point in ipairs(points) do
    values[#values + 1] = string.format("%.6f:%.6f", point.x, point.y)
  end
  return table.concat(values, ";")
end

function WaveModeUI:BuildModel()
  if not self:IsActive() then return nil end
  local planner, map = ART.RaidPlanner, activeMap()
  local value = ART:GetCurrentPreset().value
  local waveIndex = math.min(math.max(tonumber(value.currentPull) or 1, 1), #planner.raid.waves)
  local wave, step = planner.raid.waves[waveIndex], planner.preset.routeSteps[waveIndex]
  local group, groupIndex = groupFor(map.waveMode.groups, waveIndex)
  if not wave or not step or not group then return nil end

  local activePacks = {}
  for _, packKey in ipairs(wave.packKeys) do activePacks[packKey] = true end
  local canvasWidth, canvasHeight = ART:GetDefaultMapPanelSize()
  local projectedEnemies = ART.raidEnemies and ART.raidEnemies[ART:GetDB().currentRaidIndex]
  local spawnLookup = ART.MultiRaidIntegration and ART.MultiRaidIntegration.spawnLookup
      and ART.MultiRaidIntegration.spawnLookup[planner.raid.key]
  local enemies, pathsBySignature = {}, {}
  for npcKey, enemy in pairs(planner.raid.enemies or {}) do
    local entry
    for _, spawn in ipairs(enemy.spawns or {}) do
      if activePacks[spawn.packKey] then
        entry = entry or {
          npcId = tonumber(enemy.npcId) or tonumber(npcKey), name = L[enemy.name] or enemy.name,
          displayId = enemy.displayId, health = enemy.health, level = enemy.level,
          creatureType = enemy.creatureType, count = 0,
        }
        entry.count = entry.count + 1
        local reference = spawnLookup and spawnLookup[spawn.key]
        local clone = reference and projectedEnemies and projectedEnemies[reference.enemyIdx]
            and projectedEnemies[reference.enemyIdx].clones[reference.cloneIdx]
        local patrol = clone and clone.patrol
        if patrol and #patrol > 0 then
          local points = {}
          for _, point in ipairs(patrol) do
            points[#points + 1] = { x = point.x / canvasWidth, y = -point.y / canvasHeight }
          end
          local signature = pathSignature(points)
          local path = pathsBySignature[signature]
          if path then
            path.occurrences = path.occurrences + 1
          else
            pathsBySignature[signature] = { points = points, occurrences = 1 }
          end
        end
      end
    end
    if entry then
      entry.markers = planner.GetStepNpcMarks and planner:GetStepNpcMarks(step.id, entry.npcId) or {}
      enemies[#enemies + 1] = entry
    end
  end
  table.sort(enemies, function(left, right) return left.name < right.name end)

  local paths = {}
  for _, path in pairs(pathsBySignature) do paths[#paths + 1] = path end
  table.sort(paths, function(left, right)
    if left.occurrences == right.occurrences then return pathSignature(left.points) < pathSignature(right.points) end
    return left.occurrences > right.occurrences
  end)

  local camp
  for _, poi in ipairs(planner.raid.pois and planner.raid.pois[1] or {}) do
    if slug(poi.label) == wave.camp then camp = poi break end
  end
  return {
    waveIndex = waveIndex, totalWaves = #planner.raid.waves, wave = wave, step = step,
    group = group, groupIndex = groupIndex, groupWave = waveIndex - group.firstWave + 1,
    groupWaves = group.lastWave - group.firstWave + 1, camp = camp, enemies = enemies, paths = paths,
    groups = map.waveMode.groups,
  }
end

local function setBackdrop(frame, color, border)
  if not frame.SetBackdrop then return end
  frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
  })
  frame:SetBackdropColor(unpack(color))
  frame:SetBackdropBorderColor(unpack(border))
end

local function createListButton(parent, height)
  local button = CreateFrame("Button", nil, parent)
  button:SetHeight(height)
  button.background = button:CreateTexture(nil, "BACKGROUND")
  button.background:SetAllPoints()
  button.label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  button.label:SetPoint("LEFT", 8, 0)
  button.label:SetJustifyH("LEFT")
  button.index = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  button.index:SetPoint("RIGHT", -7, 0)
  return button
end

function WaveModeUI:CreateSidePanel(sidePanel)
  if sidePanel.WaveModeGroup or type(CreateFrame) ~= "function" then return end
  local group = CreateFrame("Frame", nil, sidePanel)
  group:SetAllPoints(sidePanel.PullButtonScrollGroup.frame)
  local scroll = CreateFrame("ScrollFrame", nil, group, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", 2, -2)
  scroll:SetPoint("BOTTOMRIGHT", -25, 2)
  local content = CreateFrame("Frame", nil, scroll)
  content:SetSize(218, 1)
  scroll:SetScrollChild(content)
  group.scroll, group.content, group.groupButtons, group.waveButtons = scroll, content, {}, {}
  group:Hide()
  sidePanel.WaveModeGroup = group
end

function WaveModeUI:RefreshSidePanel(model)
  local sidePanel = ART.main_frame and ART.main_frame.sidePanel
  local frame = sidePanel and sidePanel.WaveModeGroup
  if not frame then return end
  if not model then frame:Hide(); return end
  if self.lastWaveIndex ~= model.waveIndex then
    self.lastWaveIndex, self.expandedGroup = model.waveIndex, model.groupIndex
  end

  local groupButtonIndex, waveButtonIndex, y = 0, 0, -3
  for groupIndex, definition in ipairs(model.groups) do
    groupButtonIndex = groupButtonIndex + 1
    local button = frame.groupButtons[groupButtonIndex]
    if not button then
      button = createListButton(frame.content, 28)
      button:SetScript("OnClick", function(item)
        self.expandedGroup = self.expandedGroup == item.groupIndex and nil or item.groupIndex
        self:Refresh()
      end)
      frame.groupButtons[groupButtonIndex] = button
    end
    button.groupIndex = groupIndex
    button:SetPoint("TOPLEFT", 2, y)
    button:SetPoint("RIGHT", -2, 0)
    button.background:SetColorTexture(0.09, 0.075, 0.045, groupIndex == model.groupIndex and 0.98 or 0.82)
    button.label:SetText((self.expandedGroup == groupIndex and "- " or "+ ")..(L[definition.label] or definition.label))
    button.label:SetTextColor(groupIndex == model.groupIndex and 1 or 0.8, groupIndex == model.groupIndex and 0.78 or 0.66, 0.24)
    button:Show()
    y = y - 30

    if self.expandedGroup == groupIndex then
      for waveIndex = definition.firstWave, definition.lastWave do
        waveButtonIndex = waveButtonIndex + 1
        local waveButton = frame.waveButtons[waveButtonIndex]
        if not waveButton then
          waveButton = createListButton(frame.content, 24)
          waveButton:SetScript("OnClick", function(item) ART:SetSelectionToPull(item.waveIndex) end)
          frame.waveButtons[waveButtonIndex] = waveButton
        end
        local selected = waveIndex == model.waveIndex
        waveButton.waveIndex = waveIndex
        waveButton:SetPoint("TOPLEFT", 12, y)
        waveButton:SetPoint("RIGHT", -2, 0)
        waveButton.background:SetColorTexture(selected and 0.32 or 0.035, selected and 0.20 or 0.04,
            selected and 0.045 or 0.05, selected and 0.96 or 0.72)
        local finalWave = waveIndex == definition.lastWave
        waveButton.label:SetText(finalWave and L["Boss"] or (L["Wave"].." "..(waveIndex - definition.firstWave + 1)))
        waveButton.label:SetTextColor(selected and 1 or 0.78, selected and 0.86 or 0.78, selected and 0.42 or 0.78)
        waveButton.index:SetText(waveIndex.."/"..model.totalWaves)
        waveButton:Show()
        y = y - 25
      end
    end
  end
  for index = groupButtonIndex + 1, #frame.groupButtons do frame.groupButtons[index]:Hide() end
  for index = waveButtonIndex + 1, #frame.waveButtons do frame.waveButtons[index]:Hide() end
  frame.content:SetHeight(math.max(1, -y + 4))
end

local function createMarkerButton(parent, marker)
  local button = CreateFrame("Button", nil, parent)
  button:SetSize(19, 19)
  button.icon = button:CreateTexture(nil, "ARTWORK")
  button.icon:SetAllPoints()
  button.icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..marker)
  button.marker = marker
  return button
end

function WaveModeUI:CreateMapCard()
  if self.card or type(CreateFrame) ~= "function" then return end
  local parent = ART.main_frame and ART.main_frame.scrollFrame
  if not parent then return end
  local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
  card:SetSize(372, 112)
  card:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -18, -18)
  card:SetFrameStrata("HIGH")
  card:SetFrameLevel(60)
  setBackdrop(card, { 0.025, 0.03, 0.035, 0.94 }, { 0.72, 0.48, 0.12, 0.95 })
  card.title = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  card.title:SetPoint("TOPLEFT", 14, -11)
  card.title:SetPoint("RIGHT", -147, 0)
  card.title:SetJustifyH("LEFT")
  card.title:SetTextColor(1, 0.78, 0.25)
  card.subtitle = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  card.subtitle:SetPoint("TOPLEFT", card.title, "BOTTOMLEFT", 0, -4)
  card.route = card:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  card.route:SetPoint("TOPLEFT", card.subtitle, "BOTTOMLEFT", 0, -3)
  card.route:SetText(L["Approximate route"])
  card.clear = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
  card.clear:SetSize(66, 24)
  card.clear:SetPoint("TOPRIGHT", -77, -10)
  card.clear:SetText(L["Clear Marks"])
  card.clear:SetScript("OnClick", function()
    if ART.LiveMarks then ART.LiveMarks:ClearWorldMarks() end
  end)
  card.clear:SetScript("OnEnter", function(button)
    if not GameTooltip then return end
    GameTooltip:SetOwner(button, "ANCHOR_TOP")
    GameTooltip:SetText(L["Clear all Markers"])
    GameTooltip:Show()
  end)
  card.clear:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
  card.previous = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
  card.previous:SetSize(28, 24)
  card.previous:SetPoint("TOPRIGHT", -45, -10)
  card.previous:SetText("<")
  card.previous:SetScript("OnClick", function() if card.model.waveIndex > 1 then ART:SetSelectionToPull(card.model.waveIndex - 1) end end)
  card.next = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
  card.next:SetSize(28, 24)
  card.next:SetPoint("TOPRIGHT", -13, -10)
  card.next:SetText(">")
  card.next:SetScript("OnClick", function()
    if card.model.waveIndex < card.model.totalWaves then ART:SetSelectionToPull(card.model.waveIndex + 1) end
  end)
  card.rows = {}
  card:Hide()
  self.card = card
end

function WaveModeUI:CreateCardRow(card, index)
  local row = CreateFrame("Frame", nil, card)
  row:SetHeight(31)
  row:SetPoint("TOPLEFT", 10, -70 - ((index - 1) * 32))
  row:SetPoint("RIGHT", -10, 0)
  row.portrait = CreateFrame("Button", nil, row)
  row.portrait:SetSize(27, 27)
  row.portrait:SetPoint("LEFT", 0, 0)
  row.portrait.icon = row.portrait:CreateTexture(nil, "ARTWORK")
  row.portrait.icon:SetAllPoints()
  row.portrait:SetScript("OnEnter", function(button)
    if ART.DisplayBlipTooltip then ART:DisplayBlipTooltip(button, true) end
  end)
  row.portrait:SetScript("OnLeave", function(button)
    if ART.DisplayBlipTooltip then ART:DisplayBlipTooltip(button, false) end
  end)
  row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  row.name:SetPoint("LEFT", row.portrait, "RIGHT", 7, 0)
  row.name:SetWidth(116)
  row.name:SetJustifyH("LEFT")
  row.count = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  row.count:SetPoint("LEFT", 153, 0)
  row.count:SetTextColor(1, 0.78, 0.25)
  row.markers = {}
  for markerIndex, marker in ipairs(markerOrder) do
    local button = createMarkerButton(row, marker)
    button:SetPoint("LEFT", 176 + ((markerIndex - 1) * 21), 0)
    button:SetScript("OnClick", function(item)
      local selected = {}
      for _, value in ipairs(row.model.markers) do selected[value] = true end
      selected[item.marker] = not selected[item.marker]
      local markers = {}
      for _, candidate in ipairs(markerOrder) do if selected[candidate] then markers[#markers + 1] = candidate end end
      ART.RaidPlanner:SetStepNpcMarks(card.model.step.id, row.model.npcId, markers)
      self:Refresh()
    end)
    row.markers[markerIndex] = button
  end
  card.rows[index] = row
  return row
end

function WaveModeUI:RefreshCard(model)
  self:CreateMapCard()
  local card = self.card
  if not card then return end
  if not model then card:Hide(); return end
  card.model = model
  card.title:SetText(L["Wave"].." "..model.waveIndex.."/"..model.totalWaves.." — "..(L[model.group.label] or model.group.label))
  card.subtitle:SetText((model.camp and (L[model.camp.label] or model.camp.label) or model.wave.camp)
      .."  |  "..model.groupWave.."/"..model.groupWaves)
  card.previous:SetEnabled(model.waveIndex > 1)
  card.next:SetEnabled(model.waveIndex < model.totalWaves)
  for index, enemy in ipairs(model.enemies) do
    local row = card.rows[index] or self:CreateCardRow(card, index)
    row.model = enemy
    row.name:SetText(enemy.name)
    row.count:SetText("x"..enemy.count)
    SetPortraitTextureFromCreatureDisplayID(row.portrait.icon, enemy.displayId)
    row.portrait.data = {
      id = enemy.npcId, name = enemy.name, health = enemy.health, level = enemy.level,
      creatureType = enemy.creatureType,
    }
    row.portrait.clone, row.portrait.cloneIdx, row.portrait.suppressEnemyInfoHint = {}, "", true
    local selected = {}
    for _, marker in ipairs(enemy.markers) do selected[marker] = true end
    for _, button in ipairs(row.markers) do
      local enabled = selected[button.marker] or #enemy.markers < enemy.count
      button:SetEnabled(enabled)
      button.icon:SetAlpha(selected[button.marker] and 1 or (enabled and 0.2 or 0.08))
    end
    row:Show()
  end
  for index = #model.enemies + 1, #card.rows do card.rows[index]:Hide() end
  card:SetHeight(78 + (#model.enemies * 32))
  card:Show()
end

function WaveModeUI:HideRoutes()
  for _, line in ipairs(self.routeLines or {}) do line:Hide() end
  for _, arrow in ipairs(self.routeArrows or {}) do arrow:Hide() end
  if self.campMarker then self.campMarker:Hide(); self.campLabel:Hide() end
end

function WaveModeUI:RefreshRoutes(model)
  self:HideRoutes()
  if not model or type(DrawLine) ~= "function" or not ART.main_frame.mapPanelFrame then return end
  self.routeLines, self.routeArrows = self.routeLines or {}, self.routeArrows or {}
  local width, height = ART:GetDefaultMapPanelSize()
  local scale, lineIndex = ART:GetScale(), 0
  for pathIndex, path in ipairs(model.paths) do
    local points = path.points
    for index = 2, #points do
      lineIndex = lineIndex + 1
      local line = self.routeLines[lineIndex]
      if not line then
        line = ART.main_frame.mapPanelFrame:CreateTexture(nil, "OVERLAY")
        line:SetTexture(ART.AddonPath.."Textures\\Square_White")
        self.routeLines[lineIndex] = line
      end
      line:SetVertexColor(0.12, 0.62, 1, pathIndex == 1 and 0.92 or 0.48)
      DrawLine(line, ART.main_frame.mapPanelTile1, points[index - 1].x * width * scale,
          -points[index - 1].y * height * scale, points[index].x * width * scale,
          -points[index].y * height * scale, (pathIndex == 1 and 3 or 2) * scale, 1, "TOPLEFT")
      line:Show()
    end
    if #points > 1 then
      local arrow = self.routeArrows[pathIndex]
      if not arrow then
        arrow = ART.main_frame.mapPanelFrame:CreateTexture(nil, "OVERLAY")
        arrow:SetAtlas("Garr_LevelUpgradeArrow")
        arrow:SetSize(18, 18)
        self.routeArrows[pathIndex] = arrow
      end
      local previous, last = points[#points - 1], points[#points]
      arrow:ClearAllPoints()
      arrow:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", last.x * width * scale, -last.y * height * scale)
      arrow:SetRotation(math.atan2(-(last.y - previous.y), last.x - previous.x) - math.pi / 2)
      arrow:SetVertexColor(0.2, 0.75, 1, pathIndex == 1 and 1 or 0.6)
      arrow:Show()
    end
  end
  if model.camp then
    if not self.campMarker then
      self.campMarker = ART.main_frame.mapPanelFrame:CreateTexture(nil, "OVERLAY")
      self.campMarker:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
      self.campMarker:SetSize(34, 34)
      self.campMarker:SetVertexColor(1, 0.72, 0.16, 0.95)
      self.campLabel = ART.main_frame.mapPanelFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      self.campLabel:SetTextColor(1, 0.78, 0.25)
    end
    self.campMarker:ClearAllPoints()
    self.campMarker:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", model.camp.x * width * scale,
        -model.camp.y * height * scale)
    self.campLabel:ClearAllPoints()
    self.campLabel:SetPoint("BOTTOM", self.campMarker, "TOP", 0, 2)
    self.campLabel:SetText(L[model.camp.label] or model.camp.label)
    self.campMarker:Show()
    self.campLabel:Show()
  end
end

function WaveModeUI:Refresh()
  local mainFrame = ART.main_frame
  if mainFrame and mainFrame ~= self.runtimeHookFrame and type(mainFrame.HookScript) == "function" then
    self.runtimeHookFrame = mainFrame
    mainFrame:HookScript("OnHide", function() WaveModeUI:ReadHyjalWave() end)
  end
  local model = self:BuildModel()
  self:RefreshSidePanel(model)
  self:RefreshCard(model)
  self:RefreshRoutes(model)
  local sidePanel = ART.main_frame and ART.main_frame.sidePanel
  if sidePanel and sidePanel.WaveModeGroup and not model then sidePanel.WaveModeGroup:Hide() end
  return model
end

local originalMakePullSelectionButtons = ART.MakePullSelectionButtons
function ART:MakePullSelectionButtons(sidePanel)
  local result = originalMakePullSelectionButtons(self, sidePanel)
  WaveModeUI:CreateSidePanel(sidePanel)
  return result
end

local originalSetSelectionToPull = ART.SetSelectionToPull
function ART:SetSelectionToPull(...)
  local result = originalSetSelectionToPull(self, ...)
  WaveModeUI:Refresh()
  return result
end

local originalUpdateMap = ART.UpdateMap
function ART:UpdateMap(...)
  local result = originalUpdateMap(self, ...)
  WaveModeUI:Refresh()
  WaveModeUI:ReadHyjalWave()
  if ART.AutoMarksUI and ART.AutoMarksUI.UpdateAvailability then ART.AutoMarksUI:UpdateAvailability() end
  return result
end


if type(CreateFrame) == "function" then
  local runtimeFrame = CreateFrame("Frame")
  runtimeFrame:RegisterEvent("UPDATE_UI_WIDGET")
  runtimeFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  runtimeFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  runtimeFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  runtimeFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "UPDATE_UI_WIDGET" then
      local widget = ...
      if type(widget) == "table" and widget.widgetID == HYJAL_WAVE_WIDGET_ID then WaveModeUI:ReadHyjalWave() end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" and WaveModeUI:IsHyjalRuntimeActive() then
      local _, subevent, _, sourceGuid, _, _, _, destGuid = CombatLogGetCurrentEventInfo()
      local sourceNpc, destNpc = npcIdFromGuid(sourceGuid), npcIdFromGuid(destGuid)
      local bossNpc = hyjalBossGroup[sourceNpc] and sourceNpc or hyjalBossGroup[destNpc] and destNpc
      if bossNpc then WaveModeUI:HandleHyjalBoss(bossNpc, subevent == "UNIT_DIED" and bossNpc == destNpc) end
    else
      WaveModeUI:ResetHyjalRuntime()
      if C_Timer and C_Timer.After then C_Timer.After(0.5, function() WaveModeUI:ReadHyjalWave() end) end
    end
  end)
  WaveModeUI.runtimeFrame = runtimeFrame
end
