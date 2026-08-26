local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local function testFunc()
  local maximize = addon.main_frame.maximizeButton.MaximizeButton
  local minimize = addon.main_frame.maximizeButton.MinimizeButton

  C_Timer.After(0, function()
    maximize:Click()
  end)
  C_Timer.After(0.5, function()
    minimize:Click()
  end)
  C_Timer.After(1, function()
    maximize:Click()
  end)
  C_Timer.After(1.2, function()
    minimize:Click()
  end)
  C_Timer.After(1.3, function()
    maximize:Click()
  end)
  C_Timer.After(1.35, function()
    minimize:Click()
  end)
  C_Timer.After(1.4, function()
    maximize:Click()
  end)
  C_Timer.After(1.425, function()
    minimize:Click()
  end)
end

---@type ARTTest
local test = {
  name = "Maximize",
  func = testFunc,
  duration = 2
}

tinsert(addon.test.testList, test)
