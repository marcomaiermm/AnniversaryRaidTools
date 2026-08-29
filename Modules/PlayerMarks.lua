local _, ART = ...
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only

local PlayerMarks = ART.PlayerMarks or {}
ART.PlayerMarks = PlayerMarks

local VALID_CLASSES = {
  WARRIOR = true, PALADIN = true, HUNTER = true, ROGUE = true, PRIEST = true,
  SHAMAN = true, MAGE = true, WARLOCK = true, DRUID = true,
}
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
  if not name or #name > 80 or not VALID_CLASSES[player.classFile] then return end
  return { name = name, classFile = player.classFile }
end

local function validMarker(marker)
  marker = tonumber(marker)
  return marker and marker >= 1 and marker <= 8 and marker % 1 == 0 and marker or nil
end

local function copyMarks(marks)
  local copy = {}
  for marker, player in pairs(type(marks) == "table" and marks or {}) do
    player = playerCopy(player)
    marker = validMarker(marker)
    if marker and player then copy[marker] = player end
  end
  return copy
end

local function normalizeMarks(marks)
  local normalized, seen = {}, {}
  for _, marker in ipairs(MARKER_ORDER) do
    local player = playerCopy(type(marks) == "table" and marks[marker])
    if player and not seen[player.name:lower()] then
      normalized[marker], seen[player.name:lower()] = player, true
    end
  end
  return normalized
end

local function validLoadoutName(value, loadouts, oldName)
  if type(value) ~= "string" then return end
  local name = value:match("^%s*(.-)%s*$")
  if name == "" or #name > 80 or name ~= oldName and loadouts[name] ~= nil then return end
  return name
end

function PlayerMarks:GetCurrent(preset)
  local value = preset and preset.value
  if type(value) ~= "table" then return {} end
  value.artPlayerMarkCurrent = type(value.artPlayerMarkCurrent) == "table" and value.artPlayerMarkCurrent or {}
  return value.artPlayerMarkCurrent
end

function PlayerMarks:Refresh(preset)
  if preset ~= (ART.GetCurrentPreset and ART:GetCurrentPreset()) then return end
  if self.frame then self:RefreshUI() end
  if ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
end

function PlayerMarks:SetPlayer(preset, marker, player)
  marker, player = validMarker(marker), playerCopy(player)
  if not marker or not player or not preset or type(preset.value) ~= "table" then return false end
  local marks = self:GetCurrent(preset)
  for otherMarker, other in pairs(marks) do
    if otherMarker ~= marker and type(other) == "table" and type(other.name) == "string"
        and other.name:lower() == player.name:lower() then marks[otherMarker] = nil end
  end
  marks[marker] = player
  self:Refresh(preset)
  return player
end

function PlayerMarks:ClearPlayer(preset, marker)
  marker = validMarker(marker)
  local marks = preset and preset.value and preset.value.artPlayerMarkCurrent
  if not marker or type(marks) ~= "table" or not marks[marker] then return false end
  marks[marker] = nil
  if not next(marks) then preset.value.artPlayerMarkCurrent = nil end
  self:Refresh(preset)
  return true
end

function PlayerMarks:LoadLoadout(preset, name)
  local value = preset and preset.value
  local saved = type(value) == "table" and type(value.artPlayerMarkLoadouts) == "table"
      and value.artPlayerMarkLoadouts[name]
  if type(saved) ~= "table" then return false end
  value.artPlayerMarkCurrent = copyMarks(saved)
  if not next(value.artPlayerMarkCurrent) then value.artPlayerMarkCurrent = nil end
  value.artPlayerMarkSelected = name
  self:Refresh(preset)
  return true
end

function PlayerMarks:SaveCurrentAs(preset, name)
  local value = preset and preset.value
  if type(value) ~= "table" then return false end
  local loadouts = type(value.artPlayerMarkLoadouts) == "table" and value.artPlayerMarkLoadouts or {}
  name = validLoadoutName(name, loadouts)
  if not name then return false end
  loadouts[name] = copyMarks(value.artPlayerMarkCurrent)
  value.artPlayerMarkLoadouts, value.artPlayerMarkSelected = loadouts, name
  self:Refresh(preset)
  return true
end

function PlayerMarks:OverwriteSelected(preset)
  local value = preset and preset.value
  local loadouts = type(value) == "table" and value.artPlayerMarkLoadouts
  local name = type(value) == "table" and value.artPlayerMarkSelected
  if type(loadouts) ~= "table" or type(loadouts[name]) ~= "table" then return false end
  loadouts[name] = copyMarks(value.artPlayerMarkCurrent)
  self:Refresh(preset)
  return true
