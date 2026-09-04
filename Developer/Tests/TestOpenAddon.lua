local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local function testFunc()
  if not addon:AreFramesInitialized() then
    addon:ShowInterface()
    return
  end
  if addon.main_frame:IsShown() then return end
  addon:ShowInterface()
end

---@type ARTTest
local test = {
  name = "Open AddOn",
  func = testFunc,
  duration = 2
}

tinsert(addon.test.testList, test)
