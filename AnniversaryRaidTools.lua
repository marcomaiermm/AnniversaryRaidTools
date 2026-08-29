local _, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local L = ART.L

local CreateFrame, tonumber, pairs, ipairs = CreateFrame, tonumber, pairs, ipairs

local AceGUI = LibStub("AceGUI-3.0")
local db

---@param shouldWarn boolean|nil
function ART:IsInRestrictedEnvironment(shouldWarn)
  if C_Secrets and C_Secrets.ShouldAurasBeSecret and C_Secrets.ShouldAurasBeSecret() then
    if shouldWarn then
      print('ART: '..(L["Action blocked: Restricted environment"] or "Action blocked: Restricted environment"))
    end
    return true
  end
  return false
end

function ART:CreateContextMenu(ownerRegion, generator, ...)
  if self:IsInRestrictedEnvironment(true) then return end
  return self.Compat:CreateContextMenu(ownerRegion, generator, ...)
end

function ART:InitializeRuntime()
  db = ART:InitializeSavedVariables()
  if not db then return end
  ART:InitializeFadeFrame()
  return db
end

BINDING_NAME_ARTTOGGLE = L["Toggle Window"]
BINDING_NAME_ARTNPC = L["New NPC at Cursor Position"]
BINDING_NAME_ARTWAYPOINT = L["New Patrol Waypoint at Cursor Position"]
BINDING_NAME_ARTUNDODRAWING = L["undoDrawing"]
BINDING_NAME_ARTREDODRAWING = L["redoDrawing"]

function ART:GetLocaleIndex()
  local localeToIndex = {
    ["enUS"] = 1,
    ["deDE"] = 2,
    ["esES"] = 3,
    ["esMX"] = 4,
    ["frFR"] = 5,
    ["itIT"] = 6,
    ["ptBR"] = 7,
    ["ruRU"] = 8,
    ["koKR"] = 9,
    ["zhCN"] = 10,
    ["zhTW"] = 11,
  }
  return localeToIndex[GetLocale()] or 1
end

ART.mapInfo = {}
ART.scaleMultiplier = {}
ART.raidMaps = {}
ART.raidEnemies = {}
ART.mapPOIs = {}
ART.raidFloors = {}
ART.raidList = {}

function ART:GetRaidName(idx, forceEnglish)
  if forceEnglish and ART.mapInfo[idx] and ART.mapInfo[idx].englishName then
    return ART.mapInfo[idx].englishName
  end
  return ART.raidList[idx]
end

function ART:GetRaidFloors()
  return ART.raidFloors
end

---ActivatePullTooltip
---
function ART:ActivatePullTooltip(pull)
  local pullTooltip = ART.pullTooltip
  pullTooltip.currentPull = pull
  pullTooltip:Show()
end

---UpdatePullTooltip
---Updates the tooltip which is being displayed when a pull is mouseovered
function ART:UpdatePullTooltip(tooltip)
  local frame = ART.main_frame
  if not frame.sidePanel.pullButtonsScrollFrame.frame:IsMouseOver() then
    tooltip:Hide()
  elseif frame.sidePanel.newPullButton and frame.sidePanel.newPullButton.frame:IsMouseOver() then
    tooltip:Hide()
  else
    if frame.sidePanel.newPullButtons and tooltip.currentPull and frame.sidePanel.newPullButtons[tooltip.currentPull] then
      local showData

      --enemy portraits
      for k, v in pairs(frame.sidePanel.newPullButtons[tooltip.currentPull].enemyPortraits) do
        if v:IsMouseOver() and v:IsShown() then
          --model
          if v.enemyData.displayId and (not tooltip.modelNpcId or (tooltip.modelNpcId ~= v.enemyData.displayId)) then
            tooltip.Model:SetDisplayInfo(v.enemyData.displayId)
            tooltip.modelNpcId = v.enemyData.displayId
          end
          --topString
          local newLine = "\n"
          local text = newLine..newLine..newLine..L[v.enemyData.name].." x"..v.enemyData.quantity..newLine
          text = text..string.format(L["Level %d %s"], v.enemyData.level, L[v.enemyData.creatureType])..newLine
          local health = v.enemyData.baseHealth
          text = text..string.format(L["%s HP"], ART:FormatEnemyHealth(health))..newLine

          tooltip.topString:SetText(text)
          showData = true
          break
        end
      end
      if showData then
        tooltip.topString:Show()
        tooltip.Model:Show()
      else
        tooltip.topString:Hide()
        tooltip.Model:Hide()
      end

      local countEnemies = 0
      for k, v in pairs(frame.sidePanel.newPullButtons[tooltip.currentPull].enemyPortraits) do
        if v:IsShown() then countEnemies = countEnemies + 1 end
      end
      if countEnemies == 0 then
        tooltip:Hide()
        return
      end
      tooltip.botString:Hide()
    end
  end
