local _, addon = ...
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
