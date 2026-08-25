local root = assert(arg[1])
local constructor
local AceGUI = {
  RegisterWidgetType = function(_, _, callback) constructor = callback end,
}
function LibStub(name) assert(name == "AceGUI-3.0"); return AceGUI end
function SetPortraitTextureFromCreatureDisplayID() end

local ART = { L = {} }
assert(loadfile(root.."/AceGUIWidgets/AceGUIWidget-AnniversaryRaidToolsPullButton.lua"))(
  "AnniversaryRaidTools", ART)
assert(type(constructor) == "function")

local methods
for index = 1, 20 do
  local _, value = debug.getupvalue(constructor, index)
  if type(value) == "table" and type(value.SetNPCData) == "function" then methods = value break end
end
assert(methods, "pull button methods are unavailable")

local function region()
  return {
    Hide = function() end,
    Show = function() end,
    SetTexture = function() end,
    SetText = function(self, text) self.text = text end,
  }
end
local portraits = {}
for index = 1, 2 do
  portraits[index] = region()
  portraits[index].overlay = region()
  portraits[index].fontString = region()
end
local button = { enemyPortraits = portraits, UpdateCountText = function() end }
methods.SetNPCData(button, {
  { quantity = 1, displayId = 1 },
  { quantity = 3, displayId = 2 },
})
assert(portraits[1].enemyData.quantity == 3, "pull portraits sort by quantity without enemy-force data")

local file = assert(io.open(root.."/Modules/ErrorHandling.lua", "rb"))
local errorHandling = file:read("*a")
file:close()
assert(not errorHandling:find("externalButtonGroup", 1, true),
  "error handling must not depend on the removed external-links controls")

print("cleanup regression checks passed")
