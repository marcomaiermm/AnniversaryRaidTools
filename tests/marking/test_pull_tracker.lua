local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART

local raid = {
  name = "Magtheridon's Lair", mapId = 544,
  enemies = {
    ["17256"] = { name = "Hellfire Channeler", spawns = { { key = "channeler" } } },
    ["18829"] = { name = "Hellfire Warder", spawns = { { key = "warder" } } },
  },
}
local step = { marks = { channeler = 8, warder = 5 } }
ART.RaidPlanner = {
  raid = raid, preset = {}, lastPullIndex = 2,
  GetActiveStep = function() return step end,
}

local db = { currentDungeonIdx = 164 }
local currentPreset = { value = { currentPull = 2, pulls = { {}, {}, {} } } }
local addon = {
  ART = ART,
  mapInfo = { [164] = { mapID = 544 } },
  GetDB = function() return db end,
  GetCurrentPreset = function() return currentPreset end,
}
assert(loadfile(root.."/Modules/RaidMarksUI.lua"))("AnniversaryRaidTools", addon)

local model = assert(ART.RaidMarksUI:GetPullTrackerModel())
assert(model.raidName == "Magtheridon's Lair")
assert(model.pullIndex == 2 and model.totalPulls == 3 and model.nextPullIndex == 3)
assert(model.marks[1].marker == 8 and model.marks[1].name == "Hellfire Channeler")
assert(model.marks[2].marker == 5 and model.marks[2].name == "Hellfire Warder")

addon.PullClickAreaOnLeave = function() end
assert(loadfile(root.."/Modules/Pulls.lua"))("AnniversaryRaidTools", addon)
addon:SetSelectionToPull(3)
assert(currentPreset.value.currentPull == 3 and currentPreset.value.selection[1] == 3,
    "pull selection works without the main planner frame")

db.currentDungeonIdx = 1
addon.mapInfo[1] = { mapID = 999 }
assert(ART.RaidMarksUI:GetPullTrackerModel() == nil, "tracker hides outside the active raid")

print("pull tracker checks passed")
