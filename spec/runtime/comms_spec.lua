local loader = require("helpers.addon_loader")

describe("runtime comms", function()
  local separator = ":"

  local function codecLibraries()
    local serializer = {}
    function serializer:Serialize(payload)
      return table.concat({
        payload.version,
        payload.kind,
        payload.raidKey,
        payload.raidIndex,
        payload.presetUID,
        payload.index,
      }, separator)
    end

    function serializer:Deserialize(serialized)
      local version, kind, raidKey, raidIndex, presetUID, index = serialized:match(
        "^(%d+):([^:]+):([^:]+):(%d+):([^:]+):(%d+)$")
      if not version then return false, "invalid payload" end
      return true, {
        version = tonumber(version),
        kind = kind,
        raidKey = raidKey,
        raidIndex = tonumber(raidIndex),
        presetUID = presetUID,
        index = tonumber(index),
      }
    end

    local deflate = {}
    function deflate:CompressDeflate(value) return value end
    function deflate:DecompressDeflate(value) return value end
    function deflate:EncodeForPrint(value) return value end
    function deflate:DecodeForPrint(value) return value end

    local libStub = {}
    function libStub:GetLibrary(name)
      if name == "AceSerializer-3.0" then return serializer end
      if name == "LibDeflate" then return deflate end
      error("unexpected library: "..name)
    end
    return libStub
  end

  local function makePeer(name, queue, recipient)
    local peer = { name = name, fullName = name.."-Realm" }
    local playerName = name

    local commsObject = {}
    function commsObject:SendCommMessage(prefix, message, distribution, target, priority)
      queue[#queue + 1] = {
        sender = peer.name,
        senderPeer = peer,
        recipient = recipient,
        prefix = prefix,
        message = message,
        distribution = distribution,
        target = target,
        priority = priority,
      }
      return true
    end

    local raidUnits = {
      raid1 = "Leader-Realm",
      raid2 = "Receiver-Realm",
    }
    local environment = setmetatable({
      LibStub = codecLibraries(),
      IsInRaid = function() return true end,
      GetNumGroupMembers = function() return 2 end,
      UnitExists = function(unit) return raidUnits[unit] ~= nil end,
      UnitIsGroupLeader = function(unit)
        return unit == "player" and playerName == "Leader" or unit == "raid1"
      end,
      UnitIsGroupAssistant = function() return false end,
      UnitFullName = function(unit)
        if unit == "player" then return playerName, "Realm" end
        local raidName = raidUnits[unit]
        if raidName then return raidName:match("^([^-]+)-(.+)$") end
        local namePart, realmPart = tostring(unit):match("^([^-]+)-(.+)$")
        return namePart or unit, realmPart
      end,
    }, { __index = _G })

    local ART = loader.newNamespace()
    ART.L = setmetatable({}, { __index = function(_, key) return key end })
    ART.commsObject = commsObject
    ART.liveSessionPrefixes = { progress = "ARTRaidProgress" }
    ART.versionCheckPrefix = "ARTVersion"
    ART.presetCommPrefix = "ARTPreset"
    ART.knownRaids = {}
    ART.liveSessionActive = true
    ART.livePresetUID = "shared-preset"
    ART.currentPreset = {
      uid = "shared-preset",
      text = "runtime",
      value = {
        currentRaidIndex = 1,
        currentPull = 1,
        pulls = { {}, {} },
        selection = { 1 },
      },
    }
    ART.selectedPull = 1
    function ART:GetCurrentPreset() return self.currentPreset end
    function ART:GetCurrentLivePreset() return self.currentPreset end
    ART.RaidPlanner = { raid = { key = "runtime-raid" } }
    function ART:IsPlayerInGroup() return "RAID" end
    function ART:SetSelectionToPull(pull)
      self.selectedPull = pull
    end

    loader.load("Modules/Transmission.lua", ART, environment)
    loader.load("Modules/LiveSession.lua", ART, environment)
    peer.ART = ART
    return peer
  end

  it("queues a live progress packet until the other ART namespace flushes it", function()
    local queue = {}
    local receiver = makePeer("Receiver", queue)
    local sender = makePeer("Leader", queue, receiver)
    receiver.ART.currentPreset.value.currentPull = 1
    receiver.ART.currentPreset.value.selection = { 1 }
    sender.ART.currentPreset.value.currentPull = 1
    sender.ART.currentPreset.value.selection = { 1 }

    assert.is_true(sender.ART:LiveSession_SendProgress(2))
    assert.are.equal(1, #queue)
    assert.are.equal(1, receiver.ART.currentPreset.value.currentPull)
    assert.are.equal(1, receiver.ART.selectedPull)

    local packet = queue[1]
    assert.are.equal(sender.ART.liveSessionPrefixes.progress, packet.prefix)
    assert.are.equal(sender.name, packet.sender)
    assert.are.equal("!ART1!", packet.message:sub(1, 6))
    assert.are.equal("RAID", packet.distribution)
    assert.is_nil(packet.target)
    assert.are.equal("ALERT", packet.priority)

    table.remove(queue, 1)
    packet.senderPeer.ART.commsObject:OnCommReceived(
      packet.prefix, packet.message, packet.distribution, packet.sender)
    packet.recipient.ART.commsObject:OnCommReceived(
      packet.prefix, packet.message, packet.distribution, packet.sender)
    assert.are.equal(2, receiver.ART.currentPreset.value.currentPull)
    assert.are.same({ 2 }, receiver.ART.currentPreset.value.selection)
    assert.are.equal(2, receiver.ART.selectedPull)
    assert.are.equal(1, sender.ART.currentPreset.value.currentPull)
    assert.are.same({ 1 }, sender.ART.currentPreset.value.selection)
    assert.are.equal(1, sender.ART.selectedPull)
  end)
end)
