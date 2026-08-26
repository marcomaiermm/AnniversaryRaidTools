local _, ART = ...

local tinsert, tremove, tonumber, pairs, ipairs = table.insert, table.remove, tonumber, pairs, ipairs
local db

local function initializeDB()
  db = db or ART:GetDB()
end

---Adds up health of all enemies in the current pull
function ART:SumCurrentPullHealth(currentPull)
  initializeDB()
  currentPull = currentPull or 1000
  local preset = self:GetCurrentPreset()
  local pull = preset.value.pulls[currentPull]
  if not pull then return 0 end

  local totalHealth = 0
  for enemyIdx, clones in pairs(pull) do
    if tonumber(enemyIdx) then
      for k, v in pairs(clones) do
        if ART:IsCloneIncluded(enemyIdx, v) then
          local data = self.raidEnemies[db.currentRaidIndex][enemyIdx]
          local health = self:CalculateEnemyHealth(false, data.health)
          totalHealth = totalHealth + health
        end
      end
    end
  end
  return totalHealth
end

---Checks if the specified clone is part of the current map configuration
function ART:IsCloneIncluded(enemyIdx, cloneIdx)
  initializeDB()
  local enemy = ART.raidEnemies[db.currentRaidIndex][enemyIdx]
  local clone = enemy and enemy["clones"][cloneIdx]
  if not clone then return false end
  return true
end

