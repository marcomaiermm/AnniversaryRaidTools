local addonName, ART = ...
local L = ART.L
local API = ART.API
local Compat = ART.Compat

ART.StaticData = ART.StaticData or {}
ART.StaticData.raids = ART.StaticData.raids or {}
ART.StaticData.enemyInfo = ART.StaticData.enemyInfo or {}

local UI_ADDON_NAME = "AnniversaryRaidTools_UI"
local UI_DISABLED_POPUP = "ART_UI_DISABLED"
local coreDefaults = {
  announceInstanceReset = false,
  minimap = {
    hide = false,
  },
  combatLogging = {
    enabled = false,
  },
}

local function applyDefaults(target, defaults)
  for key, value in pairs(defaults) do
    if target[key] == nil then
      target[key] = type(value) == "table" and CopyTable(value) or value
    elseif type(target[key]) == "table" and type(value) == "table" then
      applyDefaults(target[key], value)
    end
  end
end

if type(AnniversaryRaidToolsDB) ~= "table" or AnniversaryRaidToolsDB.schemaVersion ~= 2 then
  AnniversaryRaidToolsDB = { schemaVersion = 2 }
end
if type(AnniversaryRaidToolsDB.global) ~= "table" then AnniversaryRaidToolsDB.global = {} end
applyDefaults(AnniversaryRaidToolsDB.global, coreDefaults)

local db = AnniversaryRaidToolsDB.global
ART.BackdropColor = { 0.058823399245739, 0.058823399245739, 0.058823399245739, 0.9 }

function ART:GetDB()
  return db
end

ART:ExportAPI("GetDB")

function API:GetBackdropColor()
  return unpack(ART.BackdropColor)
end

function ART:HardReset()
  AnniversaryRaidToolsDB = nil
  ReloadUI()
end

function ART:ResetDataCache()
  db.raidEnemies = nil
  db.mapPOIs = nil
  ReloadUI()
end

local uiHandlers
local uiPluginAPI
local uiLoading
local uiLoadingFrame
local pendingPresetComms = {}
local pendingUIInitializers = {}

local function runUIInitializer(initializer)
  xpcall(function() initializer(uiPluginAPI) end, geterrorhandler())
end

