local addonName, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local API = {}
_G.AnniversaryRaidToolsAPI = API

ART.API = API
ART.AddonName = addonName
ART.L = setmetatable({
  ["Click to toggle AddOn Window"] = "Click to toggle AddOn Window",
  ["chatNoninteractiveWarning"] = "Chat frame is currently set to noninteractive, you will not be able to click on ART routes.",
  ["combatLoggingStarted"] = "Started combat logging.",
  ["combatLoggingStopped"] = "Ended combat logging.",
  ["instanceResetAnnouncement"] = "<Instances have been reset!>",
  ["incompatibleVersionError"] = "This version of World of Warcraft is not compatible with Anniversary Raid Tools.",
  ["Middle-click to disable Minimap Button"] = "Middle-click to disable Minimap Button",
  ["Right-click to lock Minimap Button"] = "Right-click to lock Minimap Button",
  ["Toggle ART"] = "Toggle ART",
}, {
  __index = function(_, key)
    return key
  end,
})

function ART:IsCompatibleVersion()
  local interface = select(4, GetBuildInfo())
  return interface == 20505 or interface == 20506
end

function ART:ShowFallbackWindow()
  local gameVersionString = GetBuildInfo()
  local getMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
  local addonVersionString = getMetadata and getMetadata(addonName, "Version") or "unknown"
  StaticPopupDialogs.ART_INCOMPATIBLE_VERSION = {
    text = ART.L["incompatibleVersionError"].."\n\nGame: "..gameVersionString.."\nART: "..addonVersionString,
    button1 = OKAY,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
  }
  StaticPopup_Show("ART_INCOMPATIBLE_VERSION")
end

function ART:ExportAPI(methodName)
  API[methodName] = function(_, ...)
    return ART[methodName](ART, ...)
  end
end

function API:GetAddonName()
  return addonName
end

function API:GetAddonPath()
  return "Interface\\AddOns\\"..addonName.."\\"
end

ART:ExportAPI("IsCompatibleVersion")
ART:ExportAPI("ShowFallbackWindow")
