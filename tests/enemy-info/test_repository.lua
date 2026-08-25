-- Pure-Lua acceptance checks for Enemy Info Contract v1.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
ART.StaticData = { enemyInfo = {} }
local load = function(path) return assert(loadfile(root..path)) end

local repositoryAPI = load("/Core/EnemyInfoRepository.lua")("AnniversaryRaidTools", ART)
local data = load("/Data/EnemyInfo/GruulsLair.lua")()
local repository = repositoryAPI.new({ data = data })

local enemy = assert(repository:Get("gruuls-lair", 18831))
assert(enemy.name.value == "High King Maulgar")
assert(enemy.name.source.source == "azerothcore")
assert(enemy.name.source.confidence == "candidate")

local validTimestampMerge = repository:MergeObservation("gruuls-lair", 18831, {
  spells = {
    [33655] = {
      spellId = 33655,
      events = { SPELL_CAST_SUCCESS = 1 },
      source = {
        source = "live-observed",
        confidence = "verified",
        sourceRef = "test-valid-time",
        observedAt = "2024-02-29T12:00:00+00:00",
      },
    },
    [33657] = {
      spellId = 33657,
      events = { SPELL_CAST_SUCCESS = 1 },
      source = {
        source = "live-observed",
        confidence = "verified",
        sourceRef = "test-valid-fraction",
        observedAt = "2024-02-29T12:00:00.125Z",
      },
    },
  },
})
assert(validTimestampMerge)
assert(repository:Get("gruuls-lair", 18831).spells[33655].source.observedAt == "2024-02-29T12:00:00+00:00")
assert(repository:Get("gruuls-lair", 18831).spells[33657].source.observedAt == "2024-02-29T12:00:00.125Z")

local function invalidTimestamp(spellId, observedAt)
  return repository:MergeObservation("gruuls-lair", 18831, {
    spells = {
      [spellId] = {
        spellId = spellId,
        events = { SPELL_CAST_SUCCESS = 1 },
        source = {
          source = "live-observed",
          confidence = "verified",
          sourceRef = "test-invalid-time",
          observedAt = observedAt,
        },
      },
    },
  })
end
local invalidTimestampMerge, invalidTimestampReason = invalidTimestamp(33656, "2023-02-29T12:00:00Z")
assert(not invalidTimestampMerge and invalidTimestampReason == "invalid-observedAt")
assert(repository:Get("gruuls-lair", 18831).spells[33656] == nil)
invalidTimestampMerge, invalidTimestampReason = invalidTimestamp(33658, "2024-04-31T12:00:00Z")
assert(not invalidTimestampMerge and invalidTimestampReason == "invalid-observedAt")
assert(repository:Get("gruuls-lair", 18831).spells[33658] == nil)

local observations = {
  source = {
    source = "live-observed",
    confidence = "verified",
    sourceRef = "test",
    observedAt = "2026-08-21T12:00:00Z",
  },
  spells = {
    [33654] = {
      spellId = 33654,
      events = { SPELL_CAST_SUCCESS = 1 },
      source = {
        source = "live-observed",
        confidence = "verified",
        sourceRef = "test",
        observedAt = "2026-08-21T12:00:00Z",
      },
    },
  },
}
assert(repository:MergeObservation("gruuls-lair", 18831, observations))
enemy = assert(repository:Lookup("gruuls-lair", "18831"))
assert(enemy.name.source.confidence == "candidate", "merging live spell evidence must not upgrade name confidence")
assert(enemy.spells[33654].source.confidence == "verified")

local rejected, rejectedReason = repository:MergeObservation("gruuls-lair", 18831, {
  name = {
    value = "Unverified override",
    source = {
      source = "azerothcore",
      confidence = "verified",
      sourceRef = "bad-test-source",
    },
  },
})
assert(not rejected and rejectedReason == "azerothcore-confidence")
enemy = assert(repository:Get("gruuls-lair", 18831))
assert(enemy.name.value == "High King Maulgar")

local malformed = repository:Get("Gruuls Lair", 18831)
assert(malformed == nil)
local unknown = repository:Get("gruuls-lair", 99999)
assert(unknown == nil)
local diagnostics = repository:GetDiagnostics()
assert(diagnostics["invalid-observedAt"] >= 1)
assert(diagnostics["azerothcore-confidence"] >= 1)
assert(diagnostics.malformed >= 1 and diagnostics.unknown >= 1)

print("enemy-info repository: ok")
