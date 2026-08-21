-- Pure-Lua acceptance checks for feature initialization and failure isolation.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
local load = function(path) return assert(loadfile(root..path)) end
local repositoryAPI = load("/Core/EnemyInfoRepository.lua")("AnniversaryRaidTools", { ART = ART })
local recorderAPI = load("/Developer/RaidRecorder.lua")("AnniversaryRaidTools", { ART = ART })
local feature = load("/Modules/RaidEnemyInfo.lua")("AnniversaryRaidTools", { ART = ART })
local repository = repositoryAPI.new({ data = load("/Data/EnemyInfo/GruulsLair.lua")() })
local recorder = recorderAPI.new({ repository = repository, raidKey = "gruuls-lair" })

local frame = { registered = 0, scripts = {} }
function frame:RegisterEvent(event) self.registered = self.registered + 1; self.event = event end
function frame:SetScript(name, callback) self.scripts[name] = callback end
function frame:UnregisterEvent(event) self.unregistered = event end

local queriedCombatLog = 0
assert(feature:Initialize({
  repository = repository,
  recorder = recorder,
  eventFrame = frame,
  GetCombatLogEventInfo = function()
    queriedCombatLog = queriedCombatLog + 1
    return {
      raidKey = "gruuls-lair",
      subevent = "SPELL_CAST_SUCCESS",
      sourceGUID = "Creature-0-1-2-3-18831-0000000001",
      npcId = 18831,
      spellId = 33654,
      timestamp = 2,
    }
  end,
}) == feature)
assert(feature:Initialize({ repository = {} }) == feature, "Initialize is idempotent")
assert(frame.registered == 1 and frame.event == "COMBAT_LOG_EVENT_UNFILTERED")
assert(feature:Get("gruuls-lair", 18831).name.value == "High King Maulgar")
frame.scripts.OnEvent(frame, "COMBAT_LOG_EVENT_UNFILTERED", {
  raidKey = "gruuls-lair",
  subevent = "SPELL_CAST_SUCCESS",
  sourceGUID = "Creature-0-1-2-3-18831-0000000001",
  npcId = 18831,
  spellId = 33654,
  timestamp = 1,
})
assert(feature:GetRecorder():Get("gruuls-lair", 18831).spells[33654])
frame.scripts.OnEvent(frame, "COMBAT_LOG_EVENT_UNFILTERED")
assert(queriedCombatLog == 1, "empty event payload must use the injected combat-log callback")
feature:Shutdown()
assert(frame.unregistered == "COMBAT_LOG_EVENT_UNFILTERED")

print("enemy-info feature: ok")
