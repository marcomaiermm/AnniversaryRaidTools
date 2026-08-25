local root = arg[1] or "."
local file = assert(io.open(root.."/Modules/RaidEnemies.lua", "rb"))
local source = file:read("*a")
file:close()

local ART = { L = {} }
local reconciles = 0
_G.ART = { LiveMarks = { OnPlanChanged = function() reconciles = reconciles + 1 end } }
local preset = {
  value = {
    enemyAssignments = { [1] = { [1] = 3 }, [2] = { [1] = 3 }, [3] = { [1] = 4 }, [4] = { [1] = 3 } },
    pulls = { [1] = { [1] = { 1 }, [2] = { 1 }, [3] = { 1 } } },
  },
}
function ART:GetCurrentPreset() return preset end
function ART:GetCurrentPull() return 1 end

local prefix = assert(source:match("^([%s%S]-)\nfunction ART:HideDisplacedSpawnMarks"))
assert(loadstring(prefix))("AnniversaryRaidTools", ART)
local oldBlip = {
  enemyIdx = 1,
  cloneIdx = 1,
  assignment = 3,
  texture_OverlayIcon = { Hide = function(self) self.hidden = true end },
}
table.insert(ART:GetRaidEnemyBlips(), oldBlip)

ART:SetLegacyBlipMark(2, 1, 3)
assert(reconciles == 1, "legacy plan changes must reconcile live marks")
assert(preset.value.enemyAssignments[1][1] == nil and oldBlip.texture_OverlayIcon.hidden)
assert(preset.value.enemyAssignments[2][1] == 3, "new mob must own the mark")
assert(preset.value.enemyAssignments[3][1] == 4, "other marks must remain")
assert(preset.value.enemyAssignments[4][1] == 3, "other pulls must remain untouched")

print("legacy mark uniqueness checks passed")
