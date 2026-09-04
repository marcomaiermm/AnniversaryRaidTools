local loader = require("helpers.addon_loader")
local globals = require("helpers.global_snapshot")

describe("Core.Compat", function()
  local restoreGlobals

  before_each(function()
    restoreGlobals = globals.capture("IsAddOnLoaded", "LoadAddOn", "C_AddOns")
  end)

  after_each(function()
    restoreGlobals()
  end)

  it("prefers C_AddOns APIs and receives the real addon name and namespace", function()
    local modernCalls, legacyCalls = 0, 0
    _G.IsAddOnLoaded = function()
      legacyCalls = legacyCalls + 1
      return false
    end
    _G.LoadAddOn = function()
      legacyCalls = legacyCalls + 1
      return false, "legacy"
    end

    local ART = loader.newNamespace()
    local environment = setmetatable({
      C_AddOns = {
        IsAddOnLoaded = function(name)
          modernCalls = modernCalls + 1
          assert.are.equal("AnniversaryRaidTools_UI", name)
          return nil, true
        end,
        LoadAddOn = function(name)
          modernCalls = modernCalls + 1
          assert.are.equal("AnniversaryRaidTools_UI", name)
          return true, "modern"
        end,
      },
    }, { __index = _G })
    loader.load("Core/Compat.lua", ART, environment)

    assert.are.equal("Interface\\AddOns\\AnniversaryRaidTools\\", ART.AddonPath)
    assert.is_true(ART.Compat:IsAddOnLoaded("AnniversaryRaidTools_UI"))
    local loaded, reason = ART.Compat:LoadAddOn("AnniversaryRaidTools_UI")
    assert.is_true(loaded)
    assert.are.equal("modern", reason)
    assert.are.equal(2, modernCalls)
    assert.are.equal(0, legacyCalls)
  end)

  it("returns safe missing-API results", function()
    local ART = loader.newNamespace()
    local environment = { C_AddOns = {} }
    loader.load("Core/Compat.lua", ART, setmetatable(environment, {
      __index = function() return nil end,
    }))

    assert.is_false(ART.Compat:IsAddOnLoaded("missing"))
    assert.is_false(ART.Compat:EnableAddOn("missing"))
    local loaded, reason = ART.Compat:LoadAddOn("missing")
    assert.is_false(loaded)
    assert.are.equal("MISSING", reason)
    assert.is_nil(ART.Compat:GetAddOnMetadata("missing", "Version"))
    assert.are.equal(0, ART.Compat:GetNumAddOns())
    assert.is_nil(ART.Compat:GetAddOnInfo(1))
    assert.is_false(ART.Compat:SendChatMessage("message", "SAY"))
  end)
end)
