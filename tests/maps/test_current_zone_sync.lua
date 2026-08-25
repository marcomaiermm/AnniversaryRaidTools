local root = arg and arg[1] or "."
local saved = { currentDungeonIdx = 160 }
local currentPreset = { value = { currentSublevel = 1 } }
local zoneId, selectedDungeon, selectedList, mapUpdates = 344, nil, nil, 0
local MDT = {
  L = {}, BackdropColor = {}, externalLinks = { {}, { url = "" } }, AddonName = "AnniversaryRaidTools",
  Compat = { GetBestMapForUnit = function() return zoneId end },
  GetDB = function() return saved end,
  GetCurrentPreset = function() return currentPreset end,
}
assert(loadfile(root.."/Modules/MapView.lua"))("AnniversaryRaidTools", MDT)

MDT.zoneIdToDungeonIdx = { [344] = 161, [345] = 161 }
MDT.zoneIdToSublevel = { [344] = 6, [345] = 7 }
function MDT:UpdateToDungeon(dungeonIdx) saved.currentDungeonIdx, selectedDungeon = dungeonIdx, dungeonIdx end
function MDT:SetDungeonList(_, dungeonIdx) selectedList = dungeonIdx end
function MDT:UpdateMap() mapUpdates = mapUpdates + 1 end

MDT:CheckCurrentZone()
assert(selectedDungeon == 161 and selectedList == 161, "current raid is selected from its UiMapID")
assert(currentPreset.value.currentSublevel == 6 and mapUpdates == 1, "current raid floor is selected before rendering")

zoneId = 345
MDT:CheckCurrentZone()
assert(currentPreset.value.currentSublevel == 7 and mapUpdates == 2,
  "floor changes are applied even while the raid stays the same")

zoneId = 999
MDT:CheckCurrentZone()
assert(saved.currentDungeonIdx == 161 and currentPreset.value.currentSublevel == 7,
  "unsupported zones preserve the current planner selection")

local mainFrame = assert(io.open(root.."/Modules/MainFrame.lua", "rb")):read("*a")
local showFunction = assert(mainFrame:match("function MDT:ShowInterfaceInternal%(force%)(.-)function MDT:InitializeFadeFrame"))
assert(showFunction:find("self:CheckCurrentZone()", 1, true) < showFunction:find("self.main_frame:Show()", 1, true),
  "zone selection must happen before the first visible frame")

print("current raid/floor synchronization checks passed")
