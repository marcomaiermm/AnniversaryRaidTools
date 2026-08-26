local _, ART = ...
local AceGUI = LibStub("AceGUI-3.0")
local L = ART.L
local tinsert, slen = table.insert, string.len

-- handle most art errors internally and provide an easy way for users to report these errors

local caughtErrors = {}

local function getDiagnostics()
  local presetExport = ART:TableToString(ART:GetCurrentPreset())
  ---@diagnostic disable-next-line: redundant-parameter
  local addonVersion = ART.Compat:GetAddOnMetadata(ART.AddonName, "Version") or "unknown"
  local locale = GetLocale()
  local dateString = date("%d/%m/%y %H:%M:%S")
  local gameVersion = select(4, GetBuildInfo())
  local name, realm = UnitFullName("player")
  local regionId = GetCurrentRegion()
  local regions = {
    [1] = "US",
    [2] = "Korea",
    [3] = "Europe",
    [4] = "Taiwan",
    [5] = "China",
    [72] = "PTR",
    [90] = "BETA",
  }
  local region = regions[regionId] or "UNKNOWN"
  local combatState = InCombatLockdown() and "In combat" or "Out of combat"
  local mapID = ART.Compat:GetBestMapForUnit("player")
  local mapInfo = mapID and ART.Compat:GetMapInfo(mapID)
  local parentInfo = mapInfo and mapInfo.parentMapID and ART.Compat:GetMapInfo(mapInfo.parentMapID)
  local zoneInfo = format("Zone: %s (%s)", parentInfo and parentInfo.name or "unknown", mapID or "unknown")
  return {
    presetExport = presetExport,
    addonVersion = addonVersion,
    locale = locale,
    dateString = dateString,
    gameVersion = gameVersion,
    name = name,
    realm = realm,
    region = region,
    combatState = combatState,
    zoneInfo = zoneInfo
  }
end

local hasShown = false

function ART:DisplayErrors(force)
  if not force and hasShown then return end
  hasShown = true
  if #caughtErrors == 0 then return end
  if ART.initSpinner then
    ART.initSpinner:Hide()
    ART.initSpinner.Anim:Stop()
  end

  local function startCopyAction(editBox, copyButton, text)
    editBox:HighlightText(0, slen(text))
    editBox:SetFocus()
    copyButton:SetDisabled(true)
    if not ART.copyHelper then
      ART:MakeCopyHelper(ART.errorFrame.frame)
    end
    ART.copyHelper:SmartShow(ART.errorFrame.frame, 0, 0)
  end

  local function stopCopyAction(copyButton)
    copyButton:SetDisabled(false)
    ART.copyHelper:SmartHide()
  end

  local errorBoxText = ""

  if not ART.errorFrame then
    ART.errorFrame = AceGUI:Create("Frame")
    _G["ARTErrorFrame"] = ART.errorFrame.frame
    tinsert(UISpecialFrames, "ARTErrorFrame")
    local errorFrame = ART.errorFrame
    if not ART.copyHelper then ART:MakeCopyHelper(errorFrame.frame) end
    errorFrame:EnableResize(false)
    errorFrame:SetWidth(800)
    errorFrame:SetHeight(600)
    errorFrame:EnableResize(false)
    errorFrame:SetLayout("Flow")
    errorFrame:SetTitle(L["ART Error"])
    errorFrame.label = AceGUI:Create("Label")
    errorFrame.label:SetWidth(800)
    errorFrame.label:SetFontObject("GameFontNormalLarge")
    errorFrame.label.label:SetTextColor(1, 0, 0)
    errorFrame.label:SetText(L["errorLabel1"].."\n"..L["errorLabel2"])
    errorFrame:AddChild(errorFrame.label)

    local errorBox, errorBoxCopyButton
    errorFrame.errorBox = AceGUI:Create("MultiLineEditBox")
    errorBox = errorFrame.errorBox
    errorBox:SetWidth(800)
    errorBox:SetLabel(L["Error Message:"])
    errorBox:DisableButton(true)
    errorBox:SetNumLines(20)
    errorBox:SetCallback("OnTextChanged", function()
      errorBox:SetText(errorBoxText)
    end)
    errorBox.editBox:HookScript('OnEditFocusLost', function()
      stopCopyAction(errorBoxCopyButton)
    end);
    errorBox.editBox:SetScript('OnKeyUp', function(_, key)
      if (ART.copyHelper:WasControlKeyDown() and key == 'C') then
        ART.copyHelper:SmartFadeOut()
        errorBox:ClearFocus();
      else
        ART.copyHelper:SmartHide()
      end
    end);

    errorFrame.errorBoxCopyButton = AceGUI:Create("Button")
    errorBoxCopyButton = errorFrame.errorBoxCopyButton
    errorBoxCopyButton:SetText(L["Copy error"])
    errorBoxCopyButton:SetHeight(40)
    errorBoxCopyButton:SetCallback("OnClick", function(widget, callbackName, value)
      startCopyAction(errorFrame.errorBox, errorBoxCopyButton, errorBoxText)
    end)

    errorFrame.hardResetButton = AceGUI:Create("Button")
    local hardResetButton = errorFrame.hardResetButton
    hardResetButton:SetText(L["hardResetButton"])
    hardResetButton:SetHeight(40)
    hardResetButton:SetCallback("OnClick", function(widget, callbackName, value)
      ART:Async(function()
        ART:OpenConfirmationFrame(450, 150, L["hardResetPromptTitle"], L["Delete"], L["hardResetPrompt"], ART.HardReset)
      end, "hardReset")
    end)

    errorFrame:AddChild(errorFrame.errorBox)
    errorFrame:AddChild(errorFrame.errorBoxCopyButton)
    errorFrame:AddChild(errorFrame.hardResetButton)
  end

  for _, error in ipairs(caughtErrors) do
    errorBoxText = errorBoxText..error.count.."x: "..error.message.."\n"
  end
  --add diagnostics
  local diagnostics = getDiagnostics()
  errorBoxText = errorBoxText.."\n"..diagnostics.dateString.."\nART: "..diagnostics.addonVersion.."\nClient: "..diagnostics.gameVersion.." "..diagnostics.locale.."\nCharacter: "..diagnostics.name.."-"..diagnostics.realm.." ("..diagnostics.region..")"
  errorBoxText = errorBoxText.."\n"..diagnostics.combatState.."\n"..diagnostics.zoneInfo.."\n"
  errorBoxText = errorBoxText.."\nRoute:\n"..diagnostics.presetExport
  errorBoxText = errorBoxText.."\nStacktraces\n\n"
  for _, error in ipairs(caughtErrors) do
    errorBoxText = errorBoxText..error.stackTrace.."\n"
  end

  ART.errorFrame.errorBox:SetText(errorBoxText)
  if ART.main_frame then
    ART.errorFrame.frame:SetParent(ART.main_frame)
  end
  ART.errorFrame.frame:SetFrameStrata("DIALOG")
  ART.errorFrame:Show()
