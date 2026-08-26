local root = arg and arg[1] or "."

table.wipe = table.wipe or function(value) for key in pairs(value) do value[key] = nil end end

local encoded, nextEncoded = {}, 0
local Serializer = {}
function Serializer:Serialize(value)
  nextEncoded = nextEncoded + 1
  local key = tostring(nextEncoded)
  encoded[key] = value
  return key
end
function Serializer:Deserialize(key)
  if encoded[key] == nil then return false, "unknown payload" end
  return true, encoded[key]
end
local Deflate = {
  CompressDeflate = function(_, value) return value end,
  DecompressDeflate = function(_, value) return value end,
  EncodeForPrint = function(_, value) return value end,
  DecodeForPrint = function(_, value) return value end,
}
LibStub = setmetatable({
  GetLibrary = function(_, name)
    if name == "AceSerializer-3.0" then return Serializer end
    if name == "LibDeflate" then return Deflate end
    error("unexpected library: "..tostring(name))
  end,
}, { __call = function(self, name) return self:GetLibrary(name) end })

local units = {
  player = { name = "Leader", realm = "Realm", leader = true },
  Leader = { name = "Leader", realm = "Realm", leader = true },
  Assist = { name = "Assist", realm = "Realm", assistant = true },
  raid1 = { name = "Leader", realm = "Realm", leader = true },
  raid2 = { name = "Assist", realm = "Realm", assistant = true },
}
function UnitFullName(unit)
  local key = tostring(unit):match("^[^-]+")
  local value = units[unit] or units[key]
  return value and value.name, value and value.realm
end
function UnitExists(unit) return units[unit] ~= nil end
function UnitIsGroupLeader(unit) return units[unit] and units[unit].leader == true end
function UnitIsGroupAssistant(unit) return units[unit] and units[unit].assistant == true end
function IsInRaid() return true end
function GetNumGroupMembers() return 2 end

