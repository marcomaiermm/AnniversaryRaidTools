local _, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local L = ART.L

local tremove, tonumber, pairs = table.remove, tonumber, pairs
local defaultSavedVars = ART:GetDefaultSavedVariables()
local db

local function initializeDB()
  db = db or ART:GetDB()
end

function ART:UpdatePresetDropDown()
  initializeDB()
  local dropdown = ART.main_frame.sidePanel.WidgetGroup.PresetDropDown
  local presetList = {}
  for k, v in pairs(db.presets[db.currentRaidIndex]) do
    presetList[k] = ART:GetPresetDropdownText(v)
  end
  dropdown:SetList(presetList)
  dropdown:SetValue(db.currentPreset[db.currentRaidIndex])
  dropdown:ClearFocus()
end

local raidClassColorKeyByClassIndex = {
  [1] = "WARRIOR",
  [2] = "PALADIN",
  [3] = "HUNTER",
  [4] = "ROGUE",
  [5] = "PRIEST",
  [6] = "DEATHKNIGHT",
  [7] = "SHAMAN",
  [8] = "MAGE",
  [9] = "WARLOCK",
  [10] = "MONK",
  [11] = "DRUID",
  [12] = "DEMONHUNTER",
  [13] = "EVOKER",
}

function ART:GetCurrentRouteAuthor()
  local name, realm = UnitFullName("player")
  local _, _, classIdx = UnitClass("player")
  if not name or not classIdx then return end
  if not realm or realm == "" then realm = GetRealmName and GetRealmName() or "" end
  return {
    name = name,
    realm = realm,
    classIdx = classIdx,
  }
end

function ART:EnsurePresetCreatedBy(preset, force)
  if preset.text == L["Default"] then
    preset.createdBy = nil
    return
  end
  if not force and type(preset.createdBy) == "table" then return end
  local author = self:GetCurrentRouteAuthor()
  if author then preset.createdBy = author end
end

function ART:GetClassFileByIndex(classIdx)
  return raidClassColorKeyByClassIndex[tonumber(classIdx)]
end

function ART:GetClassColoredRouteAuthorName(createdBy)
  if type(createdBy) ~= "table" or type(createdBy.name) ~= "string" then return end
  local classFile = self:GetClassFileByIndex(createdBy.classIdx)
  if not classFile then return end
  local _, _, _, classHexString = GetClassColor(classFile)
  if not classHexString then return end
  return WrapTextInColorCode(createdBy.name, classHexString)
end

function ART:GetPresetDropdownText(preset)
  local text = preset.text or ""
  local authorName = self:GetClassColoredRouteAuthorName(preset.createdBy)
  if authorName then
    return authorName.." - "..text
  end
  return text
end

function ART:UpdatePresetDropdownTextColor(forceReset)
  local preset = self:GetCurrentPreset()
  local livePreset = self:GetCurrentLivePreset()
  if self.liveSessionActive and preset == livePreset and (not forceReset) then
    local dropdown = ART.main_frame.sidePanel.WidgetGroup.PresetDropDown
    dropdown.text:SetTextColor(0, 1, 0, 1)
  else
    local dropdown = ART.main_frame.sidePanel.WidgetGroup.PresetDropDown
    dropdown.text:SetTextColor(1, 1, 1, 1)
  end
end

---Returns the current preset
function ART:GetCurrentPreset()
  initializeDB()
  return db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]]
end

function ART:GetCurrentLivePreset()
  initializeDB()
  if not self.livePresetUID then return end
  if self.liveUpdateFrameOpen then
    for fullName, cachedPreset in pairs(self.transmissionCache) do
      if cachedPreset.uid == self.livePresetUID then
        return cachedPreset
      end
    end
  end
  for raidIndex, presets in pairs(db.presets) do
    for presetIdx, preset in pairs(presets) do
      if preset.uid and preset.uid == self.livePresetUID then
        return preset, presetIdx
      end
    end
  end
