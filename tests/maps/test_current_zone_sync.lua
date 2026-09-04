local root = arg and arg[1] or "."
local saved = { currentRaidIndex = 160 }
local currentPreset = { value = { currentSublevel = 1 } }
local zoneId, selectedRaid, mapUpdates = 344, nil, 0
local ART = {
  L = {}, BackdropColor = {}, AddonName = "AnniversaryRaidTools",
  Compat = { GetBestMapForUnit = function() return zoneId end },
  GetDB = function() return saved end,
  GetCurrentPreset = function() return currentPreset end,
}
assert(loadfile(root.."/Modules/MapView.lua"))("AnniversaryRaidTools", ART)

ART.zoneIdToRaidIndex = { [339] = 161, [344] = 161 }
ART.zoneIdToSublevel = { [339] = 2, [344] = 6 }
function ART:UpdateToRaid(raidIndex) saved.currentRaidIndex, selectedRaid = raidIndex, raidIndex end
function ART:UpdateMap() mapUpdates = mapUpdates + 1 end

ART:CheckCurrentZone()
assert(selectedRaid == 161, "current raid is selected from its UiMapID")
assert(currentPreset.value.currentSublevel == 6 and mapUpdates == 1, "current raid floor is selected before rendering")

ART:SetCurrentSubLevel(8)
zoneId = 339
ART:CheckCurrentZone()
assert(currentPreset.value.currentSublevel == 8 and mapUpdates == 1,
  "reopening the selected raid preserves its saved floor")

zoneId = 999
ART:CheckCurrentZone()
assert(saved.currentRaidIndex == 161 and currentPreset.value.currentSublevel == 8,
  "unsupported zones preserve the current planner selection")

local mainFrame = assert(io.open(root.."/Modules/MainFrame.lua", "rb")):read("*a")
local showFunction = assert(mainFrame:match("function ART:ShowInterfaceInternal%(force%)(.-)function ART:InitializeFadeFrame"))
assert(showFunction:find("self:CheckCurrentZone()", 1, true) < showFunction:find("self.main_frame:Show()", 1, true),
  "zone selection must happen before the first visible frame")

print("current raid/floor synchronization checks passed")
