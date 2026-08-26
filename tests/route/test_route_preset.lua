-- Pure-Lua acceptance checks for ART route and waves presets.

local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
ART.StaticData = { raids = {} }
local function load(path) return assert(loadfile(root..path))("AnniversaryRaidTools", ART) end

load("/Core/RaidRegistry.lua")
load("/Core/RoutePreset.lua")
load("/Modules/RaidPlanner.lua")
load("/Modules/RaidSelect.lua")

local function provenance()
  return { source = "manual", confidence = "verified", sourceRef = "route-test" }
end

local function spawn(raidKey, npcId, id, packKey, x)
  return {
    key = raidKey..":spawn:"..npcId..":"..id,
    npcId = npcId,
    x = x,
    y = 0.5,
    sublevel = 1,
    packKey = packKey,
    source = provenance(),
  }
end

local function raid(mode)
  local key = "test-"..mode
  local packA, packB = key..":pack:a", key..":pack:b"
  local spawnA = spawn(key, 100, "01", packA, 0.1)
  local spawnB = spawn(key, 100, "02", packA, 0.2)
  local spawnC = spawn(key, 200, "01", packB, 0.3)
  local result = {
    schemaVersion = 1,
    key = key,
    name = mode == "route" and "Route Test" or "Waves Test",
    expansion = "TBC",
    instanceId = mode == "route" and 9001 or 9002,
    mapId = 565,
    mode = mode,
    sublevels = {
      { index = 1, name = "Test Floor", mapId = 565 },
      { index = 2, name = "Other Floor", mapId = 566 },
    },
    enemies = {
      ["100"] = { npcId = 100, name = "Test Mob", spawns = { spawnA, spawnB }, source = provenance() },
      ["200"] = { npcId = 200, name = "Test Caster", spawns = { spawnC }, source = provenance() },
    },
    packs = {
      [packA] = { key = packA, spawnKeys = { spawnA.key, spawnB.key }, source = provenance() },
      [packB] = { key = packB, spawnKeys = { spawnC.key }, source = provenance() },
    },
    pois = { [1] = {} },
  }
  if mode == "waves" then
    spawnC.sublevel = 2
    result.waves = {
      { waveKey = "wave-a", camp = "entrance", packKeys = { packA }, source = provenance() },
      { waveKey = "wave-b", camp = "bridge", packKeys = { packB }, source = provenance() },
    }
  end
  return result
end

local registry = ART.RaidRegistry.new()
local routeRaid = load("/Raids/TBC/Generated/GruulsLair.lua")
local wavesRaid = raid("waves")
assert(registry:Register(routeRaid))
assert(registry:Register(wavesRaid))
assert(#registry:GetAll() == 2 and registry:GetAll()[1].key == "gruuls-lair")

-- Registry identity and UTC provenance are strict validation boundaries.
local maulgarPack = routeRaid.packs["gruuls-lair:pack:maulgar"]
local packKey = maulgarPack.key
maulgarPack.key = nil
assert(not registry:Validate(routeRaid), "missing pack.key was accepted")
maulgarPack.key = "gruuls-lair:pack:wrong"
assert(not registry:Validate(routeRaid), "mismatched pack.key was accepted")
maulgarPack.key = packKey
local observedAt = maulgarPack.source.observedAt
maulgarPack.source.observedAt = "2026-02-29T00:00:00Z"
assert(not registry:Validate(routeRaid), "invalid calendar date was accepted")
maulgarPack.source.observedAt = "2024-02-29T00:00:00Z"
assert(registry:Validate(routeRaid))
maulgarPack.source.observedAt = "2024-02-29T00:00:00+00:00"
assert(registry:Validate(routeRaid))
maulgarPack.source.observedAt = observedAt

local presets = ART.RoutePreset.new({ registry = registry })
local planner = ART.RaidPlanner
planner:Initialize({ registry = registry, routePreset = presets })
local selected = ART.RaidSelect
selected:Initialize({ registry = registry, planner = planner })

-- Route mode allows user-owned step order and round-trips a deterministic export.
assert(selected:Select("gruuls-lair"))
local first = assert(planner:AddRouteStep({
  id = "route-a", label = "First", packKeys = { "gruuls-lair:pack:maulgar" }, notes = "note", marks = {},
}))
assert(first.id == "route-a")
assert(planner:AddRouteStep({
  id = "route-b", label = "Second", packKeys = { "gruuls-lair:pack:gruul" }, notes = "", marks = {},
}))
local beforeInvalid = #planner.preset.routeSteps
local invalid, reason = planner:AddRouteStep({
  id = "invalid", label = "Invalid", packKeys = { "gruuls-lair:pack:missing" }, notes = "", marks = {},
})
assert(not invalid and reason:find("invalid pack reference", 1, true), "invalid route step was accepted")
assert(#planner.preset.routeSteps == beforeInvalid, "invalid route step mutated the preset")
assert(planner:ReorderRouteStep("route-a", 2))
assert(planner.preset.routeSteps[1].id == "route-b" and planner.preset.routeSteps[2].id == "route-a")
local exported = assert(planner:Export())
assert(exported == assert(planner:Export()), "route export is not deterministic")
local imported = assert(presets:Import(exported, registry))
assert(imported.routeSteps[1].id == "route-b" and imported.routeSteps[2].notes == "note")
local activePreset = planner.preset
local invalidImport, invalidImportReason = planner:Import("true")
assert(not invalidImport and invalidImportReason == "preset must be a table")
assert(planner.preset == activePreset, "invalid import changed the active preset")
local badSchema = { schemaVersion = 99, raidKey = "gruuls-lair", currentSublevel = 1, routeSteps = {}, marking = { npcDefaults = {}, packOverrides = {} } }
local rejected, rejectReason = presets:Import(badSchema, registry)
assert(not rejected and rejectReason == "unsupported preset schemaVersion")

-- Waves mode creates immutable, ordered steps and rejects composition changes.
local waves = assert(presets:Create(wavesRaid))
assert(#waves.routeSteps == 2)
assert(waves.routeSteps[1].waveKey == "wave-a" and waves.routeSteps[2].waveKey == "wave-b")
assert(waves.routeSteps[1].packKeys[1] == "test-waves:pack:a")
assert(presets:Validate(waves, wavesRaid))
local reordered, reorderReason = presets:Reorder(waves, "wave-wave-a", 2, wavesRaid)
assert(not reordered and reorderReason == "wave order is immutable")
local originalPack = waves.routeSteps[1].packKeys
waves.routeSteps[1].packKeys = { "test-waves:pack:b" }
local mismatch, mismatchReason = presets:Validate(waves, wavesRaid)
assert(not mismatch and mismatchReason:find("wave composition", 1, true), "wave composition mutation was accepted")
waves.routeSteps[1].packKeys = originalPack
assert(presets:Validate(waves, wavesRaid))
assert(presets:Import(assert(presets:Export(waves, wavesRaid)), registry))

local legacy = presets:Create(wavesRaid)
legacy.marking.floorNpcDefaults = nil
legacy.marking.npcDefaults = { [100] = { 1 }, [200] = { 2 } }
local migrated = assert(presets:Import(legacy, registry))
assert(migrated.marking.floorNpcDefaults[1][100][1] == 1
    and migrated.marking.floorNpcDefaults[2][200][1] == 2,
    "legacy NPC defaults migrate onto every floor containing that NPC")
assert(next(migrated.marking.npcDefaults) == nil, "legacy defaults are cleared after migration")

print("route/waves preset checks passed")