function API:RegisterUIInitializer(initializer)
  assert(type(initializer) == "function", "AnniversaryRaidTools UI initializer must be a function")
  if uiPluginAPI then
    runUIInitializer(initializer)
  else
    pendingUIInitializers[#pendingUIInitializers + 1] = initializer
  end
end

function API:AttachUI(handlers, pluginAPI)
  assert(not uiHandlers, "AnniversaryRaidTools UI already attached")
  assert(type(handlers) == "table", "AnniversaryRaidTools UI handlers must be a table")
  for _, methodName in ipairs({ "ShowInterface", "HandleSlashCommand", "HandleChatLink", "OnCommReceived", "GetRaidName", "GetRaidFloors" }) do
    assert(type(handlers[methodName]) == "function", "Missing AnniversaryRaidTools UI handler: "..methodName)
  end
  assert(type(pluginAPI) == "table", "AnniversaryRaidTools UI plugin API must be a table")
  for _, methodName in ipairs({ "RegisterNavigationSection", "GetCurrentSection", "SetCurrentSection", "GetNavigationSectionContentFrame", "HideAllDialogs" }) do
    assert(type(pluginAPI[methodName]) == "function", "Missing AnniversaryRaidTools UI plugin method: "..methodName)
  end
  uiHandlers = handlers
  uiPluginAPI = pluginAPI
  for _, initializer in ipairs(pendingUIInitializers) do runUIInitializer(initializer) end
  wipe(pendingUIInitializers)
end

local function isUILoaded()
  return Compat:IsAddOnLoaded(UI_ADDON_NAME)
end

local function showUILoading()
  if not uiLoadingFrame then
    uiLoadingFrame = CreateFrame("Frame", "ARTUILoadingFrame", UIParent)
    uiLoadingFrame:SetPoint("CENTER")
    uiLoadingFrame:SetFrameStrata("DIALOG")
    uiLoadingFrame:SetSize(160, 40)
    local text = uiLoadingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    text:SetPoint("CENTER")
    text:SetText("Loading Anniversary Raid Tools...")
  end
  uiLoadingFrame:Show()
end

local function hideUILoading()
  if uiLoadingFrame then uiLoadingFrame:Hide() end
end

StaticPopupDialogs[UI_DISABLED_POPUP] = {
  text = "Anniversary Raid Tools UI is disabled. Enable it and reload the interface?",
  button1 = "Enable and Reload",
  button2 = _G.CANCEL,
  OnAccept = function()
    Compat:EnableAddOn(UI_ADDON_NAME)
    ReloadUI()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
}

function ART:LoadUI(reason)
  if isUILoaded() then return true end
  if uiLoading then return false end

  uiLoading = true
  local loaded, loadError = Compat:LoadAddOn(UI_ADDON_NAME)
  uiLoading = nil

  if not loaded and not isUILoaded() then
    if loadError == "DISABLED" then
      StaticPopup_Show(UI_DISABLED_POPUP)
    end
    print(("|cffffd100ART:|r Failed to load UI%s: %s"):format(reason and " ("..reason..")" or "", loadError or "unknown error"))
    return false
  end
  return true
end

local function callUI(methodName, ...)
  if not ART:LoadUI(methodName) then
    hideUILoading()
    return
  end
  hideUILoading()
  if uiHandlers then
    for _, comm in ipairs(pendingPresetComms) do
      uiHandlers.OnCommReceived(unpack(comm))
    end
    wipe(pendingPresetComms)
  end
  local implementation = uiHandlers and uiHandlers[methodName]
  if type(implementation) ~= "function" then
    print("|cffffd100ART:|r UI method unavailable: "..methodName)
    return
  end
  return implementation(...)
end

local function callUIWithLoading(methodName, ...)
  if isUILoaded() then return callUI(methodName, ...) end

  local args = { ... }
  showUILoading()
  C_Timer.After(0, function() callUI(methodName, unpack(args)) end)
end

function ART:ShowInterface(...)
  return callUIWithLoading("ShowInterface", ...)
end

function ART:GetRaidName(...)
  return callUI("GetRaidName", ...)
end

function ART:GetRaidFloors(...)
  return callUI("GetRaidFloors", ...)
end

ART:ExportAPI("ShowInterface")
ART:ExportAPI("GetRaidName")
ART:ExportAPI("GetRaidFloors")

BINDING_HEADER_ART = "Anniversary Raid Tools (ART)"
BINDING_NAME_ARTTOGGLE = "Toggle ART"

SLASH_ANNIVERSARYRAIDTOOLS1 = "/art"
SLASH_ANNIVERSARYRAIDTOOLS2 = "/anniversaryraidtools"

function SlashCmdList.ANNIVERSARYRAIDTOOLS(cmd, editbox)
  cmd = cmd:lower()
  local request, argument = strsplit(" ", cmd)
  if request == "minimap" then
    if db.minimap.hide then ART:ShowMinimapButton() else ART:HideMinimapButton() end
    return
  elseif request == "hardreset" and argument == "force" then
    ART:HardReset()
    return
  end

  callUIWithLoading("HandleSlashCommand", cmd, editbox)
end

local minimapIcon = LibStub("LibDBIcon-1.0")
local minimapKey = "AnniversaryRaidTools"
local dataBroker = LibStub("LibDataBroker-1.1"):NewDataObject(minimapKey, {
  type = "data source",
  text = "Anniversary Raid Tools",
  icon = ART.AddonPath.."Textures\\ARTLogo",
  OnClick = function(_, button)
    if button == "RightButton" then
      if db.minimap.lock then
        minimapIcon:Unlock(minimapKey)
      else
        minimapIcon:Lock(minimapKey)
      end
    elseif button == "MiddleButton" then
      if db.minimap.hide then ART:ShowMinimapButton() else ART:HideMinimapButton() end
    else
      ART:ShowInterface()
    end
  end,
  OnTooltipShow = function(tooltip)
    if not tooltip or not tooltip.AddLine then return end
    tooltip:AddLine("|cFFFFFFFFAnniversary Raid Tools|r")
    tooltip:AddLine(L["Click to toggle AddOn Window"])
    tooltip:AddLine(L["Right-click to lock Minimap Button"])
    tooltip:AddLine(L["Middle-click to disable Minimap Button"])
  end,
})

function ART:HideMinimapButton()
  db.minimap.hide = true
  minimapIcon:Hide(minimapKey)
  if uiHandlers and uiHandlers.OnMinimapVisibilityChanged then uiHandlers.OnMinimapVisibilityChanged(false) end
  print("ART: Use /art minimap to show the minimap icon again")
end

function ART:ShowMinimapButton()
  db.minimap.hide = false
  minimapIcon:Refresh(minimapKey, db.minimap)
  if uiHandlers and uiHandlers.OnMinimapVisibilityChanged then uiHandlers.OnMinimapVisibilityChanged(true) end
end

function ART:RefreshMinimapButton()
  if not db.minimap.hide then minimapIcon:Refresh(minimapKey, db.minimap) end
end

ART:ExportAPI("HideMinimapButton")
ART:ExportAPI("ShowMinimapButton")

minimapIcon:Register(minimapKey, dataBroker, db.minimap)
if not db.minimap.hide then ART:ShowMinimapButton() end

local instanceResetAnnounceHooked
function ART:EnableInstanceResetAnnounceHook()
  if instanceResetAnnounceHooked then return end
  instanceResetAnnounceHooked = true
  hooksecurefunc("ResetInstances", function()
    if not ART:GetDB().announceInstanceReset then return end
    local message = ART.L["instanceResetAnnouncement"]
    if IsInRaid() then
      Compat:SendChatMessage(message, "RAID")
    elseif IsInGroup() then
      Compat:SendChatMessage(message, "PARTY")
    else
      print(message)
    end
  end)
end

if db.announceInstanceReset then ART:EnableInstanceResetAnnounceHook() end

ART:ExportAPI("EnableInstanceResetAnnounceHook")

ART.presetCommPrefix = "ARTPreset"
ART.versionCheckPrefix = "ARTVersion"
ART.liveSessionPrefixes = {
  enabled = "ARTLiveEnabled",
  request = "ARTLiveReq",
  ping = "ARTLivePing",
  obj = "ARTLiveObj",
  objOff = "ARTLiveObjOff",
  objChg = "ARTLiveObjChg",
  cmd = "ARTLiveCmd",
  note = "ARTLiveNote",
  preset = "ARTLivePreset",
  pull = "ARTLivePull",
  free = "ARTLiveFree",
  bora = "ARTLiveBora",
  reqPre = "ARTLiveReqPre",
  poiAssignment = "ARTPOIAssignment",
  progress = "ARTRaidProgress",
  ccAssignment = "ARTCCAssign",
}

ART.commsObject = ART.commsObject or {}
local commsObject = ART.commsObject
LibStub("AceComm-3.0"):Embed(commsObject)

function API:GetVersionCheckPrefix()
  return ART.versionCheckPrefix
end

function API:GetPresetCommPrefix()
  return ART.presetCommPrefix
end

function API:GetLiveSessionPrefixes()
  return CopyTable(ART.liveSessionPrefixes)
end

function API:SendCommMessage(...)
  return commsObject:SendCommMessage(...)
end

local function onCommReceived(self, prefix, message, distribution, sender)
  if prefix == ART.versionCheckPrefix then
    if message == "R" and distribution == "PARTY" then
      local version = Compat:GetAddOnMetadata(addonName, "Version") or "unknown"
      self:SendCommMessage(prefix, "V"..version, "PARTY", nil, "ALERT")
      return
    end
  end

  if isUILoaded() and uiHandlers then
    return uiHandlers.OnCommReceived(prefix, message, distribution, sender)
  end
  -- Preset links need their payload later; live links request fresh session state when clicked.
  if prefix == ART.presetCommPrefix then
    pendingPresetComms[#pendingPresetComms + 1] = { prefix, message, distribution, sender }
  end
end

commsObject.OnCommReceived = onCommReceived
commsObject:RegisterComm(ART.presetCommPrefix)
commsObject:RegisterComm(ART.versionCheckPrefix)
for _, prefix in pairs(ART.liveSessionPrefixes) do commsObject:RegisterComm(prefix) end

local lastChatWarningAt = 0
local function checkChatframeInteractive(chatFrame)
  if chatFrame and chatFrame.isUninteractable and GetTime() - lastChatWarningAt >= 5 * 60 then
    lastChatWarningAt = GetTime()
    C_Timer.After(0.2, function()
      print("ART: |cFFFF0000Warning!|r "..L["chatNoninteractiveWarning"])
    end)
  end
end

local function filterRouteLinks(chatFrame, event, msg, player, l, cs, t, flag, channelId, ...)
  if flag == "GM" or flag == "DEV" or (event == "CHAT_MSG_CHANNEL" and type(channelId) == "number" and channelId > 0) then
    return
  end

  local newMsg = ""
  local remaining = msg
  repeat
    local start, finish, characterName, displayName = remaining:find("%[ART: ([^%s]+) %- ([^%]]+)%]")
    local startLive, finishLive, characterNameLive, displayNameLive = remaining:find("%[ARTLive: ([^%s]+) %- ([^%]]+)%]")
    if characterName and displayName then
      characterName = characterName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
      displayName = displayName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
      newMsg = newMsg..remaining:sub(1, start - 1).."|cffe6cc80|Hgarrmission:art-"..characterName.."|h["..displayName.."]|h|r"
      remaining = remaining:sub(finish + 1)
      checkChatframeInteractive(chatFrame)
    elseif characterNameLive and displayNameLive then
      characterNameLive = characterNameLive:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
      displayNameLive = displayNameLive:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
      newMsg = newMsg..remaining:sub(1, startLive - 1).."|Hgarrmission:artlive-"..characterNameLive..
          "|h[|cFF00FF00Live Session: |cffe6cc80"..displayNameLive.."]|h|r"
      remaining = remaining:sub(finishLive + 1)
      checkChatframeInteractive(chatFrame)
    else
      if newMsg ~= "" then
        return false, newMsg..remaining, player, l, cs, t, flag, channelId, ...
      end
      return
    end
  until false
end

local addMessageEventFilter = ChatFrame_AddMessageEventFilter or ChatFrameUtil.AddMessageEventFilter
addMessageEventFilter("CHAT_MSG_PARTY", filterRouteLinks)
addMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterRouteLinks)
addMessageEventFilter("CHAT_MSG_RAID", filterRouteLinks)
addMessageEventFilter("CHAT_MSG_RAID_LEADER", filterRouteLinks)

hooksecurefunc("SetItemRef", function(link, text)
  if link and (link:sub(1, 19) == "garrmission:artlive" or link:sub(1, 15) == "garrmission:art") then
    callUIWithLoading("HandleChatLink", link, text)
  end
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function(self)
  ART:RefreshMinimapButton()
  if db.loadOnStartUp and db.devMode then ART:ShowInterface(true) end
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)