local sent, calls, chat = {}, {}, {}
local function record(name, ...)
  calls[name] = calls[name] or {}
  calls[name][#calls[name] + 1] = { ... }
end
local function count(name) return #(calls[name] or {}) end
local function resetSent() table.wipe(sent) end

local prefixes = {
  enabled = "ARTLiveEnabled", request = "ARTLiveReq", ping = "ARTLivePing",
  obj = "ARTLiveObj", objOff = "ARTLiveObjOff", objChg = "ARTLiveObjChg",
  cmd = "ARTLiveCmd", note = "ARTLiveNote", preset = "ARTLivePreset",
  pull = "ARTLivePull", free = "ARTLiveFree", bora = "ARTLiveBora",
  reqPre = "ARTLiveReqPre", progress = "ARTRaidProgress", ccAssignment = "ARTCCAssign",
}
local livePreset = {
  uid = "route-live", text = "Live Route",
  value = { currentRaidIndex = 161, currentSublevel = 1, currentPull = 2, pulls = { {}, {}, {} } },
  objects = { { d = { 10, 20, 0, 0, "old" } }, { d = { 30, 40, 0, 0, "second" } } },
}
local browsedPreset = livePreset
local ART = {
  L = setmetatable({}, { __index = function(_, key) return key end }),
  commsObject = { SendCommMessage = function(_, ...) sent[#sent + 1] = { ... } end },
  presetCommPrefix = "ARTPreset", versionCheckPrefix = "ARTVersion",
  liveSessionPrefixes = prefixes, liveSessionActive = true, liveSessionRequested = true,
  livePresetUID = livePreset.uid, knownRaids = {},
  RaidPlanner = { raid = { key = "black-temple" } },
  main_frame = {
    SendingStatusBar = {
      Show = function() end, Hide = function() record("hideStatus") end, SetValue = function() end,
      value = { SetText = function() end },
    },
    LiveSessionButton = { SetText = function() end, SetDisabled = function() end,
      text = { SetTextColor = function() end } },
    LinkToChatButton = { SetText = function() end, SetDisabled = function() end,
      text = { SetTextColor = function() end } },
  },
  Compat = { SendChatMessage = function(_, message, distribution)
    chat[#chat + 1] = { message = message, distribution = distribution }
  end },
}
_G.ART = ART
C_Timer = { After = function(_, callback) callback() end }

function ART:GetCurrentPreset() return browsedPreset end
function ART:GetCurrentLivePreset() return livePreset end
function ART:GetCurrentSubLevel() return browsedPreset.value.currentSublevel end
function ART:GetCurrentPull() return browsedPreset.value.currentPull end
function ART:IsPlayerInGroup() return "RAID" end
function ART:GetScale() return 2 end
function ART:GetRaidName(index) return index == 161 and "Black Temple" or nil end
function ART:ValidateImportPreset(value) return type(value) == "table" and type(value.value) == "table" end
function ART:SetUniqueID(preset) preset.uid = preset.uid or "generated" end
function ART:EnsurePresetCreatedBy(preset) preset.createdBy = preset.createdBy or "Leader-Realm" end
function ART:GetDB() return { presets = {} } end
function ART:SetSelectionToPull(index) browsedPreset.value.currentPull = index; record("selectPull", index) end
function ART:ReloadPullButtons() record("reloadPulls") end
function ART:PingMap(x, y) record("ping", x, y) end
function ART:StorePresetObject(object, silent, preset) record("storeObject", object, silent, preset) end
function ART:DrawPresetObject(object, _, scale, preset, floor) record("drawObject", object, scale, preset, floor) end
function ART:UpdatePresetObjectOffsets(index, x, y, preset, silent)
  record("offset", index, x, y, preset, silent)
end
function ART:DrawAllPresetObjects() record("drawAll") end
function ART:DeletePresetObjects(preset, silent) record("deleteObjects", preset, silent) end
function ART:PresetObjectStepBack(preset, silent, remote) record("undo", preset, silent, remote) end
function ART:PresetObjectStepForward(preset, silent, remote) record("redo", preset, silent, remote) end
function ART:ClearPreset(preset, silent) record("clear", preset, silent) end
function ART:ImportPreset(preset, remote) record("import", preset, remote) end
function ART:SendToGroup(distribution, silent, preset) record("sendGroup", distribution, silent, preset) end
function ART:LiveSession_SessionFound(sender, uid) record("sessionFound", sender, uid) end
function ART:LiveSession_NotifyEnabled() record("notify") end
function ART:LiveSession_ReceiveProgress(message, distribution, sender)
  record("progress", message, distribution, sender)
end
ART.CCAssignments = { ReceiveChange = function(_, message, distribution, sender)
  record("cc", message, distribution, sender)
end }

assert(loadfile(root.."/Modules/LiveSession.lua"))("AnniversaryRaidTools", ART)
function ART:LiveSession_SessionFound(sender, uid) record("sessionFound", sender, uid) end
function ART:LiveSession_NotifyEnabled() record("notify") end
function ART:LiveSession_ReceiveProgress(message, distribution, sender)
  record("progress", message, distribution, sender)
end
assert(loadfile(root.."/Modules/Transmission.lua"))("AnniversaryRaidTools", ART)

local function assertPacket(prefix, distribution, priority)
  local packet = assert(sent[#sent], "expected a comm packet")
  assert(packet[1] == prefix and packet[3] == distribution and packet[5] == priority,
      "unexpected packet envelope for "..prefix)
  return packet
end

-- Every live-share sender uses the live route, group distribution and expected priority.
ART:LiveSession_SendPing(10, 20, 1)
assert(assertPacket(prefixes.ping, "RAID", "ALERT")[2] == "5:10:1")
resetSent(); ART:LiveSession_SendObject({ type = "line" })
local packet = assertPacket(prefixes.obj, "RAID", "BULK")
assert(ART:StringToTable(packet[2]).type == "line")
resetSent(); ART:LiveSession_SendObjectOffsets(3, 4.5, -2)
assert(assertPacket(prefixes.objOff, "RAID", "ALERT")[2] == "3:4.5:-2")
resetSent(); ART:LiveSession_SendUpdatedObjects({ [2] = { changed = true } })
packet = assertPacket(prefixes.objChg, "RAID", "ALERT")
assert(ART:StringToTable(packet[2])[2].changed)
resetSent(); ART:LiveSession_SendCommand("undo")
assert(assertPacket(prefixes.cmd, "RAID", "ALERT")[2] == "undo")
resetSent(); ART:LiveSession_SendNoteCommand("move", 2, 12, 34)
assert(assertPacket(prefixes.note, "RAID", "ALERT")[2] == "move:2:12:34")
resetSent(); ART:LiveSession_SendPreset(livePreset)
packet = assertPacket(prefixes.preset, "RAID", "BULK")
assert(ART:StringToTable(packet[2]) == livePreset and packet[7][3] == true and packet[7][4] == true)
resetSent(); ART:SendToGroup("RAID", false, livePreset)
packet = assertPacket("ARTPreset", "RAID", "BULK")
packet[6](packet[7], 100, 100, true)
assert(#chat == 1 and chat[1].distribution == "RAID"
    and chat[1].message == "[ART: Leader+Realm - Black Temple: Live Route]",
    "completed Share sends the chat format consumed by the clickable-link filter: "
      ..tostring(chat[1] and chat[1].message))
resetSent(); ART:LiveSession_SendPulls({ { id = 1 } })
packet = assertPacket(prefixes.pull, "RAID", "ALERT")
assert(ART:StringToTable(packet[2])[1].id == 1)

-- A browsed non-live route must never emit route-scoped live updates.
browsedPreset = { uid = "browsed", value = { currentSublevel = 1, currentPull = 1, pulls = { {} } } }
for _, send in ipairs({
  function() ART:LiveSession_SendPing(1, 1, 1) end,
  function() ART:LiveSession_SendObject({}) end,
  function() ART:LiveSession_SendObjectOffsets(1, 1, 1) end,
  function() ART:LiveSession_SendUpdatedObjects({}) end,
  function() ART:LiveSession_SendCommand("clear") end,
  function() ART:LiveSession_SendNoteCommand("text", 1, "x") end,
}) do resetSent(); send(); assert(#sent == 0, "browsed routes must not send live mutations") end
browsedPreset = livePreset

local receive = ART.commsObject.OnCommReceived
local function fromAssist(prefix, message, distribution)
  return receive(ART.commsObject, prefix, message, distribution or "RAID", "Assist")
end

-- Session discovery and targeted preset requests route to exactly one handler.
fromAssist(prefixes.enabled, "assist-route")
assert(count("sessionFound") == 1 and calls.sessionFound[1][1] == "Assist-Realm")
fromAssist(prefixes.request, "0")
assert(count("notify") == 1)
resetSent()
fromAssist(prefixes.reqPre, "Leader-Realm")
packet = assertPacket("ARTPreset", "RAID", "BULK")
assert(ART:StringToTable(packet[2]) == livePreset and packet[7][3] == true)
fromAssist(prefixes.reqPre, "Someone-Realm")
assert(#sent == 1, "preset requests for another player are ignored")

-- Pulls update the live preset, clamp selection and redraw only when it is browsed.
local receivedPulls = { {}, {} }
fromAssist(prefixes.pull, ART:TableToString(receivedPulls))
assert(livePreset.value.pulls == receivedPulls and livePreset.value.currentPull == 2)
assert(count("reloadPulls") == 1 and count("selectPull") == 1)
livePreset.value.currentPull = 3
fromAssist(prefixes.pull, ART:TableToString({ {} }))
assert(livePreset.value.currentPull == 1 and livePreset.value.selection[1] == 1,
    "shorter remote pull lists clamp the current pull")
local reloads = count("reloadPulls")
browsedPreset = { uid = "browsed", value = { currentSublevel = 1, currentPull = 1, pulls = { {} } } }
fromAssist(prefixes.pull, ART:TableToString({ {}, {} }))
assert(#livePreset.value.pulls == 2 and count("reloadPulls") == reloads,
    "hidden live routes update without redrawing the browsed route")
browsedPreset = livePreset
livePreset.value.artWaveRaid = "hyjal"
local wavePulls = livePreset.value.pulls
fromAssist(prefixes.pull, ART:TableToString({ {} }))
assert(livePreset.value.pulls == wavePulls, "wave pulls reject manual pull-list synchronization")
livePreset.value.artWaveRaid = nil

-- Progress and CC payloads are dispatched with normalized full sender names.
local progressPayload, ccPayload = { index = 1 }, { operation = "set" }
fromAssist(prefixes.progress, progressPayload)
fromAssist(prefixes.ccAssignment, ccPayload)
assert(count("progress") == 1 and calls.progress[1][1] == progressPayload
    and calls.progress[1][3] == "Assist-Realm")
assert(count("cc") == 1 and calls.cc[1][1] == ccPayload and calls.cc[1][3] == "Assist-Realm")
receive(ART.commsObject, prefixes.progress, progressPayload, "RAID", "Leader")
receive(ART.commsObject, prefixes.ccAssignment, ccPayload, "RAID", "Leader")
assert(count("progress") == 1 and count("cc") == 1, "self-originated live mutations are ignored")

-- Map pings are scaled locally and constrained to the live route and current floor.
fromAssist(prefixes.ping, "4:6:1")
assert(count("ping") == 1 and calls.ping[1][1] == 8 and calls.ping[1][2] == 12)
fromAssist(prefixes.ping, "4:6:2")
assert(count("ping") == 1, "pings on another floor are ignored")
browsedPreset = { uid = "browsed", value = { currentSublevel = 1, currentPull = 1, pulls = { {} } } }
fromAssist(prefixes.ping, "4:6:1")
assert(count("ping") == 1, "pings do not leak onto a browsed non-live route")
browsedPreset = livePreset

-- Drawing creation, movement and bulk changes mutate the live preset and redraw only the visible route.
local object = { type = "line" }
fromAssist(prefixes.obj, ART:TableToString(object))
assert(count("storeObject") == 1 and calls.storeObject[1][1] == object
    and calls.storeObject[1][2] == true and calls.storeObject[1][3] == livePreset)
assert(count("drawObject") == 1 and calls.drawObject[1][1] == object)
fromAssist(prefixes.objOff, "2:3.5:-4")
assert(count("offset") == 1 and calls.offset[1][1] == 2 and calls.offset[1][2] == 3.5
    and calls.offset[1][3] == -4 and calls.offset[1][5] == true)
local changed = { [1] = { d = { 99 } } }
fromAssist(prefixes.objChg, ART:TableToString(changed))
assert(livePreset.objects[1] == changed[1] and count("drawAll") == 2)

-- Command and note protocols preserve silent/remote flags and edit the expected object.
fromAssist(prefixes.cmd, "deletePresetObjects")
fromAssist(prefixes.cmd, "undo")
fromAssist(prefixes.cmd, "redo")
fromAssist(prefixes.cmd, "clear")
assert(count("deleteObjects") == 1 and calls.deleteObjects[1][2] == true)
assert(count("undo") == 1 and calls.undo[1][2] == true and calls.undo[1][3] == true)
assert(count("redo") == 1 and calls.redo[1][2] == true and calls.redo[1][3] == true)
assert(count("clear") == 1 and calls.clear[1][2] == true)
livePreset.objects = { { d = { 10, 20, 0, 0, "old" } }, { d = { 30, 40, 0, 0, "second" } } }
fromAssist(prefixes.note, "text:1:new text:0")
assert(livePreset.objects[1].d[5] == "new text")
fromAssist(prefixes.note, "move:1:55:66")
assert(livePreset.objects[1].d[1] == 55 and livePreset.objects[1].d[2] == 66)
fromAssist(prefixes.note, "delete:1:0:0")
assert(#livePreset.objects == 1 and livePreset.objects[1].d[5] == "second")

-- Full live presets are cached, validated and imported; inactive sessions reject live mutations.
local incoming = { uid = "incoming", text = "Incoming", value = { currentRaidIndex = 161 } }
fromAssist(prefixes.preset, ART:TableToString(incoming))
assert(ART.transmissionCache["Assist-Realm"]["Black Temple: Incoming"] == incoming)
assert(ART.livePresetUID == "incoming" and count("import") == 1
    and calls.import[1][1] == incoming and calls.import[1][2] == true)
ART.liveSessionActive = false
local before = {
  pulls = livePreset.value.pulls, stores = count("storeObject"), offsets = count("offset"),
  draws = count("drawAll"), imports = count("import"), notifications = count("notify"),
}
fromAssist(prefixes.request, "0")
fromAssist(prefixes.pull, ART:TableToString({ {} }))
fromAssist(prefixes.obj, ART:TableToString({ type = "ignored" }))
fromAssist(prefixes.objOff, "1:2:3")
fromAssist(prefixes.objChg, ART:TableToString({ [1] = {} }))
fromAssist(prefixes.cmd, "clear")
fromAssist(prefixes.note, "text:1:ignored:0")
fromAssist(prefixes.preset, ART:TableToString(incoming))
assert(livePreset.value.pulls == before.pulls and count("storeObject") == before.stores
    and count("offset") == before.offsets and count("drawAll") == before.draws
    and count("import") == before.imports and count("notify") == before.notifications,
    "inactive sessions reject every live mutation")

print("live share package checks passed")