end

function PlayerMarks:RenameSelected(preset, newName)
  local value = preset and preset.value
  local loadouts = type(value) == "table" and value.artPlayerMarkLoadouts
  local oldName = type(value) == "table" and value.artPlayerMarkSelected
  if type(loadouts) ~= "table" or type(loadouts[oldName]) ~= "table" then return false end
  newName = validLoadoutName(newName, loadouts, oldName)
  if not newName then return false end
  if newName ~= oldName then loadouts[newName], loadouts[oldName] = loadouts[oldName], nil end
  value.artPlayerMarkSelected = newName
  self:Refresh(preset)
  return true
end

function PlayerMarks:DeleteSelected(preset)
  local value = preset and preset.value
  local loadouts = type(value) == "table" and value.artPlayerMarkLoadouts
  local name = type(value) == "table" and value.artPlayerMarkSelected
  if type(loadouts) ~= "table" or type(loadouts[name]) ~= "table" then return false end
  loadouts[name], value.artPlayerMarkSelected = nil, nil
  if not next(loadouts) then value.artPlayerMarkLoadouts = nil end
  self:Refresh(preset)
  return true
end

function PlayerMarks:SetEnabled(preset, enabled)
  if not preset or type(preset.value) ~= "table" then return false end
  preset.value.artPlayerMarksEnabled = enabled == true and true or nil
  self:Refresh(preset)
  return true
end

function PlayerMarks:GetActiveMarks(preset)
  local value = preset and preset.value
  if type(value) ~= "table" or value.artPlayerMarksEnabled ~= true then return {} end
  return copyMarks(value.artPlayerMarkCurrent)
end

function PlayerMarks:NormalizePreset(preset)
  local value = preset and preset.value
  if type(value) ~= "table" then return false end
  local current = normalizeMarks(value.artPlayerMarkCurrent)
  value.artPlayerMarkCurrent = next(current) and current or nil
  local loadouts = {}
  for name, marks in pairs(type(value.artPlayerMarkLoadouts) == "table" and value.artPlayerMarkLoadouts or {}) do
    local validName = validLoadoutName(name, loadouts)
    local normalized = normalizeMarks(marks)
    if validName and next(normalized) then loadouts[validName] = normalized end
  end
  value.artPlayerMarkLoadouts = next(loadouts) and loadouts or nil
  if type(value.artPlayerMarkSelected) ~= "string" or not loadouts[value.artPlayerMarkSelected] then
    value.artPlayerMarkSelected = nil
  end
  value.artPlayerMarksEnabled = value.artPlayerMarksEnabled == true and true or nil
  return true
end

local function classColor(classFile)
  local color = RAID_CLASS_COLORS and RAID_CLASS_COLORS[classFile]
  return color and color.r or 0.8, color and color.g or 0.8, color and color.b or 0.8
end

