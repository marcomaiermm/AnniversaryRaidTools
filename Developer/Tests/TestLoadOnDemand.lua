local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local function testFunc()
  local loadedOrLoading, loaded = C_AddOns.IsAddOnLoaded("AnniversaryRaidTools_UI")
  if loaded == nil then loaded = loadedOrLoading end

  assert(C_AddOns.IsAddOnLoadOnDemand("AnniversaryRaidTools_UI"), "UI addon is not load-on-demand")
  assert(loaded, "UI addon is not loaded")
  assert(_G.ART == nil, "Legacy ART compatibility global still exists")
  assert(type(_G.AnniversaryRaidToolsAPI) == "table", "Public ART API is missing")
  assert(addon ~= _G.AnniversaryRaidToolsAPI, "UI table is not private")
  assert(getmetatable(addon).__index == _G.AnniversaryRaidToolsAPI, "UI API bridge is missing")
  assert(type(_G.AnniversaryRaidToolsAPI.ShowInterface) == "function", "Public UI loader is missing")
  assert(type(_G.AnniversaryRaidToolsAPI.GetDB) == "function", "Core database API is missing")
  assert(type(_G.AnniversaryRaidToolsAPI.RegisterUIInitializer) == "function", "Deferred UI initializer API is missing")
  assert(type(addon.HandleChatLink) == "function", "Chat-link bridge is missing")
  assert(_G.AnniversaryRaidToolsAPI.InitializeRuntime == nil, "Private UI method leaked through the API")

  local initialized
  _G.AnniversaryRaidToolsAPI:RegisterUIInitializer(function(pluginAPI)
    initialized = true
    assert(pluginAPI ~= addon, "Plugin API exposes the UI addon table")
    assert(pluginAPI.InitializeRuntime == nil, "Private UI method leaked through the plugin API")
    assert(type(pluginAPI.RegisterNavigationSection) == "function", "Navigation plugin bridge is missing")
  end)
  assert(initialized, "UI initializer did not run after UI attachment")
end

---@type ARTTest
local test = {
  name = "Load-on-demand UI",
  func = testFunc,
  duration = 0,
}

tinsert(addon.test.testList, test)
