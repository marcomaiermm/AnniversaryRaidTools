local root = arg and arg[1] or "."
table.wipe = table.wipe or function(value) for key in pairs(value) do value[key] = nil end end

local inRaid, zoneId = true, 339
local units = {
  player = { name = "Leader", realm = "Realm", leader = true },
  raid1 = { name = "Leader", realm = "Realm", leader = true },
  raid2 = { name = "Assist", realm = "Realm", assistant = true },
  raid3 = { name = "Member", realm = "Realm" },
}
function IsInRaid() return inRaid end
function GetNumGroupMembers() return 3 end
function UnitExists(unit) return units[unit] ~= nil end
function UnitFullName(unit)
  local value = units[unit]
  if not value then
    local short = tostring(unit):match("^[^-]+")
    for _, candidate in pairs(units) do if candidate.name == short then value = candidate break end end
  end
  return value and value.name, value and value.realm
end
function UnitIsGroupLeader(unit) return units[unit] and units[unit].leader == true end
function UnitIsGroupAssistant(unit) return units[unit] and units[unit].assistant == true end

local sent, selected, selectedFloor, prompt, initialized = {}, nil, nil, nil, false
local livePreset = { uid = "route-a", value = { currentDungeonIdx = 161, currentPull = 2, pulls = { {}, {}, {} } } }
local currentPreset = livePreset
local MDT = {
  L = setmetatable({}, { __index = function(_, key) return key end }),
  ART = { RaidPlanner = { raid = { key = "black-temple", mode = "route" } } },
  liveSessionActive = true,
  livePresetUID = "route-a",
  liveSessionPrefixes = { progress = "ARTRaidProgress" },
  commsObject = { SendCommMessage = function(_, ...) sent[#sent + 1] = { ... } end },
  Compat = { GetBestMapForUnit = function() return zoneId end },
  zoneIdToDungeonIdx = { [339] = 161 },
  mapInfo = { [161] = { mapID = 564 } },
}
_G.ART = MDT.ART
function MDT:GetCurrentPreset() return currentPreset end
function MDT:GetCurrentLivePreset() return livePreset end
function MDT:IsPlayerInGroup() return "RAID" end
function MDT:TableToString(value) return value end
function MDT:StringToTable(value) return value end
function MDT:SetMapSublevel(index) selectedFloor = index end
function MDT:SetSelectionToPull(index) selected = index end
function MDT:OpenConfirmationFrame(_, _, _, _, _, callback) prompt = callback end
function MDT:RunAfterFramesInitialized(callback) self.afterFrames = callback end
function MDT:StartMainFrameInitialization() initialized = true; self.afterFrames() end
function MDT:LiveSession_Enable() self.enabledFromPrompt = true end

assert(loadfile(root.."/Modules/LiveSession.lua"))("AnniversaryRaidTools", MDT)

assert(MDT:LiveSession_CanControlProgress("Leader-Realm"))
assert(MDT:LiveSession_CanControlProgress("Assist-Realm"))
assert(not MDT:LiveSession_CanControlProgress("Member-Realm"))

assert(MDT:LiveSession_SendProgress(3))
assert(#sent == 1 and sent[1][1] == "ARTRaidProgress" and sent[1][3] == "RAID")
local payload = sent[1][2]
assert(payload.version == 1 and payload.kind == "selection" and payload.raidKey == "black-temple")
assert(payload.presetUID == "route-a" and payload.dungeonIndex == 161 and payload.index == 3)
units.player.leader = false
assert(not MDT:LiveSession_SendProgress(2), "raid members cannot broadcast progress")
units.player.leader = true

MDT:SetSelectionToPull(2)
assert(#sent == 2 and sent[2][2].index == 2, "explicit selection broadcasts progress")
MDT:SetSelectionToPull(1, nil, true)
assert(#sent == 2, "passive selection does not broadcast progress")
MDT.applyingLiveProgress = true
MDT:SetSelectionToPull(1)
MDT.applyingLiveProgress = nil
assert(#sent == 2, "received selection does not echo")

selected, selectedFloor = nil, nil
assert(MDT:LiveSession_ReceiveProgress(payload, "RAID", "Assist-Realm"))
assert(selected == 3 and selectedFloor == 3 and livePreset.value.currentPull == 3)
assert(MDT.applyingLiveProgress == nil, "remote selection guard must be released")
assert(not MDT:LiveSession_ReceiveProgress(payload, "RAID", "Member-Realm"))

local wrongRoute = {
  version = 1, kind = "selection", raidKey = "black-temple", dungeonIndex = 161, presetUID = "other", index = 1,
}
assert(not MDT:LiveSession_ReceiveProgress(wrongRoute, "RAID", "Assist-Realm"))
currentPreset = { uid = "browsed-route", value = { currentDungeonIdx = 161, pulls = { {} } } }
selected, selectedFloor = nil, nil
assert(MDT:LiveSession_ReceiveProgress(payload, "RAID", "Assist-Realm"))
assert(selected == nil and selectedFloor == nil and livePreset.value.currentPull == 3,
    "remote progress updates the live preset without replacing the browsed route")
currentPreset = livePreset
MDT.ART.RaidPlanner.raid = { key = "hyjal", mode = "waves" }
livePreset.value.artWaveRaid, livePreset.value.currentDungeonIdx = "hyjal", 162
assert(MDT:LiveSession_ReceiveProgress({
  version = 1, kind = "selection", raidKey = "hyjal", dungeonIndex = 162, presetUID = "other", index = 1,
}, "RAID", "Assist-Realm"), "wave raids synchronize by raid and wave index")
assert(not MDT:LiveSession_ReceiveProgress({
  version = 1, kind = "selection", raidKey = "hyjal", dungeonIndex = 162, presetUID = "other", index = 99,
}, "RAID", "Assist-Realm"))

local preferred = MDT:LiveSession_GetPreferredSession({
  { "Member-Realm", "member" }, { "Assist-Realm", "assist" }, { "Leader-Realm", "leader" },
})
assert(preferred[1] == "Leader-Realm", "raid leader owns simultaneous live-session discovery")

MDT.liveSessionActive = false
function MDT:LiveSession_Enable() self.enabledFromPrompt = true end
assert(MDT:LiveSession_CheckRaidPrompt() and prompt, "supported raid entry prompts once")
assert(not MDT:LiveSession_CheckRaidPrompt(), "same raid group is not prompted twice")
prompt()
assert(initialized and MDT.enabledFromPrompt, "accepting initializes hidden UI and enables Live Session")
inRaid = false
MDT:LiveSession_CheckRaidPrompt()
inRaid = true
assert(MDT:LiveSession_CheckRaidPrompt(), "leaving the raid group resets consent")

local bootstrap = assert(io.open(root.."/Core/Bootstrap.lua", "rb"))
local bootstrapSource = bootstrap:read("*a")
bootstrap:close()
assert(bootstrapSource:find('progress = "ARTRaidProgress"', 1, true), "progress prefix must be registered at bootstrap")
local transmission = assert(io.open(root.."/Modules/Transmission.lua", "rb"))
local transmissionSource = transmission:read("*a")
transmission:close()
assert(transmissionSource:find("LiveSession_ReceiveProgress(message, distribution, fullName)", 1, true),
    "central comm receiver must dispatch live progress")
assert(transmissionSource:find("SetSelectionToPull(MDT:GetCurrentPull(), nil, true)", 1, true),
    "received pull data must not echo a progress broadcast")

print("live progress sync checks passed")
