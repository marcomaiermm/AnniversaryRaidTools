local UIAddonName, ART = ...
local L = ART.L

local pairs, CreateFrame = pairs, CreateFrame

local asyncConfig = {
  type = "everyFrame",
  maxTime = 40,
  maxTimeCombat = 8,
  errorHandler = function(msg, stackTrace, name)
    ART:OnError(msg, stackTrace, name)
  end,
}
ART.asyncHandler = LibStub("LibAsync"):GetHandler(asyncConfig)

function ART:Async(func, name, singleton)
  ART.asyncHandler:Async(func, name, singleton)
end

function ART:CancelAsync(name)
  ART.asyncHandler:CancelAsync(name)
end

local db
function ART:HandleSlashCommand(cmd, editbox)
  cmd = cmd:lower()
  local rqst, arg = strsplit(' ', cmd)
  if rqst == "devmode" then
    if ART.ToggleDevMode then ART:ToggleDevMode() end
  elseif rqst == "reset" then
    ART:ResetMainFramePos()
  elseif rqst == "hardreset" then
    if arg == "force" then
      ART:HardReset()
    else
      ART:Async(function()
        ART:OpenConfirmationFrame(450, 150, L["hardResetPromptTitle"], L["Delete"], L["hardResetPrompt"], ART.HardReset)
      end, "hardReset")
    end
  elseif rqst == "minimap" then
    if db.minimap.hide then
      ART:ShowMinimapButton()
    else
      ART:HideMinimapButton()
    end
  elseif rqst == "test" then
    if ART.test and ART.test.RunAllTests then
      ART:OpenConfirmationFrame(450, 150, "ART Test", "Run", "Run all tests?", ART.test.RunAllTests)
    end
  else
    ART:Async(function() ART:ShowInterfaceInternal() end, "showInterface")
  end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:SetScript("OnEvent", function(self, event, ...)
  if event == "ADDON_LOADED" then
    local addon = ...
    if addon ~= UIAddonName then return end
    ART:AttachCoreAPI()
    db = ART:InitializeRuntime()
    self:UnregisterEvent("ADDON_LOADED")
  elseif event == "GROUP_ROSTER_UPDATE" then
    ART.GROUP_ROSTER_UPDATE()
  end
end)

local last = 0
function ART.GROUP_ROSTER_UPDATE()
  --check not more than once per second (blizzard event spam)
  local now = GetTime()
  if last < now - 1 then
    if not ART.main_frame then return end
    local inGroup = UnitInRaid("player") or IsInGroup()
    ART.main_frame.LinkToChatButton:SetDisabled(not inGroup)
    ART.main_frame.LiveSessionButton:SetDisabled(not inGroup)
    if inGroup then
      ART.main_frame.LinkToChatButton.text:SetTextColor(1, 0.8196, 0)
      if ART.liveSessionActive then
        ART.main_frame.LiveSessionButton:SetText(L["*Live*"])
        ART.main_frame.LiveSessionButton.text:SetTextColor(0, 1, 0)
      else
        ART.main_frame.LiveSessionButton:SetText(L["Live"])
        ART.main_frame.LiveSessionButton.text:SetTextColor(1, 0.8196, 0)
      end
    else
      ART.main_frame.LinkToChatButton.text:SetTextColor(0.5, 0.5, 0.5)
      ART.main_frame.LiveSessionButton.text:SetTextColor(0.5, 0.5, 0.5)
    end
    last = now
  end
end

local initStarted
function ART:StartMainFrameInitialization()
  if initStarted then return end
  initStarted = true
  for _, module in pairs(ART.modules) do
    if module.OnInitialize then
      module:OnInitialize()
    end
  end
  ART:RegisterErrorHandledFunctions()
  -- request spell info for all teleports, so icons are instantly working
  for _, mapInfo in pairs(ART.mapInfo) do
    if mapInfo.teleportId then
      ART.Compat:RequestLoadSpellData(mapInfo.teleportId)
    end
  end

  ART:InitializeMainFrame()
end
