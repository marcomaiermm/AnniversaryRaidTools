local root = arg and arg[1] or "."
local ART = {}
_G.ART = ART
assert(loadfile(root.."/Core/MarkResolver.lua"))("AnniversaryRaidTools", { ART = ART })

local units = {}
local raid = {
  packs = { p = { spawnKeys = { "s1", "s2", "s3" } } },
  enemies = {
    ["100"] = { spawns = {
      { key = "s1", npcId = 100, packKey = "p" },
      { key = "s2", npcId = 100, packKey = "p" },
    } },
    ["200"] = { spawns = { { key = "s3", npcId = 200, packKey = "p" } } },
  },
}
local step = { id = "pull-1", packKeys = { "p" }, marks = { s1 = 1, s2 = 8 } }
local blocked = {}
local resolver = ART.MarkResolver.new({
  raid = raid,
  routeSteps = { step },
  profile = { npcDefaults = { [100] = { 3, 4 }, [200] = { 5 } }, packOverrides = {} },
  getUnitInfo = function(token) return units[token] end,
  unitExists = function(token) return units[token] ~= nil end,
  markerAvailable = function(marker) return not blocked[marker] end,
})
assert(resolver:ActivateRouteStep(step.id))

units.a = { guid = "a", npcId = 100 }
units.b = { guid = "b", npcId = 100 }
units.c = { guid = "c", npcId = 100 }
local marker, result = resolver:ResolveUnit("a")
assert(marker == 8 and result.source == "pull", "pull pool uses established marker priority")
assert(resolver:ResolveUnit("b") == 1, "second identical NPC gets the next pull marker")
assert(resolver:ResolveUnit("a") == 8, "GUID allocation is sticky")
marker, result = resolver:ResolveUnit("c")
assert(marker == nil and result.reason == "slots-exhausted" and result.source == "pull",
    "an exhausted pull pool never falls back to the global marker")
assert(resolver:OnUnitDeath("a") and resolver:ResolveUnit("c") == 8, "death releases the owned marker")

resolver:ResetActivePack()
blocked[8] = true
assert(resolver:ResolveUnit("a") == 1, "observed occupied markers are skipped")
blocked[1] = true
marker, result = resolver:ResolveUnit("b")
assert(marker == nil and result.reason == "slots-exhausted", "all occupied pull markers fail closed")
blocked[8], blocked[1] = nil, nil

resolver:ResetActivePack()
step.marks = {}
marker, result = resolver:ResolveUnit("a")
assert(marker == 3 and result.source == "global", "global NPC rule applies without a pull rule")
assert(resolver:ResolveUnit("b") == 4, "identical NPCs use the next global fallback marker")
marker, result = resolver:ResolveUnit("c")
assert(marker == nil and result.reason == "slots-exhausted", "global fallbacks stop when exhausted")
units.outside = { guid = "outside", npcId = 200 }
marker, result = resolver:ResolveUnit("outside")
assert(marker == 5 and result.source == "global", "global rules are raid-wide")

assert(resolver:ActivateRouteStep(nil) == false)
resolver:ResetActivePack()
marker, result = resolver:ResolveUnit("outside")
assert(marker == 5 and result.source == "global", "global rules also work without an active pull")

local preview = resolver:GetPreviewForPack("p")
assert(preview.s1.marker == 3 and preview.s3.marker == 5, "preview follows global rules")

print("mark resolver checks passed")
