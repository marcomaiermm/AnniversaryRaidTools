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
local livePreset = { uid = "route-a", value = { currentRaidIndex = 161, currentPull = 2, pulls = { {}, {}, {} } } }
local currentPreset = livePreset
local ART = {
  L = setmetatable({}, { __index = function(_, key) return key end }),
  RaidPlanner = { raid = { key = "black-temple", mode = "route" } },
  liveSessionActive = true,
  livePresetUID = "route-a",
  liveSessionPrefixes = { progress = "ARTRaidProgress" },
  commsObject = { SendCommMessage = function(_, ...) sent[#sent + 1] = { ... } end },
  Compat = { GetBestMapForUnit = function() return zoneId end },
  zoneIdToRaidIndex = { [339] = 161 },
  mapInfo = { [161] = { mapID = 564 } },
}
_G.ART = ART
function ART:GetCurrentPreset() return currentPreset end
function ART:GetCurrentLivePreset() return livePreset end
function ART:IsPlayerInGroup() return "RAID" end
function ART:TableToString(value) return value end
function ART:StringToTable(value) return value end
function ART:SetMapSublevel(index) selectedFloor = index end
function ART:SetSelectionToPull(index) selected = index end
function ART:OpenConfirmationFrame(_, _, _, _, _, callback) prompt = callback end
function ART:RunAfterFramesInitialized(callback) self.afterFrames = callback end
function ART:StartMainFrameInitialization() initialized = true; self.afterFrames() end
function ART:LiveSession_Enable() self.enabledFromPrompt = true end

assert(loadfile(root.."/Modules/LiveSession.lua"))("AnniversaryRaidTools", ART)

assert(ART:LiveSession_CanControlProgress("Leader-Realm"))
assert(ART:LiveSession_CanControlProgress("Assist-Realm"))
assert(not ART:LiveSession_CanControlProgress("Member-Realm"))

assert(ART:LiveSession_SendProgress(3))
assert(#sent == 1 and sent[1][1] == "ARTRaidProgress" and sent[1][3] == "RAID")
local payload = sent[1][2]
assert(payload.version == 1 and payload.kind == "selection" and payload.raidKey == "black-temple")
assert(payload.presetUID == "route-a" and payload.raidIndex == 161 and payload.index == 3)
units.player.leader = false
assert(not ART:LiveSession_SendProgress(2), "raid members cannot broadcast progress")
units.player.leader = true

ART:SetSelectionToPull(2)
assert(#sent == 2 and sent[2][2].index == 2, "explicit selection broadcasts progress")
ART:SetSelectionToPull(1, nil, true)
assert(#sent == 2, "passive selection does not broadcast progress")
ART.applyingLiveProgress = true
ART:SetSelectionToPull(1)
ART.applyingLiveProgress = nil
assert(#sent == 2, "received selection does not echo")

selected, selectedFloor = nil, nil
assert(ART:LiveSession_ReceiveProgress(payload, "RAID", "Assist-Realm"))
assert(selected == 3 and selectedFloor == 3 and livePreset.value.currentPull == 3)
assert(ART.applyingLiveProgress == nil, "remote selection guard must be released")
assert(not ART:LiveSession_ReceiveProgress(payload, "RAID", "Member-Realm"))

local wrongRoute = {
  version = 1, kind = "selection", raidKey = "black-temple", raidIndex = 161, presetUID = "other", index = 1,
}
assert(not ART:LiveSession_ReceiveProgress(wrongRoute, "RAID", "Assist-Realm"))
currentPreset = { uid = "browsed-route", value = { currentRaidIndex = 161, pulls = { {} } } }
selected, selectedFloor = nil, nil
assert(ART:LiveSession_ReceiveProgress(payload, "RAID", "Assist-Realm"))
assert(selected == nil and selectedFloor == nil and livePreset.value.currentPull == 3,
    "remote progress updates the live preset without replacing the browsed route")
currentPreset = livePreset
ART.RaidPlanner.raid = { key = "hyjal", mode = "waves" }
livePreset.value.artWaveRaid, livePreset.value.currentRaidIndex = "hyjal", 162
assert(ART:LiveSession_ReceiveProgress({
  version = 1, kind = "selection", raidKey = "hyjal", raidIndex = 162, presetUID = "other", index = 1,
}, "RAID", "Assist-Realm"), "wave raids synchronize by raid and wave index")
assert(not ART:LiveSession_ReceiveProgress({
  version = 1, kind = "selection", raidKey = "hyjal", raidIndex = 162, presetUID = "other", index = 99,
}, "RAID", "Assist-Realm"))

local preferred = ART:LiveSession_GetPreferredSession({
  { "Member-Realm", "member" }, { "Assist-Realm", "assist" }, { "Leader-Realm", "leader" },
})
assert(preferred[1] == "Leader-Realm", "raid leader owns simultaneous live-session discovery")

ART.liveSessionActive = false
function ART:LiveSession_Enable() self.enabledFromPrompt = true end
assert(ART:LiveSession_CheckRaidPrompt() and prompt, "supported raid entry prompts once")
assert(not ART:LiveSession_CheckRaidPrompt(), "same raid group is not prompted twice")
prompt()
assert(initialized and ART.enabledFromPrompt, "accepting initializes hidden UI and enables Live Session")
inRaid = false
ART:LiveSession_CheckRaidPrompt()
inRaid = true
assert(ART:LiveSession_CheckRaidPrompt(), "leaving the raid group resets consent")

local bootstrap = assert(io.open(root.."/Core/Bootstrap.lua", "rb"))
local bootstrapSource = bootstrap:read("*a")
bootstrap:close()
assert(bootstrapSource:find('progress = "ARTRaidProgress"', 1, true), "progress prefix must be registered at bootstrap")
local transmission = assert(io.open(root.."/Modules/Transmission.lua", "rb"))
local transmissionSource = transmission:read("*a")
transmission:close()
assert(transmissionSource:find("LiveSession_ReceiveProgress(message, distribution, fullName)", 1, true),
    "central comm receiver must dispatch live progress")
assert(transmissionSource:find("SetSelectionToPull(ART:GetCurrentPull(), nil, true)", 1, true),
    "received pull data must not echo a progress broadcast")

print("live progress sync checks passed")