function PlayerMarks:GetCandidates()
  local players = ART.Roster and ART.Roster:GetPlayers(true) or {}
  local ownName = canonicalName("player")
  local ownClass
  if type(UnitClass) == "function" then _, ownClass = UnitClass("player") end
  local ownPlayer = playerCopy({ name = ownName, classFile = ownClass })
  if ownPlayer then
    local found
    for _, player in ipairs(players) do
      if player.name:lower() == ownPlayer.name:lower() then found = true break end
    end
    if not found then
      ownPlayer.unit, ownPlayer.online = "player", true
      players[#players + 1] = ownPlayer
    end
  end
  table.sort(players, function(left, right)
    local leftLive, rightLive = left.unit and left.online ~= false, right.unit and right.online ~= false
    if leftLive ~= rightLive then return leftLive end
    return left.name:lower() < right.name:lower()
  end)
  return players
end

function PlayerMarks:HideSuggestions()
  if self.suggestions then self.suggestions:Hide() end
end

function PlayerMarks:ShowSuggestions(edit)
  local query = edit and edit:GetText():lower() or ""
  if query == "" or not self.suggestions then return self:HideSuggestions() end
  local matches = {}
  for _, player in ipairs(self:GetCandidates()) do
    local displayName = player.name:match("^[^-]+") or player.name
    if player.name:lower():find(query, 1, true) or displayName:lower():find(query, 1, true) then
      matches[#matches + 1] = player
      if #matches == 8 then break end
    end
  end
  if #matches == 0 then return self:HideSuggestions() end
  local popup = self.suggestions
  popup:ClearAllPoints()
  popup:SetPoint("TOPLEFT", edit, "BOTTOMLEFT", 0, -2)
  popup:SetFrameLevel(edit:GetFrameLevel() + 20)
  popup:SetHeight(#matches * 20 + 4)
  for index, button in ipairs(popup.buttons) do
    button.player = matches[index]
    button:SetShown(button.player ~= nil)
    if button.player then
      button.text:SetText(button.player.name:match("^[^-]+") or button.player.name)
      button.text:SetTextColor(classColor(button.player.classFile))
    end
  end
  popup.owner = edit
  popup:Show()
end

function PlayerMarks:CommitEdit(edit)
  if not edit or self.refreshing then return end
  local text = edit:GetText():match("^%s*(.-)%s*$")
  local preset = ART:GetCurrentPreset()
  if text == "" then
    edit.dirty = nil
    self:ClearPlayer(preset, edit.marker)
    return true
  end
  local wanted, match = text:lower()
  for _, player in ipairs(self:GetCandidates()) do
    local displayName = player.name:match("^[^-]+") or player.name
    if player.name:lower() == wanted or displayName:lower() == wanted then
      match = player
      break
    end
  end
  if match then
    edit.dirty = nil
    return self:SetPlayer(preset, edit.marker, match)
  end
  edit:SetTextColor(1, 0.3, 0.3)
  return false
end

function PlayerMarks:CommitPendingEdits()
  for _, edit in pairs(self.frame and self.frame.edits or {}) do
    if edit.dirty and not self:CommitEdit(edit) then return false end
  end
  return true
end

function PlayerMarks:OpenNameDialog(mode)
  local frame = self.nameDialog
  if not frame then return end
  frame.mode = mode
  frame.title:SetText(mode == "rename" and "Rename Loadout" or "Save Current Loadout")
  frame.edit:SetText(mode == "rename" and (ART:GetCurrentPreset().value.artPlayerMarkSelected or "") or "")
  frame.error:SetText("")
  frame:Show()
  frame.edit:SetFocus()
end

function PlayerMarks:ValidateNameDialog()
  local frame, preset = self.nameDialog, ART:GetCurrentPreset()
  if not frame or not preset then return end
  local value = preset.value
  local loadouts = type(value.artPlayerMarkLoadouts) == "table" and value.artPlayerMarkLoadouts or {}
  local oldName = frame.mode == "rename" and value.artPlayerMarkSelected or nil
  local name = validLoadoutName(frame.edit:GetText(), loadouts, oldName)
  frame.confirm:SetEnabled(name ~= nil)
  frame.error:SetText(name and "" or "Enter a unique, non-empty loadout name.")
  frame.validName = name
end

function PlayerMarks:ConfirmNameDialog()
  local frame, preset = self.nameDialog, ART:GetCurrentPreset()
  if not frame or not frame.validName then return end
  local result
  if frame.mode == "rename" then result = self:RenameSelected(preset, frame.validName)
  else result = self:SaveCurrentAs(preset, frame.validName) end
  if result then frame:Hide() end
end

function PlayerMarks:OpenDeleteDialog(preset, name)
  local dialog = self.deleteDialog
  if not dialog or type(name) ~= "string" then return false end
  dialog.preset, dialog.loadoutName = preset, name
  dialog.prompt:SetText("Delete '"..name.."'?\nThe current rows will be kept.")
  dialog:Show()
  return true
end

function PlayerMarks:ConfirmDeleteDialog()
  local dialog = self.deleteDialog
  if not dialog then return false end
  local preset, name = dialog.preset, dialog.loadoutName
  local value = preset and preset.value
  local result = type(value) == "table" and value.artPlayerMarkSelected == name
      and self:DeleteSelected(preset) or false
  dialog:Hide()
  return result
end

function PlayerMarks:OpenLoadoutMenu(button)
  if not ART.CreateContextMenu then return end
  local preset = ART:GetCurrentPreset()
  local value = preset and preset.value or {}
  local loadouts = type(value.artPlayerMarkLoadouts) == "table" and value.artPlayerMarkLoadouts or {}
  local selected = value.artPlayerMarkSelected
  ART:CreateContextMenu(button, function(_, root)
    local load = root:CreateButton("Load")
    local names = {}
    for name in pairs(loadouts) do names[#names + 1] = name end
    table.sort(names, function(left, right) return left:lower() < right:lower() end)
    if #names == 0 then
      load:CreateTitle("No saved loadouts")
    else
      for _, name in ipairs(names) do
        local loadoutName = name
        load:CreateButton(loadoutName, function() self:LoadLoadout(preset, loadoutName) end)
      end
    end
    root:CreateButton("Save current as...", function() self:OpenNameDialog("save") end)
    if type(loadouts[selected]) == "table" then
      root:CreateButton("Overwrite selected loadout", function() self:OverwriteSelected(preset) end)
      root:CreateButton("Rename selected loadout...", function() self:OpenNameDialog("rename") end)
      root:CreateButton("Delete selected loadout...", function()
        self:OpenDeleteDialog(preset, selected)
      end)
    end
  end)
end

function PlayerMarks:RefreshUI()
  local frame = self.frame
  if not frame then return end
  local preset = ART.GetCurrentPreset and ART:GetCurrentPreset()
  local value = preset and preset.value or {}
  local current = type(value.artPlayerMarkCurrent) == "table" and value.artPlayerMarkCurrent or {}
  self.refreshing = true
  for marker, edit in pairs(frame.edits) do
    if not edit.dirty then
      local player = playerCopy(current[marker])
      edit:SetText(player and (player.name:match("^[^-]+") or player.name) or "")
      edit:SetTextColor(classColor(player and player.classFile))
    end
  end
  local loadouts = type(value.artPlayerMarkLoadouts) == "table" and value.artPlayerMarkLoadouts or {}
  local selected = type(loadouts[value.artPlayerMarkSelected]) == "table" and value.artPlayerMarkSelected
  frame.loadout:SetText("Loadout: "..(selected or "Unsaved"))
  local enabled = value.artPlayerMarksEnabled == true
  frame.toggle:SetText(enabled and "Disable" or "Enable")
  frame.status:SetText(enabled and "Enabled — current rows are applied to raid players."
      or "Disabled — current rows are not applied live.")
  self.refreshing = nil
end

function PlayerMarks:CreateNameDialog(parent)
  local dialog = CreateFrame("Frame", "ARTPlayerMarkLoadoutNameDialog", parent, "BackdropTemplate")
  dialog:SetSize(360, 150)
  dialog:SetPoint("CENTER")
  dialog:SetFrameStrata("DIALOG")
  dialog:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
    insets = { left = 4, right = 4, top = 4, bottom = 4 } })
  dialog.title = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  dialog.title:SetPoint("TOP", 0, -18)
  dialog.edit = CreateFrame("EditBox", nil, dialog, "InputBoxTemplate")
  dialog.edit:SetSize(250, 22)
  dialog.edit:SetPoint("TOP", 0, -48)
  dialog.edit:SetAutoFocus(false)
  dialog.edit:SetMaxLetters(80)
  dialog.edit:SetScript("OnTextChanged", function() self:ValidateNameDialog() end)
  dialog.edit:SetScript("OnEnterPressed", function() self:ConfirmNameDialog() end)
  dialog.edit:SetScript("OnEscapePressed", function() dialog:Hide() end)
  dialog.error = dialog:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  dialog.error:SetPoint("TOP", dialog.edit, "BOTTOM", 0, -5)
  dialog.error:SetTextColor(1, 0, 0)
  dialog.confirm = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate")
  dialog.confirm:SetSize(90, 24)
  dialog.confirm:SetPoint("BOTTOMRIGHT", -92, 14)
  dialog.confirm:SetText("Confirm")
  dialog.confirm:SetScript("OnClick", function() self:ConfirmNameDialog() end)
  local cancel = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate")
  cancel:SetSize(80, 24)
  cancel:SetPoint("LEFT", dialog.confirm, "RIGHT", 8, 0)
  cancel:SetText("Cancel")
  cancel:SetScript("OnClick", function() dialog:Hide() end)
  dialog:Hide()
  self.nameDialog = dialog
end

function PlayerMarks:CreateDeleteDialog(parent)
  local dialog = CreateFrame("Frame", "ARTPlayerMarkLoadoutDeleteDialog", parent, "BackdropTemplate")
  dialog:SetSize(360, 130)
  dialog:SetPoint("CENTER")
  dialog:SetFrameStrata("DIALOG")
  dialog:EnableMouse(true)
  dialog:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
    insets = { left = 4, right = 4, top = 4, bottom = 4 } })
  dialog.title = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  dialog.title:SetPoint("TOP", 0, -18)
  dialog.title:SetText("Delete loadout?")
  dialog.prompt = dialog:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  dialog.prompt:SetPoint("TOP", 0, -48)
  dialog.prompt:SetWidth(320)
  dialog.prompt:SetJustifyH("CENTER")
  dialog.delete = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate")
  dialog.delete:SetSize(100, 24)
  dialog.delete:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -4, 16)
  dialog.delete:SetText("Delete")
  dialog.delete:SetScript("OnClick", function() self:ConfirmDeleteDialog() end)
  dialog.cancel = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate")
  dialog.cancel:SetSize(100, 24)
  dialog.cancel:SetPoint("BOTTOMLEFT", dialog, "BOTTOM", 4, 16)
  dialog.cancel:SetText("Cancel")
  dialog.cancel:SetScript("OnClick", function() dialog:Hide() end)
  dialog:Hide()
  self.deleteDialog = dialog
