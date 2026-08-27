local root = arg and arg[1] or "."

wipe = wipe or function(value) for key in pairs(value) do value[key] = nil end end
bit = bit or {}
bit.band = bit.band or function(left, right)
  local result, place = 0, 1
  while left > 0 and right > 0 do
    if left % 2 == 1 and right % 2 == 1 then result = result + place end
    left, right, place = math.floor(left / 2), math.floor(right / 2), place * 2
  end
  return result
end
COMBATLOG_OBJECT_RAIDTARGET8 = 128

local now = 100
function GetTime() return now end
function IsInRaid() return true end
function GetNumGroupMembers() return 2 end
function UnitFullName(unit)
  if unit == "raid1" or unit == "player" or unit == "Mage-Realm" then return "Mage", "Realm" end
  if unit == "raid2" or unit == "Rogue-Realm" then return "Rogue", "Realm" end
end
function UnitClass(unit)
  if unit == "raid1" then return "Mage", "MAGE" end
  if unit == "raid2" then return "Rogue", "ROGUE" end
end
function UnitIsConnected() return true end
function UnitGUID() return nil end
function GetInstanceInfo() return "Test Raid", "raid", 1, "", 25, 0, false, 1 end
local eventFrame = { events = {} }
function eventFrame:RegisterEvent(event) self.events[event] = true end
function eventFrame:UnregisterEvent(event) self.events[event] = nil end
function eventFrame:SetScript(_, callback) self.onEvent = callback end
function CreateFrame() return eventFrame end

local spawn = { key = "raid:spawn:100:a", npcId = 100, packKey = "raid:pack:a", sublevel = 1 }
local otherSpawn = { key = "raid:spawn:101:a", npcId = 101, packKey = "raid:pack:b", sublevel = 1 }
local enemy = {
  npcId = 100, name = "Test Controller", characteristics = { Polymorph = true, Sap = true },
  spawns = { spawn },
}
local otherEnemy = { npcId = 101, name = "Other Target", characteristics = {}, spawns = { otherSpawn } }
local raid = { key = "raid", mapId = 1, instanceId = 1, sublevels = { {}, {} },
  enemies = { ["100"] = enemy, ["101"] = otherEnemy } }
