local _, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local L = ART.L
local ARTcommsObject = ART.commsObject
local AceGUI = LibStub("AceGUI-3.0")

local versionCheckPrefix = ART.versionCheckPrefix
local versionCheckRequest = "R"
local versionCheckResponsePrefix = "V"
local changeLogRequestPrefix = "C"
local changeLogHeaderPrefix = "H"
local changeLogNotePrefix = "N"
local versionCheckCooldown = 300
local currentVersion = ART.Compat:GetAddOnMetadata(ART.AddonName, "Version") or "0"
local latestVersion = currentVersion
local lastVersionRequestAt = -versionCheckCooldown

local versionColors = {
  current = { 1, 1, 1, 1 },
  patch = { 1, 0.82, 0, 1 },
  majorMinor = { 1, 0.1, 0.1, 1 },
}

local changeLog = ART.changeLog or {}
local incomingChangeLogs = {}
local reportedVersions = {}
local remoteChangeLog
local buildChangeLogText
local buildPlayerVersionsText

local function getFullName(unit)
  local name, realm = UnitFullName(unit)
  if not name then return nil end
  if not realm or string.len(realm) < 3 then
    local _, playerRealm = UnitFullName("player")
    realm = playerRealm
  end
  if realm and string.len(realm) > 0 then
    return name.."-"..realm
  end
  return name
end

local function forEachPartyMember(callback)
  for i = 1, GetNumSubgroupMembers() do
    callback(getFullName("party"..i))
  end
end

local function sendVersionCheckComm(message)
  ARTcommsObject:SendCommMessage(versionCheckPrefix, message, "PARTY", nil, "ALERT")
end

