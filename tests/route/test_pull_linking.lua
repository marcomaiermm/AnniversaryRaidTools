local root = arg[1] or "."
local file = assert(io.open(root.."/Modules/RaidEnemies.lua", "rb"))
local source = file:read("*a")
file:close()

local definitionStart = assert(source:find("function ART:RaidEnemies_AddOrRemoveBlipToCurrentPull", 1, true))
local definitionEnd = assert(source:find("function ART:RaidEnemies_UpdateBlipColors", definitionStart, true))
local chunk = assert(loadstring(source:sub(definitionStart, definitionEnd - 1)))

local function blip(enemyIdx, group, pullGroup, sublevel)
  return {
    enemyIdx = enemyIdx,
    cloneIdx = 1,
    clone = { g = group, artPullGroup = pullGroup, sublevel = sublevel,
      artSpawnKey = "spawn-"..enemyIdx },
    IsEnabled = function() return true end,
  }
end

local first = blip(1, 1, "raid:pull-group:linked", 1)
local linked = blip(2, 2, "raid:pull-group:linked", 1)
local otherFloor = blip(3, 3, "raid:pull-group:linked", 2)
local storedPreset = { value = { currentPull = 1, pulls = {} } }
local reconciles = 0
local environment = {
  ART = {
    GetCurrentPreset = function() return storedPreset end,
    GetCurrentPull = function() return storedPreset.value.currentPull end,
  },
  preset = { value = { currentPull = 1, pulls = {} } },
  blips = { first, linked, otherFloor },
  isCloneConstrained = function() return false end,
  getLinkedBlips = function(selected)
    local matches = {}
    for _, candidate in ipairs({ first, linked, otherFloor }) do
      local samePack = selected.clone.g and candidate.clone.g == selected.clone.g
      local samePullGroup = selected.clone.artPullGroup == candidate.clone.artPullGroup
          and selected.clone.sublevel == candidate.clone.sublevel
      if samePack or samePullGroup then matches[#matches + 1] = candidate end
    end
    return matches
  end,
  pairs = pairs,
  tinsert = table.insert,
  tremove = table.remove,
  notifyLiveMarkPlanChanged = function() reconciles = reconciles + 1 end,
}
setfenv(chunk, setmetatable(environment, { __index = _G }))
chunk()

local pulls = {}
environment.ART:RaidEnemies_AddOrRemoveBlipToCurrentPull(first, true, false, pulls, 1, true)
assert(first.selected and linked.selected, "linked packs on the same floor must join the pull")
assert(not otherFloor.selected, "pull linking must not cross floors")
assert(#pulls[1][1] == 1 and #pulls[1][2] == 1 and pulls[1][3] == nil, "pull membership mismatch")

storedPreset.value.pulls[1] = {
  [1] = { 1 },
  artCCAssignments = { [first.clone.artSpawnKey] = { ccKey = "POLYMORPH" } },
}
environment.ART:RaidEnemies_AddOrRemoveBlipToCurrentPull(first, false, true)
assert(not storedPreset.value.pulls[1].artCCAssignments,
    "removing a mob from the pull removes its pull CC assignment")
assert(reconciles == 1, "stored pull membership changes refresh the assignment projection")

storedPreset.value.currentPull = 2
storedPreset.value.pulls = {
  [1] = { [1] = { 1 }, artCCAssignments = { [first.clone.artSpawnKey] = { ccKey = "POLYMORPH" } } },
  [2] = {},
}
environment.ART:RaidEnemies_AddOrRemoveBlipToCurrentPull(first, true, true)
assert(not storedPreset.value.pulls[1].artCCAssignments,
    "moving a mob to another pull removes its old pull CC assignment")
assert(reconciles == 2)

print("pull linking checks passed")