end

local function round(number, decimals)
  return tonumber((("%%.%df"):format(decimals)):format(number))
end

function ART:CalculateEnemyHealth(_, baseHealth)
  return round(baseHealth, 0)
end

function ART:FormatEnemyHealth(amount)
  amount = tonumber(amount)
  if not amount then return "" end

  if self:GetLocaleIndex() == 9 then
    -- KR
    if amount >= 1e16 then
      return string.format("%.3f경", amount / 1e16)
    elseif amount >= 1e12 then
      return string.format("%.3f조", amount / 1e12)
    elseif amount >= 1e8 then
      return string.format("%.2f억", amount / 1e8)
    elseif amount >= 1e4 then
      return string.format("%.1f만", amount / 1e4)
    else
      return amount
    end
  elseif self:GetLocaleIndex() == 10 or self:GetLocaleIndex() == 11 then
    if amount >= 1e8 then
      return string.format("%.2f亿", amount / 1e8)
    elseif amount >= 1e4 then
      return string.format("%d万", math.floor(amount / 1e4))
    else
      return amount
    end
  else
    if amount >= 1e12 then
      return string.format("%.3ft", amount / 1e12)
    elseif amount >= 1e9 then
      return string.format("%.3fb", amount / 1e9)
    elseif amount >= 1e6 then
      return string.format("%.2fm", amount / 1e6)
    elseif amount >= 1e3 then
      return string.format("%.1fk", amount / 1e3)
    else
      return amount
    end
  end
end

function ART:MakePullSelectionButtons(frame)
  frame.PullButtonScrollGroup = AceGUI:Create("SimpleGroup")
  frame.PullButtonScrollGroup:SetWidth(248)
  frame.PullButtonScrollGroup:SetHeight(410)
  frame.PullButtonScrollGroup:SetPoint("TOPLEFT", frame.WidgetGroup.frame, "BOTTOMLEFT", -4, -32)
  frame.PullButtonScrollGroup:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 30)
  frame.PullButtonScrollGroup:SetLayout("Fill")
  frame.PullButtonScrollGroup.frame:SetParent(frame)
  if not frame.PullButtonScrollGroup.frame.SetBackdrop then
    Mixin(frame.PullButtonScrollGroup.frame, BackdropTemplateMixin)
  end
  frame.PullButtonScrollGroup.frame:SetBackdropColor(1, 1, 1, 0)
  frame.PullButtonScrollGroup.frame:Hide()

  self:FixAceGUIShowHide(frame.PullButtonScrollGroup)

  frame.pullButtonsScrollFrame = AceGUI:Create("ScrollFrame")
  frame.pullButtonsScrollFrame:SetLayout("Flow")

  frame.PullButtonScrollGroup:AddChild(frame.pullButtonsScrollFrame)

  frame.newPullButtons = {}
  --rightclick context menu
  frame.optionsDropDown = CreateFrame("frame", "ARTPullButtonsOptionsDropDown", nil, "UIDropDownMenuTemplate")
end

