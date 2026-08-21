local addonName, MDT = ...
local L = MDT.L
local API = MDT.API
local Compat = MDT.Compat
local ART = rawget(_G, "ART") or MDT.ART or MDT

_G.ART = ART
if MDT.ART == nil then MDT.ART = ART end
ART.StaticData = ART.StaticData or {}
ART.StaticData.raids = ART.StaticData.raids or {}
ART.StaticData.enemyInfo = ART.StaticData.enemyInfo or {}

local UI_ADDON_NAME = "MythicDungeonTools_UI"
local UI_DISABLED_POPUP = "ART_UI_DISABLED"
local coreDefaults = {
  enemyForcesTooltip = 1,
  muteXalatathVoiceLines = false,
  announceDungeonReset = false,
  minimap = {
    hide = false,
    compartmentHide = false,
  },
  focusMarker = {
    announceReadyCheck = false,
    useMacro = false,
    disableTargetMarkerInRaid = false,
    preserveExistingTargetMarkers = true,
    suppressNotifications = false,
    assignments = {},
  },
  combatLogging = {
    enabled = false,
    content = {
      lfr = false,
      normal = false,
      heroic = false,
      mythic = false,
      mythic_dungeon = false,
      mythic_plus = false,
    },
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

-- The root migration is intentionally a copy: the legacy value remains recoverable
-- until a later versioned domain migration has accepted its contents.
if type(AnniversaryRaidToolsDB) ~= "table" then
  AnniversaryRaidToolsDB = type(MythicDungeonToolsDB) == "table" and CopyTable(MythicDungeonToolsDB) or {}
end
if type(AnniversaryRaidToolsDB.global) ~= "table" then AnniversaryRaidToolsDB.global = {} end
applyDefaults(AnniversaryRaidToolsDB.global, coreDefaults)

local db = AnniversaryRaidToolsDB.global
MDT.BackdropColor = { 0.058823399245739, 0.058823399245739, 0.058823399245739, 0.9 }

function MDT:GetDB()
  return db
end

MDT:ExportAPI("GetDB")

function API:GetBackdropColor()
  return unpack(MDT.BackdropColor)
end

function MDT:HardReset()
  AnniversaryRaidToolsDB = nil
  MythicDungeonToolsDB = nil
  ReloadUI()
end

function MDT:ResetDataCache()
  db.dungeonEnemies = nil
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
  assert(type(initializer) == "function", "MythicDungeonTools UI initializer must be a function")
  if uiPluginAPI then
    runUIInitializer(initializer)
  else
    pendingUIInitializers[#pendingUIInitializers + 1] = initializer
  end
end

function API:AttachUI(handlers, pluginAPI)
  assert(not uiHandlers, "MythicDungeonTools UI already attached")
  assert(type(handlers) == "table", "MythicDungeonTools UI handlers must be a table")
  for _, methodName in ipairs({ "ShowInterface", "HandleSlashCommand", "HandleChatLink", "OnCommReceived", "GetEnemyForces", "GetDungeonName", "GetDungeonSublevels" }) do
    assert(type(handlers[methodName]) == "function", "Missing MythicDungeonTools UI handler: "..methodName)
  end
  assert(type(pluginAPI) == "table", "MythicDungeonTools UI plugin API must be a table")
  for _, methodName in ipairs({ "RegisterNavigationSection", "GetCurrentSection", "SetCurrentSection", "GetNavigationSectionContentFrame", "HideAllDialogs", "RegisterDungeonData" }) do
    assert(type(pluginAPI[methodName]) == "function", "Missing MythicDungeonTools UI plugin method: "..methodName)
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

function MDT:LoadUI(reason)
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
  if not MDT:LoadUI(methodName) then
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

function MDT:ShowInterface(...)
  return callUIWithLoading("ShowInterface", ...)
end

function MDT:GetEnemyForces(...)
  return callUI("GetEnemyForces", ...)
end

function MDT:GetDungeonName(...)
  return callUI("GetDungeonName", ...)
end

function MDT:GetDungeonSublevels(...)
  return callUI("GetDungeonSublevels", ...)
end

MDT:ExportAPI("ShowInterface")
MDT:ExportAPI("GetEnemyForces")
MDT:ExportAPI("GetDungeonName")
MDT:ExportAPI("GetDungeonSublevels")

BINDING_HEADER_MDT = "Anniversary Raid Tools (ART)"
BINDING_NAME_MDTTOGGLE = "Toggle ART"
_G["BINDING_NAME_CLICK MDTFocusMarkerButton:LeftButton"] = L["MDT Set Focus Macro"]

SLASH_ANNIVERSARYRAIDTOOLS1 = "/art"
SLASH_ANNIVERSARYRAIDTOOLS2 = "/mdt"
SLASH_ANNIVERSARYRAIDTOOLS3 = "/anniversaryraidtools"

function SlashCmdList.ANNIVERSARYRAIDTOOLS(cmd, editbox)
  cmd = cmd:lower()
  local request, argument = strsplit(" ", cmd)
  if request == "minimap" then
    if db.minimap.hide then MDT:ShowMinimapButton() else MDT:HideMinimapButton() end
    return
  elseif request == "hardreset" and argument == "force" then
    MDT:HardReset()
    return
  end

  callUIWithLoading("HandleSlashCommand", cmd, editbox)
end

local minimapIcon = LibStub("LibDBIcon-1.0")
local minimapKey = "AnniversaryRaidTools"
local dataBroker = LibStub("LibDataBroker-1.1"):NewDataObject(minimapKey, {
  type = "data source",
  text = "Anniversary Raid Tools",
  icon = MDT.AddonPath.."Textures\\MDTMinimap",
  OnClick = function(_, button)
    if button == "RightButton" then
      if db.minimap.lock then
        minimapIcon:Unlock(minimapKey)
      else
        minimapIcon:Lock(minimapKey)
      end
    elseif button == "MiddleButton" then
      if db.minimap.hide then MDT:ShowMinimapButton() else MDT:HideMinimapButton() end
    else
      MDT:ShowInterface()
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

function MDT:HideMinimapButton()
  db.minimap.hide = true
  minimapIcon:Hide(minimapKey)
  if uiHandlers and uiHandlers.OnMinimapVisibilityChanged then uiHandlers.OnMinimapVisibilityChanged(false) end
  print("ART: Use /art minimap to show the minimap icon again")
end

function MDT:ShowMinimapButton()
  db.minimap.hide = false
  minimapIcon:Refresh(minimapKey, db.minimap)
  if uiHandlers and uiHandlers.OnMinimapVisibilityChanged then uiHandlers.OnMinimapVisibilityChanged(true) end
end

function MDT:RefreshMinimapButton()
  if not db.minimap.hide then minimapIcon:Refresh(minimapKey, db.minimap) end
end

function MDT:SetCompartmentButtonShown(shown)
  db.minimap.compartmentHide = not shown
  if shown then
    if minimapIcon.AddButtonToCompartment then minimapIcon:AddButtonToCompartment(minimapKey) end
  else
    if minimapIcon.RemoveButtonFromCompartment then minimapIcon:RemoveButtonFromCompartment(minimapKey) end
  end
end

MDT:ExportAPI("HideMinimapButton")
MDT:ExportAPI("ShowMinimapButton")
MDT:ExportAPI("SetCompartmentButtonShown")

minimapIcon:Register(minimapKey, dataBroker, db.minimap)
if not db.minimap.hide then MDT:ShowMinimapButton() end
if not db.minimap.compartmentHide and minimapIcon.AddButtonToCompartment then minimapIcon:AddButtonToCompartment(minimapKey) end

local function buildFocusMarkerMacro(settings)
  local markerIndex = tonumber(settings.lastMarker) or 0
  local body = "/focus [@mouseover,exists,nodead][]"
  local conditionals = "[@focus]"
  local targetMarkerIndex = markerIndex
  if settings.disableTargetMarkerInRaid then
    body = body.."\n/stopmacro [group:raid]"
    conditionals = "[@focus,harm,exists]"
  end
  if markerIndex > 0 and settings.preserveExistingTargetMarkers then targetMarkerIndex = "~"..markerIndex end
  return body.."\n/tm "..conditionals.." "..targetMarkerIndex
end

local focusMarkerButton = CreateFrame("Button", "MDTFocusMarkerButton", UIParent, "SecureActionButtonTemplate")
focusMarkerButton:SetSize(1, 1)
focusMarkerButton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -100, -100)
focusMarkerButton:SetAlpha(0)
focusMarkerButton:EnableMouse(false)
focusMarkerButton:RegisterForClicks("AnyUp", "AnyDown")
focusMarkerButton:SetAttribute("type1", "macro")
focusMarkerButton:SetAttribute("macrotext1", buildFocusMarkerMacro(db.focusMarker))

local xalatathSoundFileIds = {
  1391165, 1391166, 2530794, 2530796, 2530797, 2530798, 2530811, 2530835, 5770084, 5770087, 5834632, 5835211,
  5835212, 5835214, 5835215, 5835725, 5835726, 5854705, 5859141, 6178475, 6178476, 6178477, 6178478, 6178479,
  6178480, 6178481, 6178488, 6178489, 6178494, 6178497, 6178498, 6178500, 6178502, 6178504, 6178506, 6178508,
}

function MDT:SetXalatathVoiceLinesMuted(muted)
  local updateSoundFile = muted and MuteSoundFile or UnmuteSoundFile
  for _, soundFileId in ipairs(xalatathSoundFileIds) do updateSoundFile(soundFileId) end
end

function MDT:ApplyXalatathVoiceLinesMute()
  if db.muteXalatathVoiceLines then MDT:SetXalatathVoiceLinesMuted(true) end
end

local dungeonResetAnnounceHooked
function MDT:EnableDungeonResetAnnounceHook()
  if dungeonResetAnnounceHooked then return end
  dungeonResetAnnounceHooked = true
  hooksecurefunc("ResetInstances", function()
    if not MDT:GetDB().announceDungeonReset then return end
    local message = MDT.L["dungeonResetAnnouncement"]
    if IsInRaid() then
      Compat:SendChatMessage(message, "RAID")
    elseif IsInGroup() then
      Compat:SendChatMessage(message, "PARTY")
    else
      print(message)
    end
  end)
end

function MDT:EnableEnemyForcesTooltip()
  -- Kept as a no-op for MDT-derived plugins; raid planning has no forces tooltip.
end

if db.announceDungeonReset then MDT:EnableDungeonResetAnnounceHook() end
if db.enemyForcesTooltip ~= 1 then MDT:EnableEnemyForcesTooltip() end

MDT:ExportAPI("SetXalatathVoiceLinesMuted")
MDT:ExportAPI("EnableDungeonResetAnnounceHook")
MDT:ExportAPI("EnableEnemyForcesTooltip")

MDT.presetCommPrefix = "MDTPreset"
MDT.versionCheckPrefix = "MDTVersion"
MDT.liveSessionPrefixes = {
  enabled = "MDTLiveEnabled",
  request = "MDTLiveReq",
  ping = "MDTLivePing",
  obj = "MDTLiveObj",
  objOff = "MDTLiveObjOff",
  objChg = "MDTLiveObjChg",
  cmd = "MDTLiveCmd",
  note = "MDTLiveNote",
  preset = "MDTLivePreset",
  pull = "MDTLivePull",
  free = "MDTLiveFree",
  bora = "MDTLiveBora",
  reqPre = "MDTLiveReqPre",
  difficulty = "MDTLiveLvl",
  poiAssignment = "MDTPOIAssignment",
  focusMarkerAssignment = "MDTFocusMark",
}

MDT.commsObject = MDT.commsObject or {}
local commsObject = MDT.commsObject
LibStub("AceComm-3.0"):Embed(commsObject)

function API:GetVersionCheckPrefix()
  return MDT.versionCheckPrefix
end

function API:GetPresetCommPrefix()
  return MDT.presetCommPrefix
end

function API:GetLiveSessionPrefixes()
  return CopyTable(MDT.liveSessionPrefixes)
end

function API:SendCommMessage(...)
  return commsObject:SendCommMessage(...)
end

local function onCommReceived(self, prefix, message, distribution, sender)
  if prefix == MDT.versionCheckPrefix then
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
  if prefix == MDT.presetCommPrefix then
    pendingPresetComms[#pendingPresetComms + 1] = { prefix, message, distribution, sender }
  end
end

commsObject.OnCommReceived = onCommReceived
commsObject:RegisterComm(MDT.presetCommPrefix)
commsObject:RegisterComm(MDT.versionCheckPrefix)
for _, prefix in pairs(MDT.liveSessionPrefixes) do commsObject:RegisterComm(prefix) end

local lastChatWarningAt = 0
local function checkChatframeInteractive(chatFrame)
  if chatFrame and chatFrame.isUninteractable and GetTime() - lastChatWarningAt >= 5 * 60 then
    lastChatWarningAt = GetTime()
    C_Timer.After(0.2, function()
      print("MDT: |cFFFF0000Warning!|r "..L["chatNoninteractiveWarning"])
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
    local start, finish, characterName, displayName = remaining:find("%[MDT_v2: ([^%s]+) %- ([^%]]+)%]")
    local startLive, finishLive, characterNameLive, displayNameLive = remaining:find("%[MDTLive: ([^%s]+) %- ([^%]]+)%]")
    if characterName and displayName then
      characterName = characterName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
      displayName = displayName:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
      newMsg = newMsg..remaining:sub(1, start - 1).."|cffe6cc80|Hgarrmission:mdt-"..characterName.."|h["..displayName.."]|h|r"
      remaining = remaining:sub(finish + 1)
      checkChatframeInteractive(chatFrame)
    elseif characterNameLive and displayNameLive then
      characterNameLive = characterNameLive:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
      displayNameLive = displayNameLive:gsub("|c[Ff][Ff]......", ""):gsub("|r", "")
      newMsg = newMsg..remaining:sub(1, startLive - 1).."|Hgarrmission:mdtlive-"..characterNameLive..
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
  if link and (link:sub(1, 19) == "garrmission:mdtlive" or link:sub(1, 15) == "garrmission:mdt") then
    callUIWithLoading("HandleChatLink", link, text)
  end
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("READY_CHECK")
eventFrame:SetScript("OnEvent", function(self, event)
  if event == "READY_CHECK" then
    if isUILoaded() then return end
    local settings = MDT:GetDB().focusMarker
    local markerIndex = tonumber(settings.lastMarker)
    if settings.announceReadyCheck and markerIndex and markerIndex >= 1 and markerIndex <= 8 and not IsInRaid() then
      Compat:SendChatMessage(MDT.L["focusMarkerChatAnnouncement"]:format(markerIndex), "PARTY")
    end
    return
  end

  MDT:RefreshMinimapButton()
  MDT:ApplyXalatathVoiceLinesMute()
  if db.loadOnStartUp and db.devMode then MDT:ShowInterface(true) end
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)
