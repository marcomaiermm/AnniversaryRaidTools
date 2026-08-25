-- UI adapter for raid marks. Central registration belongs to the integrator.

local _, addon = ...
local ART = rawget(_G, "ART") or (addon and addon.ART) or addon or {}
if not rawget(_G, "ART") then _G.ART = ART end
if addon and addon.ART == nil then addon.ART = ART end

local RaidMarksUI = ART.RaidMarksUI or {}
ART.RaidMarksUI = RaidMarksUI
if addon and addon.RaidMarksUI == nil then addon.RaidMarksUI = RaidMarksUI end

local tracker
local L = addon.L or {}

function RaidMarksUI:GetPullTrackerModel()
  local planner = ART.RaidPlanner
  local raid, preset = planner and planner.raid, planner and planner.preset
  if not raid or not preset then return nil end

  local db = addon.GetDB and addon:GetDB()
  local mapInfo = db and addon.mapInfo and addon.mapInfo[db.currentDungeonIdx]
  if mapInfo and mapInfo.mapID ~= raid.mapId then return nil end

  local currentPreset = addon.GetCurrentPreset and addon:GetCurrentPreset()
  local value = currentPreset and currentPreset.value
  local selectedPull = tonumber(planner.lastPullIndex)
  if self.trackerPreset ~= preset then
    self.trackerPreset, self.trackerPullIndex, self.trackerTotalPulls = preset, nil, nil
  end
  local pulls = value and value.pulls or {}
  if selectedPull or not self.trackerPullIndex then
    self.trackerPullIndex = selectedPull or tonumber(value and value.currentPull)
    self.trackerTotalPulls = #pulls
  end
  local pullIndex = self.trackerPullIndex
  if not pullIndex then return nil end

  local mode, currentLabel, currentText, nextText = raid.mode
  local totalPulls = self.trackerTotalPulls
  if mode == "waves" then
    totalPulls = #raid.waves
    local definition = ART.MapDefinitions and ART.MapDefinitions[raid.key]
    for _, group in ipairs(definition and definition.waveMode and definition.waveMode.groups or {}) do
      if pullIndex >= group.firstWave and pullIndex <= group.lastWave then
        local boss = pullIndex == group.lastWave
        currentLabel = L[group.label] or group.label
        currentText = (L[boss and "Boss" or "Wave"] or (boss and "Boss" or "Wave")).." "..pullIndex.." / "..totalPulls
        break
      end
    end
    nextText = pullIndex < totalPulls and "NEXT  "..(L["Wave"] or "Wave").." "..(pullIndex + 1).."  >" or "LAST WAVE"
  else
    currentLabel = "CURRENT PULL"
    currentText = ("Pull %d / %d"):format(pullIndex, totalPulls)
    nextText = pullIndex < totalPulls and "NEXT  Pull "..(pullIndex + 1).."  >" or "LAST PULL"
  end

  local names = {}
  for _, enemy in pairs(raid.enemies or {}) do
    for _, spawn in ipairs(enemy.spawns or {}) do names[spawn.key] = enemy.name end
  end
  local rows = {}
  local step = planner.GetActiveStep and planner:GetActiveStep()
  for spawnKey, marker in pairs(step and step.marks or {}) do
    marker = tonumber(marker)
    if marker and marker >= 1 and marker <= 8 then
      rows[#rows + 1] = { marker = marker, name = names[spawnKey] or spawnKey }
    end
  end
  table.sort(rows, function(left, right)
    return left.marker > right.marker or left.marker == right.marker and left.name < right.name
  end)

  return {
    raidName = raid.name,
    mode = mode,
    showNext = mode ~= "waves",
    pullIndex = pullIndex,
    totalPulls = totalPulls,
    nextPullIndex = pullIndex < totalPulls and pullIndex + 1 or nil,
    currentLabel = currentLabel,
    currentText = currentText,
    nextText = nextText,
    marks = rows,
  }
end

local function showBody(frame, shown)
  frame.status:SetShown(shown)
  frame.assignments:SetShown(shown)
  frame.clear:SetShown(shown)
  frame.empty:SetShown(shown and #frame.model.marks == 0)
  for _, row in ipairs(frame.rows) do row:SetShown(shown and row.used) end
end

local function setBodyAlpha(frame, alpha)
  frame.status:SetAlpha(alpha)
  frame.assignments:SetAlpha(alpha)
  frame.clear:SetAlpha(alpha)
  frame.empty:SetAlpha(alpha)
  for _, row in ipairs(frame.rows) do row:SetAlpha(alpha) end
  frame.bodyAlpha = alpha
end

local function expandedHeight(frame)
  return 170 + math.max(1, #frame.model.marks) * 22
end

local function anchorAtHeader(frame)
  local left, top = frame:GetLeft(), frame:GetTop()
  if not left or not top then return end
  frame:ClearAllPoints()
  frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
end

local function setExpanded(frame, expanded, animate)
  anchorAtHeader(frame)
  frame.expanded = expanded
  frame.toggle.text:SetText(expanded and "-" or "+")
  showBody(frame, true)
  local targetHeight, targetAlpha = expanded and expandedHeight(frame) or 32, expanded and 1 or 0
  if animate then
    frame:AnimateResize(targetHeight, targetAlpha)
  else
    frame.resizeAnimation = nil
    frame:SetHeight(targetHeight)
    setBodyAlpha(frame, targetAlpha)
    if not expanded then showBody(frame, false) end
  end
end

local function createTracker()
  if tracker or type(CreateFrame) ~= "function" or not UIParent then return tracker end
  local frame = CreateFrame("Frame", "ARTPullTrackerFrame", UIParent)
  frame:SetSize(300, 192)
  frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -36, -210)
  frame:SetFrameStrata("MEDIUM")
  frame:SetClampedToScreen(true)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  if frame.SetClipsChildren then frame:SetClipsChildren(true) end

  frame.shadow = frame:CreateTexture(nil, "BACKGROUND")
  frame.shadow:SetPoint("TOPLEFT", -4, 4)
  frame.shadow:SetPoint("BOTTOMRIGHT", 4, -4)
  frame.shadow:SetColorTexture(0, 0, 0, 0)
  frame.background = frame:CreateTexture(nil, "BACKGROUND")
  frame.background:SetAllPoints()
  frame.background:SetColorTexture(0, 0, 0, 0)
  frame.accent = frame:CreateTexture(nil, "BORDER")
  frame.accent:SetPoint("TOPLEFT", 5, -31)
  frame.accent:SetPoint("TOPRIGHT", -31, -31)
  frame.accent:SetHeight(1)
  frame.accent:SetColorTexture(0.74, 0.52, 0.1, 0.8)

  frame.header = CreateFrame("Button", nil, frame)
  frame.header:SetPoint("TOPLEFT")
  frame.header:SetPoint("TOPRIGHT")
  frame.header:SetHeight(32)
  frame.header:RegisterForDrag("LeftButton")
  frame.header:SetScript("OnDragStart", function() frame:StartMoving() end)
  frame.header:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    anchorAtHeader(frame)
  end)
  frame.header.background = frame.header:CreateTexture(nil, "ARTWORK")
  frame.header.background:SetAllPoints()
  frame.header.background:SetColorTexture(0, 0, 0, 0)
  frame.header.line = frame.header:CreateTexture(nil, "OVERLAY")
  frame.header.line:SetPoint("BOTTOMLEFT", 5, 0)
  frame.header.line:SetPoint("BOTTOMRIGHT")
  frame.header.line:SetHeight(1)
  frame.header.line:SetColorTexture(0.8, 0.58, 0.12, 0.65)

  frame.title = frame.header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.title:SetPoint("LEFT", 18, 1)
  frame.title:SetPoint("RIGHT", -38, 1)
  frame.title:SetJustifyH("LEFT")
  frame.title:SetTextColor(1, 0.82, 0.18)

  frame.toggle = CreateFrame("Button", nil, frame.header, "BackdropTemplate")
  frame.toggle:SetSize(22, 22)
  frame.toggle:SetPoint("RIGHT", -3, 1)
  frame.toggle:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
  frame.toggle:SetBackdropColor(0.06, 0.04, 0.01, 0.95)
  frame.toggle:SetBackdropBorderColor(0.78, 0.57, 0.15, 0.9)
  frame.toggle.text = frame.toggle:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.toggle.text:SetAllPoints()
  frame.toggle.text:SetTextColor(0.82, 0.67, 0.25)
  frame.toggle:SetScript("OnEnter", function() frame.toggle.text:SetTextColor(1, 0.9, 0.45) end)
  frame.toggle:SetScript("OnLeave", function() frame.toggle.text:SetTextColor(0.82, 0.67, 0.25) end)
  frame.toggle:SetScript("OnClick", function() setExpanded(frame, not frame.expanded, true) end)

  frame.status = CreateFrame("Button", nil, frame, "BackdropTemplate")
  frame.status:SetPoint("TOPLEFT", 8, -40)
  frame.status:SetSize(284, 62)
  frame.status:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
  frame.status:SetBackdropColor(0.025, 0.035, 0.045, 0.96)
  frame.status:SetBackdropBorderColor(0.86, 0.62, 0.12, 0.95)
  frame.status:SetScript("OnEnter", function()
    frame.status:SetBackdropBorderColor(1, 0.78, 0.22, 1)
  end)
  frame.status:SetScript("OnLeave", function()
    frame.status:SetBackdropBorderColor(0.86, 0.62, 0.12, 0.95)
  end)
  frame.status:SetScript("OnClick", function()
    local pullIndex = frame.model and frame.model.pullIndex
    if not pullIndex then return end
    local selectPull = function()
      if addon.SetSelectionToPull then addon:SetSelectionToPull(pullIndex) end
    end
    selectPull()
    if addon.ShowInterface then addon:ShowInterface(true) end
    if addon.RunAfterFramesInitialized then addon:RunAfterFramesInitialized(selectPull) end
  end)
  frame.status.background = frame.status:CreateTexture(nil, "BACKGROUND")
  frame.status.background:SetPoint("TOPLEFT", 6, -6)
  frame.status.background:SetPoint("BOTTOMRIGHT", -6, 6)
  frame.status.background:SetColorTexture(0.025, 0.04, 0.06, 0.84)
  frame.status.highlight = frame.status:CreateTexture(nil, "HIGHLIGHT")
  frame.status.highlight:SetPoint("TOPLEFT", 6, -6)
  frame.status.highlight:SetPoint("BOTTOMRIGHT", -6, 6)
  frame.status.highlight:SetColorTexture(0.12, 0.35, 0.58, 0.28)
  frame.status:SetHighlightTexture(frame.status.highlight)
  frame.status.pushed = frame.status:CreateTexture(nil, "ARTWORK")
  frame.status.pushed:SetPoint("TOPLEFT", 4, -4)
  frame.status.pushed:SetPoint("BOTTOMRIGHT", -4, 4)
  frame.status.pushed:SetColorTexture(0.95, 0.62, 0.08, 0.34)
  frame.status:SetPushedTexture(frame.status.pushed)

  frame.currentLabel = frame.status:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.currentLabel:SetPoint("TOPLEFT", 14, -10)
  frame.currentLabel:SetText("CURRENT PULL")
  frame.currentLabel:SetTextColor(0.92, 0.72, 0.26)
  frame.current = frame.status:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.current:SetPoint("TOPLEFT", frame.currentLabel, "BOTTOMLEFT", 0, -3)
  frame.current:SetTextColor(1, 1, 1)

  frame.next = CreateFrame("Button", nil, frame.status, "BackdropTemplate")
  frame.next:SetPoint("TOPRIGHT", -8, -8)
  frame.next:SetSize(128, 42)
  frame.next:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
  frame.next:SetBackdropColor(0.025, 0.035, 0.05, 0.98)
  frame.next:SetBackdropBorderColor(0.4, 0.31, 0.12, 0.8)
  frame.next.background = frame.next:CreateTexture(nil, "ARTWORK")
  frame.next.background:SetPoint("TOPLEFT", 3, -3)
  frame.next.background:SetPoint("BOTTOMRIGHT", -3, 3)
  frame.next.background:SetColorTexture(0.08, 0.11, 0.16, 0.95)
  frame.next.label = frame.next:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.next.label:SetAllPoints()
  frame.next.label:SetTextColor(1, 0.82, 0.18)
  frame.next:SetScript("OnEnter", function() frame.next.background:SetColorTexture(0.12, 0.2, 0.31, 1) end)
  frame.next:SetScript("OnLeave", function()
    if frame.model and frame.model.nextPullIndex then
      frame.next.background:SetColorTexture(0.08, 0.11, 0.16, 0.95)
    else
      frame.next.background:SetColorTexture(0.045, 0.05, 0.06, 0.9)
    end
  end)
  frame.next:SetScript("OnClick", function()
    local nextPull = frame.model and frame.model.nextPullIndex
    if nextPull and addon.SetSelectionToPull then addon:SetSelectionToPull(nextPull) end
  end)

  frame.progressBackground = frame.status:CreateTexture(nil, "ARTWORK")
  frame.progressBackground:SetPoint("BOTTOMLEFT", 7, 7)
  frame.progressBackground:SetPoint("BOTTOMRIGHT", -7, 7)
  frame.progressBackground:SetHeight(5)
  frame.progressBackground:SetColorTexture(0.07, 0.1, 0.16, 1)
  frame.progress = frame.status:CreateTexture(nil, "OVERLAY")
  frame.progress:SetPoint("BOTTOMLEFT", 7, 7)
  frame.progress:SetHeight(5)
  frame.progress:SetColorTexture(0.08, 0.46, 0.95, 1)

  frame.assignments = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.assignments:SetPoint("TOPLEFT", 12, -112)
  frame.assignments:SetText("MARK ASSIGNMENTS")
  frame.assignments:SetTextColor(0.92, 0.72, 0.26)

  frame.rows = {}
  for index = 1, 8 do
    local row = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row:SetPoint("TOPLEFT", 16, -130 - (index - 1) * 22)
    row:SetPoint("RIGHT", -12, 0)
    row:SetJustifyH("LEFT")
    frame.rows[index] = row
  end

  frame.empty = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  frame.empty:SetPoint("TOPLEFT", 16, -132)
  frame.empty:SetText("No marks assigned")

  frame.clear = CreateFrame("Button", nil, frame, "BackdropTemplate")
  frame.clear:SetSize(284, 26)
  frame.clear:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 9,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
  frame.clear:SetBackdropColor(0.035, 0.025, 0.02, 0.96)
  frame.clear:SetBackdropBorderColor(0.5, 0.36, 0.12, 0.85)
  frame.clear.background = frame.clear:CreateTexture(nil, "ARTWORK")
  frame.clear.background:SetPoint("TOPLEFT", 3, -3)
  frame.clear.background:SetPoint("BOTTOMRIGHT", -3, 3)
  frame.clear.background:SetColorTexture(0.09, 0.055, 0.045, 0.95)
  frame.clear.highlight = frame.clear:CreateTexture(nil, "HIGHLIGHT")
  frame.clear.highlight:SetPoint("TOPLEFT", 3, -3)
  frame.clear.highlight:SetPoint("BOTTOMRIGHT", -3, 3)
  frame.clear.highlight:SetColorTexture(0.65, 0.15, 0.06, 0.25)
  frame.clear:SetHighlightTexture(frame.clear.highlight)
  frame.clear.pushed = frame.clear:CreateTexture(nil, "ARTWORK")
  frame.clear.pushed:SetPoint("TOPLEFT", 2, -2)
  frame.clear.pushed:SetPoint("BOTTOMRIGHT", -2, 2)
  frame.clear.pushed:SetColorTexture(1, 0.22, 0.06, 0.42)
  frame.clear:SetPushedTexture(frame.clear.pushed)
  frame.clear.label = frame.clear:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.clear.label:SetAllPoints()
  frame.clear.label:SetText("CLEAR MARKS")
  frame.clear.label:SetTextColor(0.85, 0.67, 0.35)
  frame.clear:SetScript("OnEnter", function()
    frame.clear.background:SetColorTexture(0.24, 0.07, 0.045, 1)
    frame.clear.label:SetTextColor(1, 0.78, 0.35)
  end)
  frame.clear:SetScript("OnLeave", function()
    frame.clear.background:SetColorTexture(0.09, 0.055, 0.045, 0.95)
    frame.clear.label:SetTextColor(0.85, 0.67, 0.35)
  end)
  frame.clear:SetScript("OnClick", function()
    if ART.LiveMarks then ART.LiveMarks:ClearWorldMarks() end
  end)

  frame.bodyAlpha, frame.progressWidth = 1, 0
  frame.updateAnimations = function(self, elapsed)
    local resize = self.resizeAnimation
    if resize then
      resize.elapsed = resize.elapsed + elapsed
      local progress = math.min(resize.elapsed / 0.24, 1)
      local eased = progress * progress * (3 - 2 * progress)
      self:SetHeight(resize.startHeight + (resize.targetHeight - resize.startHeight) * eased)
      setBodyAlpha(self, resize.startAlpha + (resize.targetAlpha - resize.startAlpha) * eased)
      if progress == 1 then
        self.resizeAnimation = nil
        if not self.expanded then showBody(self, false) end
      end
    end

    local fill = self.progressAnimation
    if fill then
      fill.elapsed = fill.elapsed + elapsed
      local progress = math.min(fill.elapsed / 0.45, 1)
      local eased = 1 - (1 - progress) * (1 - progress) * (1 - progress)
      self.progressWidth = fill.startWidth + (fill.targetWidth - fill.startWidth) * eased
      self.progress:SetWidth(math.max(0.001, self.progressWidth))
      if progress == 1 then self.progressAnimation = nil end
    end
    if not self.resizeAnimation and not self.progressAnimation then self:SetScript("OnUpdate", nil) end
  end
  frame.AnimateResize = function(self, targetHeight, targetAlpha)
    self.resizeAnimation = {
      elapsed = 0, startHeight = self:GetHeight(), targetHeight = targetHeight,
      startAlpha = self.bodyAlpha, targetAlpha = targetAlpha,
    }
    self:SetScript("OnUpdate", self.updateAnimations)
  end
  frame.AnimateProgress = function(self, targetWidth)
    self.progressAnimation = {
      elapsed = 0, startWidth = self.progressWidth, targetWidth = targetWidth,
    }
    self:SetScript("OnUpdate", self.updateAnimations)
  end

  tracker = frame
  return frame
end

function RaidMarksUI:RefreshPullTracker()
  local model = self:GetPullTrackerModel()
  if not model then if tracker then tracker:Hide() end return end
  if not ART.LiveMarks then return model end
  local frame = createTracker()
  if not frame then return end
  frame.model = model
  frame.title:SetText(model.raidName)
  frame.currentLabel:SetText(model.currentLabel)
  frame.current:SetText(model.currentText)
  frame.next:SetShown(model.showNext)
  frame.next.label:SetText(model.nextText)
  if model.nextPullIndex then
    frame.next:Enable()
    frame.next.background:SetColorTexture(0.08, 0.11, 0.16, 0.95)
    frame.next.label:SetTextColor(1, 0.82, 0.18)
  else
    frame.next:Disable()
    frame.next.background:SetColorTexture(0.045, 0.05, 0.06, 0.9)
    frame.next.label:SetTextColor(0.45, 0.45, 0.45)
  end
  frame:AnimateProgress(270 * math.min(model.pullIndex / math.max(1, model.totalPulls), 1))
  for index, row in ipairs(frame.rows) do
    local mark = model.marks[index]
    row.used = mark ~= nil
    if mark then
      row:SetText(("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:16:16:0:0|t  %s")
          :format(mark.marker, mark.name))
    end
  end
  frame.clear:ClearAllPoints()
  frame.clear:SetPoint("TOPLEFT", 8, -140 - math.max(1, #model.marks) * 22)
  setExpanded(frame, frame.expanded ~= false, false)
  frame:Show()
  return model
end

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
  if unitToken ~= "mouseover" then return false, "mouseover-only" end
  if not ART.LiveMarks then return false, "not-initialized" end
  return ART.LiveMarks:TryMouseover()
end
