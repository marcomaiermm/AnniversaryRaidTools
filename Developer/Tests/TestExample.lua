local _, addon = ...

local function testFunc()

end

---@type ARTTest
local test = {
  name = "Example",
  func = testFunc,
  duration = 4
}

tinsert(addon.test.testList, test)
