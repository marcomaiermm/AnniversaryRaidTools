-- Pure-Lua acceptance checks for route-step activation and planned spawn marks.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
ART.StaticData = { raids = {} }
local addon = { ART = ART }
local function load(path) return assert(loadfile(root..path))("AnniversaryRaidTools", addon) end

load("/Core/RaidRegistry.lua")
load("/Core/RoutePreset.lua")
load("/Core/MarkResolver.lua")
load("/Modules/RaidMarks.lua")
load("/Modules/RaidPlanner.lua")

local function provenance()
  return { source = "manual", confidence = "verified", sourceRef = "activation-test" }
end

local function spawn(npcId, id, packKey)
  return {
    key = "test-activation:spawn:"..npcId..":"..id,
    npcId = npcId,
    x = 0.5,
    y = 0.5,
    sublevel = 1,
    packKey = packKey,
    source = provenance(),
  }
end

local packA, packB, packC = "test-activation:pack:a", "test-activation:pack:b", "test-activation:pack:c"
local spawnA, spawnB, spawnBAlt, spawnB2, spawnC = spawn(100, "01", packA), spawn(200, "01", packB),
    spawn(200, "02", packB), spawn(201, "03", packB), spawn(300, "01", packC)
local raid = {
  schemaVersion = 1,
  key = "test-activation",
  name = "Activation Test",
  expansion = "TBC",
  instanceId = 9003,
  mapId = 565,
  mode = "route",
  sublevels = { { index = 1, name = "Test Floor", mapId = 565 } },
  enemies = {
    ["100"] = { npcId = 100, name = "Mob A", spawns = { spawnA }, source = provenance() },
    ["200"] = { npcId = 200, name = "Mob B", spawns = { spawnB, spawnBAlt }, source = provenance() },
    ["201"] = { npcId = 201, name = "Mob B2", spawns = { spawnB2 }, source = provenance() },
    ["300"] = { npcId = 300, name = "Mob C", spawns = { spawnC }, source = provenance() },
  },
  packs = {
    [packA] = { key = packA, spawnKeys = { spawnA.key }, source = provenance() },
    [packB] = { key = packB, spawnKeys = { spawnB.key, spawnBAlt.key, spawnB2.key }, source = provenance() },
    [packC] = { key = packC, spawnKeys = { spawnC.key }, source = provenance() },
  },
  pois = { [1] = {} },
}

local registry = ART.RaidRegistry.new()
assert(registry:Register(raid))
local presets = ART.RoutePreset.new({ registry = registry })

local changes = 0
local pullPackKeys = {}
local planner = ART.RaidPlanner
planner:Initialize({
  registry = registry,
  routePreset = presets,
  onChange = function() changes = changes + 1 end,
  getPullPackKeys = function(pullIndex) return pullPackKeys[pullIndex] end,
})

-- Fresh presets start in auto mode with no pinned step.
assert(planner:Create(raid.key))
local preset = planner.preset
assert(preset.currentStepId == nil and preset.currentStepPinned == false, "fresh preset activation defaults")
assert(planner:GetActiveStep() == nil and not planner:IsStepPinned(), "fresh planner has no active step")

for _, definition in ipairs({
  { id = "step-a", packKeys = { packA } },
  { id = "step-b", packKeys = { packB } },
  { id = "step-c", packKeys = { packC } },
  { id = "step-b2", packSteps = nil, packKeys = { packB } },
}) do
  assert(planner:AddRouteStep({ label = definition.id, packKeys = definition.packKeys, notes = "", marks = {}, id = definition.id }))
end

-- Derivation requires the pull pack dependency and a usable pull index.
planner.getPullPackKeys = nil
local sync, reason = planner:SyncStepFromPull(1)
assert(not sync and reason == "unsupported", "sync without dependency must be unsupported")
planner.getPullPackKeys = function(index) return pullPackKeys[index] end
sync, reason = planner:SyncStepFromPull("x")
assert(not sync and reason == "invalid pull index", "non-numeric pull accepted")
sync, reason = planner:SyncStepFromPull(99)
assert(not sync and reason == "empty pull", "unknown pull accepted")

-- Auto mode derives the step from the selected pull's packs.
pullPackKeys[1] = { packA }
changes = 0
sync = assert(planner:SyncStepFromPull(1))
assert(sync.id == "step-a" and planner:GetActiveStep().id == "step-a", "pull derives its step")
assert(changes == 1, "derivation commits once")
assert(planner.lastPullIndex == 1, "sync remembers the last pull")

-- Hysteresis: the active step wins when it shares a pack with the new pull.
pullPackKeys[2] = { packB, packC }
pullPackKeys[3] = { packB }
sync = assert(planner:SyncStepFromPull(2))
assert(sync.id == "step-b", "overlapping pull switches to its first matching step")
sync = assert(planner:SyncStepFromPull(3))
assert(sync.id == "step-b" and changes == 2, "active step wins ties without committing")

-- Explicit selection pins until unpinned.
changes = 0
assert(planner:SelectStep("step-c").id == "step-c")
assert(planner:IsStepPinned() and changes == 1, "explicit selection pins and commits")
sync, reason = planner:SyncStepFromPull(1)
assert(not sync and reason == "step-pinned", "pinned step ignores pulls")
assert(planner:GetActiveStep().id == "step-c", "pin keeps the step")
assert(planner:UnpinStep())
assert(not planner:IsStepPinned() and planner:GetActiveStep().id == "step-b", "unpin resyncs from last pull")

