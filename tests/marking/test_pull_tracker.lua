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

local db = { currentRaidIndex = 164 }
local currentPreset = { value = { currentPull = 2, pulls = { {}, {}, {} } } }
ART.mapInfo = { [164] = { mapID = 544 } }
function ART:GetDB() return db end
function ART:GetCurrentPreset() return currentPreset end
assert(loadfile(root.."/Modules/RaidMarksUI.lua"))("AnniversaryRaidTools", ART)

db.showPullTracker = false
assert(ART.RaidMarksUI:RefreshPullTracker() == nil, "disabled tracker stays hidden on refresh")
ART.RaidMarksUI:SetPullTrackerShown(true)
assert(db.showPullTracker == true, "tracker visibility setting can re-enable it")

local model = assert(ART.RaidMarksUI:GetPullTrackerModel())
assert(model.raidName == "Magtheridon's Lair")
assert(model.pullIndex == 2 and model.totalPulls == 3 and model.nextPullIndex == 3)
assert(model.marks[1].marker == 8 and model.marks[1].name == "Hellfire Channeler")
assert(model.marks[2].marker == 5 and model.marks[2].name == "Hellfire Warder")

ART.RaidPlanner.lastPullIndex = nil
currentPreset.value.currentPull = 1
currentPreset.value.pulls = { {} }
model = assert(ART.RaidMarksUI:GetPullTrackerModel())
assert(model.pullIndex == 2 and model.totalPulls == 3,
    "passive floor changes must not advance the pull tracker")

local waves = {}
for index = 1, 37 do waves[index] = {} end
raid.key, raid.name, raid.mapId, raid.mode, raid.waves = "hyjal", "Hyjal Summit", 534, "waves", waves
ART.MapDefinitions = { hyjal = { waveMode = { groups = {
  { label = "Rage Winterchill", firstWave = 1, lastWave = 9 },
  { label = "Anetheron", firstWave = 10, lastWave = 18 },
  { label = "Kaz'rogal", firstWave = 19, lastWave = 27 },
  { label = "Azgalor", firstWave = 28, lastWave = 36 },
  { label = "Archimonde", firstWave = 37, lastWave = 37 },
} } } }
db.currentRaidIndex = 162
ART.mapInfo[162] = { mapID = 534 }
ART.RaidPlanner.lastPullIndex = 3
model = assert(ART.RaidMarksUI:GetPullTrackerModel())
assert(model.mode == "waves" and model.currentLabel == "Rage Winterchill")
assert(model.currentText == "Wave 3 / 37" and model.nextText == "NEXT  Wave 4  >",
    "Hyjal tracker presents wave progress instead of pull progress")
assert(model.showNext == false, "automatic wave mode hides the tracker Next button")

ART.PullClickAreaOnLeave = function() end
assert(loadfile(root.."/Modules/Pulls.lua"))("AnniversaryRaidTools", ART)
ART:SetSelectionToPull(3)
assert(currentPreset.value.currentPull == 3 and currentPreset.value.selection[1] == 3,
    "pull selection works without the main planner frame")

db.currentRaidIndex = 1
ART.mapInfo[1] = { mapID = 999 }
assert(ART.RaidMarksUI:GetPullTrackerModel() == nil, "tracker hides outside the active raid")

print("pull tracker checks passed")
