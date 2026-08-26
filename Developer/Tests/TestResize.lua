local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local function testFunc()
  local resizer = addon.main_frame.resizer
  local onMouseDown = resizer:GetScript("OnMouseDown")
  local onMouseUp = resizer:GetScript("OnMouseUp")
  C_Timer.After(0, function()
    onMouseDown()
  end)
  C_Timer.After(0.5, function()
    onMouseUp()
  end)
  C_Timer.After(1, function()
    onMouseDown()
  end)
  C_Timer.After(1.2, function()
    onMouseUp()
  end)
  C_Timer.After(1.3, function()
    onMouseDown()
  end)
  C_Timer.After(1.35, function()
    onMouseUp()
  end)
end

---@type ARTTest
local test = {
  name = "Resize",
  func = testFunc,
  duration = 2
}

tinsert(addon.test.testList, test)
