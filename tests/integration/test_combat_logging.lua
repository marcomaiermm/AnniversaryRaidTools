local root = assert(arg[1])
local instanceType, logging = "none", false
local calls = {}
local db = { combatLogging = { enabled = false } }
local frame = { events = {} }

function frame:SetScript(_, callback) self.callback = callback end
function frame:RegisterEvent(event) self.events[event] = true end
function frame:UnregisterAllEvents() self.events = {} end
function CreateFrame() return frame end
function GetInstanceInfo() return "", instanceType end
function LoggingCombat(enabled)
  if enabled ~= nil then logging = enabled; calls[#calls + 1] = enabled end
  return logging
end
function SetCVar(name, value) assert(name == "advancedCombatLogging" and value == "1") end
C_Timer = { After = function() end }

local ART = {}
function ART:GetDB() return db end
function ART:ExportAPI() end

assert(loadfile(root.."/Core/CombatLogging.lua"))("AnniversaryRaidTools", ART)
assert(#calls == 0, "disabled logging must not change the client's state on load")

instanceType = "party"
ART:CombatLogging_SetEnabled(true)
assert(db.combatLogging.enabled and calls[#calls] == false)
instanceType = "raid"
frame.callback()
assert(calls[#calls] == true, "logging starts in raids")
ART:CombatLogging_SetEnabled(false)
assert(not db.combatLogging.enabled and calls[#calls] == false and next(frame.events) == nil)

print("combat logging checks passed")
