local _, addon = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.


local function FireUnprotectedSlashCommand(command)
  local editbox = ChatEdit_ChooseBoxForSend(DEFAULT_CHAT_FRAME); -- Get an editbox
  ChatEdit_ActivateChat(editbox);                                -- Show the editbox
  editbox:SetText(command);                                      -- Command goes here
  -- Process command and hide (runs ChatEdit_SendText() and ChatEdit_DeactivateChat() respectively)
  ChatEdit_OnEnterPressed(editbox);
end

local function testFunc()
  if addon.main_frame and addon.main_frame:IsShown() then return end
  FireUnprotectedSlashCommand("/art")
end

---@type ARTTest
local test = {
  name = "Open AddOn",
  func = testFunc,
  duration = 2
}

tinsert(addon.test.testList, test)
