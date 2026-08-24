local root = arg[1] or "."
local MDT = {
  dungeonEnemies = {
    [1] = {
      [1] = { clones = { [1] = { sublevel = 1 }, [2] = { sublevel = 2 } } },
      [2] = { clones = { [1] = { sublevel = 2 } } },
    },
  },
}
local preset = {
  value = {
    currentSublevel = 1,
    currentPull = 1,
    selection = { 1 },
    pulls = {
      { [1] = { 1, 2 }, color = "abcdef" },
      { [2] = { 1 } },
    },
  },
}
function MDT:GetDB() return { currentDungeonIdx = 1 } end
function MDT:GetCurrentPreset() return preset end

assert(loadfile(root.."/Modules/Pulls.lua"))("AnniversaryRaidTools", MDT)
MDT:EnablePullsPerSublevel()
assert(#preset.value.pullsBySublevel[1] == 1 and preset.value.pullsBySublevel[1][1][1][1] == 1)
assert(#preset.value.pullsBySublevel[2] == 2 and preset.value.pullsBySublevel[2][1][1][1] == 2)
assert(preset.value.pullsBySublevel[2][1].color == "abcdef", "split pulls keep their options")
assert(preset.value.pulls == preset.value.pullsBySublevel[1], "current floor owns the active pull list")

preset.value.currentPull = 1
MDT:SetPullSublevel(2)
assert(preset.value.currentSublevel == 2 and preset.value.pulls == preset.value.pullsBySublevel[2])
preset.value.currentPull = 2
MDT:SetPullSublevel(1)
MDT:SetPullSublevel(2)
assert(preset.value.currentPull == 2, "each floor remembers its selected pull")

print("floor pull checks passed")
