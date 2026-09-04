local loader = require("helpers.addon_loader")
local globals = require("helpers.global_snapshot")

describe("Core.SavedVariables", function()
  local restoreGlobals

  before_each(function()
    restoreGlobals = globals.capture("AnniversaryRaidToolsDB", "LibStub")
  end)

  after_each(function()
    restoreGlobals()
  end)

  local function loadSavedVariables(saved)
    local aceDB = {
      New = function(_, name, defaults)
        assert.are.equal("AnniversaryRaidToolsDB", name)
        assert.is_table(defaults.global.currentPreset)
        return { global = saved }
      end,
    }
    _G.AnniversaryRaidToolsDB = saved
    _G.LibStub = function(name)
      assert.are.equal("AceDB-3.0", name)
      return aceDB
    end

    local ART = loader.newNamespace()
    ART.L = setmetatable({}, { __index = function(_, key) return key end })
    loader.load("Core/SavedVariables.lua", ART)
    return ART
  end

  it("creates a fresh route store when no saved route store exists", function()
    local saved = { currentPreset = {} }
    local ART = loadSavedVariables(saved)
    local store = ART:GetRaidRouteStore()

    assert.is_table(store)
    assert.are.equal(1, store.schemaVersion)
    assert.are.same({}, store.presets)
    assert.are.equal(store, saved.raidRoutes)
    assert.are.equal(store, ART:GetRaidRouteStore())
  end)

  it("normalizes invalid preset indexes and leaves an invalid route store unavailable", function()
    local saved = {
      currentPreset = { [160] = 0, [161] = -2, [162] = 2 },
      raidRoutes = "legacy-value",
    }
    local ART = loadSavedVariables(saved)
    local db = ART:GetDB()

    assert.are.equal(1, db.currentPreset[160])
    assert.are.equal(1, db.currentPreset[161])
    assert.are.equal(2, db.currentPreset[162])
    assert.are.equal("legacy-value", db.raidRoutes)
    assert.is_nil(ART:GetRaidRouteStore())
  end)
end)
