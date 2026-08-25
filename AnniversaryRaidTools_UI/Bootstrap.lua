local addonName, ART = ...
local API = assert(_G.AnniversaryRaidToolsAPI,
  "Anniversary Raid Tools UI requires Anniversary Raid Tools")

ART.UIAddonName = addonName
ART.AddonName = API:GetAddonName()
ART.AddonPath = API:GetAddonPath()
ART.BackdropColor = { API:GetBackdropColor() }
ART.L = setmetatable({}, { __index = function(_, key) return key end })
ART.presetCommPrefix = API:GetPresetCommPrefix()
ART.versionCheckPrefix = API:GetVersionCheckPrefix()
ART.liveSessionPrefixes = API:GetLiveSessionPrefixes()
ART.commsObject = {
  SendCommMessage = function(_, ...)
    return API:SendCommMessage(...)
  end,
}

setmetatable(ART, { __index = API })

local pluginAPI = {}

function pluginAPI:RegisterNavigationSection(section)
  return ART:RegisterNavigationSection(section)
end

function pluginAPI:GetCurrentSection()
  return ART:GetCurrentSection()
end

function pluginAPI:SetCurrentSection(sectionKey)
  return ART:SetCurrentSection(sectionKey)
end

function pluginAPI:GetNavigationSectionContentFrame(sectionKey)
  local frames = ART.main_frame and ART.main_frame.sectionContentFrames
  return frames and frames[sectionKey]
end

function pluginAPI:HideAllDialogs()
  return ART:HideAllDialogs()
end

function ART:AttachCoreAPI()
  API:AttachUI({
    ShowInterface = function(...) return ART:ShowInterface(...) end,
    HandleSlashCommand = function(...) return ART:HandleSlashCommand(...) end,
    HandleChatLink = function(...) return ART:HandleChatLink(...) end,
    OnCommReceived = function(...) return ART.commsObject:OnCommReceived(...) end,
    GetRaidName = function(...) return ART:GetRaidName(...) end,
    GetRaidFloors = function(...) return ART:GetRaidFloors(...) end,
    OnMinimapVisibilityChanged = function(shown)
      local checkbox = ART.main_frame and ART.main_frame.minimapCheckbox
      if checkbox then checkbox:SetValue(shown) end
    end,
  }, pluginAPI)
end
