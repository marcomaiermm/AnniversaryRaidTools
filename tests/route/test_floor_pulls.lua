local root = arg[1] or "."
local ART = {
  raidEnemies = {
    [1] = {
      [1] = { clones = {
        [1] = { sublevel = 1, artSpawnKey = "floor-1" },
        [2] = { sublevel = 2, artSpawnKey = "floor-2" },
      } },
      [2] = { clones = { [1] = { sublevel = 2, artSpawnKey = "floor-2b" } } },
    },
  },
}
local preset = {
  value = {
    currentSublevel = 1,
    currentPull = 1,
    selection = { 1 },
    pulls = {
      { [1] = { 1, 2 }, color = "abcdef", artCCAssignments = {
        ["floor-1"] = { ccKey = "POLYMORPH" }, ["floor-2"] = { ccKey = "SAP" },
      } },
      { [2] = { 1 } },
    },
  },
}
function ART:GetDB() return { currentRaidIndex = 1 } end
function ART:GetCurrentPreset() return preset end

assert(loadfile(root.."/Modules/Pulls.lua"))("AnniversaryRaidTools", ART)
ART:EnablePullsPerSublevel()
assert(#preset.value.pullsBySublevel[1] == 1 and preset.value.pullsBySublevel[1][1][1][1] == 1)
assert(#preset.value.pullsBySublevel[2] == 2 and preset.value.pullsBySublevel[2][1][1][1] == 2)
assert(preset.value.pullsBySublevel[2][1].color == "abcdef", "split pulls keep their options")
assert(preset.value.pullsBySublevel[1][1].artCCAssignments["floor-1"]
    and not preset.value.pullsBySublevel[1][1].artCCAssignments["floor-2"]
    and preset.value.pullsBySublevel[2][1].artCCAssignments["floor-2"]
    and not preset.value.pullsBySublevel[2][1].artCCAssignments["floor-1"],
    "split pulls keep CC assignments only on the spawn's floor")
assert(preset.value.pulls == preset.value.pullsBySublevel[1], "current floor owns the active pull list")

preset.value.currentPull = 1
ART:SetPullSublevel(2)
assert(preset.value.currentSublevel == 2 and preset.value.pulls == preset.value.pullsBySublevel[2])
preset.value.currentPull = 2
ART:SetPullSublevel(1)
ART:SetPullSublevel(2)
assert(preset.value.currentPull == 2, "each floor remembers its selected pull")

print("floor pull checks passed")