---Updates the portraits display of a button to show which and how many npcs are selected
function ART:UpdatePullButtonNPCData(idx)
  if db.devMode then return end
  local preset = ART:GetCurrentPreset()
  local frame = ART.main_frame.sidePanel
  local enemyTable = {}
  if preset.value.pulls[idx] then
    local enemyTableIdx = 0
    for enemyIdx, clones in pairs(preset.value.pulls[idx]) do
      if tonumber(enemyIdx) then
        --check if enemy exists, remove if not
        if ART.raidEnemies[db.currentRaidIndex][enemyIdx] then
          local incremented = false
          local npcId = ART.raidEnemies[db.currentRaidIndex][enemyIdx]["id"]
          local name = ART.raidEnemies[db.currentRaidIndex][enemyIdx]["name"]
          local creatureType = ART.raidEnemies[db.currentRaidIndex][enemyIdx]["creatureType"]
          local level = ART.raidEnemies[db.currentRaidIndex][enemyIdx]["level"]
          local baseHealth = ART.raidEnemies[db.currentRaidIndex][enemyIdx]["health"]
          for k, cloneIdx in pairs(clones) do
            --check if clone exists, remove if not
            if ART.raidEnemies[db.currentRaidIndex][enemyIdx]["clones"][cloneIdx] then
              if self:IsCloneIncluded(enemyIdx, cloneIdx) then
                if not incremented then
                  enemyTableIdx = enemyTableIdx + 1
                  incremented = true
                end
                if not enemyTable[enemyTableIdx] then enemyTable[enemyTableIdx] = {} end
                enemyTable[enemyTableIdx].quantity = enemyTable[enemyTableIdx].quantity or 0
                enemyTable[enemyTableIdx].npcId = npcId
                enemyTable[enemyTableIdx].displayId = ART.raidEnemies[db.currentRaidIndex][enemyIdx]["displayId"]
                enemyTable[enemyTableIdx].quantity = enemyTable[enemyTableIdx].quantity + 1
                enemyTable[enemyTableIdx].name = name
                enemyTable[enemyTableIdx].level = level
                enemyTable[enemyTableIdx].creatureType = creatureType
                enemyTable[enemyTableIdx].baseHealth = baseHealth
                enemyTable[enemyTableIdx].isBoss = ART.raidEnemies[db.currentRaidIndex][enemyIdx]["isBoss"]
              end
            end
          end
        end
      end
    end
  end
  frame.newPullButtons[idx]:SetNPCData(enemyTable)

end

---Reloads all pull buttons in the scroll frame
function ART:ReloadPullButtons(force)
  ART:Async(function()
    local frame = ART.main_frame.sidePanel
    if not frame.pullButtonsScrollFrame then return end
    local preset = db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]]
    --store scroll value
    local oldScrollValue = frame.pullButtonsScrollFrame.localstatus.scrollvalue
    --first release all children of the scroll frame
    frame.pullButtonsScrollFrame:ReleaseChildren()
    coroutine.yield()
    local maxPulls = 0
    for k, v in pairs(preset.value.pulls) do
      maxPulls = maxPulls + 1
    end
    --add new children to the scrollFrame, the frames are from the widget pool so no memory is wasted
    local idx = 0
    for k, pull in ipairs(preset.value.pulls) do
      idx = idx + 1
      ---@diagnostic disable-next-line: param-type-mismatch
      frame.newPullButtons[idx] = AceGUI:Create("ARTPullButton")
      frame.newPullButtons[idx]:SetMaxPulls(maxPulls)
      frame.newPullButtons[idx]:SetIndex(idx)
      ART:UpdatePullButtonNPCData(idx)
      frame.newPullButtons[idx]:Initialize()
      frame.newPullButtons[idx]:Enable()
      frame.pullButtonsScrollFrame:AddChild(frame.newPullButtons[idx])
      coroutine.yield()
    end
    --add the "new pull" button
    ---@diagnostic disable-next-line: param-type-mismatch
    frame.newPullButton = AceGUI:Create("ARTNewPullButton")
    frame.newPullButton:Initialize()
    frame.newPullButton:Enable()
    frame.pullButtonsScrollFrame:AddChild(frame.newPullButton)
    --set the scroll value back to the old value
    frame.pullButtonsScrollFrame.scrollframe.obj:SetScroll(oldScrollValue)
    frame.pullButtonsScrollFrame.scrollframe.obj:FixScroll()
    if self:IsPullModeEnabled() then self:PickPullButton(preset.value.currentPull) end
    if self.RefreshPullModeButton then self:RefreshPullModeButton() end
    ART:ColorAllPulls(nil, 0)
    if preset.value.artWaveRaid then
      ART:ReleaseHullTextures()
    else
      ART:DrawAllHulls(preset.value.pulls, force)
    end
  end, "ReloadPullButtons", true)
end

---Deselects all pull buttons
function ART:ClearPullButtonPicks()
  local frame = ART.main_frame.sidePanel
  for k, v in pairs(frame.newPullButtons) do
    v:ClearPick()
  end
end