end

local numError = 0
local currentFunc = ""
local addTrace = false
local function onError(msg, stackTrace, name)
  numError = numError + 1
  local funcName = name or currentFunc
  local e = funcName..": "..msg
  -- return early on duplicate errors
  for _, error in pairs(caughtErrors) do
    if error.message == e then
      error.count = error.count + 1
      addTrace = false
      return false
    end
  end
  local stackTraceValue = stackTrace and name..":\n"..stackTrace
  tinsert(caughtErrors, { message = e, stackTrace = stackTraceValue, count = 1 })
  addTrace = true
  if ART.errorTimer then ART.errorTimer:Cancel() end
  ART.errorTimer = C_Timer.NewTimer(0.5, function()
    ART:DisplayErrors(true)
  end)
  --if spam erroring then show errors early otherwise risk error display never showing
  if numError > 100 then
    ART:DisplayErrors(true)
  end
  return false
end

--accessible function for errors in coroutines
function ART:OnError(msg, stackTrace, name)
  onError(msg, stackTrace, name)
end

function ART:GetErrors()
  return caughtErrors
end

function ART:RegisterErrorHandledFunctions()
  --register all functions except the ones that have to run as coroutines
  local blacklisted = {
    ["RaidEnemies_UpdateSelected"] = true,
    ["RaidEnemies_UpdateEnemiesAsync"] = true,
    ["ReloadPullButtons"] = true,
    ["DrawAllPresetObjects"] = true,
    ["AddPull"] = true,
    ["ClearPull"] = true,
    ["ShowInterfaceInternal"] = true,
    ["InitializeMainFrame"] = true,
    ["UpdateToRaid"] = true,
    ["UpdateMap"] = true,
    ["MovePullUp"] = true,
    ["ShowInterface"] = true,
    ["DeletePull"] = true,
    ["ExportRaidDataIncrementally"] = true,
    ["DrawAllHulls"] = true,
    ["ExportString"] = true,
    ["Async"] = true,
    ["RegisterErrorHandledFunctions"] = true,
    ["OnError"] = true,
  }
  local tablesToAdd = {
    ART, ARTRaidEnemyMixin
  }
  for k, table in pairs(tablesToAdd) do
    for funcName, func in pairs(table) do
      if type(func) == "function" and not blacklisted[funcName] then
        table[funcName] = function(...)
          currentFunc = funcName
          local results = { xpcall(func, onError, ...) }
          local ok = select(1, unpack(results))
          if not ok then
            if addTrace then
              --add stackTrace to the latest error
              caughtErrors[#caughtErrors].stackTrace = currentFunc..":\n"..debugstack()
            end
            return
          end
          return select(2, unpack(results))
        end
      end
    end
  end
end