local function parseVersion(version)
  local parts = {}
  for part in version:gmatch("%d+") do
    parts[#parts + 1] = tonumber(part)
  end
  return parts
end

local function compareVersions(a, b)
  a = parseVersion(a)
  b = parseVersion(b)
  for i = 1, 4 do
    if (a[i] or 0) ~= (b[i] or 0) then
      return (a[i] or 0) > (b[i] or 0)
    end
  end
  return false
end

local function getOutdatedType()
  if not compareVersions(latestVersion, currentVersion) then return nil end

  local currentParts = parseVersion(currentVersion)
  local latestParts = parseVersion(latestVersion)
  if (latestParts[1] or 0) > (currentParts[1] or 0) or (latestParts[2] or 0) > (currentParts[2] or 0) then
    return "majorMinor"
  end

  return "patch"
end

local function recordVersion(version, sender)
  if not version or version == "" then return end
  if sender then
    reportedVersions[sender] = version
  end
  if compareVersions(version, latestVersion) then
    latestVersion = version
  end
  ART:UpdateVersionCheckDisplay()
  ART:UpdatePlayerVersionsDisplay()
end

function ART:RequestVersionCheck(force)
  local now = GetTime()
  if not force and now - lastVersionRequestAt < versionCheckCooldown then
    ART:UpdateVersionCheckDisplay()
    ART:UpdatePlayerVersionsDisplay()
    return false
  end

  lastVersionRequestAt = now
  sendVersionCheckComm(versionCheckRequest)
  return true
end

function ART:UpdateVersionCheckDisplay()
  local outdatedType = getOutdatedType()
  local bottomText = " v"..currentVersion
  local bottomColor = versionColors.current

  if outdatedType then
    bottomText = bottomText.." "..L["update available"]
    bottomColor = versionColors[outdatedType]
  end

  local versionText = ART.main_frame and ART.main_frame.bottomLeftPanelString
  if versionText then
    versionText:SetText(bottomText)
    versionText:SetTextColor(unpack(bottomColor))
    if versionText.clickArea then
      versionText.clickArea:SetWidth(math.max(50, versionText:GetStringWidth() + 8))
    end
  end

end

local function updateVersionCheckScrollText(f, text)
  if not f or not f.changeLogTextBox then return end

  f.changeLogTextBox:SetText(text)
  local contentHeight = math.max(f.scrollHeight, f.changeLogTextBox:GetStringHeight() + (f.textPadding * 2))
  f.changeLogContentFrame:SetHeight(contentHeight)
  f.sliderHeight = math.max(1, contentHeight - f.scrollHeight)
  f.slider:SetMinMaxValues(0, f.sliderHeight)
  local sliderValue = math.min(f.slider:GetValue(), f.sliderHeight)
  f.slider:SetValue(sliderValue)
end

function ART:UpdateChangeLogDisplay()
  local f = ART.versionCheckFrame
  if not f or not f.changeLogTextBox then return end
  if f.activeTab and f.activeTab ~= "changelog" then return end

  updateVersionCheckScrollText(f, buildChangeLogText())
end

function ART:UpdatePlayerVersionsDisplay()
  local f = ART.versionCheckFrame
  if not f or not f.changeLogTextBox then return end
  if f.activeTab ~= "versions" then return end

  updateVersionCheckScrollText(f, buildPlayerVersionsText())
end

function ART:VersionCheck_OnCommReceived(message, distribution, sender)
  if distribution ~= "PARTY" then return end

  if message == versionCheckRequest then
    lastVersionRequestAt = GetTime()
    sendVersionCheckComm(versionCheckResponsePrefix..currentVersion)
    return
  end

  if message:sub(1, 1) == changeLogRequestPrefix then
    local requestedVersion = message:sub(2)
    local entry = changeLog[1]
    if entry.tag == requestedVersion then
      sendVersionCheckComm(changeLogHeaderPrefix..entry.tag.."\t"..entry.date.."\t"..#entry.notes)
      for i, note in ipairs(entry.notes) do
        sendVersionCheckComm(changeLogNotePrefix..entry.tag.."\t"..i.."\t"..note)
      end
    end
    return
  end

  if message:sub(1, 1) == changeLogHeaderPrefix then
    local version, date, noteCount = message:match("^"..changeLogHeaderPrefix.."([^\t]+)\t([^\t]+)\t(%d+)$")
    incomingChangeLogs[version] = {
      tag = version,
      date = date,
      noteCount = tonumber(noteCount),
      notes = {},
    }
    return
  end

  if message:sub(1, 1) == changeLogNotePrefix then
    local version, noteIndex, note = message:match("^"..changeLogNotePrefix.."([^\t]+)\t(%d+)\t(.+)$")
    local entry = incomingChangeLogs[version]
    entry.notes[tonumber(noteIndex)] = note

    local noteCount = 0
    for _ in pairs(entry.notes) do
      noteCount = noteCount + 1
    end
    if noteCount == entry.noteCount then
      remoteChangeLog = entry
      ART:UpdateChangeLogDisplay()
    end
    return
  end

  if message:sub(1, 1) == versionCheckResponsePrefix then
    recordVersion(message:sub(2), sender)
  end
end

buildChangeLogText = function()
  local displayChangeLog = {}
  if remoteChangeLog then
    displayChangeLog[#displayChangeLog + 1] = remoteChangeLog
  end
  for _, entry in ipairs(changeLog) do
    if not remoteChangeLog or entry.tag ~= remoteChangeLog.tag then
      displayChangeLog[#displayChangeLog + 1] = entry
    end
  end

  if #displayChangeLog == 0 then
    return L["No changelog entries available."]
  end

  local text = ""
  for _, entry in ipairs(displayChangeLog) do
    text = text.."v"..entry.tag.." ("..entry.date..")\n"
    for _, note in ipairs(entry.notes) do
      text = text.."  - "..note.."\n"
    end
    text = text.."\n"
  end

  return text
end

local function hasMissingPlayerVersionData()
  local missing = false
  forEachPartyMember(function(memberName)
    if memberName and not reportedVersions[memberName] then missing = true end
  end)

  return missing
end

local function requestMissingPlayerVersions()
  if hasMissingPlayerVersionData() then
    ART:RequestVersionCheck(true)
  end
end

local function reportPlayerVersionsToParty()
  ART.Compat:SendChatMessage("ART Version Check:", "PARTY")
  ART.Compat:SendChatMessage(getFullName("player")..": v"..currentVersion, "PARTY")
  forEachPartyMember(function(memberName)
    local version = reportedVersions[memberName]
    if version then
      ART.Compat:SendChatMessage(memberName..": v"..version, "PARTY")
    end
  end)
end

buildPlayerVersionsText = function()
  local lines = {
    getFullName("player")..": v"..currentVersion,
  }
  forEachPartyMember(function(memberName)
    local version = reportedVersions[memberName]
    if version then
      lines[#lines + 1] = memberName..": v"..version
    end
  end)

  return table.concat(lines, "\n")
end

local function setActiveVersionCheckTab(f, tab)
  f.activeTab = tab
  f.changeLogTab:SetDisabled(tab == "changelog")
  f.versionsTab:SetDisabled(tab == "versions")
  if tab == "versions" then
    f.reportVersionsButton.frame:Show()
    requestMissingPlayerVersions()
    ART:UpdatePlayerVersionsDisplay()
  else
    f.reportVersionsButton.frame:Hide()
    ART:UpdateChangeLogDisplay()
  end
  ART:UpdateVersionCheckDisplay()
end

local function createVersionCheckTabButton(parent, tab, text, tabIndex)
  local width = parent:GetWidth() / 3
  local xOffset = 10 + ((tabIndex - 1) * width)
  local button = AceGUI:Create("Button")
  button.frame:SetParent(parent)
  button:SetWidth(width)
  button:SetHeight(22)
  button.frame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, -31)
  button.frame:Show()
  button:SetText(text)
  button:SetCallback("OnClick", function()
    setActiveVersionCheckTab(parent, tab)
  end)

  return button
end

local function createVersionCheckFrame()
  local width, height = 500, 300
  local titleText = L["Version Check / Change Log"]

  local f = CreateFrame("frame", "ART_VersionCheckFrame", ART.main_frame, "BackdropTemplate")
  f:SetSize(width, height)
  f:ClearAllPoints()
  f:SetPoint("BOTTOMLEFT", ART.main_frame, "BOTTOMLEFT", 0, 0)
  f:SetFrameStrata("HIGH")
  f:SetFrameLevel(50)
  f:EnableMouse(true)
  f.bgTex = f:CreateTexture(nil, "BACKGROUND", nil, 0)
  f.bgTex:SetAllPoints()
  f.bgTex:SetDrawLayer("BORDER", -5)
  f.bgTex:SetColorTexture(unpack(ART.BackdropColor))
  f:Hide()

  ART.main_frame:HookScript("OnHide", function()
    f:Hide()
  end)

  local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("TOP", f, "TOP", 0, -5)
  title:SetText(titleText)
  --bigger font size
  title:SetFontObject("GameFontNormal")
  ---@diagnostic disable-next-line: param-type-mismatch
  title:SetFont(title:GetFont(), 12);
  title:SetTextColor(1, 1, 1)

  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
  close:SetScript("OnClick", function()
    f:Hide()
    ART.copyHelper:SmartHide()
  end)

  f.changeLogTab = createVersionCheckTabButton(f, "changelog", L["Change Log"], 1)
  f.versionsTab = createVersionCheckTabButton(f, "versions", L["Party Versions"], 2)
  f.activeTab = "changelog"

  local scrollFrame = CreateFrame("scrollframe", nil, f, "BackdropTemplate")
  scrollFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -62)
  local scrollWidth = width - 46
  local scrollHeight = height - 127
  scrollFrame:SetSize(scrollWidth, scrollHeight)

  local contentFrame = CreateFrame("frame", nil, scrollFrame, "BackdropTemplate")
  contentFrame:SetWidth(scrollWidth)
  contentFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    tile = true,
    tileSize = 16,
    insets = { left = 1, right = 1, top = 0, bottom = 1 },
  })
  contentFrame:SetBackdropColor(0.267, 0.267, 0.267, 1)

  --text box
  local textPadding = 6
  local textBox = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  textBox:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", textPadding, -textPadding)
  textBox:SetPoint("BOTTOMRIGHT", contentFrame, "BOTTOMRIGHT", -textPadding, textPadding)
  textBox:SetJustifyH("LEFT")
  textBox:SetJustifyV("TOP")
  textBox:SetTextColor(1, 1, 1)
  textBox:SetWidth(scrollWidth - (textPadding * 2))

  textBox:SetText(buildChangeLogText())
  local contentHeight = math.max(scrollHeight, textBox:GetStringHeight() + (textPadding * 2))
  contentFrame:SetSize(scrollWidth, contentHeight)
  -- this is the trick
  local sliderHeight = math.max(1, contentHeight - scrollHeight)

  ---@diagnostic disable-next-line: param-type-mismatch
  scrollFrame:SetScrollChild(contentFrame)

  local slider = CreateFrame("slider", nil, f, "BackdropTemplate")
  slider:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    tile = true,
    tileSize = 16,
    insets = { left = 1, right = 1, top = 0, bottom = 1 },
  })
  slider:SetBackdropColor(.4, .4, .4, .7)

  slider.thumb = slider:CreateTexture(nil, "OVERLAY")
  slider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
  slider.thumb:SetSize(25, 25)

  slider:SetThumbTexture(slider.thumb)
  slider:SetOrientation("VERTICAL");
  slider:SetSize(16, scrollHeight + 1)
  slider:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT")
  slider:SetMinMaxValues(0, sliderHeight)
  slider:SetValueStep(1)
  slider:SetValue(0)
  f.sliderHeight = sliderHeight
  slider:SetScript("OnValueChanged", function(self)
    scrollFrame:SetVerticalScroll(self:GetValue())
  end)

  scrollFrame:EnableMouseWheel(true)
  scrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local current = slider:GetValue()
    local sliderHeight = f.sliderHeight
    if (IsShiftKeyDown() and (delta > 0)) then
      slider:SetValue(0)
    elseif (IsShiftKeyDown() and (delta < 0)) then
      slider:SetValue(sliderHeight)
    elseif ((delta < 0) and (current < sliderHeight)) then
      slider:SetValue(current + 20)
    elseif ((delta > 0) and (current > 0)) then
      slider:SetValue(current - 20)
    end
  end)

  local reportVersionsButton = AceGUI:Create("Button")
  reportVersionsButton.frame:SetParent(f)
  reportVersionsButton:SetWidth(230)
  reportVersionsButton:SetHeight(22)
  reportVersionsButton.frame:SetPoint("TOPLEFT", scrollFrame, "BOTTOMLEFT", 0, -8)
  reportVersionsButton:SetText(L["Send versions to party chat"])
  reportVersionsButton:SetCallback("OnClick", reportPlayerVersionsToParty)
  reportVersionsButton.frame:Hide()

  f.reportVersionsButton = reportVersionsButton
  f.changeLogTextBox = textBox
  f.changeLogContentFrame = contentFrame
  f.scrollHeight = scrollHeight
  f.textPadding = textPadding
  f.slider = slider
  setActiveVersionCheckTab(f, f.activeTab)

  return f
end

function ART:ToggleVersionCheckFrame()
  if not ART.versionCheckFrame then
    ART.versionCheckFrame = createVersionCheckFrame()
  end
  if ART.versionCheckFrame:IsShown() then
    ART.versionCheckFrame:Hide()
    ART.copyHelper:SmartHide()
  else
    ART:HideAllDialogs()
    ART.copyHelper:SmartHide()
    ART:UpdateVersionCheckDisplay()
    if getOutdatedType() and (not remoteChangeLog or remoteChangeLog.tag ~= latestVersion) then
      sendVersionCheckComm(changeLogRequestPrefix..latestVersion)
    end
    if ART.versionCheckFrame.activeTab == "versions" then
      requestMissingPlayerVersions()
      ART:UpdatePlayerVersionsDisplay()
    else
      ART:UpdateChangeLogDisplay()
    end
    ART.versionCheckFrame:Show()
  end
end