---Selects the current pull button and deselects all other buttons
function ART:PickPullButton(idx, keepPicked)
  if db.devMode then return end

  if not keepPicked then
    ART:ClearPullButtonPicks()
  end
  local frame = ART.main_frame.sidePanel
  if frame.newPullButtons[idx] then
    frame.newPullButtons[idx]:Pick()
  end
end

function ART:GetFirstNotSelectedPullButton(start, direction)
  if not direction then
    direction = -1
  elseif direction == "UP" then
    direction = -1
  elseif direction == "DOWN" then
    direction = 1
  end

  local pullIdx = start
  while ART.U.contains(ART:GetCurrentPreset().value.selection, pullIdx)
    and ART.U.isInRange(pullIdx, 1, #ART:GetCurrentPreset().value.pulls) do
    pullIdx = pullIdx + direction
  end

  if not ART.U.isInRange(pullIdx, 1, #ART:GetCurrentPreset().value.pulls) then
    return
  end

  return pullIdx
end

function ART:Round(number, decimals)
  return (("%%.%df"):format(decimals)):format(number)
end

function ART:RGBToHex(r, g, b)
  r = r * 255
  g = g * 255
  b = b * 255
  return ("%.2x%.2x%.2x"):format(r, g, b)
end

function ART:HexToRGB(rgb)
  if type(rgb) ~= "string" then return end
  if string.len(rgb) == 6 then
    local r, g, b
    r, g, b = tonumber('0x'..strsub(rgb, 0, 2)), tonumber('0x'..strsub(rgb, 3, 4)), tonumber('0x'..
      strsub(rgb, 5, 6))
    if not r then r = 0 else r = r / 255 end
    if not g then g = 0 else g = g / 255 end
    if not b then b = 0 else b = b / 255 end
    return r, g, b
  else
    return
  end
end

---Checks if the players is in a group/raid and returns the type
function ART:IsPlayerInGroup()
  local inGroup = (UnitInRaid("player") and "RAID") or (IsInGroup() and "PARTY")
  return inGroup
end

function ART:DropIndicator()
  local indicator = ART.main_frame.drop_indicator
  if not indicator then
    indicator = CreateFrame("Frame", "ART_DropIndicator")
    indicator:SetHeight(4)
    indicator:SetFrameStrata("FULLSCREEN")

    local texture = indicator:CreateTexture(nil, "OVERLAY", nil, 0)
    texture:SetBlendMode("ADD")
    texture:SetAllPoints(indicator)
    texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")

    local icon = indicator:CreateTexture(nil, "OVERLAY", nil, 0)
    icon:ClearAllPoints()
    icon:SetSize(16, 16)
    icon:SetPoint("CENTER", indicator)

    indicator.icon = icon
    indicator.texture = texture
    ART.main_frame.drop_indicator = indicator

    indicator:Hide()
  end

  return indicator
end

function ART:IsShown_DropIndicator()
  local indicator = ART:DropIndicator()
  return indicator:IsShown()
end

function ART:Show_DropIndicator(target, pos)
  local indicator = ART:DropIndicator()
  indicator:ClearAllPoints()
  if pos == "TOP" then
    indicator:SetPoint("BOTTOMLEFT", target.frame, "TOPLEFT", 0, -1)
    indicator:SetPoint("BOTTOMRIGHT", target.frame, "TOPRIGHT", 0, -1)
    indicator:Show()
  elseif pos == "BOTTOM" then
    indicator:SetPoint("TOPLEFT", target.frame, "BOTTOMLEFT", 0, 1)
    indicator:SetPoint("TOPRIGHT", target.frame, "BOTTOMRIGHT", 0, 1)
    indicator:Show()
  end
end

function ART:Hide_DropIndicator()
  local indicator = ART:DropIndicator()
  indicator:Hide()
end

function ART:GetScrollingAmount(scrollFrame, pixelPerSecond)
  local viewheight = scrollFrame.frame.obj.content:GetHeight()
  return (pixelPerSecond / viewheight) * 1000
end

function ART:GetPullButton(pullIdx)
  local frame = ART.main_frame.sidePanel
  return frame.newPullButtons[pullIdx]
end

function ART:UpdatePullButtonColor(pullIdx, r, g, b)
  local button = ART:GetPullButton(pullIdx)
  if not button then return end
  button.color.r, button.color.g, button.color.b = r, g, b
  button:UpdateColor()
end

ART.modules = {}
function ART:RegisterModule(modulename, module)
  ART.modules[modulename] = module
end
