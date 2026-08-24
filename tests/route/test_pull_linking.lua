local root = arg[1] or "."
local file = assert(io.open(root.."/Modules/DungeonEnemies.lua", "rb"))
local source = file:read("*a")
file:close()

local definitionStart = assert(source:find("function MDT:DungeonEnemies_AddOrRemoveBlipToCurrentPull", 1, true))
local definitionEnd = assert(source:find("function MDT:DungeonEnemies_UpdateBlipColors", definitionStart, true))
local chunk = assert(loadstring(source:sub(definitionStart, definitionEnd - 1)))

local function blip(enemyIdx, group, pullGroup, sublevel)
  return {
    enemyIdx = enemyIdx,
    cloneIdx = 1,
    clone = { g = group, artPullGroup = pullGroup, sublevel = sublevel },
    IsEnabled = function() return true end,
  }
end

local first = blip(1, 1, "raid:pull-group:linked", 1)
local linked = blip(2, 2, "raid:pull-group:linked", 1)
local otherFloor = blip(3, 3, "raid:pull-group:linked", 2)
local environment = {
  MDT = { GetCurrentPreset = function() return { value = { currentPull = 1, pulls = {} } } end },
  preset = { value = { currentPull = 1, pulls = {} } },
  blips = { first, linked, otherFloor },
  isCloneConstrained = function() return false end,
  pairs = pairs,
  tinsert = table.insert,
  tremove = table.remove,
}
setfenv(chunk, setmetatable(environment, { __index = _G }))
chunk()

local pulls = {}
environment.MDT:DungeonEnemies_AddOrRemoveBlipToCurrentPull(first, true, false, pulls, 1, true)
assert(first.selected and linked.selected, "linked packs on the same floor must join the pull")
assert(not otherFloor.selected, "pull linking must not cross floors")
assert(#pulls[1][1] == 1 and #pulls[1][2] == 1 and pulls[1][3] == nil, "pull membership mismatch")

print("pull linking checks passed")
