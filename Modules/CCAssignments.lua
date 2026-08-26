local _, ART = ...

local CC = ART.CCAssignments or {}
ART.CCAssignments = CC

local MARKER_ORDER = { 8, 7, 1, 5, 6, 3, 4, 2 }
local LONG_CC = {
  Polymorph = true, Sap = true, Banish = true, ["Shackle Undead"] = true,
  Hibernate = true, Fear = true, Repentance = true, ["Scare Beast"] = true,
  ["Turn Evil"] = true,
}

local catalog = {
  POLYMORPH = {
    label = "Polymorph", characteristic = "Polymorph", classFile = "MAGE", spellId = 12826,
    duration = 50, icon = "Interface\\Icons\\Spell_Nature_Polymorph",
    auraIds = { 118, 12824, 12825, 12826, 28271, 28272 },
  },
  SAP = {
    label = "Sap", characteristic = "Sap", classFile = "ROGUE", spellId = 11297,
    duration = 45, icon = "Interface\\Icons\\Ability_Sap", auraIds = { 6770, 2070, 11297 },
  },
  BANISH = {
    label = "Banish", characteristic = "Banish", classFile = "WARLOCK", spellId = 18647,
    duration = 30, icon = "Interface\\Icons\\Spell_Shadow_Cripple", auraIds = { 710, 18647 },
  },
  SHACKLE_UNDEAD = {
    label = "Shackle Undead", characteristic = "Shackle Undead", classFile = "PRIEST", spellId = 10955,
    duration = 50, icon = "Interface\\Icons\\Spell_Nature_Slow", auraIds = { 9484, 9485, 10955 },
  },
  HIBERNATE = {
    label = "Hibernate", characteristic = "Hibernate", classFile = "DRUID", spellId = 18658,
    duration = 40, icon = "Interface\\Icons\\Spell_Nature_Sleep", auraIds = { 2637, 18657, 18658 },
  },
  FREEZING_TRAP = {
    label = "Freezing Trap", classFile = "HUNTER", spellId = 14311, duration = 20,
    icon = "Interface\\Icons\\Spell_Frost_ChainsOfIce", auraIds = { 3355, 14308, 14309 }, trap = true,
  },
  FEAR = {
    label = "Fear", characteristic = "Fear", classFile = "WARLOCK", spellId = 6215,
    duration = 20, icon = "Interface\\Icons\\Spell_Shadow_Possession", auraIds = { 5782, 6213, 6215 },
  },
  REPENTANCE = {
    label = "Repentance", characteristic = "Repentance", classFile = "PALADIN", spellId = 20066,
    duration = 6, icon = "Interface\\Icons\\Spell_Holy_PrayerOfHealing", auraIds = { 20066 }, talent = true,
  },
  SCARE_BEAST = {
    label = "Scare Beast", characteristic = "Scare Beast", classFile = "HUNTER", spellId = 14327,
    duration = 20, icon = "Interface\\Icons\\Ability_Druid_Cower", auraIds = { 1513, 14326, 14327 },
  },
  TURN_EVIL = {
    label = "Turn Evil", characteristic = "Turn Evil", classFile = "PALADIN", spellId = 10326,
    duration = 20, icon = "Interface\\Icons\\Spell_Holy_TurnUndead", auraIds = { 10326 },
  },
}
local catalogOrder = {
  "POLYMORPH", "SAP", "BANISH", "SHACKLE_UNDEAD", "HIBERNATE",
  "FREEZING_TRAP", "FEAR", "REPENTANCE", "SCARE_BEAST", "TURN_EVIL",
}
local TEST_PLAYERS = {
  { name = "ARTTestDruid-Test", displayName = "Test Druid", classFile = "DRUID", online = true },
  { name = "ARTTestHunter-Test", displayName = "Test Hunter", classFile = "HUNTER", online = true },
  { name = "ARTTestMage-Test", displayName = "Test Mage", classFile = "MAGE", online = true },
  { name = "ARTTestPaladin-Test", displayName = "Test Paladin", classFile = "PALADIN", online = true },
  { name = "ARTTestPriest-Test", displayName = "Test Priest", classFile = "PRIEST", online = true },
  { name = "ARTTestRogue-Test", displayName = "Test Rogue", classFile = "ROGUE", online = true },
  { name = "ARTTestWarlock-Test", displayName = "Test Warlock", classFile = "WARLOCK", online = true },
}
local auraCatalog = {}
for key, definition in pairs(catalog) do
  definition.key = key
  for _, spellId in ipairs(definition.auraIds) do auraCatalog[spellId] = definition end
end

CC.catalog = catalog
CC.catalogOrder = catalogOrder
CC.markerOrder = MARKER_ORDER
CC.runtime = CC.runtime or {}
CC.testPullAssignments = CC.testPullAssignments or {}
CC.testDefaultAssignments = CC.testDefaultAssignments or {}

local function fullName(unit)
  if type(UnitFullName) ~= "function" then return end
  local name, realm = UnitFullName(unit)
  if not name then return end
  if not realm or realm == "" then
    local _, playerRealm = UnitFullName("player")
    realm = playerRealm
  end
  return realm and realm ~= "" and name.."-"..realm or name
end

local function shortName(name)
  return type(name) == "string" and name:match("^[^-]+") or name
end

local function namesMatch(left, right)
  if type(left) ~= "string" or type(right) ~= "string" then return false end
  left, right = left:lower(), right:lower()
  return left == right or shortName(left) == shortName(right)
end

local function validMarker(marker)
  marker = tonumber(marker)
  return marker and marker >= 1 and marker <= 8 and marker % 1 == 0 and marker or nil
end

local function assignmentCopy(value)
  if type(value) ~= "table" or type(value.assignee) ~= "table" then return end
  local definition = catalog[value.ccKey]
  local name, classFile = value.assignee.name, value.assignee.classFile
  if not definition or type(name) ~= "string" or name == "" or #name > 80
      or classFile ~= definition.classFile then return end
  return { ccKey = value.ccKey, assignee = { name = name, classFile = classFile } }
end

