local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local ART = addon

local function testFunc()
  local importPreset = CopyTable(ART:GetCurrentPreset())
  importPreset.text = importPreset.text.." (runtime import)"
  importPreset.uid = nil
  local importString = ART:TableToString(importPreset)
  local decoded = ART:StringToTable(importString, true)
  assert(type(decoded) == "table" and decoded.text == importPreset.text
      and decoded.value.currentRaidIndex == importPreset.value.currentRaidIndex, "Current import decoding failed")
  local frame = ART.main_frame
  frame.sidePanelImportButton.frame:Click()
  C_Timer.After(0.5, function()
    frame.presetImportBox:SetText(importString)
    frame.presetImportBox:HighlightText()
    frame.presetImportBox.OnTextChanged(nil, nil, importString)
    C_Timer.After(0.5, function()
      frame.presetImportButton.frame:Click()
      C_Timer.After(0.5, function()
        local importedPreset = ART:GetCurrentPreset()
        assert(importedPreset.text == importPreset.text
            and importedPreset.value.currentRaidIndex == importPreset.value.currentRaidIndex,
          "Import UI did not import current export")
      end)
    end)
  end)
end

---@type ARTTest
local test = {
  name = "Import Route",
  func = testFunc,
  duration = 2
}

tinsert(addon.test.testList, test)
