local _, ART = ...

local Profiler = { functions = {
  "UpdateMap", "RaidEnemies_UpdateEnemiesAsync", "DrawAllHulls", "FindClosestPull",
} }
ART.PerformanceProfiler = Profiler
_G.ARTPerformanceProfiler = Profiler

function Profiler:RegisterUI(ui)
  self.ui = ui
end

local function addonMemory(name)
  local update = UpdateAddOnMemoryUsage or C_AddOns and C_AddOns.UpdateAddOnMemoryUsage
  local get = GetAddOnMemoryUsage or C_AddOns and C_AddOns.GetAddOnMemoryUsage
  if update then update() end
  return get and get(name) or 0
end

function Profiler:Start()
  if ResetCPUUsage then ResetCPUUsage() end
  self.startedAt = debugprofilestop and debugprofilestop() or 0
  self.coreMemory = addonMemory("AnniversaryRaidTools")
  self.uiMemory = addonMemory("AnniversaryRaidTools_UI")
  print("|cffffd100ART perf:|r recording started")
end

function Profiler:Report()
  local elapsed = (debugprofilestop and debugprofilestop() or 0) - (self.startedAt or 0)
  print(("|cffffd100ART perf:|r %.1f ms elapsed; first UI load %.1f ms; memory %.1f KiB core + %.1f KiB UI"):format(
      elapsed, self.lastUILoadMs or 0, addonMemory("AnniversaryRaidTools"), addonMemory("AnniversaryRaidTools_UI")))
  if not GetFunctionCPUUsage then
    print("|cffffd100ART perf:|r enable scriptProfile and reload for per-function CPU data")
    return
  end
  local owner = self.ui or ART
  for _, name in ipairs(self.functions) do
    local fn = owner[name]
    if type(fn) == "function" then
      local cpu, calls = GetFunctionCPUUsage(fn, true)
      print(("  %s: %.2f ms / %d calls"):format(name, cpu or 0, calls or 0))
    end
  end
end

local loadUI = ART.LoadUI
function ART:LoadUI(...)
  local started = debugprofilestop and debugprofilestop() or 0
  local loaded, reason = loadUI(self, ...)
  Profiler.lastUILoadMs = (debugprofilestop and debugprofilestop() or started) - started
  return loaded, reason
end

local slash = SlashCmdList.ANNIVERSARYRAIDTOOLS
function SlashCmdList.ANNIVERSARYRAIDTOOLS(command, ...)
  local action = tostring(command or ""):lower():match("^debug:perf%s*(%S*)")
  if action then
    if action == "start" then Profiler:Start() else Profiler:Report() end
    return
  end
  return slash(command, ...)
end