local function playerCopy(value)
  if type(value) ~= "table" or type(value.name) ~= "string" or value.name == "" or #value.name > 80
      or type(value.classFile) ~= "string" then return end
  local player = { name = value.name, classFile = value.classFile }
  local definition = value.ccKey and catalog[value.ccKey]
  if definition and definition.classFile == value.classFile then player.ccKey = value.ccKey end
  return player
end

function CC:GetRaidForPreset(preset, raidKey)
  local registry = ART.RaidRegistry
  if raidKey and registry and registry.Get then return registry:Get(raidKey) end
  local value = preset and preset.value
  local mapInfo = value and ART.mapInfo and ART.mapInfo[value.currentRaidIndex]
  for _, raid in ipairs(registry and registry.GetAll and registry:GetAll() or {}) do
    if mapInfo and raid.mapId == mapInfo.mapID then return raid end
  end
  local planner = ART.RaidPlanner
  return planner and planner.raid or nil
end

function CC:FindSpawn(raid, spawnKey)
  for npcKey, enemy in pairs(raid and raid.enemies or {}) do
    for _, spawn in ipairs(enemy.spawns or {}) do
      if spawn.key == spawnKey then return spawn, enemy, tonumber(enemy.npcId) or tonumber(npcKey) end
    end
  end
end

function CC:PullContainsSpawn(preset, pullIndex, spawnKey)
  local value = preset and preset.value
  local pull = value and value.pulls and value.pulls[pullIndex]
  local enemies = value and ART.raidEnemies and ART.raidEnemies[value.currentRaidIndex]
  if type(pull) ~= "table" then return false end
  for enemyIdx, clones in pairs(pull) do
    local enemy = tonumber(enemyIdx) and enemies and enemies[tonumber(enemyIdx)]
    for _, cloneIdx in ipairs(type(clones) == "table" and clones or {}) do
      local clone = enemy and enemy.clones and enemy.clones[cloneIdx]
      if clone and clone.artSpawnKey == spawnKey then return true, tonumber(enemyIdx), cloneIdx end
    end
  end
  return false
end

function CC:MarkerAvailableForSpawn(preset, pullIndex, spawnKey, marker)
  local value = preset and preset.value
  local pull = value and value.pulls and value.pulls[pullIndex]
  local enemies = value and ART.raidEnemies and ART.raidEnemies[value.currentRaidIndex]
  local assignments = value and value.enemyAssignments or {}
  for enemyIdx, clones in pairs(type(pull) == "table" and pull or {}) do
    local enemy = tonumber(enemyIdx) and enemies and enemies[tonumber(enemyIdx)]
    local enemyAssignments = assignments[enemyIdx] or assignments[tonumber(enemyIdx)]
    for _, cloneIdx in ipairs(type(clones) == "table" and clones or {}) do
      local clone = enemy and enemy.clones and enemy.clones[cloneIdx]
      if enemyAssignments and enemyAssignments[cloneIdx] == marker
          and clone and clone.artSpawnKey ~= spawnKey then return false end
    end
  end
  return true
end

function CC:IsEligible(definition, enemy)
  if not definition or not enemy then return false end
  local characteristics = enemy.characteristics or {}
  if definition.trap then
    local isBoss = enemy.isBoss
    if not isBoss then
      local npcId = tonumber(enemy.npcId)
      local current = ART.GetDB and ART:GetDB()
      for _, projected in pairs(current and ART.raidEnemies and ART.raidEnemies[current.currentRaidIndex] or {}) do
        if tonumber(projected.id) == npcId and projected.isBoss then isBoss = true break end
      end
    end
    if isBoss then return false end
    for key in pairs(LONG_CC) do if characteristics[key] then return true end end
    return false
  end
  return characteristics[definition.characteristic] == true
end

