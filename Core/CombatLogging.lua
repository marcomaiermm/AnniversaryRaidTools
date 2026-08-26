local _, ART = ...

local eventFrame = CreateFrame("Frame")
local hasSyncedState

local function getSettings()
  return ART:GetDB().combatLogging
end

local function evaluateLater()
  C_Timer.After(1, function() ART:CombatLogging_Evaluate() end)
  C_Timer.After(15, function() ART:CombatLogging_Evaluate() end)
end

function ART:CombatLogging_Evaluate(forceDisable)
  local _, instanceType = GetInstanceInfo()
  local shouldLog = not forceDisable and getSettings().enabled and instanceType == "raid"
  local isLogging = LoggingCombat() and true or false
  if not hasSyncedState or isLogging ~= shouldLog then LoggingCombat(shouldLog) end
  hasSyncedState = true
end

function ART:CombatLogging_SetEnabled(enabled)
  getSettings().enabled = enabled and true or false
  hasSyncedState = false
  if enabled then
    SetCVar("advancedCombatLogging", "1")
    eventFrame:RegisterEvent("UPDATE_INSTANCE_INFO")
    eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:CombatLogging_Evaluate()
    evaluateLater()
  else
    eventFrame:UnregisterAllEvents()
    self:CombatLogging_Evaluate(true)
  end
end

eventFrame:SetScript("OnEvent", function() ART:CombatLogging_Evaluate() end)

if getSettings().enabled then ART:CombatLogging_SetEnabled(true) end

ART:ExportAPI("CombatLogging_SetEnabled")