end

function ART:ReturnToLivePreset()
  local preset, presetIdx = self:GetCurrentLivePreset()
  ---@diagnostic disable-next-line: need-check-nil
  self:UpdateToRaid(preset.value.currentRaidIndex, true)
  db.currentPreset[db.currentRaidIndex] = presetIdx
  self:UpdatePresetDropDown()
  self:UpdateMap()
end

function ART:SetLivePreset()
  local preset = self:GetCurrentPreset()
  local callback = function()
    self:SetUniqueID(preset)
    self:LiveSession_SetUID(preset.uid)
    self:LiveSession_SendPreset(preset)
    self:UpdatePresetDropdownTextColor()
    self.main_frame.setLivePresetButton:Hide()
    self.main_frame.liveReturnButton:Hide()
  end
  ART:CheckPresetSize(callback)
end

---Makes sure profiles are valid and have their fields set
function ART:NormalizeCurrentPreset()
  initializeDB()
  if db.alwaysOverwriteRoutesByUID == nil then db.alwaysOverwriteRoutesByUID = false end
  if not ART.raidList[db.currentRaidIndex] then
    db.currentRaidIndex = defaultSavedVars.global.currentRaidIndex
  end
  local preset = ART:GetCurrentPreset()
  if preset.value == 0 then --<New Preset> as selected preset
    db.presets[db.currentRaidIndex] = {
      [1] = {
        text = L["Default"],
        value = {},
        objects = {},
        colorPaletteInfo = { autoColoring = true, colorPaletteIdx = 4 }
      },
      [2] = { text = L["<New Preset>"], value = 0 },
    }
    db.currentPreset[db.currentRaidIndex] = 1
    preset = ART:GetCurrentPreset()
  end
  if preset.objects then
    local isValid = true
    for _, obj in pairs(preset.objects) do
      if type(obj) ~= "table" then
        isValid = false
      end
    end
    if not isValid then
      preset.objects = nil
    end
  end
  preset.week = nil
  db.currentPreset[db.currentRaidIndex] = db.currentPreset[db.currentRaidIndex] or 1
  db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentRaidIndex = db.currentRaidIndex
  db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentSublevel = db.presets[
  db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentSublevel or 1
  db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentPull = db.presets[
  db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentPull or 1
  db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls = db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls or {}
  -- make sure, that at least 1 pull exists
  if #db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls == 0 then
    db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls[1] = {}
  end
  --ensure that there exists a map for the current sublevel
  local sublevel = ART:GetCurrentSubLevel()
  if not ART.raidMaps[db.currentRaidIndex][sublevel] then
    db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentSublevel = 1
  end

  --ensure the pulls table is not fully corrupted
  if not preset.value.pulls or (type(preset.value.pulls) ~= "table") then
    preset.value.pulls = {}
  else
    for pullIdx, pull in pairs(preset.value.pulls) do
      --detect gaps in pull list and delete invalid pulls
      if pullIdx == 0 or pullIdx > #preset.value.pulls then
        preset.value.pulls[pullIdx] = nil
      end
      --fix wrong indexes of clones within pulls
      for enemyIdx, clones in pairs(pull) do
        local assignmentIdx = 1
        if tonumber(enemyIdx) and type(clones) == "table" then
          for actualIndex, cloneIdx in pairs(clones) do
            if actualIndex ~= assignmentIdx then
              clones[assignmentIdx] = cloneIdx
              clones[actualIndex] = nil
            end
            assignmentIdx = assignmentIdx + 1
          end
        end
      end
    end
  end

  -- Set current pull to last pull, if the actual current pull does not exists anymore
  if not
      db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls[
      db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentPull] then
    db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentPull = #
        db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls
  end

  for k, v in pairs(db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls) do
    if k == 0 then
      db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls[0] = nil
      break
    end
  end

  --removed clones: remove data from presets
  for pullIdx, pull in pairs(preset.value.pulls) do
    for enemyIdx, clones in pairs(pull) do
      if tonumber(enemyIdx) then
        --enemy does not exist at all anymore
        if not ART.raidEnemies[db.currentRaidIndex][enemyIdx] then
          pull[enemyIdx] = nil
        else
          --only clones
          for k, v in pairs(clones) do
            if not ART.raidEnemies[db.currentRaidIndex][enemyIdx]["clones"][v] then
              clones[k] = nil
            end
          end
        end
      end
    end
    pull["color"] = pull["color"] or "228b22"
  end
  if ART.CCAssignments then ART.CCAssignments:NormalizePreset(preset) end
  if ART.Roster then ART.Roster:NormalizePreset(preset) end

  --make sure sublevel actually exists for the raid
  --this might have been caused by bugged dropdowns in the past
  local maxSublevel = -1
  for _, _ in pairs(ART.raidMaps[db.currentRaidIndex]) do
    maxSublevel = maxSublevel + 1
  end
  if preset.value.currentSublevel > maxSublevel then preset.value.currentSublevel = maxSublevel end
end

function ART:EnsureDBTables()
  return self:NormalizeCurrentPreset()
end

function ART:DeletePreset(index)
  initializeDB()
  if index == 1 then return end
  tremove(db.presets[db.currentRaidIndex], index)
  db.currentPreset[db.currentRaidIndex] = index - 1
  ART:UpdatePresetDropDown()
  ART:UpdateMap()
end

---Counts the number of presets of the current raid
function ART:CountPresets()
  initializeDB()
  return #db.presets[db.currentRaidIndex] - 2
end

---Deletes all presets from the current raid
function ART:DeleteAllPresets()
  initializeDB()
  local countPresets = #db.presets[db.currentRaidIndex] - 1
  for i = countPresets, 2, -1 do
    tremove(db.presets[db.currentRaidIndex], i)
    db.currentPreset[db.currentRaidIndex] = i - 1
  end
  ART:UpdatePresetDropDown()
  ART:UpdateMap()
end

function ART:ClearPreset(preset, silent)
  if preset == self:GetCurrentPreset() then silent = false end
  table.wipe(preset.value.pulls)
  preset.value.currentPull = 1
  --ART:DeleteAllPresetObjects()
  self:EnsureDBTables()
  if not silent then
    self:UpdateMap()
    self:ReloadPullButtons()
  end
  ART:ColorPull()
end

function ART:CreateNewPreset(name)
  initializeDB()
  if name == "<New Preset>" then
    ART.main_frame.presetCreationLabel:SetText(string.format(L["Cannot create preset '%s'"], name))
    ART.main_frame.presetCreationCreateButton:SetDisabled(true)
    ART.main_frame.presetCreationCreateButton.text:SetTextColor(0.5, 0.5, 0.5)
    ART.main_frame.presetCreationFrame:DoLayout()
    return
  end
  local duplicate = false
  local countPresets = 0
  for k, v in pairs(db.presets[db.currentRaidIndex]) do
    countPresets = countPresets + 1
    if v.text == name then duplicate = true end
  end
  if duplicate == false then
    db.presets[db.currentRaidIndex][countPresets + 1] = db.presets[db.currentRaidIndex][countPresets] --put <New Preset> at the end of the list

    local startingPointPresetIdx = ART.main_frame.PresetCreationDropDown:GetValue() - 1
    if startingPointPresetIdx > 0 then
      db.presets[db.currentRaidIndex][countPresets] = CopyTable(db.presets[db.currentRaidIndex][
      startingPointPresetIdx])
      db.presets[db.currentRaidIndex][countPresets].text = name
      db.presets[db.currentRaidIndex][countPresets].uid = nil
    else
      db.presets[db.currentRaidIndex][countPresets] = { text = name, value = {} }
    end

    db.currentPreset[db.currentRaidIndex] = countPresets
    ART:EnsurePresetCreatedBy(db.presets[db.currentRaidIndex][countPresets], true)
    ART.main_frame.presetCreationFrame:Hide()
    ART:UpdatePresetDropDown()
    ART:UpdateMap()
    ART:SetPresetColorPaletteInfo()
    ART:ColorAllPulls()
  else
    ART.main_frame.presetCreationLabel:SetText(string.format(L["Preset '%s' already exists"], name))
    ART.main_frame.presetCreationCreateButton:SetDisabled(true)
    ART.main_frame.presetCreationCreateButton.text:SetTextColor(0.5, 0.5, 0.5)
    ART.main_frame.presetCreationFrame:DoLayout()
  end
end

function ART:SanitizePresetName(text)
  initializeDB()
  --check if name is valid, block button if so, unblock if valid
  if text == "<New Preset>" then
    return false
  else
    local duplicate = false
    local countPresets = 0
    for k, v in pairs(db.presets[db.currentRaidIndex]) do
      countPresets = countPresets + 1
      if v.text == text then duplicate = true end
    end
    return not duplicate and text or false
  end
end

function ART:ValidateImportPreset(preset, allowKnownRaid)
  if type(preset) ~= "table" then return false end
  if not preset.text then return false end
  if not preset.value then return false end
  if type(preset.text) ~= "string" then return false end
  if type(preset.value) ~= "table" then return false end
  if not preset.value.currentRaidIndex then return false end
  if not preset.value.currentPull then return false end
  if not preset.value.currentSublevel then return false end
  if not preset.value.pulls then return false end
  if type(preset.value.pulls) ~= "table" then return false end
  if not ART.raidList[preset.value.currentRaidIndex] and
      not (allowKnownRaid and ART.knownRaids and ART.knownRaids[preset.value.currentRaidIndex]) then
    return false
  end
  if ART.CCAssignments then ART.CCAssignments:NormalizePreset(preset) end
  if ART.Roster then ART.Roster:NormalizePreset(preset) end
  return true
end

function ART:ImportPreset(preset, fromLiveSession)
  initializeDB()
  if not ART:AreFramesInitialized() then
    ART:RunAfterFramesInitialized(function()
      ART:ImportPreset(preset, fromLiveSession)
    end)
    return
  end

  --change raid to raid of the new preset
  ART:UpdateToRaid(preset.value.currentRaidIndex, true)
  --search for uid
  local updateIndex
  local duplicatePreset
  for k, v in pairs(db.presets[db.currentRaidIndex]) do
    if preset.uid and v.uid and v.uid == preset.uid then
      updateIndex = k
      duplicatePreset = v
      break
    end
  end

  local finishImport = function()
    self:UpdatePresetDropDown()
    self:UpdateMap()
    self.liveUpdateFrameOpen = nil
    if fromLiveSession then
      self.main_frame.SendingStatusBar:Hide()
      if self.main_frame.LoadingSpinner then
        self.main_frame.LoadingSpinner:Hide()
        self.main_frame.LoadingSpinner.Anim:Stop()
      end
    end
  end

  local clearConfirmationCloseCallback = function()
    if self.main_frame.ConfirmationFrame then
      self.main_frame.ConfirmationFrame:SetCallback("OnClose", function()
      end)
    end
  end

  local updateCallback = function()
    clearConfirmationCloseCallback()
    db.presets[db.currentRaidIndex][updateIndex] = preset
    db.currentPreset[db.currentRaidIndex] = updateIndex
    finishImport()
  end

  local copyCallback = function(preserveUid)
    clearConfirmationCloseCallback()
    local name = preset.text
    local num = 2
    for k, v in pairs(db.presets[db.currentRaidIndex]) do
      if name == v.text then
        name = preset.text.." "..num
        num = num + 1
      end
    end
    preset.text = name
    if fromLiveSession then
      if not preserveUid and duplicatePreset then duplicatePreset.uid = nil end
      ART:SetUniqueID(preset)
    else
      if not preserveUid then preset.uid = nil end
      ART:SetUniqueID(preset)
    end
    local countPresets = 0
    for k, v in pairs(db.presets[db.currentRaidIndex]) do
      countPresets = countPresets + 1
    end
    db.presets[db.currentRaidIndex][countPresets + 1] = db.presets[db.currentRaidIndex][countPresets] --put <New Preset> at the end of the list
    db.presets[db.currentRaidIndex][countPresets] = preset
    db.currentPreset[db.currentRaidIndex] = countPresets
    finishImport()
  end
  local closeCallback = function()
    self.liveUpdateFrameOpen = nil
    self:LiveSession_Disable()
    self.main_frame.ConfirmationFrame:SetCallback("OnClose", function()
    end)
    if fromLiveSession then
      self.main_frame.SendingStatusBar:Hide()
      if self.main_frame.LoadingSpinner then
        self.main_frame.LoadingSpinner:Hide()
        self.main_frame.LoadingSpinner.Anim:Stop()
      end
    end
  end

  --open dialog to ask for replacing
  if updateIndex then
    if db.alwaysOverwriteRoutesByUID then
      updateCallback()
      return
    end
    local prompt = string.format(L["Earlier Version"], duplicatePreset.text, "\n", "\n", "\n", "\n")
    local checkboxCallback = function(value)
      db.alwaysOverwriteRoutesByUID = value
      if self.main_frame and self.main_frame.alwaysOverwriteRoutesByUIDCheckbox then
        self.main_frame.alwaysOverwriteRoutesByUIDCheckbox:SetValue(value)
      end
    end
    self:OpenConfirmationFrame(450, 180, L["Import Preset"], L["Overwrite"], prompt, updateCallback, L["Make copy"],
      function() copyCallback(false) end, nil, L["Always overwrite matching routes on import"], db.alwaysOverwriteRoutesByUID,
      checkboxCallback)
    if fromLiveSession then
      self.liveUpdateFrameOpen = true
      self.main_frame.ConfirmationFrame:SetCallback("OnClose", function() closeCallback() end)
    end
  else
    copyCallback(true)
  end
end

---Saves currently selected automatic coloring settings to the current
---This can be achieved easier, but it will increase the export text length significantly for non custom palettes.
function ART:SetPresetColorPaletteInfo()
  local preset = ART:GetCurrentPreset()
  preset.colorPaletteInfo = {}
  preset.colorPaletteInfo.autoColoring = db.colorPaletteInfo.autoColoring
  if preset.colorPaletteInfo.autoColoring then
    preset.colorPaletteInfo.colorPaletteIdx = db.colorPaletteInfo.colorPaletteIdx
    if preset.colorPaletteInfo.colorPaletteIdx == 6 then
      preset.colorPaletteInfo.customPaletteValues = db.colorPaletteInfo.customPaletteValues
      preset.colorPaletteInfo.numberCustomColors = db.colorPaletteInfo.numberCustomColors
    end
  end
  --Code below works, but in most cases it saves more data to the preset and thereby significantly increases the export string length
  --ART:GetCurrentPreset().colorPaletteInfo = db.colorPaletteInfo
end

function ART:GetPresetColorPaletteInfo(preset)
  preset = preset or ART:GetCurrentPreset()
  if not preset.colorPaletteInfo then
    ART:SetPresetColorPaletteInfo()
  end
  return preset.colorPaletteInfo
end

function ART:RenamePreset(renameText, takeOwnership)
  initializeDB()
  local preset = db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]]
  preset.text = renameText
  if takeOwnership then
    ART:EnsurePresetCreatedBy(preset, true)
    preset.uid = nil
    ART:SetUniqueID(preset)
  end
  ART.main_frame.RenameFrame:Hide()
  ART:UpdatePresetDropDown()
end
