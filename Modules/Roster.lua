local _, ART = ...
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only

local Roster = ART.Roster or {}
ART.Roster = Roster

local VALID_CLASSES = {
  WARRIOR = true, PALADIN = true, HUNTER = true, ROGUE = true, PRIEST = true,
  SHAMAN = true, MAGE = true, WARLOCK = true, DRUID = true,
}
local CLASS_ORDER = { "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "SHAMAN", "MAGE", "WARLOCK", "DRUID" }
local MARKER_ORDER = { 8, 7, 1, 5, 6, 3, 4, 2 }

local function canonicalName(value)
  if type(value) ~= "string" then return end
  local name = value:match("^%s*(.-)%s*$")
  if name == "" then return end
  if not name:find("-", 1, true) and type(UnitFullName) == "function" then
    local resolved, realm = UnitFullName(name)
    if not realm or realm == "" then _, realm = UnitFullName("player") end
    name = (resolved or name)..(realm and realm ~= "" and "-"..realm or "")
  end
  return name
end

local function playerCopy(player)
  local name = type(player) == "table" and canonicalName(player.name)
  if type(player) ~= "table" or type(player.name) ~= "string" or player.name == ""
      or not name or #name > 80 or not VALID_CLASSES[player.classFile] then return end
  local copy = { name = name, classFile = player.classFile }
  local definition = player.ccKey and ART.CCAssignments and ART.CCAssignments.catalog
      and ART.CCAssignments.catalog[player.ccKey]
  if definition and definition.classFile == player.classFile then copy.ccKey = player.ccKey end
  return copy
end

local function validMarker(marker)
  marker = tonumber(marker)
  return marker and marker >= 1 and marker <= 8 and marker % 1 == 0 and marker or nil
end

function Roster:RefreshMarks(preset)
  if preset ~= (ART.GetCurrentPreset and ART:GetCurrentPreset()) then return end
  if ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged()
  elseif ART.RaidMarksUI and ART.RaidMarksUI.RefreshPullTracker then ART.RaidMarksUI:RefreshPullTracker() end
end

function Roster:SendChange(preset, operation, marker, player)
  if not ART.liveSessionActive or not ART.LiveSession_CanControlProgress
      or not ART:LiveSession_CanControlProgress() or not preset or preset.uid ~= ART.livePresetUID
      or not ART.IsPlayerInGroup or ART:IsPlayerInGroup() ~= "RAID" then return false end
  local raid = ART.RaidPlanner and ART.RaidPlanner.raid
  if not raid or not ART.commsObject or not ART.liveSessionPrefixes.playerMark then return false end
  ART.commsObject:SendCommMessage(ART.liveSessionPrefixes.playerMark, ART:TableToString({
    version = 1, raidKey = raid.key, raidIndex = preset.value.currentRaidIndex,
    presetUID = preset.uid, operation = operation, marker = marker, player = player,
  }), "RAID", nil, "ALERT")
  return true
end

function Roster:GetSlots()
  local db = ART.GetDB and ART:GetDB()
  if not db then return {} end
  db.roster = type(db.roster) == "table" and db.roster or {}
  db.roster.slots = type(db.roster.slots) == "table" and db.roster.slots or {}
  return db.roster.slots
end

function Roster:SetSlot(index, player)
  index = tonumber(index)
  player = playerCopy(player)
  if not index or index < 1 or index > 40 or index % 1 ~= 0 or not player then return false end
  local slots = self:GetSlots()
  for otherIndex, other in pairs(slots) do
    if otherIndex ~= index and type(other) == "table" and type(other.name) == "string"
        and other.name:lower() == player.name:lower() then slots[otherIndex] = nil end
  end
  slots[index] = player
  return player
end

function Roster:ClearSlot(index)
  index = tonumber(index)
  local slots = self:GetSlots()
  if not index or index < 1 or index > 40 or not slots[index] then return false end
  slots[index] = nil
  return true
end

function Roster:SwapSlots(left, right)
  left, right = tonumber(left), tonumber(right)
  if not left or not right or left < 1 or left > 40 or right < 1 or right > 40 then return false end
  local slots = self:GetSlots()
  slots[left], slots[right] = slots[right], slots[left]
  return true
end

function Roster:GetPlayers(includeGroup)
  local result, byName = {}, {}
  local function add(player)
    player = playerCopy(player)
    if not player then return end
    local key = player.name:lower()
    local current = byName[key]
    if current then
      for field, value in pairs(player) do current[field] = value end
      return
    end
    player.displayName = player.name:match("^[^-]+") or player.name
    result[#result + 1], byName[key] = player, player
  end
  for _, player in pairs(self:GetSlots()) do add(player) end
  if includeGroup then
    local units = {}
    if type(IsInRaid) == "function" and IsInRaid() then
      for index = 1, (GetNumGroupMembers and GetNumGroupMembers() or 0) do units[#units + 1] = "raid"..index end
    elseif type(IsInGroup) == "function" and IsInGroup() then
      units[1] = "player"
      for index = 1, (GetNumSubgroupMembers and GetNumSubgroupMembers() or 0) do units[#units + 1] = "party"..index end
    end
    for _, unit in ipairs(units) do
      local name = canonicalName(unit)
      local classFile
      if type(UnitClass) == "function" then _, classFile = UnitClass(unit) end
      if name and classFile then
        add({ name = name, classFile = classFile, unit = unit,
          online = type(UnitIsConnected) ~= "function" or UnitIsConnected(unit) ~= false })
        local player = byName[name:lower()]
        player.unit = unit
        player.online = type(UnitIsConnected) ~= "function" or UnitIsConnected(unit) ~= false
      end
    end
  end
  for _, player in ipairs(result) do if player.online == nil then player.online = false end end
  table.sort(result, function(left, right) return left.name < right.name end)
  return result
end

function Roster:LoadCurrentRaid()
  if not (type(IsInRaid) == "function" and IsInRaid()) then return false end
  local nextInGroup, loaded = {}, {}
  for index = 1, (GetNumGroupMembers and GetNumGroupMembers() or 0) do
    local name, _, subgroup = GetRaidRosterInfo(index)
    local _, classFile = UnitClass("raid"..index)
    subgroup = tonumber(subgroup)
    local player = playerCopy({ name = name, classFile = classFile })
    if player and subgroup and subgroup >= 1 and subgroup <= 8 then
      nextInGroup[subgroup] = (nextInGroup[subgroup] or 0) + 1
      local position = nextInGroup[subgroup]
      if position <= 5 then loaded[(subgroup - 1) * 5 + position] = player end
    end
  end
  local slots = self:GetSlots()
  for index = 1, 40 do slots[index] = loaded[index] end
  return true
end

function Roster:GetPlayerMark(preset, marker)
  marker = validMarker(marker)
  local marks = preset and preset.value and preset.value.artCCMarks
  return playerCopy(marker and marks and marks[marker])
end

function Roster:SetPlayerMark(preset, marker, player, silent)
  marker, player = validMarker(marker), playerCopy(player)
  if not marker or not player or not preset or type(preset.value) ~= "table" then return false end
  local marks = type(preset.value.artCCMarks) == "table" and preset.value.artCCMarks or {}
  for otherMarker, other in pairs(marks) do
    if otherMarker ~= marker and type(other) == "table" and type(other.name) == "string"
        and other.name:lower() == player.name:lower() then marks[otherMarker] = nil end
  end
  marks[marker] = player
  preset.value.artCCMarks = marks
  if not silent then self:SendChange(preset, "set", marker, player) end
  self:RefreshMarks(preset)
  return player
end

function Roster:ClearPlayerMark(preset, marker, silent)
  marker = validMarker(marker)
  local marks = preset and preset.value and preset.value.artCCMarks
  if not marker or type(marks) ~= "table" or not marks[marker] then return false end
  marks[marker] = nil
  if not next(marks) then preset.value.artCCMarks = nil end
  if not silent then self:SendChange(preset, "clear", marker) end
  self:RefreshMarks(preset)
  return true
end

function Roster:SetPlayerCC(preset, marker, ccKey, silent)
  local player = self:GetPlayerMark(preset, marker)
  local definition = ccKey and ART.CCAssignments and ART.CCAssignments.catalog
      and ART.CCAssignments.catalog[ccKey]
  if not player or not definition or definition.classFile ~= player.classFile then return false end
  player.ccKey = ccKey
  return self:SetPlayerMark(preset, marker, player, silent)
end

function Roster:ClearPlayerCC(preset, marker, silent)
  local player = self:GetPlayerMark(preset, marker)
  if not player or not player.ccKey then return false end
  player.ccKey = nil
  return self:SetPlayerMark(preset, marker, player, silent)
end

function Roster:NormalizePreset(preset)
  local value = preset and preset.value
  if type(value) ~= "table" then return false end
  if value.artCCMarks == nil and type(value.artPlayerMarks) == "table" then
    value.artCCMarks, value.artPlayerMarks = value.artPlayerMarks, nil
  end
  local normalized, seen = {}, {}
  local marks = type(value.artCCMarks) == "table" and value.artCCMarks or {}
  for _, marker in ipairs(MARKER_ORDER) do
    local player = playerCopy(marks[marker])
    if marker and player and not seen[player.name:lower()] then
      normalized[marker], seen[player.name:lower()] = player, true
    end
  end
  value.artCCMarks = next(normalized) and normalized or nil
  return true
end

function Roster:ReceiveChange(message, distribution, sender)
  if not ART.liveSessionActive or distribution ~= "RAID" or not ART.LiveSession_CanControlProgress
      or not ART:LiveSession_CanControlProgress(sender) then return false end
  local payload = type(message) == "table" and message or ART:StringToTable(message, false)
  local preset = ART:GetCurrentLivePreset()
  local raid = ART.RaidPlanner and ART.RaidPlanner.raid
  if type(payload) ~= "table" or payload.version ~= 1 or type(payload.raidKey) ~= "string"
      or type(payload.raidIndex) ~= "number" or type(payload.presetUID) ~= "string"
      or not validMarker(payload.marker) or not preset or preset.uid ~= payload.presetUID
      or not preset.value or preset.value.currentRaidIndex ~= payload.raidIndex
      or not raid or raid.key ~= payload.raidKey then return false end
  if payload.operation == "clear" then
    return self:ClearPlayerMark(preset, payload.marker, true) == true
  elseif payload.operation == "set" and playerCopy(payload.player) then
    return self:SetPlayerMark(preset, payload.marker, payload.player, true) ~= false
  end
  return false
end

function Roster:RefreshGuildPlayers()
  local players = {}
  if type(GetNumGuildMembers) == "function" and type(GetGuildRosterInfo) == "function" then
    for index = 1, GetNumGuildMembers() do
      local name, _, _, _, _, _, _, _, _, _, classFile = GetGuildRosterInfo(index)
      local player = playerCopy({ name = name, classFile = classFile })
      if player then players[#players + 1] = player end
    end
  end
  table.sort(players, function(left, right) return left.name < right.name end)
  self.guildPlayers = players
  return players
end

function Roster:GetAutocompletePlayers()
  local players, seen = {}, {}
  local function add(player)
    local copy = playerCopy(player)
    if not copy or seen[copy.name:lower()] then return end
    copy.unit, copy.online = player.unit, player.online
    players[#players + 1], seen[copy.name:lower()] = copy, true
  end
  for _, player in ipairs(self:GetPlayers(true)) do add(player) end
  for _, player in ipairs(self.guildPlayers or {}) do add(player) end
  table.sort(players, function(left, right)
    local leftRaid, rightRaid = left.unit ~= nil, right.unit ~= nil
    if leftRaid ~= rightRaid then return leftRaid end
    return left.name:lower() < right.name:lower()
  end)
  return players
end

local function classColor(classFile)
  local color = RAID_CLASS_COLORS and RAID_CLASS_COLORS[classFile]
  return color and color.r or 0.8, color and color.g or 0.8, color and color.b or 0.8
end

local function colorCode(classFile)
  local r, g, b = classColor(classFile)
  return ("|cff%02x%02x%02x"):format(
    math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
end

local CLASS_ICON_TEXTURE = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"
local BUTTON_TEXTURE = "Interface\\Buttons\\UI-Panel-Button-Up"

local function className(classFile)
  return classFile:sub(1, 1)..classFile:sub(2):lower()
end

local function classIconMarkup(classFile)
  local coords = CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[classFile]
  if not coords then return "" end
  return ("|T%s:16:16:0:0:256:256:%d:%d:%d:%d|t "):format(CLASS_ICON_TEXTURE,
    math.floor(coords[1] * 256), math.floor(coords[2] * 256),
    math.floor(coords[3] * 256), math.floor(coords[4] * 256))
end

function Roster:HideSuggestions()
  if self.suggestions then self.suggestions:Hide() end
end

function Roster:CommitEdit(edit)
  if not edit or self.refreshing then return end
  local text = edit:GetText():match("^%s*(.-)%s*$")
  if text == "" then
    self:ClearSlot(edit.slotIndex)
    edit.pendingClass, edit.pendingPlayer = nil, nil
    self:RefreshUI()
    return
  end
  local selected = edit.pendingPlayer
  if not selected then
    local wanted = text:lower()
    for _, player in ipairs(self:GetAutocompletePlayers()) do
      local displayName = player.name:match("^[^-]+") or player.name
      if player.name:lower() == wanted or displayName:lower() == wanted then
        selected = player
        break
      end
    end
  end
  local current = self:GetSlots()[edit.slotIndex]
  local classFile = selected and selected.classFile or edit.pendingClass
      or current and (current.name:match("^[^-]+") or current.name):lower() == text:lower()
          and current.classFile
  if not classFile then
    edit:SetTextColor(1, 0.3, 0.3)
    return false
  end
  local player = self:SetSlot(edit.slotIndex, selected or { name = text, classFile = classFile })
  if player then
    edit.pendingClass, edit.pendingPlayer = nil, nil
    self:RefreshUI()
    return player
  end
  edit:SetTextColor(1, 0.3, 0.3)
  return false
end

function Roster:ShowSuggestions(edit)
  local query = edit and edit:GetText():lower() or ""
  if query == "" or not self.suggestions then return self:HideSuggestions() end
  local matches = {}
  for _, player in ipairs(self:GetAutocompletePlayers()) do
    local displayName = player.name:match("^[^-]+") or player.name
    if displayName:lower():find(query, 1, true) or player.name:lower():find(query, 1, true) then
      matches[#matches + 1] = player
    end
    if #matches == 8 then break end
  end
  if #matches == 0 then return self:HideSuggestions() end
  local popup = self.suggestions
  popup:ClearAllPoints()
  popup:SetPoint("TOPLEFT", edit, "BOTTOMLEFT", 0, -2)
  popup:SetFrameLevel(edit:GetFrameLevel() + 20)
  popup:SetHeight(#matches * 20 + 4)
  for index, button in ipairs(popup.buttons) do
    local player = matches[index]
    button:SetShown(player ~= nil)
    if player then
      button.player = player
      button.text:SetText(player.name:match("^[^-]+") or player.name)
      button.text:SetTextColor(classColor(player.classFile))
    end
  end
  popup.owner = edit
  popup:Show()
end

function Roster:OpenClassMenu(edit)
  if not ART.CreateContextMenu then return end
  ART:CreateContextMenu(edit.classButton, function(_, root)
    root:CreateTitle("Class")
    for _, classFile in ipairs(CLASS_ORDER) do
      local selectedClass = classFile
      root:CreateButton(classIconMarkup(selectedClass)
          ..colorCode(selectedClass)..className(selectedClass).."|r", function()
        edit.pendingClass = selectedClass
        self:CommitEdit(edit)
      end)
    end
  end)
end

function Roster:OpenMarkMenu(marker, button)
  if not ART.CreateContextMenu then return end
  ART:CreateContextMenu(button, function(_, root)
    root:CreateTitle(("Player for |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:16:16|t"):format(marker))
    local preset = ART:GetCurrentPreset()
    if self:GetPlayerMark(preset, marker) then
      root:CreateButton("Clear assignment", function()
        if self:ClearPlayerMark(preset, marker) then self:RefreshUI() end
      end)
      root:CreateDivider()
    end
    for _, player in ipairs(self:GetPlayers(false)) do
      root:CreateButton(colorCode(player.classFile)..player.displayName.."|r", function()
        if self:SetPlayerMark(preset, marker, player) then self:RefreshUI() end
      end)
    end
  end)
end

function Roster:OpenPlayerCCMenu(marker, button)
  if not ART.CreateContextMenu then return end
  local preset = ART:GetCurrentPreset()
  local player = self:GetPlayerMark(preset, marker)
  if not player then return end
  ART:CreateContextMenu(button, function(_, root)
    root:CreateTitle("Crowd control for "..(player.name:match("^[^-]+") or player.name))
    if player.ccKey then
      root:CreateButton("Clear CC", function()
        if self:ClearPlayerCC(preset, marker) then self:RefreshUI() end
      end)
      root:CreateDivider()
    end
    local any = false
    local cc = ART.CCAssignments
    for _, ccKey in ipairs(cc and cc.catalogOrder or {}) do
      local selectedCCKey = ccKey
      local definition = cc.catalog[selectedCCKey]
      if definition.classFile == player.classFile then
        any = true
        root:CreateButton(("|T%s:16:16:0:0|t %s"):format(definition.icon, definition.label), function()
          if self:SetPlayerCC(preset, marker, selectedCCKey) then self:RefreshUI() end
        end)
      end
    end
    if not any then root:CreateTitle("No supported CC for "..className(player.classFile)) end
  end)
end

function Roster:RefreshUI()
  local frame = self.frame
  if not frame then return end
  self.refreshing = true
  local slots = self:GetSlots()
  for index, edit in ipairs(frame.edits) do
    local player = slots[index]
    edit:SetText(player and (player.name:match("^[^-]+") or player.name) or "")
    edit:SetTextColor(classColor(player and player.classFile))
    edit.classButton:SetNormalTexture(player and CLASS_ICON_TEXTURE or BUTTON_TEXTURE)
    local texture = edit.classButton:GetNormalTexture()
    local coords = player and CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[player.classFile]
    if texture then
      if coords then texture:SetTexCoord(unpack(coords))
      else texture:SetTexCoord(0, 0.625, 0, 0.6875) end
    end
    edit.classButton:SetText(player and "" or "?")
  end
  local preset = ART.GetCurrentPreset and ART:GetCurrentPreset()
  for marker, button in pairs(frame.markButtons) do
    local player = self:GetPlayerMark(preset, marker)
    button:SetText(player and (player.name:match("^[^-]+") or player.name) or "Unassigned")
    button:GetFontString():SetTextColor(classColor(player and player.classFile))
    local ccButton = frame.ccButtons and frame.ccButtons[marker]
    if ccButton then
      local definition = player and player.ccKey and ART.CCAssignments
          and ART.CCAssignments.catalog[player.ccKey]
      ccButton:SetText(definition and ("|T%s:16:16:0:0|t"):format(definition.icon) or "CC")
      if player then ccButton:Enable() else ccButton:Disable() end
    end
  end
  self.refreshing = nil
end

function Roster:CreateUI(parent)
  if self.frame or type(CreateFrame) ~= "function" or not parent then return self.frame end
  local frame = CreateFrame("Frame", "ARTRosterFrame", parent)
  frame:SetAllPoints()
  frame.edits, frame.markButtons, frame.ccButtons = {}, {}, {}

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 28, -34)
  title:SetText("Raid Roster")
  local help = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  help:SetPoint("LEFT", title, "RIGHT", 12, 0)
  help:SetText("Guild + raid autocomplete · drag names to swap slots")

  for group = 1, 8 do
    local column, band = (group - 1) % 2, math.floor((group - 1) / 2)
    local x, y = 28 + column * 225, -76 - band * 126
    local heading = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heading:SetPoint("TOPLEFT", x, y)
    heading:SetText("Group "..group)
    for position = 1, 5 do
      local slotIndex = (group - 1) * 5 + position
      local edit = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
      edit:SetSize(174, 20)
      edit:SetPoint("TOPLEFT", x, y - 20 - (position - 1) * 20)
      edit:SetAutoFocus(false)
      edit:SetMaxLetters(80)
      edit.slotIndex = slotIndex
      edit:SetScript("OnEnterPressed", function(box) self:CommitEdit(box); box:ClearFocus() end)
      edit:SetScript("OnEscapePressed", function(box) box:ClearFocus(); self:RefreshUI() end)
      edit:SetScript("OnEditFocusLost", function(box) self:CommitEdit(box); self:HideSuggestions() end)
      edit:SetScript("OnTextChanged", function(box, user) if user then self:ShowSuggestions(box) end end)
      edit:RegisterForDrag("LeftButton")
      edit:SetScript("OnDragStart", function(box) self.dragIndex = box.slotIndex; box:SetAlpha(0.5) end)
      edit:SetScript("OnDragStop", function(box)
        box:SetAlpha(1)
        for _, target in ipairs(frame.edits) do
          if target ~= box and target:IsMouseOver() then self:SwapSlots(self.dragIndex, target.slotIndex) break end
        end
        self.dragIndex = nil
        self:RefreshUI()
      end)
      edit.classButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
      edit.classButton:SetSize(26, 20)
      edit.classButton:SetPoint("LEFT", edit, "RIGHT", 2, 0)
      edit.classButton:SetScript("OnClick", function() self:OpenClassMenu(edit) end)
      frame.edits[slotIndex] = edit
    end
  end

  local loadRaid = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  loadRaid:SetSize(180, 24)
  loadRaid:SetPoint("BOTTOMLEFT", 28, 24)
  loadRaid:SetText("Load Current Raid")
  loadRaid:SetScript("OnClick", function()
    local load = function() if self:LoadCurrentRaid() then self:RefreshUI() end end
    if next(self:GetSlots()) and ART.OpenConfirmationFrame then
      ART:OpenConfirmationFrame(430, 150, "Replace roster?", "Replace",
        "Replace the saved roster with the current raid groups?", load)
    else
      load()
    end
  end)

  local marksTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  marksTitle:SetPoint("TOPLEFT", 505, -34)
  marksTitle:SetText("CC Marks")
  local marksHelp = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  marksHelp:SetPoint("TOPLEFT", marksTitle, "BOTTOMLEFT", 0, -4)
  marksHelp:SetWidth(250)
  marksHelp:SetJustifyH("LEFT")
  marksHelp:SetText("Assign which player owns this mob marker; optional CC sets the spell for that assignee.")
  for index, marker in ipairs(MARKER_ORDER) do
    local selectedMarker = marker
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(marker))
    icon:SetSize(22, 22)
    icon:SetPoint("TOPLEFT", 505, -92 - (index - 1) * 32)
    local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    button:SetSize(142, 24)
    button:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    button:SetScript("OnClick", function() self:OpenMarkMenu(selectedMarker, button) end)
    frame.markButtons[selectedMarker] = button
    local ccButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    ccButton:SetSize(44, 24)
    ccButton:SetPoint("LEFT", button, "RIGHT", 4, 0)
    ccButton:SetScript("OnClick", function() self:OpenPlayerCCMenu(selectedMarker, ccButton) end)
    ccButton:SetScript("OnEnter", function(control)
      if not GameTooltip then return end
      local player = self:GetPlayerMark(ART:GetCurrentPreset(), selectedMarker)
      local definition = player and player.ccKey and ART.CCAssignments
          and ART.CCAssignments.catalog[player.ccKey]
      GameTooltip:SetOwner(control, "ANCHOR_RIGHT")
      GameTooltip:SetText(definition and definition.label or "Choose crowd control")
      GameTooltip:Show()
    end)
    ccButton:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    frame.ccButtons[selectedMarker] = ccButton
  end

  local popup = CreateFrame("Frame", "ARTRosterAutocomplete", frame, "BackdropTemplate")
  popup:SetSize(200, 164)
  popup:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10,
    insets = { left = 3, right = 3, top = 3, bottom = 3 } })
  popup:SetBackdropColor(0.03, 0.03, 0.03, 0.98)
  popup.buttons = {}
  for index = 1, 8 do
    local button = CreateFrame("Button", nil, popup)
    button:SetPoint("TOPLEFT", 4, -2 - (index - 1) * 20)
    button:SetPoint("RIGHT", -4, 0)
    button:SetHeight(20)
    button.text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    button.text:SetPoint("LEFT", 5, 0)
    button:SetScript("OnClick", function(item)
      local edit = popup.owner
      edit.pendingClass, edit.pendingPlayer = item.player.classFile, item.player
      edit:SetText(item.player.name:match("^[^-]+") or item.player.name)
      self:CommitEdit(edit)
      edit:ClearFocus()
      self:HideSuggestions()
    end)
    popup.buttons[index] = button
  end
  popup:Hide()
  self.suggestions, self.frame = popup, frame

  local eventFrame = CreateFrame("Frame", "ARTRosterEventFrame")
  eventFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
  eventFrame:SetScript("OnEvent", function() self:RefreshGuildPlayers() end)
  self.eventFrame = eventFrame
  self:RefreshGuildPlayers()
  self:RefreshUI()
  return frame
end

if ART.RegisterNavigationSection then
  ART:RegisterNavigationSection({
    key = "roster", name = "Roster", tooltip = "Roster",
    texture = "Interface\\AddOns\\"..ART.AddonName.."\\Textures\\users",
    texCoords = { 0, 1, 0, 1 }, iconSize = 25,
    createSidePanelFrame = false,
    onShow = function()
      local parent = ART.main_frame and ART.main_frame.sectionContentFrames
          and ART.main_frame.sectionContentFrames.roster
      if parent then Roster:CreateUI(parent); Roster:RefreshUI() end
      if C_GuildInfo and C_GuildInfo.GuildRoster then C_GuildInfo.GuildRoster()
      elseif type(GuildRoster) == "function" then GuildRoster() end
    end,
  })
end

ART.Roster = Roster
