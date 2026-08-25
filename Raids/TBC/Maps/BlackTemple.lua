-- Black Temple client-map inventory; floor alignment remains candidate for 20505/20506.
local addonName, addon = ...
local ART = rawget(_G, "ART")
if not ART then
  ART = addon and addon.ART or addon or {}
  _G.ART = ART
end
if addon and addon.ART == nil then addon.ART = ART end

local source = {
  source = "client-data",
  confidence = "high",
  sourceRef = "https://warcraft.wiki.gg/wiki/UiMapID | https://static.wikia.nocookie.net/wowwiki/images/6/65/WorldMap-BlackTemple.jpg/revision/latest/scale-to-width-down/1000?cb=20110628010432",
  observedAt = "2026-08-21T20:50:00Z",
}

local floors = {
  { "Karabor Sewers", 340 },
  { "Illidari Training Grounds", 339 },
  { "Sanctuary of Shadows", 341 },
  { "Halls of Anguish", 342 },
  { "Gorefiend's Vigil", 343 },
  { "Den of Mortal Delights", 344 },
  { "Chamber of Command", 345 },
  { "Temple Summit", 346 },
}

local clientTextureFloors = { 1, nil, 2, 3, 4, 5, 6, 7 }
local trainingGroundsTextures = "Interface\\AddOns\\"..addonName.."\\Raids\\TBC\\Textures\\BlackTempleTrainingGrounds"

local sublevels = {}
for index, floor in ipairs(floors) do
  local clientTextureFloor = clientTextureFloors[index]
  sublevels[index] = {
    index = index,
    mapId = 564,
    uiMapId = floor[2],
    name = floor[1],
    transformKey = "black-temple:transform:"..index,
    asset = {
      kind = clientTextureFloor and "client-map" or "custom-map",
      mapId = 564,
      textureFolder = "BlackTemple",
      texturePrefix = clientTextureFloor and "BlackTemple"..clientTextureFloor.."_" or nil,
      customTextures = not clientTextureFloor and trainingGroundsTextures or nil,
      uiMapId = floor[2],
      source = source,
    },
    source = source,
  }
end

local map = {
  schemaVersion = 1,
  raidKey = "black-temple",
  instanceId = 564,
  mapId = 564,
  links = {
    [1] = {
      { x = 0.279, y = 0.088, target = 2, direction = -1 },
    },
    [2] = {
      { x = 0.279, y = 0.780, target = 1, direction = 1 },
      { x = 0.690, y = 0.475, target = 3, direction = 2 },
    },
    [3] = {
      { x = 0.269, y = 0.228, target = 6, direction = 1 },
      { x = 0.632, y = 0.349, target = 4, direction = 2 },
      { x = 0.233, y = 0.516, target = 2, direction = -2 },
      { x = 0.574, y = 0.921, target = 5, direction = -2 },
    },
    [4] = {
      { x = 0.623, y = 0.398, target = 3, direction = -2 },
    },
    [5] = {
      { x = 0.690, y = 0.689, target = 3, direction = 2 },
    },
    [6] = {
      { x = 0.084, y = 0.471, target = 3, direction = -1 },
      { x = 0.673, y = 0.581, target = 7, direction = 1 },
    },
    [7] = {
      { x = 0.694, y = 0.126, target = 6, direction = -1 },
      { x = 0.475, y = 0.271, target = 8, direction = -1 },
    },
    [8] = {
      { x = 0.530, y = 0.103, target = 7, direction = -1 },
    },
  },
  source = source,
  sublevels = sublevels,
}

ART.MapDefinitions = ART.MapDefinitions or {}
ART.MapDefinitions[map.raidKey] = map
return map
