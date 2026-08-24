local root = arg[1] or "."
local file = assert(io.open(root.."/Modules/DungeonEnemies.lua", "rb"))
local source = file:read("*a")
file:close()

local definitionStart = assert(source:find("local blipScaleAnimations", 1, true))
local definitionEnd = assert(source:find("function MDT:DoFramesOverlap", definitionStart, true))
local definition = source:sub(definitionStart, definitionEnd - 1)
local chunk = assert(loadstring(definition))
local mapTile = {}
local frames = {}
local function blip(index)
  local item = { enemyIdx = index, cloneIdx = 1, data = {}, clone = { x = 0, y = 0 }, x = 0, y = 0 }
  item.GetWidth = function() return 13 end
  item.IsShown, item.IsEnabled = function() return true end, function() return true end
  item.GetPoint = function(self) return "CENTER", mapTile, "TOPLEFT", self.x, self.y end
  item.ClearAllPoints = function() end
  item.SetPoint = function(self, _, _, _, x, y) self.x, self.y = x, y end
  return item
end
local anchor, other = blip(1), blip(2)
local environment
environment = {
  blips = { anchor, other },
  MANUAL_EXPLOSION_RADIUS = 10,
  MANUAL_EXPLOSION_GAP = 1,
  MANUAL_EXPLOSION_ANIMATION_DURATION = 0.12,
  HOVER_SCALE_ANIMATION_DURATION = 0.12,
  MDT = {
    main_frame = { mapPanelTile1 = mapTile },
    GetScale = function() return 1 end,
    DoFramesOverlap = function(_, left, right) return left ~= right end,
  },
  max = math.max,
  pairs = pairs,
  ipairs = ipairs,
  tonumber = tonumber,
  table = table,
  math = math,
  unpack = unpack,
  abs = math.abs,
  min = math.min,
  next = next,
  IsShiftKeyDown = function() return environment.shiftDown end,
  CreateFrame = function()
    local frame = {}
    frame.SetScript = function(self, name, callback) self[name] = callback end
    frame.RegisterEvent = function() end
    frame.Show, frame.Hide = function() end, function() end
    frames[#frames + 1] = frame
    return frame
  end,
}
setfenv(chunk, setmetatable(environment, { __index = _G }))
chunk()

environment.MDT:SetManualExplosionHover(anchor)
environment.shiftDown = true
frames[1].OnEvent(nil, nil, "LSHIFT", 1)
frames[2].OnUpdate(nil, 0.12)
assert(other.x ~= 0 or other.y ~= 0, "holding shift must separate overlapping blips")

local explodedX, explodedY = other.x, other.y
assert(source:find("local explosionItem = manualExplosion and manualExplosion.members[self]", 1, true),
  "blip refresh must preserve the exploded position")

environment.shiftDown = false
frames[1].OnEvent(nil, nil, "LSHIFT", 0)
frames[2].OnUpdate(nil, 0.12)
assert(other.x == 0 and other.y == 0, "releasing shift must restore original positions")
assert(not source:find('button == "MiddleButton"', 1, true), "middle click must not trigger explosion")
assert(not source:find('(button == "LeftButton" and IsShiftKeyDown())', 1, true), "shift-click must not trigger explosion")

print("manual explosion checks passed")