local pull = { [1] = { 1 }, [2] = { 1 } }
local preset = {
  uid = "route-a",
  value = { currentRaidIndex = 1, currentSublevel = 1, currentPull = 1, pulls = { pull } },
}
local sent = {}
local selectedPull = 1
local ART = {
  mapInfo = { [1] = { mapID = 1 } },
  raidEnemies = { [1] = { [1] = {
    id = 100, name = enemy.name, characteristics = enemy.characteristics,
    clones = { { artSpawnKey = spawn.key, sublevel = 1 } },
  }, [2] = { id = 101, name = otherEnemy.name, characteristics = {},
    clones = { { artSpawnKey = otherSpawn.key, sublevel = 1 } } } } },
  RaidRegistry = {
    Get = function(_, key) return key == "raid" and raid or nil end,
    GetAll = function() return { raid } end,
  },
  RaidPlanner = {
    raid = raid, lastPullIndex = 1,
    preset = { marking = { npcDefaults = {} } },
    GetPullStep = function() return { marks = { [spawn.key] = 8 } } end,
    GetNpcDefaultMarks = function(self, npcId) return self.preset.marking.npcDefaults[npcId] or {} end,
  },
  liveSessionActive = true,
  livePresetUID = "route-a",
  liveSessionPrefixes = { ccAssignment = "ARTCCAssign" },
  commsObject = { SendCommMessage = function(_, ...) sent[#sent + 1] = { ... } end },
}
_G.ART = ART
function ART:GetDB() return { currentRaidIndex = 1 } end
function ART:GetCurrentPreset() return preset end
function ART:GetCurrentPull() return selectedPull end
function ART:GetCurrentSubLevel() return preset.value.currentSublevel end
function ART:GetCurrentLivePreset() return preset end
function ART:LiveSession_CanControlProgress() return true end
function ART:IsPlayerInGroup() return "RAID" end
function ART:TableToString(value) return value end
function ART:StringToTable(value) return value end

assert(loadfile(root.."/Modules/CCAssignments.lua"))("AnniversaryRaidTools", ART)
local CC = ART.CCAssignments
assert(not eventFrame.events.COMBAT_LOG_EVENT_UNFILTERED,
    "CC combat logging stays idle without assignments")

local mage = { ccKey = "POLYMORPH", assignee = { name = "Mage-Realm", classFile = "MAGE" } }
local rogue = { ccKey = "SAP", assignee = { name = "Rogue-Realm", classFile = "ROGUE" } }
assert(CC:SetDefaultAssignment(preset, 100, 8, rogue, true, raid))
assert(CC:GetDefaultAssignment(preset, 100, 8).ccKey == "SAP")
preset.value.currentSublevel = 2
assert(not CC:GetDefaultAssignment(preset, 100, 8), "floor CC defaults do not leak onto another floor")
preset.value.currentSublevel = 1
CC:RefreshEventRegistration()
assert(eventFrame.events.COMBAT_LOG_EVENT_UNFILTERED,
    "CC combat logging activates for assignments in the current raid")
assert(CC:GetEffectiveAssignment(preset, 1, spawn.key, 100, 8).ccKey == "SAP")
local rows = CC:GetAssignmentRows(1)
assert(#rows == 1 and rows[1].marker == 8 and rows[1].assignment.ccKey == "SAP" and not rows[1].global,
    "matching pull and global NPC marks merge the global CC into the pull row")
local originalGetPullStep = ART.RaidPlanner.GetPullStep
ART.RaidPlanner.GetPullStep = function() return { marks = {} } end
ART.RaidPlanner.GetNpcDefaultMarks = function(_, npcId) return npcId == 100 and { 8 } or {} end
rows = CC:GetAssignmentRows(1)
assert(#rows == 1 and rows[1].global and rows[1].assignment.ccKey == "SAP",
    "a global CC on a free marker appears as a global Active Pull row")
ART.RaidPlanner.GetPullStep = function() return { marks = { [spawn.key] = 8 } } end
rows = CC:GetAssignmentRows(1)
assert(#rows == 1 and rows[1].spawnKey == spawn.key and not rows[1].global
    and rows[1].assignment and rows[1].assignment.ccKey == "SAP",
    "a pull mark inherits the lower-priority floor CC on the same marker")
ART.RaidPlanner.GetPullStep = originalGetPullStep
ART.RaidPlanner.GetNpcDefaultMarks = function(self, npcId) return self.preset.marking.npcDefaults[npcId] or {} end

preset.value.artPlayerMarks = {
  [1] = { name = mage.assignee.name, classFile = mage.assignee.classFile, ccKey = "POLYMORPH" },
}
rows = CC:GetAssignmentRows(1)
local playerRow
for _, row in ipairs(rows) do if row.marker == 1 then playerRow = row end end
assert(playerRow and playerRow.playerGlobal and playerRow.name == "Mage-Realm"
    and playerRow.assignment and playerRow.assignment.ccKey == "POLYMORPH",
    "a free marker exposes its preset-wide player and CC assignment")
ART.RaidPlanner.GetNpcDefaultMarks = function(_, npcId)
  return npcId == 100 and { 7 } or npcId == 101 and { 5 } or {}
end
preset.value.artPlayerMarks[6] = { name = mage.assignee.name, classFile = mage.assignee.classFile }
ART.RaidPlanner.GetPullStep = function() return { marks = { [spawn.key] = 6 } } end
pull[2] = nil
local _, displayRows = CC:GetAssignmentRows(1)
assert(#displayRows == 3 and displayRows[1].source == "pull"
    and displayRows[1].inheritedPlayer.name == "Mage-Realm" and not displayRows[1].assignment
    and displayRows[2].source == "floor" and displayRows[2].npcId == 100
    and displayRows[3].source == "global" and displayRows[3].marker == 1,
    "marker resolution inherits a missing pull assignee from the matching global mark")
preset.value.artPlayerMarks[6] = nil
pull[2] = { 1 }
ART.RaidPlanner.GetPullStep = originalGetPullStep
ART.RaidPlanner.GetNpcDefaultMarks = function(self, npcId) return self.preset.marking.npcDefaults[npcId] or {} end
ART.RaidPlanner.GetPullStep = function() return { marks = { [spawn.key] = 1 } } end
rows = CC:GetAssignmentRows(1)
for _, row in ipairs(rows) do
  assert(not row.playerGlobal, "a pull marker suppresses the lower-priority player mark")
end
assert(#rows == 1 and rows[1].assignment and rows[1].assignment.ccKey == "POLYMORPH"
    and rows[1].assignment.assignee.name == "Mage-Realm",
    "a pull mark without CC inherits the global CC and assignee on that marker")

preset.value.artPlayerMarks[6] = {
  name = "Warlock-Realm", classFile = "WARLOCK", ccKey = "BANISH",
}
ART.RaidPlanner.GetPullStep = function() return { marks = { [otherSpawn.key] = 6 } } end
rows = CC:GetAssignmentRows(1)
local immuneRow
for _, row in ipairs(rows) do if row.marker == 6 then immuneRow = row end end
assert(#rows == 2 and immuneRow and not immuneRow.assignment and not immuneRow.inheritedPlayer,
    "an ineligible global CC does not merge its CC or player onto the marked NPC")
preset.value.artPlayerMarks[6] = nil

assert(CC:SetDefaultAssignment(preset, 100, 1, rogue, true, raid))
ART.RaidPlanner.GetNpcDefaultMarks = function(_, npcId) return npcId == 100 and { 1 } or {} end
rows = CC:GetAssignmentRows(1)
assert(rows[1].assignment.ccKey == "SAP" and rows[1].assignment.assignee.name == "Rogue-Realm",
    "a floor CC wins over the global CC when a pull only owns the marker")

pull.artCCAssignments = { [spawn.key] = mage }
ART.RaidPlanner.GetPullStep = function() return { marks = { [spawn.key] = 1 } } end
rows = CC:GetAssignmentRows(1)
assert(rows[1].assignment.ccKey == "POLYMORPH" and rows[1].assignment.assignee.name == "Mage-Realm",
    "a pull CC wins over floor and global CC on the same marker")
pull.artCCAssignments = nil
assert(CC:ClearDefaultAssignment(preset, 100, 1, true))
ART.RaidPlanner.GetPullStep = originalGetPullStep
rows = CC:GetAssignmentRows(1)
local floorRow
for _, row in ipairs(rows) do
  if row.marker == 1 then floorRow = row end
  assert(not row.playerGlobal, "an active-pull floor rule suppresses the global player mark")
end
assert(floorRow and floorRow.global and floorRow.npcId == 100
    and floorRow.assignment and floorRow.assignment.ccKey == "POLYMORPH",
    "a floor mark without CC inherits the global CC on the same marker")
ART.RaidPlanner.GetNpcDefaultMarks = function(self, npcId) return self.preset.marking.npcDefaults[npcId] or {} end
ART.RaidPlanner.GetPullStep = function() return nil end
rows = CC:GetAssignmentRows(1)
assert(#rows == 1 and rows[1].playerGlobal,
    "global player marks remain active when the selected pull has no route step")
ART.RaidPlanner.GetPullStep = originalGetPullStep
preset.value.artPlayerMarks[1] = preset.value.artPlayerMarks[1] or {
  name = mage.assignee.name, classFile = mage.assignee.classFile,
}
local routePlannerPreset, routeMode = ART.RaidPlanner.preset, raid.mode
raid.mode = "waves"
ART.RaidPlanner.preset = {
  routeSteps = { { id = "wave-1", marks = { [spawn.key] = 8 } } },
  marking = routePlannerPreset.marking,
}
_, rows = CC:GetAssignmentRows(1)
assert(rows[1].source == "pull" and rows[1].spawnKey == spawn.key
    and rows[2].source == "global" and rows[2].marker == 1,
    "wave route-step marks and free global assignments resolve into tracker rows immediately")
ART.RaidPlanner.preset, raid.mode = routePlannerPreset, routeMode
preset.value.artPlayerMarks = nil
assert(CC:SetPullAssignment(preset, 1, spawn.key, 8, mage, true, raid))
assert(CC:GetEffectiveAssignment(preset, 1, spawn.key, 100, 8).ccKey == "POLYMORPH",
    "pull assignment overrides the raid default")
assert(CC:ClearPullAssignment(preset, 1, spawn.key, true))
assert(CC:GetEffectiveAssignment(preset, 1, spawn.key, 100, 8).ccKey == "SAP",
    "clearing the override reveals the raid default")

local trap = CC.catalog.FREEZING_TRAP
assert(CC:IsEligible(trap, enemy), "Freezing Trap accepts non-bosses with supported long CC")
enemy.isBoss = true
assert(not CC:IsEligible(trap, enemy), "Freezing Trap remains hidden for bosses")
enemy.isBoss = nil

assert(CC:SetPullAssignment(preset, 1, spawn.key, 8, mage, true, raid))
rows = CC:GetAssignmentRows(1)
assert(#rows == 1 and rows[1].marker == 8 and rows[1].assignment.ccKey == "POLYMORPH")
assert(CC:ClearActivePullAssignments() and not pull.artCCAssignments,
    "clearing marks removes every CC assignment from the active pull")
assert(CC:SetPullAssignment(preset, 1, spawn.key, 8, mage, true, raid))

CC:HandleCombatLog(0, "SPELL_AURA_APPLIED", false, "Player-1", "Mage-Realm", 0, 0,
    "Creature-0-0-0-0-100-1", "Test Controller", 0, 128, 12826)
local runtime = CC:GetRuntime(100, 8)
assert(runtime and runtime.duration == 50 and runtime.expires == 150 and not runtime.wrongCaster,
    "matching max-rank CC starts its fallback timer")
CC:HandleCombatLog(0, "SPELL_AURA_REMOVED", false, "Player-1", "Mage-Realm", 0, 0,
    "Creature-0-0-0-0-100-1", "Test Controller", 0, 128, 12826)
assert(not CC:GetRuntime(100, 8), "aura removal clears the timer")
CC:HandleCombatLog(0, "SPELL_AURA_APPLIED", false, "Player-2", "Other-Realm", 0, 0,
    "Creature-0-0-0-0-100-1", "Test Controller", 0, 128, 118)
assert(CC:GetRuntime(100, 8).wrongCaster, "lower ranks are recognized and wrong casters are signalled")

CC:SetPullAssignment(preset, 1, spawn.key, 8, mage, false, raid)
assert(sent[#sent][1] == "ARTCCAssign" and sent[#sent][2].scope == "pull",
    "authorized Live edits send the versioned assignment payload")
CC:ClearPullAssignment(preset, 1, spawn.key, true)
local sentBeforeReceive = #sent
assert(CC:ReceiveChange({
  version = 1, raidKey = "raid", raidIndex = 1, presetUID = "route-a", sublevel = 1,
  scope = "pull", operation = "set",
  target = { pullIndex = 1, spawnKey = spawn.key, marker = 8, assignment = mage },
}, "RAID", "Assist-Realm"))
assert(CC:GetPullAssignment(preset, 1, spawn.key).ccKey == "POLYMORPH" and #sent == sentBeforeReceive,
    "authorized remote assignments apply without echo")

pull.artCCAssignments.bad = { ccKey = "UNKNOWN", assignee = { name = "x", classFile = "MAGE" } }
preset.value.artCCFloorDefaults[1][999] = { [9] = mage }
CC:NormalizePreset(preset, raid)
assert(not pull.artCCAssignments.bad and not preset.value.artCCFloorDefaults[1][999],
    "normalization removes invalid imported assignments without touching valid entries")
local legacyPreset = { value = { currentSublevel = 1, pulls = {}, artCCDefaults = {
  [100] = { [8] = rogue },
} } }
enemy.spawns[2] = { key = "raid:spawn:100:b", npcId = 100, sublevel = 2 }
assert(CC:NormalizePreset(legacyPreset, raid))
assert(legacyPreset.value.artCCFloorDefaults[1][100][8].ccKey == "SAP"
    and legacyPreset.value.artCCFloorDefaults[2][100][8].ccKey == "SAP"
    and legacyPreset.value.artCCDefaults == nil,
    "legacy CC defaults migrate to every NPC floor and clear their old storage")
enemy.spawns[2] = nil
local bulkPreset = { value = { currentSublevel = 1, artCCFloorDefaults = {
  [1] = { [100] = { [8] = rogue } }, [2] = { [100] = { [8] = mage } },
} } }
assert(CC:ClearFloorAssignments(bulkPreset, 1, true)
    and not bulkPreset.value.artCCFloorDefaults[1]
    and bulkPreset.value.artCCFloorDefaults[2][100][8].ccKey == "POLYMORPH",
    "clearing floor marks removes CC defaults only from that floor")

local function menuNode()
  local node = { buttons = {} }
  function node:CreateButton(label, callback)
    local child = menuNode()
    child.label, child.callback = label, callback
    self.buttons[#self.buttons + 1] = child
    return child
  end
  function node:CreateTitle() end
  function node:CreateDivider() end
  return node
end
local function findButton(node, text)
  for _, button in ipairs(node.buttons) do
    if tostring(button.label):find(text, 1, true) then return button end
  end
end
local markedMenu = menuNode()
CC:AddNpcMenu(markedMenu, { assignment = 8, clone = { artSpawnKey = spawn.key } }, function() return true end)
assert(findButton(markedMenu, "Polymorph") and not findButton(markedMenu, "CC Assignment"),
    "marked NPCs expose CC choices directly")
preset.value.pulls = { {}, pull }
preset.value.currentPull, selectedPull = 1, 2
local selectedPullMenu = menuNode()
CC:AddNpcMenu(selectedPullMenu, { assignment = 8, clone = { artSpawnKey = spawn.key } }, function() return true end)
assert(findButton(selectedPullMenu, "Polymorph") and not findButton(selectedPullMenu, "CC Assignment"),
    "CC choices follow the visibly selected pull when multiple pulls exist")
preset.value.pulls = { pull, {} }
preset.value.currentPull, selectedPull = 2, 2
local otherPullMenu = menuNode()
CC:AddNpcMenu(otherPullMenu, { assignment = 8, clone = { artSpawnKey = spawn.key } }, function() return true end)
assert(findButton(otherPullMenu, "Polymorph") and not findButton(otherPullMenu, "CC Assignment"),
    "CC choices resolve the pull containing the clicked NPC when another pull is selected")
preset.value.pulls = { pull, {} }
pull.artCCAssignments = { [spawn.key] = mage }
local badge = { shown = false }
function badge:SetTexture(texture) self.texture = texture end
function badge:Show() self.shown = true end
function badge:Hide() self.shown = false end
CC:UpdateBlipBadge({ assignment = 1, clone = { artSpawnKey = spawn.key }, texture_CCIcon = badge })
assert(badge.shown and badge.texture == CC.catalog.POLYMORPH.icon,
    "map CC badges resolve the pull containing the NPC when another pull is active")
preset.value.pulls = { {}, {} }
preset.value.artCCFloorDefaults = { [1] = { [100] = { [8] = rogue } } }
badge.shown, badge.texture = false, nil
CC:UpdateBlipBadge({ assignment = 8, clone = { artSpawnKey = spawn.key }, texture_CCIcon = badge })
assert(badge.shown and badge.texture == CC.catalog.SAP.icon,
    "floor CC badges remain visible when the NPC does not belong to a pull")
preset.value.pulls, preset.value.currentPull, selectedPull = { pull }, 1, 1
local unmarkedMenu = menuNode()
CC:AddNpcMenu(unmarkedMenu, { clone = { artSpawnKey = spawn.key } }, function() return true end)
local crossMenu = findButton(unmarkedMenu, "UI-RaidTargetingIcon_7")
assert(crossMenu and findButton(crossMenu, "Polymorph"),
    "unmarked NPCs expose marker, CC, then player choices")

local defaultMenu, defaultMenuChange = nil, true
function ART:CreateContextMenu(_, generator)
  defaultMenu = menuNode()
  generator(nil, defaultMenu)
end
CC:OpenDefaultMenu({}, enemy, 8, function(assignment) defaultMenuChange = assignment or false end)
local ccForMarker = findButton(defaultMenu, "CC for")
assert(ccForMarker and findButton(defaultMenu, "Remove CC assignment"),
    "assigned Auto Marks expose a clear action beside the CC submenu")
findButton(defaultMenu, "Remove CC assignment").callback()
assert(defaultMenuChange == false and not CC:GetDefaultAssignment(preset, 100, 8),
    "the visible clear action removes the assignment and notifies Auto Marks")

local savedAssignment, sentBeforeTest = pull.artCCAssignments[spawn.key], #sent
assert(CC:SetDebugMode(true) and #CC:GetRoster() == 7, "CC debug provides a solo fake roster")
assert(CC:SetDefaultAssignment(preset, 100, 8, mage, false, raid)
    and CC:ClearFloorAssignments(preset, 1)
    and not CC:GetDefaultAssignment(preset, 100, 8),
    "clearing floor marks also suppresses local debug CC defaults")
assert(CC:FindRosterPlayer("ARTTestMage-Test").displayName == "Test Mage",
    "debug assignees expose readable display names")
local testRogue = { ccKey = "SAP", assignee = { name = "ARTTestRogue-Test", classFile = "ROGUE" } }
assert(CC:SetPullAssignment(preset, 1, spawn.key, 8, testRogue, false, raid))
assert(CC:GetPullAssignment(preset, 1, spawn.key).assignee.name == "ARTTestRogue-Test"
    and pull.artCCAssignments[spawn.key] == savedAssignment and #sent == sentBeforeTest,
    "debug assignments are local and are not synced or saved")
assert(CC:ClearActivePullAssignments() and not CC:GetPullAssignment(preset, 1, spawn.key)
    and pull.artCCAssignments[spawn.key] == savedAssignment,
    "CLEAR MARKS suppresses debug CC assignments without changing the saved route")
assert(CC:SetPullAssignment(preset, 1, spawn.key, 8, testRogue, false, raid))
local trackerRefreshes, autoMarksRefreshes, enemyRefreshes = 0, 0, 0
ART.RaidMarksUI = { RefreshPullTracker = function() trackerRefreshes = trackerRefreshes + 1 end }
ART.AutoMarksUI = { Refresh = function() autoMarksRefreshes = autoMarksRefreshes + 1 end }
ART.RaidEnemies_UpdateEnemiesAsync = function() enemyRefreshes = enemyRefreshes + 1 end
local badgeRefreshes = 0
ART.RaidEnemies_UpdateCCBadges = function() badgeRefreshes = badgeRefreshes + 1 end
CC:RefreshDefaultUI()
assert(enemyRefreshes == 0 and autoMarksRefreshes == 0 and badgeRefreshes == 1,
    "Auto Marks CC changes update only active map badges without rebuilding UI or NPC blips")
trackerRefreshes = 0
assert(CC:FireFirstDebugCC(1))
assert(CC:GetRuntime(100, 8).duration == 10 and not CC:GetRuntime(100, 8).wrongCaster,
    "the debug button path drives the real runtime timer state")
assert(trackerRefreshes == 1 and autoMarksRefreshes == 0 and enemyRefreshes == 0,
    "firing a runtime CC must refresh only the pull tracker")
pull.artCCAssignments = nil
preset.value.artPlayerMarks = {
  [1] = { name = mage.assignee.name, classFile = mage.assignee.classFile, ccKey = "POLYMORPH" },
}
ART.RaidPlanner.GetPullStep = function() return { marks = {} } end
assert(CC:FireFirstDebugCC(1) and CC:GetAssignmentRows(1)[1].runtime,
    "FIRE CC exposes its timer for a free global CC assignment")
ART.RaidPlanner.GetPullStep = originalGetPullStep
preset.value.artPlayerMarks = nil
pull.artCCAssignments = { [spawn.key] = savedAssignment }
assert(not CC:SetDebugMode(false))
assert(CC:GetPullAssignment(preset, 1, spawn.key).assignee.name == savedAssignment.assignee.name,
    "leaving CC debug restores the saved assignment")

trackerRefreshes, autoMarksRefreshes, enemyRefreshes, badgeRefreshes = 0, 0, 0, 0
assert(CC:ReceiveChange({
  version = 1, raidKey = "raid", raidIndex = 1, presetUID = "route-a", sublevel = 1,
  scope = "default", operation = "set",
  target = { npcId = 100, marker = 8, assignment = mage },
}, "RAID", "Assist-Realm"))
assert(autoMarksRefreshes == 1 and badgeRefreshes == 1 and enemyRefreshes == 0,
    "remote global CC changes rebuild Auto Marks once and update map badges without rebuilding NPCs")

local lifecycle = assert(io.open(root.."/Core/Lifecycle.lua", "r"))
local commands = lifecycle:read("*a")
lifecycle:close()
assert(commands:find('rqst == "debug"', 1, true)
    and commands:find('rqst == "debug:cc"', 1, true)
    and commands:find('rqst == "debug:marks"', 1, true)
    and not commands:find('rqst == "cctest"', 1, true)
    and not commands:find('rqst == "devmode"', 1, true), "debug commands use colon notation")

local refreshCalls = 0
ART.AutoMarksUI = { Refresh = function()
  refreshCalls = refreshCalls + 1
  CC:EnsureDefaultMarkers(preset)
end }
ART.LiveMarks = { OnPlanChanged = function() end }
CC:EnsureDefaultMarkers(preset)
assert(refreshCalls == 0, "ensuring CC defaults must not recursively refresh the marks UI")
assert(CC:SetDefaultAssignment(preset, 100, 8, rogue, true, raid) and refreshCalls == 0,
    "changing a CC default does not rebuild the Auto Marks list")

print("CC assignment checks passed")