end

function PlayerMarks:CreateUI(parent)
  if self.frame or type(CreateFrame) ~= "function" or not parent then return self.frame end
  local frame = CreateFrame("Frame", "ARTPlayerMarksFrame", parent)
  frame:SetAllPoints()
  frame.edits = {}
  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 28, -34)
  title:SetText("Player Mark Loadout")
  frame.loadout = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  frame.loadout:SetSize(220, 26)
  frame.loadout:SetPoint("TOPLEFT", 28, -72)
  frame.loadout:SetScript("OnClick", function(button) self:OpenLoadoutMenu(button) end)
  frame.toggle = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  frame.toggle:SetSize(100, 26)
  frame.toggle:SetPoint("LEFT", frame.loadout, "RIGHT", 12, 0)
  frame.toggle:SetScript("OnClick", function()
    local preset = ART:GetCurrentPreset()
    local enabled = preset.value.artPlayerMarksEnabled == true
    if enabled or self:CommitPendingEdits() then self:SetEnabled(preset, not enabled) end
  end)
  frame.status = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.status:SetPoint("TOPLEFT", 28, -108)
  for index, marker in ipairs(MARKER_ORDER) do
    local selectedMarker = marker
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(marker))
    icon:SetSize(24, 24)
    icon:SetPoint("TOPLEFT", 28, -142 - (index - 1) * 34)
    local edit = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    edit:SetSize(250, 22)
    edit:SetPoint("LEFT", icon, "RIGHT", 10, 0)
    edit:SetAutoFocus(false)
    edit:SetMaxLetters(80)
    edit.marker = selectedMarker
    edit:SetScript("OnEnterPressed", function(box) self:CommitEdit(box); box:ClearFocus() end)
    edit:SetScript("OnEscapePressed", function(box)
      box.dirty = nil
      box:ClearFocus()
      self:RefreshUI()
    end)
    edit:SetScript("OnEditFocusLost", function(box) self:CommitEdit(box); self:HideSuggestions() end)
    edit:SetScript("OnTextChanged", function(box, user)
      if user then box.dirty = true; self:ShowSuggestions(box) end
    end)
    local clear = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    clear:SetSize(42, 22)
    clear:SetPoint("LEFT", edit, "RIGHT", 6, 0)
    clear:SetText("Clear")
    clear:SetScript("OnClick", function()
      edit.dirty = nil
      self:ClearPlayer(ART:GetCurrentPreset(), selectedMarker)
    end)
    frame.edits[selectedMarker] = edit
  end
  local clearCurrent = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  clearCurrent:SetSize(180, 26)
  clearCurrent:SetPoint("TOPLEFT", 28, -430)
  clearCurrent:SetText("Clear Current Loadout")
  clearCurrent:SetScript("OnClick", function()
    local preset = ART:GetCurrentPreset()
    preset.value.artPlayerMarkCurrent = nil
    self:Refresh(preset)
  end)
  local popup = CreateFrame("Frame", "ARTPlayerMarksAutocomplete", frame, "BackdropTemplate")
  popup:SetSize(250, 164)
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
      edit.dirty = nil
      edit:SetText(item.player.name:match("^[^-]+") or item.player.name)
      self:SetPlayer(ART:GetCurrentPreset(), edit.marker, item.player)
      edit:ClearFocus()
      self:HideSuggestions()
    end)
    popup.buttons[index] = button
  end
  popup:Hide()
  self.suggestions, self.frame = popup, frame
  self:CreateNameDialog(frame)
  self:CreateDeleteDialog(frame)
  self:RefreshUI()
  return frame
end

if ART.RegisterNavigationSection then
  ART:RegisterNavigationSection({
    key = "player-marks", name = "Marks", tooltip = "Player Marks",
    texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",
    texCoords = { 0, 1, 0, 1 }, iconSize = 25,
    createSidePanelFrame = false,
    onShow = function()
      local parent = ART.main_frame and ART.main_frame.sectionContentFrames
          and ART.main_frame.sectionContentFrames["player-marks"]
      if parent then PlayerMarks:CreateUI(parent); PlayerMarks:RefreshUI() end
    end,
  })
end
