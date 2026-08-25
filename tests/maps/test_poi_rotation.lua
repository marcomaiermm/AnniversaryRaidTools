local root = arg and arg[1] or "."

table.wipe = table.wipe or function(value)
  for key in pairs(value) do value[key] = nil end
end

local function texture()
  local value = { width = 10, height = 10 }
  for _, method in ipairs({ "Hide", "Show", "SetAtlas", "SetDesaturated", "SetDrawLayer", "SetVertexColor" }) do
    value[method] = function() end
  end
  function value:GetHeight() return self.height end
  function value:GetWidth() return self.width end
  function value:SetSize(width, height) self.width, self.height = width, height end
  function value:SetRotation(rotation) self.rotation = rotation end
  return value
end

local frame = { Texture = texture(), HighlightTexture = texture(), width = 10, height = 10 }
for _, method in ipairs({ "ClearAllPoints", "SetFrameLevel", "SetMovable", "SetPoint", "SetScript", "Show" }) do
  frame[method] = function() end
end
function frame:GetHeight() return self.height end
function frame:GetWidth() return self.width end
function frame:SetSize(width, height) self.width, self.height = width, height end

local pool = { ReleaseAll = function() end, Acquire = function() return frame end }
local db = { currentRaidIndex = 162 }
local ART = {
  L = setmetatable({}, { __index = function(_, key) return key end }),
  main_frame = { mapPanelTile1 = {} },
  mapPOIs = { [162] = { [1] = {} } },
  GetDB = function() return db end,
  GetCurrentSubLevel = function() return 1 end,
  GetFramePool = function() return pool end,
  GetScale = function() return 1 end,
}

assert(loadfile(root.."/Modules/Pointsofinterest.lua"))("AnniversaryRaidTools", ART)

ART.mapPOIs[162][1][1] = {
  x = 100, y = -100, target = 1, direction = 1, arrowAtlas = "Garr_LevelUpgradeArrow",
  arrowRotation = math.pi, type = "mapLink",
}
ART:POI_UpdateAll()
assert(frame.Texture.rotation == math.pi and frame.HighlightTexture.rotation == math.pi)

ART.mapPOIs[162][1][1] = { x = 100, y = -100, type = "generalNote", text = "Alliance Base" }
ART:POI_UpdateAll()
assert(frame.Texture.rotation == 0 and frame.HighlightTexture.rotation == 0,
  "pooled general-note textures reset map-link rotation")

print("POI rotation reset: ok")
