local loader = require("helpers.addon_loader")
local globals = require("helpers.global_snapshot")

describe("Core.MarkResolver", function()
  local restoreGlobals

  before_each(function()
    restoreGlobals = globals.capture("ART")
  end)

  after_each(function()
    restoreGlobals()
  end)

  it("assigns pull markers in deterministic priority order and keeps them sticky", function()
    local ART = loader.newNamespace()
    loader.load("Core/MarkResolver.lua", ART)

    local units = {
      first = { guid = "Creature-0-0-0-0-100", npcId = 100 },
      second = { guid = "Creature-0-0-0-0-200", npcId = 100 },
    }
    local resolver = ART.MarkResolver.new({
      raid = {
        enemies = {
          [100] = { spawns = {
            { key = "spawn-a", npcId = 100 },
            { key = "spawn-b", npcId = 100 },
          } },
        },
      },
      routeSteps = { { id = "pull", marks = { ["spawn-a"] = 1, ["spawn-b"] = 8 } } },
      getUnitInfo = function(token) return units[token] end,
      markerAvailable = function() return true end,
    })

    assert.is_true(resolver:ActivateRouteStep("pull"))
    local candidates, source = resolver:GetRuleForNpcId(100)
    assert.are.same({ 8, 1 }, candidates)
    assert.are.equal("pull", source)
    assert.are.equal(8, resolver:ResolveUnit("first"))
    assert.are.equal(1, resolver:ResolveUnit("second"))
    local marker, result = resolver:ResolveUnit("first")
    assert.are.equal(8, marker)
    assert.is_true(result.reused)
  end)

  it("ignores malformed and out-of-range markers instead of failing closed", function()
    local ART = loader.newNamespace()
    loader.load("Core/MarkResolver.lua", ART)

    local resolver = ART.MarkResolver.new({
      raid = { enemies = { [100] = { spawns = { { key = "spawn", npcId = 100 } } } } },
      routeSteps = { {
        id = "malformed",
        marks = { spawn = "8x", zero = 0, high = 9, fraction = 2.5, text = false },
      } },
      profile = { floorNpcDefaults = { [1] = { [100] = { 6 } } } },
      getCurrentSublevel = function() return 1 end,
      getUnitInfo = function() return { guid = "Creature-0-0-0-0-100", npcId = 100 } end,
      markerAvailable = function() return true end,
    })

    assert.is_true(resolver:ActivateRouteStep("malformed"))
    local candidates, source = resolver:GetRuleForNpcId(100)
    assert.are.same({ 6 }, candidates)
    assert.are.equal("global", source)
    local marker, result = resolver:ResolveUnit("target")
    assert.are.equal(6, marker)
    assert.are.equal("global", result.source)
  end)
end)
