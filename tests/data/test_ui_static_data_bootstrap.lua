local API = {
  GetAddonName = function() return "AnniversaryRaidTools" end,
  GetAddonPath = function() return "Interface\\AddOns\\AnniversaryRaidTools\\" end,
  GetBackdropColor = function() return 0, 0, 0, 1 end,
  GetPresetCommPrefix = function() return "ART" end,
  GetVersionCheckPrefix = function() return "ART_VERSION" end,
  GetLiveSessionPrefixes = function() return {} end,
}

_G.AnniversaryRaidToolsAPI = API

local ART = {}
assert(loadfile("AnniversaryRaidTools_UI/Bootstrap.lua"))("AnniversaryRaidTools_UI", ART)

assert(type(ART.StaticData) == "table", "UI bootstrap must initialize StaticData")
assert(type(ART.StaticData.raids) == "table", "UI bootstrap must initialize the raid bucket")
assert(type(ART.StaticData.enemyInfo) == "table", "UI bootstrap must initialize the enemy-info bucket")

assert(loadfile("Raids/TBC/Generated/GruulsLair.lua"))("AnniversaryRaidTools_UI", ART)
assert(ART.StaticData.raids["gruuls-lair"], "generated raid data must publish after UI bootstrap")
