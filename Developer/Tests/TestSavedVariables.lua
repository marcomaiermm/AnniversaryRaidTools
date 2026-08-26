local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local function testFunc()
  local defaults = addon:GetDefaultSavedVariables()

  assert(type(defaults) == "table", "SavedVariables defaults missing")
  assert(type(defaults.global) == "table", "SavedVariables global defaults missing")
  assert(defaults.global.currentRaidIndex == 160, "Unexpected default raid")
  assert(defaults.global.presets[1] ~= defaults.global.presets[2], "Raid preset lists share a table")
  assert(defaults.global.presets[1][1] ~= defaults.global.presets[2][1], "Default presets share a table")
  assert(defaults.global.presets[1][1].value ~= defaults.global.presets[2][1].value,
    "Default preset values share a table")
  assert(addon:GetDB() == AnniversaryRaidToolsDB.global, "GetDB returned unexpected table")
end

---@type ARTTest
local test = {
  name = "SavedVariables",
  func = testFunc,
  duration = 0,
}

tinsert(addon.test.testList, test)
