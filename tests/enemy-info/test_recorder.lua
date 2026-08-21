-- Pure-Lua acceptance checks for bounded live observations.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
ART.StaticData = { enemyInfo = {} }
local load = function(path) return assert(loadfile(root..path)) end

local repositoryAPI = load("/Core/EnemyInfoRepository.lua")("AnniversaryRaidTools", { ART = ART })
local recorderAPI = load("/Developer/RaidRecorder.lua")("AnniversaryRaidTools", { ART = ART })
local repository = repositoryAPI.new({ data = load("/Data/EnemyInfo/GruulsLair.lua")() })
local recorder = recorderAPI.new({
  repository = repository,
  raidKey = "gruuls-lair",
  utcNow = function() return "2026-08-21T12:00:00Z" end,
  maxCount = 2,
})

local guid = "Creature-0-1-2-3-18831-0000000001"
local function record(subevent, timestamp, spellId)
  return recorder:RecordEvent({
    raidKey = "gruuls-lair",
    subevent = subevent,
    sourceGUID = guid,
    npcId = 18831,
    spellId = spellId,
    timestamp = timestamp,
  })
end

assert(record("SPELL_CAST_START", 1, 33654))
local duplicate, duplicateReason = record("SPELL_CAST_START", 1, 33654)
assert(not duplicate and duplicateReason == "duplicate")
assert(record("SPELL_CAST_START", 2, 33654))
assert(record("SPELL_CAST_START", 3, 33654))

local observed = assert(recorder:Get("gruuls-lair", 18831))
assert(observed.spells[33654].events.SPELL_CAST_START == 2, "event counts are bounded")
assert(observed.spells[33654].latest.source.observedAt == "2026-08-21T12:00:00Z")
assert(observed.spells[33654].latestEvidence == observed.spells[33654].latest)

assert(record("SPELL_CAST_SUCCESS", 4, 33654))
assert(record("SPELL_AURA_APPLIED", 5, 33654))
assert(record("SPELL_AURA_REMOVED", 6, 33654))
assert(record("SPELL_INTERRUPT", 7, 12345))
assert(record("SPELL_DISPEL", 8, 12345))
assert(recorder:RecordEvent({
  raidKey = "gruuls-lair", subevent = "UNIT_DIED", destGUID = guid, npcId = 18831, timestamp = 9,
}))
assert(recorder:RecordEvent({
  raidKey = "gruuls-lair", subevent = "PARTY_KILL", destGUID = guid, npcId = 18831, timestamp = 10,
}))
observed = assert(recorder:GetObservations("gruuls-lair", 18831))
assert(observed.events.UNIT_DIED == 1 and observed.events.PARTY_KILL == 1)

local accepted, reason = recorder:RecordEvent({ raidKey = "gruuls-lair", subevent = "SPELL_DAMAGE", sourceGUID = guid, npcId = 18831, spellId = 1 })
assert(not accepted and reason == "unknown-event")
accepted, reason = recorder:RecordEvent({ raidKey = "gruuls-lair", subevent = "SPELL_CAST_START", sourceGUID = "Player-0-1-2-3", npcId = 18831, spellId = 1 })
assert(not accepted and reason == "malformed-guid")
accepted, reason = recorder:RecordEvent({ raidKey = "gruuls-lair", subevent = "SPELL_CAST_START", sourceGUID = guid, npcId = 18831 })
assert(not accepted and reason == "malformed-spell")

local failingRecorder = recorderAPI.new({
  repository = { MergeObservation = function() error("repository unavailable") end },
  raidKey = "gruuls-lair",
  utcNow = function() return "2026-08-21T12:00:00Z" end,
})
local failedIsolation = failingRecorder:RecordEvent({
  raidKey = "gruuls-lair", subevent = "SPELL_CAST_SUCCESS", sourceGUID = guid, npcId = 18831, spellId = 1, timestamp = 1,
})
assert(failedIsolation == true, "repository failures must not reject an observation")

local stats = recorder:GetStats()
assert(stats.accepted >= 9 and stats.duplicates == 1)

local capped = recorderAPI.new({
  raidKey = "gruuls-lair",
  utcNow = function() return "2026-08-21T12:00:00Z" end,
  maxSpells = 1,
})
assert(capped:RecordEvent({
  raidKey = "gruuls-lair", subevent = "SPELL_CAST_SUCCESS", sourceGUID = guid,
  npcId = 18831, spellId = 100, timestamp = 1,
}))
local bounded, boundedReason = capped:RecordEvent({
  raidKey = "gruuls-lair", subevent = "SPELL_CAST_SUCCESS", sourceGUID = guid,
  npcId = 18831, spellId = 101, timestamp = 2,
})
assert(not bounded and boundedReason == "bounded")
local cappedState = assert(capped:Get("gruuls-lair", 18831))
assert(cappedState.spells[101] == nil and cappedState.events.SPELL_CAST_SUCCESS == 1)
assert(cappedState.latest.spellId == 100)
print("enemy-info recorder: ok")