---Returns the current pull of the currently active preset
function ART:GetCurrentPull()
  local selection = ART:GetSelection()
  return selection[#selection]
end

function ART:EnablePullsPerSublevel()
  initializeDB()
  local value = self:GetCurrentPreset().value
  local currentSublevel = value.currentSublevel or 1
  if not value.pullsBySublevel then
    local pullsBySublevel = {}
    for _, pull in ipairs(value.pulls or {}) do
      local split, options, ccAssignments = {}, {}, nil
      for key, item in pairs(pull) do
        local enemyIdx = tonumber(key)
        if enemyIdx and type(item) == "table" then
          local enemy = self.raidEnemies[db.currentRaidIndex] and self.raidEnemies[db.currentRaidIndex][enemyIdx]
          for _, cloneIdx in ipairs(item) do
            local clone = enemy and enemy.clones and enemy.clones[cloneIdx]
            local sublevel = clone and clone.sublevel or currentSublevel
            split[sublevel] = split[sublevel] or {}
            split[sublevel][enemyIdx] = split[sublevel][enemyIdx] or {}
            tinsert(split[sublevel][enemyIdx], cloneIdx)
          end
        elseif key == "artCCAssignments" then
          ccAssignments = item
        else
          options[key] = item
        end
      end
      if next(split) then
        for sublevel, floorPull in pairs(split) do
          for key, item in pairs(options) do floorPull[key] = item end
          if type(ccAssignments) == "table" then
            local floorAssignments = {}
            for spawnKey, assignment in pairs(ccAssignments) do
              for _, enemy in pairs(self.raidEnemies[db.currentRaidIndex] or {}) do
                for _, clone in ipairs(enemy.clones or {}) do
                  if clone.artSpawnKey == spawnKey and clone.sublevel == sublevel then
                    floorAssignments[spawnKey] = assignment
                  end
                end
              end
            end
            if next(floorAssignments) then floorPull.artCCAssignments = floorAssignments end
          end
          pullsBySublevel[sublevel] = pullsBySublevel[sublevel] or {}
          tinsert(pullsBySublevel[sublevel], floorPull)
        end
      else
        pullsBySublevel[currentSublevel] = pullsBySublevel[currentSublevel] or {}
        tinsert(pullsBySublevel[currentSublevel], pull)
      end
    end
    value.pullsBySublevel = pullsBySublevel
    value.currentPullBySublevel = {}
  end
  local pulls = value.pullsBySublevel[currentSublevel] or { {} }
  value.pullsBySublevel[currentSublevel] = pulls
  value.pulls = pulls
  value.currentPull = math.min(value.currentPullBySublevel[currentSublevel] or value.currentPull or 1, #pulls)
  value.selection = { value.currentPull }
end

function ART:SetPullSublevel(sublevel)
  local value = self:GetCurrentPreset().value
  if not value.pullsBySublevel then value.currentSublevel = sublevel; return end
  value.pullsBySublevel[value.currentSublevel] = value.pulls
  value.currentPullBySublevel[value.currentSublevel] = value.currentPull
  value.currentSublevel = sublevel
  local pulls = value.pullsBySublevel[sublevel] or { {} }
  value.pullsBySublevel[sublevel] = pulls
  value.pulls = pulls
  value.currentPull = math.min(value.currentPullBySublevel[sublevel] or 1, #pulls)
  value.selection = { value.currentPull }
end

---Stores r g b values for coloring pulls with ART:ColorPull()
local colorPaletteValues = {
  [1] = { --Rainbow values
    [1] = { [1] = 0.2446, [2] = 1, [3] = 0.2446 },
    [2] = { [1] = 0.2446, [2] = 1, [3] = 0.6223 },
    [3] = { [1] = 0.2446, [2] = 1, [3] = 1 },
    [4] = { [1] = 0.2446, [2] = 0.6223, [3] = 1 },
    [5] = { [1] = 0.2446, [2] = 0.2446, [3] = 1 },
    [6] = { [1] = 0.6223, [2] = 0.6223, [3] = 1 },
    [7] = { [1] = 1, [2] = 0.2446, [3] = 1 },
    [8] = { [1] = 1, [2] = 0.2446, [3] = 0.6223 },
    [9] = { [1] = 1, [2] = 0.2446, [3] = 0.2446 },
    [10] = { [1] = 1, [2] = 0.60971, [3] = 0.2446 },
    [11] = { [1] = 1, [2] = 0.98741, [3] = 0.2446 },
    [12] = { [1] = 0.63489, [2] = 1, [3] = 0.2446 },
    --[13] = {[1]=1, [2]=0.2446, [3]=0.54676},
    --[14] = {[1]=1, [2]=0.2446, [3]=0.32014},
    --[15] = {[1]=1, [2]=0.38309, [3]=0.2446},
    --[16] = {[1]=1, [2]=0.60971, [3]=0.2446},
    --[17] = {[1]=1, [2]=0.83633, [3]=0.2446},
    --[18] = {[1]=0.93705, [2]=1, [3]=0.2446},
    --[19] = {[1]=0.71043, [2]=1, [3]=0.2446},
    --[20] = {[1]=0.48381, [2]=1, [3]=0.2446},
  },
  [2] = { --Black and Yellow values
    [1] = { [1] = 0.4, [2] = 0.4, [3] = 0.4 },
    [2] = { [1] = 1, [2] = 1, [3] = 0.0 },
  },
  [3] = { --Red, Green and Blue values
    [1] = { [1] = 0.85882, [2] = 0.058824, [3] = 0.15294 },
    [2] = { [1] = 0.49804, [2] = 1.0, [3] = 0.0 },
    [3] = { [1] = 0.0, [2] = 0.50196, [3] = 1.0 },
  },
  [4] = { --High Contrast values
    [1] = { [1] = 1, [2] = 0.2446, [3] = 1 },
    [2] = { [1] = 0.2446, [2] = 1, [3] = 0.6223 },
    [3] = { [1] = 1, [2] = 0.2446, [3] = 0.2446 },
    [4] = { [1] = 0.2446, [2] = 0.6223, [3] = 1 },
    [5] = { [1] = 1, [2] = 0.98741, [3] = 0.2446 },
    [6] = { [1] = 0.2446, [2] = 1, [3] = 0.2446 },
    [7] = { [1] = 1, [2] = 0.2446, [3] = 0.6223 },
    [8] = { [1] = 0.2446, [2] = 1, [3] = 1 },
    [9] = { [1] = 1, [2] = 0.60971, [3] = 0.2446 },
    [10] = { [1] = 0.2446, [2] = 0.2446, [3] = 1 },
    [11] = { [1] = 0.63489, [2] = 1, [3] = 0.2446 },
  },
  [5] = { --Color Blind Friendly values (Based on IBM's color library "Color blind safe"
    [1] = { [1] = 0.39215686274509803, [2] = 0.5607843137254902, [3] = 1.0 },
    --[2] = {[1]=0.47058823529411764, [2]=0.3686274509803922, [3]=0.9411764705882353},
    [2] = { [1] = 0.8627450980392157, [2] = 0.14901960784313725, [3] = 0.4980392156862745 },
    [3] = { [1] = 0.996078431372549, [2] = 0.3803921568627451, [3] = 0.0 },
    [4] = { [1] = 1.0, [2] = 0.6901960784313725, [3] = 0.0 },
  },
}

---Function executes full coloring of a pull and it's blips
function ART:ColorPull(colorValues, pullIdx, preset, bypass, exportColorBlind) -- bypass can be passed as true to color even when automatic coloring is toggled off
  initializeDB()
  local colorPaletteInfo = ART:GetPresetColorPaletteInfo(preset)
  local pullIdx = pullIdx or ART:GetCurrentPull()
  if (pullIdx) then
    local colorValues
    local numberColors
    local r, g, b
    if colorPaletteInfo.autoColoring or bypass == true then
      --Force color blind mode locally, will not alter the color values saved to a preset
      if db.colorPaletteInfo.forceColorBlindMode == true and not exportColorBlind then
        --Local color blind mode, will not alter the colorPaletteInfo saved to a preset
        colorValues = colorValues or colorPaletteValues[colorValues] or colorPaletteValues[5]
        numberColors = #colorValues
      else
        --Regular coloring
        colorValues = colorValues or colorPaletteValues[colorValues] or colorPaletteInfo.colorPaletteIdx == 6 and colorPaletteInfo.customPaletteValues or colorPaletteValues[colorPaletteInfo.colorPaletteIdx]
        numberColors = colorPaletteInfo.colorPaletteIdx == 6 and colorPaletteInfo.numberCustomColors or #colorValues -- tables must start from 1 and have no blank rows
      end
      local colorIdx = (pullIdx - 1) % numberColors + 1
      r, g, b = colorValues[colorIdx][1], colorValues[colorIdx][2], colorValues[colorIdx][3]

      ART:RaidEnemies_SetPullColor(pullIdx, r, g, b)
      ART:UpdatePullButtonColor(pullIdx, r, g, b)
      ART:RaidEnemies_UpdateBlipColors(pullIdx, r, g, b)
    end
  end
end

---Loops over all pulls in a preset and colors them
function ART:ColorAllPulls(colorValues, startFrom, bypass, exportColorBlind)
  local preset = self:GetCurrentPreset()
  local startFrom = startFrom or 0
  for pullIdx, _ in pairs(preset.value.pulls) do
    if pullIdx >= startFrom then
      ART:ColorPull(colorValues, pullIdx, preset, bypass, exportColorBlind)
    end
  end
end

function ART:PresetsAddPull(index, data, preset)
  preset = preset or self:GetCurrentPreset()
  if not data then data = {} end
  if index then
    tinsert(preset.value.pulls, index, data)
  else
    tinsert(preset.value.pulls, data)
  end
  self:EnsureDBTables()
end

---Merges a list of pulls and inserts them at a specified destination.
---
---@param pulls table List of all pull indices, that shall be merged (and deleted). If pulls
---                   is a number, then the pull list is automatically generated from pulls
---                   and destination.
---@param destination number The pull index, where the merged pull shall be inserted.
---
---@author Dradux
function ART:PresetsMergePulls(pulls, destination)
  if type(pulls) == "number" then
    pulls = { pulls, destination }
  end

  if not destination then
    destination = pulls[#pulls]
  end

  local count_if = self.U.count_if

  local newPull = {}
  local destinationPull = self:GetCurrentPreset().value.pulls[destination]
  local destinationCC = destinationPull and destinationPull.artCCAssignments
  local removed_pulls = {}

  for _, pullIdx in ipairs(pulls) do
    local offset = count_if(removed_pulls, function(entry)
      return entry < pullIdx
    end)

    local index = pullIdx - offset
    local pull = self:GetCurrentPreset().value.pulls[index]

    for enemyIdx, clones in pairs(pull) do
      if string.match(enemyIdx, "^%d+$") then
        -- it's really an enemy index
        if tonumber(enemyIdx) then
          if not newPull[enemyIdx] then
            newPull[enemyIdx] = clones
          else
            for k, v in pairs(clones) do
              if newPull[enemyIdx][k] ~= nil then
                local newIndex = #newPull[enemyIdx] + 1
                newPull[enemyIdx][newIndex] = v
              else
                newPull[enemyIdx][k] = v
              end
            end
          end
        end
      elseif enemyIdx == "artCCAssignments" then
        newPull.artCCAssignments = newPull.artCCAssignments or {}
        for spawnKey, assignment in pairs(clones) do newPull.artCCAssignments[spawnKey] = assignment end
      else
        -- it's another pull option like color
        local optionName = enemyIdx
        local optionValue = clones
        newPull[optionName] = optionValue
      end
    end

    self:PresetsDeletePull(index)
    tinsert(removed_pulls, pullIdx)
  end

  local offset = count_if(removed_pulls, function(entry)
    return entry < destination
  end)

  local index = destination - offset
  if destinationCC then
    newPull.artCCAssignments = newPull.artCCAssignments or {}
    for spawnKey, assignment in pairs(destinationCC) do newPull.artCCAssignments[spawnKey] = assignment end
  end
  self:PresetsAddPull(index, newPull)
  return index
end

function ART:PresetsDeletePull(p, preset)
  preset = preset or self:GetCurrentPreset()
  if p == preset.value.currentPull then
    preset.value.currentPull = math.max(p - 1, 1)
  end
  tremove(preset.value.pulls, p)
end

function ART:GetPulls(preset)
  preset = preset or self:GetCurrentPreset()
  return preset.value.pulls
end

function ART:GetPullsNum(preset)
  preset = preset or self:GetCurrentPreset()
  return #preset.value.pulls
end

function ART:PresetsSwapPulls(p1, p2)
  local pulls = self:GetCurrentPreset().value.pulls
  pulls[p1], pulls[p2] = pulls[p2], pulls[p1]
end

function ART:SetSelectionToPull(pull, ignoreHulls)
  --if pull is not specified set pull to last pull in preset (for adding new pulls)
  if not pull then
    local count = 0
    for k, v in pairs(ART:GetCurrentPreset().value.pulls) do
      count = count + 1
    end
    pull = count
  end

  --SaveCurrentPresetPull
  if type(pull) == "number" and pull > 0 then
    ART:GetCurrentPreset().value.currentPull = pull
    ART:GetCurrentPreset().value.selection = { pull }
    if ART.main_frame and ART.main_frame.sidePanel then
      ART:PickPullButton(pull)
      ART:RaidEnemies_UpdateSelected(pull, nil, ignoreHulls)
    end
  elseif type(pull) == "table" then
    ART:GetCurrentPreset().value.currentPull = pull[#pull]
    ART:GetCurrentPreset().value.selection = pull

    if ART.main_frame and ART.main_frame.sidePanel then
      ART:ClearPullButtonPicks()
      for _, pullIdx in ipairs(ART:GetSelection()) do
        ART:PickPullButton(pullIdx, true)
        ART:RaidEnemies_UpdateSelected(pullIdx, nil, ignoreHulls)
      end
    end
  end
  ART:PullClickAreaOnLeave()
end

---Creates a new pull in the current preset and calls ReloadPullButtons to reflect the change in the scrollframe
function ART:AddPull(index)
  ART:PresetsAddPull(index)
  ART:ReloadPullButtons()
  ART:SetSelectionToPull(index)
end

---Clears all the npcs out of a pull
function ART:ClearPull(index)
  initializeDB()
  table.wipe(db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls[index])
  ART:EnsureDBTables()
  ART:ReloadPullButtons()
  ART:SetSelectionToPull(index)
end

---Moves the selected pull up
function ART:MovePullUp(index)
  ART:PresetsSwapPulls(index, index - 1)
  ART:ReloadPullButtons()
  ART:SetSelectionToPull(index - 1)
end

---Moves the selected pull down
function ART:MovePullDown(index)
  ART:PresetsSwapPulls(index, index + 1)
  ART:ReloadPullButtons()
  ART:SetSelectionToPull(index + 1)
end

---Deletes the selected pull and makes sure that a pull will be selected afterwards
function ART:DeletePull(index)
  local pulls = self:GetPulls()
  if #pulls == 1 then return end
  self:PresetsDeletePull(index)
  self:ReloadPullButtons()
  local pullCount = 0
  for k, v in pairs(pulls) do
    pullCount = pullCount + 1
  end
  if index > pullCount then index = pullCount end
  self:SetSelectionToPull(index)
end

function ART:GetSelection()
  if not ART:GetCurrentPreset().value.selection or #ART:GetCurrentPreset().value.selection == 0 then
    ART:GetCurrentPreset().value.selection = { ART:GetCurrentPreset().value.currentPull }
  end

  return ART:GetCurrentPreset().value.selection
end

function ART:CopyPullOptions(sourceIdx, destinationIdx)
  local preset = ART:GetCurrentPreset()
  local pulls = preset.value.pulls
  local source = pulls[sourceIdx]
  local destination = pulls[destinationIdx]

  if source and destination then
    for optionName, optionValue in pairs(source) do
      -- Assure, that it is an option and not an enemy index
      if optionName ~= "artCCAssignments" and not string.match(optionName, "^%d+$") then
        destination[optionName] = optionValue
      end
    end
  end
end
