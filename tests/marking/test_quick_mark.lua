local root = arg[1] or "."
local frames = {}
local inCombat = false

UIParent = {}
function CreateFrame(_, name)
  local frame = { name = name, scripts = {}, bindings = {} }
  function frame:SetSize() end
  function frame:SetPoint() end
  function frame:SetAlpha() end
  function frame:EnableMouse() end
  function frame:SetScript(event, handler) self.scripts[event] = handler end
  function frame:GetName() return self.name end
  frames[name] = frame
  return frame
end
function InCombatLockdown() return inCombat end
function ClearOverrideBindings(owner)
  assert(not inCombat, "ClearOverrideBindings called in combat")
  owner.bindings = {}
end
function SetOverrideBindingClick(owner, _, key, buttonName)
  assert(not inCombat, "SetOverrideBindingClick called in combat")
  owner.bindings[key] = buttonName
end
function GetBindingKey(binding) return binding == "RAIDTARGET1" and "CTRL-F1" or nil end

ART = {
  GetCurrentPreset = function() return ART.currentPreset end,
  HideDisplacedSpawnMarks = function() end,
  SetLegacyBlipMark = function(_, enemyIdx, cloneIdx, marker)
    ART.legacyApplied = { enemyIdx, cloneIdx, marker }
  end,
  RaidPlanner = {
    initialized = true,
    FindStepsForPack = function(self) return self.steps or { {} } end,
    SetSpawnMark = function(self, packKey, spawnKey, marker)
      self.applied = { packKey, spawnKey, marker }
      return marker
    end,
  },
}

assert(loadfile(root.."/Modules/QuickMark.lua"))("AnniversaryRaidTools", ART)
local blip = {
  data = {},
  clone = { artPackKey = "pack", artSpawnKey = "spawn" },
  SetUp = function(self) self.updated = true end,
}

ART.QuickMark:Arm(blip)
local capture = frames.ARTQuickMarkCapture
local expectedMarkers = { 8, 7, 1, 5, 6, 3, 4, 2 }
for key, marker in ipairs(expectedMarkers) do
  assert(capture.bindings[tostring(key)] == "ARTQuickMarkButton"..marker)
end
assert(capture.bindings["CTRL-F1"] == "ARTQuickMarkButton1")
ART.QuickMark:Disarm({})
assert(capture.bindings["1"] == "ARTQuickMarkButton8", "stale OnLeave must not clear the active blip")
frames[capture.bindings["1"]].scripts.OnClick()
assert(ART.RaidPlanner.applied[3] == 8 and blip.updated, "key 1 must assign skull")
ART.QuickMark:Disarm()
assert(next(capture.bindings) == nil)

ART.currentPreset = { value = {} }
ART.RaidPlanner.steps = {}
blip.enemyIdx, blip.cloneIdx, blip.updated = 2, 3, nil
ART.QuickMark:Arm(blip)
frames[capture.bindings["1"]].scripts.OnClick()
assert(ART.legacyApplied[1] == 2 and ART.legacyApplied[2] == 3 and ART.legacyApplied[3] == 8 and blip.updated)
ART.QuickMark:Disarm(blip)

inCombat = true
ART.QuickMark:Arm(blip)
ART.QuickMark:Disarm(blip)
inCombat = false

print("quick mark checks passed")