function CC:GetEligibleCCs(enemy)
  local result = {}
  for _, key in ipairs(catalogOrder) do
    local definition = catalog[key]
    if self:IsEligible(definition, enemy) then result[#result + 1] = definition end
  end
  return result
end

function CC:GetRoster()
  if self.debugMode then return TEST_PLAYERS end
  if ART.Roster and ART.Roster.GetPlayers then return ART.Roster:GetPlayers(true) end
  local result, units = {}, {}
  if type(IsInRaid) == "function" and IsInRaid() then
    for index = 1, (GetNumGroupMembers and GetNumGroupMembers() or 0) do units[#units + 1] = "raid"..index end
  elseif type(IsInGroup) == "function" and IsInGroup() then
    units[1] = "player"
    for index = 1, (GetNumSubgroupMembers and GetNumSubgroupMembers() or 0) do units[#units + 1] = "party"..index end
  else
    return result
  end
  for _, unit in ipairs(units) do
    local name = fullName(unit)
    local _, classFile = UnitClass(unit)
    if name and classFile then
      result[#result + 1] = {
        name = name, displayName = shortName(name), classFile = classFile, unit = unit,
        online = type(UnitIsConnected) ~= "function" or UnitIsConnected(unit) ~= false,
      }
    end
  end
  table.sort(result, function(left, right) return left.name < right.name end)
  return result
end

function CC:GetEligiblePlayers(ccKey)
  local definition, result = catalog[ccKey], {}
  for _, player in ipairs(self:GetRoster()) do
    if definition and player.classFile == definition.classFile then result[#result + 1] = player end
  end
  return result
end

function CC:FindRosterPlayer(name)
  for _, player in ipairs(self:GetRoster()) do if namesMatch(name, player.name) then return player end end
end

function CC:CanEdit()
  if self.debugMode then return true end
  if type(IsInRaid) == "function" and IsInRaid() then
    return ART.LiveSession_CanControlProgress and ART:LiveSession_CanControlProgress() or false
  end
  return true
end

function CC:GetPullAssignment(preset, pullIndex, spawnKey)
  if self.debugMode then
    local pulls = self.testPullAssignments[preset]
    local assignments = pulls and pulls[pullIndex]
    if assignments and assignments[spawnKey] ~= nil then return assignmentCopy(assignments[spawnKey]) end
  end
  local pull = preset and preset.value and preset.value.pulls and preset.value.pulls[pullIndex]
  return assignmentCopy(type(pull) == "table" and pull.artCCAssignments and pull.artCCAssignments[spawnKey])
end

local function assignmentSublevel(preset, sublevel)
  return tonumber(sublevel) or tonumber(ART.GetCurrentSubLevel and ART:GetCurrentSubLevel())
      or tonumber(preset and preset.value and preset.value.currentSublevel) or 1
end

function CC:GetDefaultAssignment(preset, npcId, marker, sublevel)
  sublevel = assignmentSublevel(preset, sublevel)
  if self.debugMode then
    local floors = self.testDefaultAssignments[preset]
    local defaults = floors and floors[sublevel]
    local markers = defaults and defaults[tonumber(npcId)]
    if markers and markers[validMarker(marker)] ~= nil then return assignmentCopy(markers[validMarker(marker)]) end
  end
  local floors = preset and preset.value and preset.value.artCCFloorDefaults
  local defaults = floors and floors[sublevel]
  return assignmentCopy(defaults and defaults[tonumber(npcId)] and defaults[tonumber(npcId)][validMarker(marker)])
end

function CC:GetEffectiveAssignment(preset, pullIndex, spawnKey, npcId, marker)
  return self:GetPullAssignment(preset, pullIndex, spawnKey)
      or self:GetDefaultAssignment(preset, npcId, marker)
end

function CC:NormalizePreset(preset, raid)
  local value = preset and preset.value
  if type(value) ~= "table" then return false end
  raid = raid or self:GetRaidForPreset(preset)
  if not raid then return false end
  local sourceFloors = type(value.artCCFloorDefaults) == "table" and value.artCCFloorDefaults or {}
  for npcId, markers in pairs(type(value.artCCDefaults) == "table" and value.artCCDefaults or {}) do
    local enemy = raid.enemies and raid.enemies[tostring(tonumber(npcId))]
    local floors = {}
    for _, spawn in ipairs(enemy and enemy.spawns or {}) do
      local sublevel = tonumber(spawn.sublevel)
      if sublevel then floors[sublevel] = true end
    end
    for sublevel in pairs(floors) do
      sourceFloors[sublevel] = sourceFloors[sublevel] or {}
      sourceFloors[sublevel][tonumber(npcId)] = sourceFloors[sublevel][tonumber(npcId)] or markers
    end
  end
  local floorDefaults = {}
  for sublevel, defaults in pairs(sourceFloors) do
    sublevel = tonumber(sublevel)
    if sublevel and raid.sublevels and raid.sublevels[sublevel] and type(defaults) == "table" then
      local normalizedFloor = {}
      for npcId, markers in pairs(defaults) do
        local enemy = raid.enemies and raid.enemies[tostring(tonumber(npcId))]
        if enemy and type(markers) == "table" then
          local normalized = {}
          for marker, assignment in pairs(markers) do
            local normalizedMarker = validMarker(marker)
            local normalizedAssignment = assignmentCopy(assignment)
            if normalizedMarker and normalizedAssignment
                and self:IsEligible(catalog[normalizedAssignment.ccKey], enemy) then
              normalized[normalizedMarker] = normalizedAssignment
            end
          end
          if next(normalized) then normalizedFloor[tonumber(npcId)] = normalized end
        end
      end
      if next(normalizedFloor) then floorDefaults[sublevel] = normalizedFloor end
    end
  end
  value.artCCFloorDefaults = next(floorDefaults) and floorDefaults or nil
  value.artCCDefaults = nil
  for pullIndex, pull in ipairs(type(value.pulls) == "table" and value.pulls or {}) do
    local normalized = {}
    for spawnKey, assignment in pairs(type(pull.artCCAssignments) == "table" and pull.artCCAssignments or {}) do
      local _, enemy = self:FindSpawn(raid, spawnKey)
      local normalizedAssignment = assignmentCopy(assignment)
      if normalizedAssignment and enemy and self:PullContainsSpawn(preset, pullIndex, spawnKey)
          and self:IsEligible(catalog[normalizedAssignment.ccKey], enemy) then
        normalized[spawnKey] = normalizedAssignment
      end
    end
    pull.artCCAssignments = next(normalized) and normalized or nil
  end
  return true
end

function CC:RefreshTracker()
  if ART.RaidMarksUI and ART.RaidMarksUI.RefreshPullTracker then ART.RaidMarksUI:RefreshPullTracker() end
end

function CC:RefreshUI()
  self:RefreshEventRegistration()
  self:RefreshTracker()
  if ART.AutoMarksUI and ART.AutoMarksUI.Refresh then ART.AutoMarksUI:Refresh() end
  if ART.RaidEnemies_UpdateEnemiesAsync then
    if ART.Async then ART:Async(function() ART:RaidEnemies_UpdateEnemiesAsync() end, "ARTCCAssignments", true)
    else ART:RaidEnemies_UpdateEnemiesAsync() end
  end
end

function CC:RefreshDefaultUI()
  self:RefreshEventRegistration()
  self:RefreshTracker()
  if ART.RaidEnemies_UpdateCCBadges then ART:RaidEnemies_UpdateCCBadges() end
end

function CC:SetDebugMode(enabled)
  self.debugMode = enabled == nil and not self.debugMode or enabled == true
  wipe(self.testPullAssignments)
  wipe(self.testDefaultAssignments)
  self:ResetRuntime()
  self:RefreshUI()
  if self.debugMode and ART.ShowInterface then ART:ShowInterface(true) end
  print(self.debugMode
      and "|cffffd100ART:|r CC debug enabled. Test assignments stay local."
      or "|cffffd100ART:|r CC debug disabled.")
  return self.debugMode
end

function CC:SetMarkerForSpawn(preset, pullIndex, spawnKey, marker)
  local value = preset and preset.value
  local _, enemyIdx, cloneIdx = self:PullContainsSpawn(preset, pullIndex, spawnKey)
  if not enemyIdx then return false end
  value.enemyAssignments = value.enemyAssignments or {}
  local pull = value.pulls and value.pulls[pullIndex]
  for otherEnemyIdx, clones in pairs(type(pull) == "table" and pull or {}) do
    local assignments = value.enemyAssignments[otherEnemyIdx]
        or value.enemyAssignments[tonumber(otherEnemyIdx)]
    if type(assignments) == "table" then
      for _, otherCloneIdx in ipairs(type(clones) == "table" and clones or {}) do
        if assignments[otherCloneIdx] == marker then assignments[otherCloneIdx] = nil end
      end
    end
  end
  value.enemyAssignments[enemyIdx] = value.enemyAssignments[enemyIdx] or {}
  value.enemyAssignments[enemyIdx][cloneIdx] = marker
  return true
end

function CC:SetPullAssignment(preset, pullIndex, spawnKey, marker, assignment, silent, raid)
  marker, assignment = validMarker(marker), assignmentCopy(assignment)
  raid = raid or self:GetRaidForPreset(preset)
  local _, enemy = self:FindSpawn(raid, spawnKey)
  local pull = preset and preset.value and preset.value.pulls and preset.value.pulls[pullIndex]
  if not marker or not assignment or not enemy or type(pull) ~= "table"
      or not self:PullContainsSpawn(preset, pullIndex, spawnKey)
      or not self:MarkerAvailableForSpawn(preset, pullIndex, spawnKey, marker)
      or not self:IsEligible(catalog[assignment.ccKey], enemy) then return false end
  if self.debugMode and not silent then
    self.testPullAssignments[preset] = self.testPullAssignments[preset] or {}
    self.testPullAssignments[preset][pullIndex] = self.testPullAssignments[preset][pullIndex] or {}
    self.testPullAssignments[preset][pullIndex][spawnKey] = assignment
    self:RefreshUI()
    return assignment
  end
  pull.artCCAssignments = pull.artCCAssignments or {}
  pull.artCCAssignments[spawnKey] = assignment
  if not silent then
    self:SendChange(preset, "pull", "set", {
      pullIndex = pullIndex, spawnKey = spawnKey, marker = marker, assignment = assignment,
    })
    self:RefreshUI()
  end
  return assignment
end

function CC:ClearPullAssignment(preset, pullIndex, spawnKey, silent)
  local pull = preset and preset.value and preset.value.pulls and preset.value.pulls[pullIndex]
  if self.debugMode and not silent then
    if not pull then return false end
    self.testPullAssignments[preset] = self.testPullAssignments[preset] or {}
    self.testPullAssignments[preset][pullIndex] = self.testPullAssignments[preset][pullIndex] or {}
    self.testPullAssignments[preset][pullIndex][spawnKey] = false
    self:RefreshUI()
    return true
  end
  if not pull or not pull.artCCAssignments or not pull.artCCAssignments[spawnKey] then return false end
  pull.artCCAssignments[spawnKey] = nil
  if not next(pull.artCCAssignments) then pull.artCCAssignments = nil end
  if not silent then
    self:SendChange(preset, "pull", "clear", { pullIndex = pullIndex, spawnKey = spawnKey })
    self:RefreshUI()
  end
  return true
end

function CC:ClearActivePullAssignments()
  local preset, pullIndex = ART:GetCurrentPreset(), self:GetActivePullIndex()
  local pull = preset and preset.value and preset.value.pulls and preset.value.pulls[pullIndex]
  local assignments = type(pull) == "table" and pull.artCCAssignments
  local spawnKeys = {}
  for spawnKey in pairs(type(assignments) == "table" and assignments or {}) do spawnKeys[spawnKey] = true end
  if self.debugMode then
    local debugAssignments = self.testPullAssignments[preset]
    debugAssignments = debugAssignments and debugAssignments[pullIndex]
    for spawnKey in pairs(debugAssignments or {}) do spawnKeys[spawnKey] = true end
    if not next(spawnKeys) then return false end
    self.testPullAssignments[preset] = self.testPullAssignments[preset] or {}
    self.testPullAssignments[preset][pullIndex] = self.testPullAssignments[preset][pullIndex] or {}
    for spawnKey in pairs(spawnKeys) do self.testPullAssignments[preset][pullIndex][spawnKey] = false end
    self:RefreshDefaultUI()
    return true
  end
  if not next(spawnKeys) then return false end
  for spawnKey in pairs(spawnKeys) do
    self:ClearPullAssignment(preset, pullIndex, spawnKey, true)
    self:SendChange(preset, "pull", "clear", { pullIndex = pullIndex, spawnKey = spawnKey })
  end
  self:RefreshDefaultUI()
  return true
end

function CC:SetDefaultAssignment(preset, npcId, marker, assignment, silent, raid, sublevel)
  npcId, marker, assignment = tonumber(npcId), validMarker(marker), assignmentCopy(assignment)
  sublevel = assignmentSublevel(preset, sublevel)
  raid = raid or self:GetRaidForPreset(preset)
  local enemy = raid and raid.enemies and raid.enemies[tostring(npcId)]
  if not npcId or not marker or not assignment or not enemy
      or not self:IsEligible(catalog[assignment.ccKey], enemy) then return false end
  if self.debugMode and not silent then
    self.testDefaultAssignments[preset] = self.testDefaultAssignments[preset] or {}
    self.testDefaultAssignments[preset][sublevel] = self.testDefaultAssignments[preset][sublevel] or {}
    self.testDefaultAssignments[preset][sublevel][npcId] = self.testDefaultAssignments[preset][sublevel][npcId] or {}
    self.testDefaultAssignments[preset][sublevel][npcId][marker] = assignment
    self:RefreshDefaultUI()
    return assignment
  end
  local value = preset.value
  value.artCCFloorDefaults = value.artCCFloorDefaults or {}
  value.artCCFloorDefaults[sublevel] = value.artCCFloorDefaults[sublevel] or {}
  value.artCCFloorDefaults[sublevel][npcId] = value.artCCFloorDefaults[sublevel][npcId] or {}
  value.artCCFloorDefaults[sublevel][npcId][marker] = assignment
  self:EnsureDefaultMarkers(preset)
  if ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
  if not silent then
    self:SendChange(preset, "default", "set", { npcId = npcId, marker = marker, assignment = assignment })
    self:RefreshDefaultUI()
  end
  return assignment
end

function CC:ClearDefaultAssignment(preset, npcId, marker, silent, sublevel)
  npcId, marker = tonumber(npcId), validMarker(marker)
  sublevel = assignmentSublevel(preset, sublevel)
  if self.debugMode and not silent then
    self.testDefaultAssignments[preset] = self.testDefaultAssignments[preset] or {}
    self.testDefaultAssignments[preset][sublevel] = self.testDefaultAssignments[preset][sublevel] or {}
    self.testDefaultAssignments[preset][sublevel][npcId] = self.testDefaultAssignments[preset][sublevel][npcId] or {}
    self.testDefaultAssignments[preset][sublevel][npcId][marker] = false
    self:RefreshDefaultUI()
    return true
  end
  local floors = preset and preset.value and preset.value.artCCFloorDefaults
  local defaults = floors and floors[sublevel]
  if not defaults or not defaults[npcId] or not defaults[npcId][marker] then return false end
  defaults[npcId][marker] = nil
  if not next(defaults[npcId]) then defaults[npcId] = nil end
  if not next(defaults) then floors[sublevel] = nil end
  if not next(floors) then preset.value.artCCFloorDefaults = nil end
  if not silent then
    self:SendChange(preset, "default", "clear", { npcId = npcId, marker = marker })
    self:RefreshDefaultUI()
  end
  return true
end

function CC:ClearFloorAssignments(preset, sublevel, silent)
  sublevel = assignmentSublevel(preset, sublevel)
  local floors = preset and preset.value and preset.value.artCCFloorDefaults
  local defaults = floors and floors[sublevel]
  if self.debugMode and not silent then
    local debugFloors = self.testDefaultAssignments[preset]
    local debugDefaults = debugFloors and debugFloors[sublevel]
    local targets = {}
    for npcId, markers in pairs(type(defaults) == "table" and defaults or {}) do
      targets[npcId] = targets[npcId] or {}
      for marker in pairs(markers) do targets[npcId][marker] = true end
    end
    for npcId, markers in pairs(type(debugDefaults) == "table" and debugDefaults or {}) do
      targets[npcId] = targets[npcId] or {}
      for marker in pairs(markers) do targets[npcId][marker] = true end
    end
    if not next(targets) then return false end
    self.testDefaultAssignments[preset] = self.testDefaultAssignments[preset] or {}
    self.testDefaultAssignments[preset][sublevel] = self.testDefaultAssignments[preset][sublevel] or {}
    for npcId, markers in pairs(targets) do
      self.testDefaultAssignments[preset][sublevel][npcId] =
          self.testDefaultAssignments[preset][sublevel][npcId] or {}
      for marker in pairs(markers) do self.testDefaultAssignments[preset][sublevel][npcId][marker] = false end
    end
    self:RefreshDefaultUI()
    return true
  end
  if type(defaults) ~= "table" then return false end
  local targets = {}
  for npcId, markers in pairs(defaults) do
    for marker in pairs(markers) do targets[#targets + 1] = { npcId = npcId, marker = marker } end
  end
  floors[sublevel] = nil
  if not next(floors) then preset.value.artCCFloorDefaults = nil end
  if not silent then
    for _, target in ipairs(targets) do
      self:SendChange(preset, "default", "clear", target)
    end
    self:RefreshDefaultUI()
  end
  return true
end

function CC:EnsureDefaultMarkers(preset)
  preset = preset or (ART.GetCurrentPreset and ART:GetCurrentPreset())
  local planner = ART.RaidPlanner
  if not planner or not planner.preset or not planner.preset.marking or not preset or preset ~= ART:GetCurrentPreset() then return end
  local sublevel = assignmentSublevel(preset)
  planner.preset.marking.floorNpcDefaults = planner.preset.marking.floorNpcDefaults or {}
  local npcDefaults = planner.preset.marking.floorNpcDefaults[sublevel] or {}
  planner.preset.marking.floorNpcDefaults[sublevel] = npcDefaults
  local floorDefaults = preset.value.artCCFloorDefaults and preset.value.artCCFloorDefaults[sublevel]
  for npcId, markers in pairs(floorDefaults or {}) do
    local selected = {}
    for _, marker in ipairs(npcDefaults[npcId] or {}) do selected[marker] = true end
    for marker in pairs(markers) do selected[marker] = true end
    local values = {}
    for _, marker in ipairs(MARKER_ORDER) do if selected[marker] then values[#values + 1] = marker end end
    npcDefaults[npcId] = values
  end
end

local function coloredPlayer(player, talent)
  local color = RAID_CLASS_COLORS and RAID_CLASS_COLORS[player.classFile]
  local text = player.displayName or shortName(player.name)
  if talent then text = text.." (Talent)" end
  if color and color.colorStr then return "|c"..color.colorStr..text.."|r" end
  return text
end

local function iconLabel(definition)
  return ("|T%s:16:16:0:0|t %s"):format(definition.icon, definition.label)
end

function CC:AddChoices(menu, enemy, commit)
  local any = false
  for _, definition in ipairs(self:GetEligibleCCs(enemy)) do
    any = true
    local ccMenu = menu:CreateButton(iconLabel(definition), function() end)
    local players = self:GetEligiblePlayers(definition.key)
    if #players == 0 then
      ccMenu:CreateTitle("No eligible players in group")
    else
      for _, player in ipairs(players) do
        ccMenu:CreateButton(coloredPlayer(player, definition.talent), function()
          commit(definition, player)
        end)
      end
    end
  end
  if not any then menu:CreateTitle("No supported long CC") end
end

function CC:GetUsedMarkers(pullIndex)
  if not pullIndex then return {} end
  local used, planner = {}, ART.RaidPlanner
  local step = planner and planner.GetPullStep and planner:GetPullStep(pullIndex)
  local active = planner and planner.GetActiveStep and planner:GetActiveStep()
  if active and ((pullIndex and active.id == "pull-"..pullIndex)
      or planner.IsStepPinned and planner:IsStepPinned()) then step = active end
  for _, marker in pairs(step and step.marks or {}) do
    local normalized = validMarker(marker)
    if normalized then used[normalized] = true end
  end
  return used
end

function CC:AddNpcMenu(root, frame, setMarker)
  if not self:CanEdit() then
    root:CreateButton("CC Assignment", function() end):CreateTitle("Raid lead or assist required")
    return
  end
  local preset = ART:GetCurrentPreset()
  local pullIndex = tonumber(preset.value.currentPull) or 1
  local spawnKey = frame.clone and frame.clone.artSpawnKey
  local _, enemy, npcId = self:FindSpawn(ART.RaidPlanner and ART.RaidPlanner.raid, spawnKey)
  if not spawnKey or not enemy or not self:PullContainsSpawn(preset, pullIndex, spawnKey) then
    root:CreateButton("CC Assignment", function() end):CreateTitle("Add this NPC to the current pull first")
    return
  end
  local menu = root
  local current = self:GetPullAssignment(preset, pullIndex, spawnKey)
  if current then
    menu:CreateButton("Remove pull assignment", function()
      CC:ClearPullAssignment(preset, pullIndex, spawnKey)
    end)
    menu:CreateDivider()
  end
  local marker = validMarker(frame.assignment)
  local function addForMarker(parent, selectedMarker)
    self:AddChoices(parent, enemy, function(definition, player)
      if not marker and not setMarker(selectedMarker) then return end
      CC:SetMarkerForSpawn(preset, pullIndex, spawnKey, selectedMarker)
      CC:SetPullAssignment(preset, pullIndex, spawnKey, selectedMarker, {
        ccKey = definition.key, assignee = { name = player.name, classFile = player.classFile },
      })
    end)
  end
  if marker then
    addForMarker(menu, marker)
  else
    local used = self:GetUsedMarkers(pullIndex)
    local available = false
    for _, candidate in ipairs(MARKER_ORDER) do
      if not used[candidate] then
        available = true
        local markerMenu = menu:CreateButton(("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:16:16|t %s")
            :format(candidate, _G["RAID_TARGET_"..candidate] or candidate), function() end)
        addForMarker(markerMenu, candidate)
      end
    end
    if not available then menu:CreateTitle("No free raid markers") end
  end
end

function CC:OpenDefaultMenu(owner, enemy, marker, assignmentChanged)
  ART:CreateContextMenu(owner, function(_, root)
    root:CreateTitle(enemy.name)
    local menu = root:CreateButton(("CC for |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:16:16|t")
        :format(marker), function() end)
    if not CC:CanEdit() then menu:CreateTitle("Raid lead or assist required"); return end
    local preset = ART:GetCurrentPreset()
    if CC:GetDefaultAssignment(preset, enemy.npcId, marker) then
      root:CreateButton("Remove CC assignment", function()
        if CC:ClearDefaultAssignment(preset, enemy.npcId, marker) then assignmentChanged(nil) end
      end)
      root:CreateDivider()
    end
    CC:AddChoices(menu, enemy.definition or enemy, function(definition, player)
      local assignment = {
        ccKey = definition.key, assignee = { name = player.name, classFile = player.classFile },
      }
      if CC:SetDefaultAssignment(preset, enemy.npcId, marker, assignment) then assignmentChanged(assignment) end
    end)
  end)
end

function CC:GetActivePullIndex()
  local tracker = ART.RaidMarksUI
  return tonumber(tracker and tracker.trackerPullIndex)
      or tonumber(ART.RaidPlanner and ART.RaidPlanner.lastPullIndex)
      or tonumber(ART.GetCurrentPreset and ART:GetCurrentPreset().value.currentPull)
end

function CC:GetAssignmentRows(pullIndex)
  local preset, planner = ART:GetCurrentPreset(), ART.RaidPlanner
  local raid = planner and planner.raid
  pullIndex = pullIndex or self:GetActivePullIndex()
  local step = pullIndex and planner and planner.GetPullStep and planner:GetPullStep(pullIndex)
  local active = planner and planner.GetActiveStep and planner:GetActiveStep()
  if active and (active.id == "pull-"..pullIndex or planner.IsStepPinned and planner:IsStepPinned()) then step = active end
  if not raid or not preset or type(preset.value) ~= "table" then return {} end
  step = step or { marks = {} }
  local rows, usedMarkers, names, floorByMarker, globalByMarker = {}, {}, {}, {}, {}
  for npcKey, enemy in pairs(raid.enemies or {}) do
    names[tonumber(enemy.npcId) or tonumber(npcKey)] = enemy.name
  end

  for marker, player in pairs(type(preset.value.artPlayerMarks) == "table" and preset.value.artPlayerMarks or {}) do
    marker, player = validMarker(marker), playerCopy(player)
    if marker and player then
      globalByMarker[marker] = {
        key = "player:"..marker, marker = marker, name = player.name,
        player = player, playerGlobal = true,
        assignment = player.ccKey and {
          ccKey = player.ccKey,
          assignee = { name = player.name, classFile = player.classFile },
        } or nil,
      }
    end
  end

  local pull = pullIndex and preset.value.pulls and preset.value.pulls[pullIndex]
  local enemies = ART.raidEnemies and ART.raidEnemies[preset.value.currentRaidIndex]
  for enemyIdx, clones in pairs(type(pull) == "table" and pull or {}) do
    local projected = tonumber(enemyIdx) and enemies and enemies[tonumber(enemyIdx)]
    local npcId = projected and tonumber(projected.id)
    if npcId then
      for _, marker in ipairs(planner:GetNpcDefaultMarks(npcId)) do
        marker = validMarker(marker)
        if marker then
          floorByMarker[marker] = {
            key = npcId..":"..marker, npcId = npcId, marker = marker,
            name = names[npcId] or projected.name,
            assignment = self:GetDefaultAssignment(preset, npcId, marker), global = true,
          }
        end
      end
    end
  end

  for spawnKey, marker in pairs(step.marks or {}) do
    local _, enemy, npcId = self:FindSpawn(raid, spawnKey)
    local normalizedMarker = validMarker(marker)
    if enemy and normalizedMarker then
      local floor, global = floorByMarker[normalizedMarker], globalByMarker[normalizedMarker]
      usedMarkers[normalizedMarker] = true
      rows[#rows + 1] = {
        key = spawnKey, spawnKey = spawnKey, npcId = npcId, marker = normalizedMarker,
        name = enemy.name,
        assignment = self:GetEffectiveAssignment(preset, pullIndex, spawnKey, npcId, normalizedMarker)
            or floor and floor.assignment or global and global.assignment,
      }
    end
  end

  for marker, floor in pairs(floorByMarker) do
    if not usedMarkers[marker] then
      usedMarkers[marker] = true
      floor.assignment = floor.assignment or globalByMarker[marker] and globalByMarker[marker].assignment
      rows[#rows + 1] = floor
    end
  end
  for marker, global in pairs(globalByMarker) do
    if not usedMarkers[marker] then rows[#rows + 1] = global end
  end
  local priority = {}; for index, marker in ipairs(MARKER_ORDER) do priority[marker] = index end
  table.sort(rows, function(left, right)
    return priority[left.marker] < priority[right.marker]
        or priority[left.marker] == priority[right.marker] and left.name < right.name
  end)
  for _, row in ipairs(rows) do row.runtime = self:GetRuntime(row.npcId, row.marker) end
  return rows
end

local function npcIdFromGuid(guid)
  if type(guid) ~= "string" then return end
  local previous, last
  for component in guid:gmatch("[^%-]+") do previous, last = last, component end
  return tonumber(previous)
end

local function markerFromFlags(flags)
  flags = tonumber(flags)
  if not flags then return end
  for marker = 1, 8 do
    local value = _G["COMBATLOG_OBJECT_RAIDTARGET"..marker] or 2 ^ (marker - 1)
    if value and bit and bit.band(flags, value) ~= 0 then return marker end
  end
end

function CC:GetRuntime(npcId, marker)
  local pullIndex = self:GetActivePullIndex()
  if self.runtimePullIndex ~= pullIndex then
    wipe(self.runtime)
    self.runtimePullIndex = pullIndex
  end
  for _, state in pairs(self.runtime) do
    if state.npcId == tonumber(npcId) and state.marker == tonumber(marker) then
      if state.expires <= (GetTime and GetTime() or 0) then self.runtime[state.guid] = nil return end
      self:SyncAura(state)
      return state
    end
  end
end

function CC:ResetRuntime()
  wipe(self.runtime)
  self.runtimePullIndex = self:GetActivePullIndex()
  self:RefreshEventRegistration()
  self:RefreshTracker()
end

function CC:FireDebugCC(npcId, marker, assignment)
  if not self.debugMode then return false end
  local definition = assignment and catalog[assignment.ccKey]
  if not definition then return false end
  local now = GetTime and GetTime() or 0
  wipe(self.runtime)
  self.runtimePullIndex = self:GetActivePullIndex()
  self.runtime["ART-CC-TEST"] = {
    guid = "ART-CC-TEST", npcId = tonumber(npcId), marker = validMarker(marker),
    definition = definition, started = now, duration = 10, expires = now + 10,
    wrongCaster = false,
  }
  self:RefreshTracker()
  return true
end

function CC:FireFirstDebugCC(pullIndex)
  for _, row in ipairs(self:GetAssignmentRows(pullIndex)) do
    if row.assignment then return self:FireDebugCC(row.npcId, row.marker, row.assignment) end
  end
  print("|cffffd100ART:|r Assign a CC in the current pull first.")
  return false
end

local function unitForGuid(guid)
  if type(UnitGUID) ~= "function" then return end
  local fixed = { "target", "focus", "mouseover" }
  for _, unit in ipairs(fixed) do if UnitGUID(unit) == guid then return unit end end
  for index = 1, 40 do
    local unit = "nameplate"..index
    if UnitGUID(unit) == guid then return unit end
  end
end

function CC:SyncAura(state)
  local unit = unitForGuid(state.guid)
  if not unit or type(UnitDebuff) ~= "function" then return end
  for index = 1, 40 do
    local name, _, _, _, duration, expirationTime, _, _, _, spellId = UnitDebuff(unit, index)
    if not name then break end
    if auraCatalog[tonumber(spellId)] == state.definition and tonumber(duration) and tonumber(expirationTime) then
      state.duration, state.expires = duration, expirationTime
      state.started = expirationTime - duration
      return
    end
  end
end

function CC:HandleCombatLog(...)
  local data = { ... }
  local subevent, sourceName, destGuid, destRaidFlags = data[2], data[5], data[8], data[11]
  if subevent == "UNIT_DIED" then
    if self.runtime[destGuid] then self.runtime[destGuid] = nil; self:RefreshTracker() end
    return
  end
  local spellId, definition = tonumber(data[12]), auraCatalog[tonumber(data[12])]
  if not definition then return end
  if subevent == "SPELL_AURA_REMOVED" or subevent == "SPELL_AURA_BROKEN"
      or subevent == "SPELL_AURA_BROKEN_SPELL" then
    if self.runtime[destGuid] then self.runtime[destGuid] = nil; self:RefreshTracker() end
    return
  end
  if subevent ~= "SPELL_AURA_APPLIED" and subevent ~= "SPELL_AURA_REFRESH" then return end
  local npcId, marker = npcIdFromGuid(destGuid), markerFromFlags(destRaidFlags)
  if not npcId or not marker then return end
  local planned
  for _, row in ipairs(self:GetAssignmentRows(self:GetActivePullIndex())) do
    if row.npcId == npcId and row.marker == marker and row.assignment and row.assignment.ccKey == definition.key then
      planned = row.assignment break
    end
  end
  if not planned then return end
  local now = GetTime and GetTime() or 0
  local state = {
    guid = destGuid, npcId = npcId, marker = marker, definition = definition,
    started = now, duration = definition.duration, expires = now + definition.duration,
    wrongCaster = not namesMatch(planned.assignee.name, sourceName),
  }
  self.runtime[destGuid] = state
  self:SyncAura(state)
  self:RefreshTracker()
end

function CC:SendChange(preset, scope, operation, target)
  if self.debugMode then return false end
  if not ART.liveSessionActive or not ART.LiveSession_CanControlProgress
      or not ART:LiveSession_CanControlProgress() or preset.uid ~= ART.livePresetUID
      or ART:IsPlayerInGroup() ~= "RAID" then return false end
  local raid = self:GetRaidForPreset(preset)
  if not raid then return false end
  ART.commsObject:SendCommMessage(ART.liveSessionPrefixes.ccAssignment, ART:TableToString({
    version = 1, raidKey = raid.key, raidIndex = preset.value.currentRaidIndex, presetUID = preset.uid,
    sublevel = preset.value.currentSublevel or 1, scope = scope, operation = operation, target = target,
  }), "RAID", nil, "ALERT")
  return true
end

function CC:ReceiveChange(message, distribution, sender)
  if not ART.liveSessionActive or distribution ~= "RAID" or not ART:LiveSession_CanControlProgress(sender) then return false end
  local payload = type(message) == "table" and message or ART:StringToTable(message, false)
  local preset = ART:GetCurrentLivePreset()
  if type(payload) ~= "table" or payload.version ~= 1 or type(payload.raidKey) ~= "string"
      or type(payload.raidIndex) ~= "number" or type(payload.presetUID) ~= "string"
      or type(payload.sublevel) ~= "number" or payload.sublevel % 1 ~= 0
      or type(payload.target) ~= "table" or not preset or preset.uid ~= payload.presetUID
      or preset.value.currentRaidIndex ~= payload.raidIndex then return false end
  local raid = self:GetRaidForPreset(preset, payload.raidKey)
  local mapInfo = ART.mapInfo and ART.mapInfo[payload.raidIndex]
  if not raid or not raid.sublevels[payload.sublevel] or not mapInfo or mapInfo.mapID ~= raid.mapId then return false end
  local target, result = payload.target
  if payload.scope == "pull" then
    local pullIndex = tonumber(target.pullIndex)
    if not pullIndex or pullIndex % 1 ~= 0 or pullIndex < 1 or pullIndex > #(preset.value.pulls or {}) then return false end
    if payload.operation == "clear" then
      result = self:ClearPullAssignment(preset, pullIndex, target.spawnKey, true)
    elseif payload.operation == "set" then
      result = self:SetPullAssignment(preset, pullIndex, target.spawnKey, target.marker, target.assignment, true, raid)
      if result then self:SetMarkerForSpawn(preset, pullIndex, target.spawnKey, target.marker) end
    end
  elseif payload.scope == "default" then
    if payload.operation == "clear" then
      result = self:ClearDefaultAssignment(preset, target.npcId, target.marker, true, payload.sublevel)
    elseif payload.operation == "set" then
      result = self:SetDefaultAssignment(preset, target.npcId, target.marker, target.assignment, true, raid,
        payload.sublevel)
    end
  end
  if result and preset == ART:GetCurrentPreset() then
    if payload.scope == "default" then
      if ART.AutoMarksUI and ART.AutoMarksUI.Refresh then ART.AutoMarksUI:Refresh() end
      self:RefreshDefaultUI()
    else
      self:RefreshUI()
    end
  end
  return result and true or false
end

function CC:UpdateBlipBadge(frame)
  if not frame or not frame.texture_CCIcon then return end
  local preset, marker = ART:GetCurrentPreset(), validMarker(frame.assignment)
  local spawnKey = frame.clone and frame.clone.artSpawnKey
  local _, _, npcId = self:FindSpawn(ART.RaidPlanner and ART.RaidPlanner.raid, spawnKey)
  local assignment = marker and self:GetEffectiveAssignment(preset, preset.value.currentPull, spawnKey, npcId, marker)
  if assignment then
    frame.texture_CCIcon:SetTexture(catalog[assignment.ccKey].icon)
    frame.texture_CCIcon:Show()
  else
    frame.texture_CCIcon:Hide()
  end
end

local originalUpdateMap = ART.UpdateMap
if type(originalUpdateMap) == "function" then
  function ART:UpdateMap(...)
    CC:EnsureDefaultMarkers()
    return originalUpdateMap(self, ...)
  end
end

function CC:RefreshEventRegistration()
  local preset = ART.GetCurrentPreset and ART:GetCurrentPreset()
  local value = preset and preset.value
  local pull = value and value.pulls and value.pulls[self:GetActivePullIndex()]
  local hasGlobalCC = false
  for _, player in pairs(type(value and value.artPlayerMarks) == "table" and value.artPlayerMarks or {}) do
    if playerCopy(player) and player.ccKey then hasGlobalCC = true break end
  end
  local hasAssignments = type(pull) == "table" and type(pull.artCCAssignments) == "table"
      and next(pull.artCCAssignments) ~= nil
      or type(value and value.artCCFloorDefaults) == "table" and next(value.artCCFloorDefaults) ~= nil
      or hasGlobalCC
  local raid = ART.RaidPlanner and ART.RaidPlanner.raid
  local inRaid = raid and type(GetInstanceInfo) == "function" and select(8, GetInstanceInfo()) == raid.instanceId
  local active = hasAssignments and inRaid or false
  if self.combatLogActive == active then return end
  self.combatLogActive = active
  if not self.eventFrame then return end
  if active then self.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  elseif self.eventFrame.UnregisterEvent then self.eventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end
end

if type(CreateFrame) == "function" then
  local eventFrame = CreateFrame("Frame")
  eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  eventFrame:RegisterEvent("ENCOUNTER_END")
  eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
  eventFrame:SetScript("OnEvent", function(_, event)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
      CC:HandleCombatLog(CombatLogGetCurrentEventInfo())
    else
      CC:ResetRuntime()
    end
  end)
  CC.eventFrame = eventFrame
  CC:RefreshEventRegistration()
end
