local root = arg and arg[1] or "."
local file = assert(io.open(root.."/Modules/PresetObjects.lua", "rb"))
local source = file:read("*a")
file:close()

local definitionStart = assert(source:find("local function POIButton_CalculateNumericTexCoords", 1, true))
local definition = "local noteFramePool\n"..source:sub(definitionStart)
local chunk = assert(loadstring(definition))
local dispatchStart = assert(source:find("function ART:DrawPresetObject", 1, true))
local dispatchEnd = assert(source:find("\n\n---Deletes objects", dispatchStart, true))
local dispatchChunk = assert(loadstring(source:sub(dispatchStart, dispatchEnd - 1)))

local function texture()
  local value = {}
  for _, method in ipairs({ "SetPoint", "SetSize", "SetTexture", "SetTexCoord", "Show" }) do
    value[method] = function(self, ...) self[method] = { ... } end
  end
  return value
end

local note = {}
for _, method in ipairs({ "ClearAllPoints", "SetPoint", "SetSize", "RegisterForClicks", "SetScript", "Show" }) do
  note[method] = function() end
end
for _, kind in ipairs({ "Normal", "Highlight", "Pushed" }) do
  note["Get"..kind.."Texture"] = function(self) return self[string.lower(kind).."Texture"] end
  note["Set"..kind.."Texture"] = function(self, value) self[string.lower(kind).."Texture"] = value end
end
function note:CreateTexture()
  local value = texture()
  self.createdTextures = self.createdTextures or {}
  self.createdTextures[#self.createdTextures + 1] = value
  return value
end
local ART = {
  main_frame = { mapPanelFrame = {}, mapPanelTile1 = {} },
  GetScale = function() return 1 end,
  HexToRGB = function() return 1, 1, 1 end,
  DrawLine = function(self) self.drawingDrawn = true end,
  CreateFramePool = function()
    return { active = { note }, Acquire = function() return note end }
  end,
}
local environment = {
  ART = ART,
  floor = math.floor,
  mod = math.fmod,
  ipairs = ipairs,
  CloseDropDownMenus = function() end,
  GameTooltip = { SetOwner = function() end, AddLine = function() end, Show = function() end, Hide = function() end },
}
setfenv(chunk, setmetatable(environment, { __index = _G }))
setfenv(dispatchChunk, setmetatable(environment, { __index = _G }))
chunk()
dispatchChunk()

local drawing = { d = { 5, 1, 2, true, "ffffff" }, l = { 1, 2, 3, 4 } }
local importedNote = { n = true, d = { 10, 20, 2, true, "Imported note" } }
local preset = { objects = { drawing, importedNote } }
ART:DrawPresetObject(drawing, 1, 1, preset, 2)
ART:DrawPresetObject(importedNote, 2, 1, preset, 2)
assert(ART.drawingDrawn, "drawings remain independent from note texture setup")

assert(note.normalTexture and note.highlightTexture and note.pushedTexture,
  "notes without QuestPinTemplate textures create owned button textures")
assert(note.artNumberTexture, "notes without Display.Icon use an owned number texture")
assert(note.artNumberTexture.SetTexture[1] == "Interface/WorldMap/UI-QuestPoi-NumberIcons")
assert(note.artNumberTexture.Show, "fallback number texture is shown")

print("preset note checks passed")
