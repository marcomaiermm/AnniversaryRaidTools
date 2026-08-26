local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local ART = addon

local function testFunc()
  local frame = ART.main_frame
  local deleteButton = frame.sidePanelDeleteButton.frame
  local okayButton = frame.DeleteConfirmationFrame.OkayButton.frame
  deleteButton:Click()
  C_Timer.After(0.5, function()
    okayButton:Click()
  end)
end

---@type ARTTest
local test = {
  name = "Delete Route",
  func = testFunc,
  duration = 1
}

tinsert(addon.test.testList, test)