-- Planned marks live in the step owning the pack, preferring the active step.
local reconciles = 0
ART.LiveMarks = { OnPlanChanged = function() reconciles = reconciles + 1 end }
changes = 0
assert(planner:SetNpcDefaultMark(200, 5) == 5)
assert(planner:GetNpcDefaultMark(200) == 5 and changes == 1,
    "global NPC marks persist through the planner change boundary")
local fallbackMarks = assert(planner:SetNpcDefaultMarks(200, { 8, 7, 8 }))
assert(#fallbackMarks == 2 and fallbackMarks[1] == 8 and fallbackMarks[2] == 7,
    "global NPC fallback marks preserve priority and remove duplicates")
assert(#planner:GetNpcDefaultMarks(200) == 2)
assert(planner:SetNpcDefaultMark(200, nil) == 0 and planner:GetNpcDefaultMark(200) == nil)
local globalMark, globalReason = planner:SetNpcDefaultMark(999, 1)
assert(globalMark == nil and globalReason == "unknown npc", "unknown NPC defaults are rejected")
globalMark, globalReason = planner:SetNpcDefaultMark(200, 9)
assert(globalMark == nil and globalReason == "invalid marker", "invalid NPC defaults are rejected")

local stepMarkers = assert(planner:SetStepNpcMarks("step-b", 200, { 8, 7 }))
assert(stepMarkers[1] == 8 and stepMarkers[2] == 7 and planner.preset.routeSteps[2].marks[spawnB.key] == 8
    and planner.preset.routeSteps[2].marks[spawnBAlt.key] == 7, "step NPC marker pool is stored on deterministic spawns")
assert(#planner:GetStepNpcMarks("step-b", 200) == 2, "step NPC marker pool roundtrips")
local rejected, rejectedReason = planner:SetStepNpcMarks("step-b", 200, { 8, 7, 1 })
assert(not rejected and rejectedReason == "too many markers", "step NPC marker pool cannot exceed occurrences")
assert(planner:SetStepNpcMarks("step-b", 200, {}), "step NPC marker pool clears")
reconciles = 0

assert(planner:SetSpawnMark(packB, spawnB.key, 8) == 8, "mark assignment succeeds")
assert(reconciles == 1, "route mark changes must reconcile live marks")
local owner = assert(planner:GetActiveStep())
assert(owner.marks[spawnB.key] == 8 and owner.id == "step-b", "mark lands in the active owner step")
local assigned, displaced = planner:SetSpawnMark(packB, spawnB2.key, 8)
assert(assigned == 8 and displaced[1] == spawnB.key, "reassigning a mark reports its previous spawn")
assert(owner.marks[spawnB.key] == nil and owner.marks[spawnB2.key] == 8, "step marks must be unique")
assert(planner:SetSpawnMark(packB, spawnB.key, 8) == 8)

changes = 0
assert(planner:SelectStep("step-b2"))
assert(planner:GetActiveStep().id == "step-b2", "second owner step selectable")
assert(planner:SetSpawnMark(packB, spawnB.key, 3) == 3)
assert(planner.preset.routeSteps[4].marks[spawnB.key] == 3, "shared pack prefers the active step")
assert(planner.preset.routeSteps[2].marks[spawnB.key] == 8, "other step marks stay untouched")
assert(planner:SetSpawnMark(packB, spawnB.key, 0) == 0)
assert(planner.preset.routeSteps[4].marks[spawnB.key] == nil, "marker zero removes the mark")

local mark, reason = planner:SetSpawnMark("test-activation:pack:none", spawnB.key, 1)
assert(not mark and reason == "pack-without-step", "packless spawns reject marks")
mark, reason = planner:SetSpawnMark(packB, spawnB.key, 9)
assert(not mark and reason == "invalid marker", "out-of-range marker rejected")
mark, reason = planner:SetSpawnMark(packB, spawnB.key, 1.5)
assert(not mark and reason == "invalid marker", "fractional marker rejected")

local before = planner.preset.routeSteps[2].marks[spawnB.key]
mark, reason = planner:SetSpawnMark(packA, spawnB.key, 5)
assert(not mark and reason ~= nil, "mismatched spawn key rejected")
assert(planner.preset.routeSteps[2].marks[spawnB.key] == before, "failed marks revert")

-- Roundtrip keeps activation state and marks deterministic.
preset.currentStepId = "step-b"
preset.currentStepPinned = true
preset.routeSteps[2].marks[spawnB.key] = 8
local exported = assert(planner:Export())
local imported = assert(presets:Import(exported, registry))
assert(imported.currentStepId == "step-b" and imported.currentStepPinned == true, "roundtrip keeps activation state")
assert(imported.routeSteps[2].marks[spawnB.key] == 8, "roundtrip keeps marks")

local bad = assert(presets:Import(exported, registry))
bad.currentStepId = "missing-step"
assert(not presets:Validate(bad, raid), "unknown currentStepId rejected")
bad.currentStepId = "step-b"
bad.currentStepPinned = "yes"
assert(not presets:Validate(bad, raid), "non-boolean pin rejected")
bad.currentStepPinned = nil
bad.routeSteps[1].marks[spawnB.key] = 8
assert(not presets:Validate(bad, raid), "marks outside the step packs rejected")

-- Clearing removes planned marks across every step.
assert(planner:ClearAllSpawnMarks())
assert(reconciles > 1, "clearing route marks must reconcile live marks")
for _, step in ipairs(planner.preset.routeSteps) do
  assert(next(step.marks) == nil, "clear wipes all step marks")
end

print("step activation checks passed")
