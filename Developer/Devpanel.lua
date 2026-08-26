local AceGUI = LibStub("AceGUI-3.0")
local _, ART = ...
local db
local tonumber, tinsert, pairs, ipairs = tonumber, table.insert, pairs, ipairs
local UnitName, UnitGUID, UnitCreatureType, UnitHealthMax, UnitLevel = UnitName, UnitGUID, UnitCreatureType, UnitHealthMax, UnitLevel

--[[
  Bind macros:
  1. Add clone
  /run ART:AddCloneAtCursorPosition()
  2. Add patrol point to clone
  /run ART:AddPatrolWaypointAtCursorPosition()
  3. Add untargetable unit if needed
  /run ART:AddNPCFromUnit("mouseover")
]]

function ART:ToggleDevMode()
  db = ART:GetDB()
  if db.devMode then
    ART:Async(function()
      ART:DisableDevMode()
    end, "toggleDevMode")
    return
  end

  ART:Async(function()
    ART:EnableDevMode()
  end, "toggleDevMode")
end

local function syncDevModeCache()
  if not db.loadCache then return end

  if db.raidEnemies then
    ART.raidEnemies = db.raidEnemies
  else
    db.raidEnemies = ART.raidEnemies
  end

  if db.mapPOIs then
    ART.mapPOIs = db.mapPOIs
  else
    db.mapPOIs = ART.mapPOIs
  end
end

function ART:PositionDevPanel(frame, maximized)
  frame = frame or ART.main_frame
  if not frame or not frame.devPanel then return end
  if maximized == nil then maximized = db.maximized end

  frame.devPanel:ClearAllPoints()
  if maximized then
    frame.devPanel:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -45)
  else
    frame.devPanel:SetPoint("TOPRIGHT", frame.navigationSidebar, "TOPLEFT", 0, 0)
  end
  if db.devMode then frame.devPanel.frame:Show() end
end

local function syncDevPanelShowHide(devPanel, frame)
  local originalShow, originalHide = frame.Show, frame.Hide

  function frame:Hide(...)
    devPanel.frame:Hide()
    return originalHide(self, ...)
  end

  function frame:Show(...)
    if db.devMode then
      devPanel.frame:Show()
    end
    return originalShow(self, ...)
  end
end

function ART:EnableDevMode()
  db = ART:GetDB()
  db.devMode = true
  syncDevModeCache()

  ART:ShowInterfaceInternal(true)

  local frame = ART.main_frame
  if not frame then return end

  frame:SetScript("OnUpdate", nil)
  ART:HideAllBlipLabels(true)

  if ART.CreateDevPanel and not frame.devPanel then
    ART:CreateDevPanel(frame)
  end

  if frame.devPanel then
    ART:PositionDevPanel(frame)
  end

  ART:UpdateMap()
  ART:UpdateEnemyInfoFrame()
  print("|cffffd100ART:|r Debug mode enabled.")
end

function ART:DisableDevMode()
  db = ART:GetDB()
  db.devMode = false

  local frame = ART.main_frame
  if not frame then return end

  if frame.devPanel then
    frame.devPanel.frame:Hide()
  end

  ART:SetUpModifiers(frame)
  ART:HideAllBlipLabels(true)
  ART:UpdateMap()
  ART:UpdateEnemyInfoFrame()
  print("|cffffd100ART:|r Debug mode disabled.")
end

function ART:AddNPCFromUnit(unit)
  db = ART:GetDB()
  local npcId
  local guid = UnitGUID(unit)
  if guid then
    npcId = select(6, strsplit("-", guid))
    npcId = tonumber(npcId)
  end
  local added
  for _, npcData in pairs(ART.raidEnemies[db.currentRaidIndex]) do
    if npcData.id == npcId then
      added = true; break
    end
  end
  if npcId and not added then
    local npcName = UnitName(unit)
    local npcHealth = UnitHealthMax(unit)
    local npcLevel = UnitLevel(unit)
    local npcCreatureType = UnitCreatureType(unit)
    local npcScale = 1
    tinsert(ART.raidEnemies[db.currentRaidIndex], {
      name = npcName,
      health = npcHealth,
      level = npcLevel,
      creatureType = npcCreatureType,
      id = npcId,
      scale = npcScale,
      clones = {},
    })
    return npcId
  end
end

local currentEnemyIdx
local currentCloneGroup
local currentPatrol
local currentBossEnemyIdx = 1
local currentCloneScale
---CreateDevPanel
---Creates the dev panel which contains buttons to add npcs, objects to the map
function ART:CreateDevPanel(frame)
  db = ART:GetDB()
  frame.devPanel = AceGUI:Create("TabGroup")
  local devPanel = frame.devPanel
  devPanel.frame:SetParent(frame)
  devPanel.frame:SetFrameStrata("HIGH")
  devPanel.frame:SetFrameLevel(50)

  devPanel:SetTabs(
    {
      { text = "POI/Zoom",  value = "tab1" },
      { text = "Enemy",     value = "tab2" },
      { text = "Manage DB", value = "tab3" },
      { text = "Calibration", value = "tab4" },
    }
  )
  devPanel:SetWidth(250)
  devPanel:ClearAllPoints()
  ART:PositionDevPanel(frame)
  devPanel:SetLayout("Flow")
  if not db.devMode then devPanel.frame:Hide() end

  syncDevPanelShowHide(devPanel, frame)

  -- function that draws the widgets for the first tab
  local function DrawGroup1(container)
    --mapLink Options
    local option1 = AceGUI:Create("EditBox")
    option1:SetLabel("Target Floor / Bot Index")
    option1:SetText(1)
    local option2 = AceGUI:Create("EditBox")
    option2:SetLabel("Direction 1up -1d 2r -2l")
    option2:SetText(1)
    container:AddChild(option1)
    container:AddChild(option2)

    --door options
    local option3 = AceGUI:Create("EditBox")
    option3:SetLabel("Door Name / Connected Index")
    option3:SetText("")
    local option4 = AceGUI:Create("EditBox")
    option4:SetLabel("Door Descripting")
    option4:SetText("")
    local lockedCheckbox = AceGUI:Create("CheckBox")
    lockedCheckbox:SetLabel("Lockpickable")
    container:AddChild(option3)
    container:AddChild(option4)
    container:AddChild(lockedCheckbox)

    --graveyard options
    local option5 = AceGUI:Create("EditBox")
    option5:SetLabel("Graveyard Description / General Note Text")
    option5:SetText("")
    container:AddChild(option5)

    local buttons = {
      [1] = {
        text = "MapLink",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local links = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 300, -200
          local t = tonumber(option1:GetText())
          local d = tonumber(option2:GetText())
          local c = tonumber(option3:GetText())
          if t and d then
            tinsert(links,
              {
                x = posx,
                y = posy,
                target = t,
                direction = d,
                connectionIndex = c,
                template = "MapLinkPinTemplate",
                type = "mapLink"
              })
            ART:POI_UpdateAll()
          end
        end,
      },
      [2] = {
        text = "Door",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local links = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 300, -200
          local doorNameText = option3:GetText()
          local doorDescriptionText = option4:GetText()
          local lockpickableStatus = lockedCheckbox:GetValue() or nil
          tinsert(links,
            {
              x = posx,
              y = posy,
              template = "MapLinkPinTemplate",
              type = "door",
              doorName = doorNameText,
              doorDescription = doorDescriptionText,
              lockpick = lockpickableStatus
            })
          ART:POI_UpdateAll()
        end,
      },
      [3] = {
        text = "Graveyard",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local links = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 300, -200
          local graveyardDescriptionText = option5:GetText()
          tinsert(links,
            {
              x = posx,
              y = posy,
              template = "DeathReleasePinTemplate",
              type = "graveyard",
              graveyardDescription = graveyardDescriptionText
            })
          ART:POI_UpdateAll()
        end,
      },
      [4] = {
        text = "General Note",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local pois = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 300, -200
          local noteText = option5:GetText()
          tinsert(pois, { x = posx, y = posy, template = "MapLinkPinTemplate", type = "generalNote", text = noteText })
          ART:POI_UpdateAll()
        end,
      },
      [5] = {
        text = "Heavy Cannon",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local pois = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 300, -200
          tinsert(pois, { x = posx, y = posy, template = "MapLinkPinTemplate", type = "heavyCannon" })
          ART:POI_UpdateAll()
        end,
      },
      [6] = {
        text = "Mechagon Bot",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local pois = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local botType = tonumber(option1:GetText())
          local posx, posy = 400 + (30 * botType), -250
          tinsert(pois, { x = posx, y = posy, template = "MapLinkPinTemplate", type = "mechagonBot", botType = botType })
          ART:POI_UpdateAll()
        end,
      },
      [7] = {
        text = "Iron Docks Iron Star",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local pois = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 430, -250
          tinsert(pois,
            { x = posx, y = posy, template = "MapLinkPinTemplate", type = "ironDocksIronStar", starIndex = 1 })
          ART:POI_UpdateAll()
        end,
      },
      [8] = {
        text = "Text Frame",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local pois = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 430, -250
          local text = option5:GetText()
          tinsert(pois,
            { x = posx, y = posy, template = "MapLinkPinTemplate", type = "textFrame", text = text })
          ART:POI_UpdateAll()
        end,
      },
      [9] = {
        text = "Zoom Icon",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local pois = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 430, -250

          local index = ARTMapPanelFrame:GetScale() - 2 -- this is the threshold after which the button should zoom out
          local value1 = ARTMapPanelFrame:GetScale()
          local value2 = ARTScrollFrame:GetHorizontalScroll() / ART:GetScale()
          local value3 = ARTScrollFrame:GetVerticalScroll() / ART:GetScale()
          tinsert(pois,
            {
              x = posx,
              y = posy,
              template = "MapLinkPinTemplate",
              type = "zoom",
              index = index,
              value1 = value1,
              value2 = value2,
              value3 = value3
            })
          ART:POI_UpdateAll()
        end,
      },
      [10] = {
        text = "World Marker",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local pois = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local posx, posy = 430, -250
          local index = tonumber(option5:GetText())
          tinsert(pois,
            { x = posx, y = posy, template = "MapLinkPinTemplate", type = "worldMarker", index = index })
          ART:POI_UpdateAll()
        end,
      },
      [11] = {
        text = "Brackenhide Cage",
        func = function()
          if not ART.mapPOIs[db.currentRaidIndex] then ART.mapPOIs[db.currentRaidIndex] = {} end
          if not ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] then
            ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()] = {}
          end
          local pois = ART.mapPOIs[db.currentRaidIndex][ART:GetCurrentSubLevel()]
          local cageIndex = tonumber(option1:GetText())
          local posx, posy = 400, -250
          tinsert(pois, { x = posx, y = posy, template = "MapLinkPinTemplate", type = "brackenhideCage", cageIndex = cageIndex })
          ART:POI_UpdateAll()
        end,
      },
      [12] = {
        text = "Export Zoom Settings",
        func = function()
          ART:ExportCurrentZoomPanSettings()
        end,
      },
      [13] = {
        text = "Export to LUA",
        func = function()
          local export = ART:ExportLuaTable(ART.mapPOIs[db.currentRaidIndex], ART:GetSchema("pois"))
          ART:ExportString(export)
        end,
      },
      [14] = {
        text = "Export Current Zone ID",
        func = function()
          local currentZoneId = C_Map.GetBestMapForUnit("player")
          if not currentZoneId then
            print("ART DevMode: Unable to determine current zone ID")
            return
          end
          local zones, includedZones = {}, {}
          local function addZone(zoneId)
            zoneId = tonumber(zoneId)
            if zoneId and not includedZones[zoneId] then
              tinsert(zones, zoneId)
              includedZones[zoneId] = true
            end
          end
          for zoneId, raidIndex in pairs(ART.zoneIdToRaidIndex) do
            if raidIndex == db.currentRaidIndex then
              addZone(zoneId)
            end
          end
          addZone(currentZoneId)
          table.sort(zones)
          ART:ExportString(("local zones = { %s }"):format(table.concat(zones, ", ")))
        end,
      },
    }
    for buttonIdx, buttonData in ipairs(buttons) do
      local button = AceGUI:Create("Button")
      button:SetText(buttonData.text)
      button:SetCallback("OnClick", buttonData.func)
      container:AddChild(button)
    end
  end

  -- function that draws the widgets for the second tab
  local function DrawGroup2(container)
    local editBoxes = {}
    local scaleSlider
    local dropdown

    local function updateFields(health, level, creatureType, id, scale, idx)
      if idx then
        local data = ART.raidEnemies[db.currentRaidIndex][idx]
        if not data then return end
        health = data.health
        level = data.level
        creatureType = data.creatureType
        id = data.id
        scale = data.scale
      end
      editBoxes[1]:SetText(id)
      editBoxes[2]:SetText(health)
      editBoxes[3]:SetText(level)
      editBoxes[4]:SetText(creatureType)
      scaleSlider:SetValue(scale)
    end

    local enemyInfoButton = AceGUI:Create("Button")
    enemyInfoButton:SetText("Open Enemy Info")
    enemyInfoButton:SetCallback("OnClick", function()
      local devBlip = ART:GetCurrentDevmodeBlip()
      if devBlip then ART:ShowEnemyInfoFrame(devBlip) else print("ART DevMode: Please select a blip") end
    end)
    container:AddChild(enemyInfoButton)

    local findCloneIssuesButton = AceGUI:Create("Button")
    findCloneIssuesButton:SetText("Find Clone Issues")
    findCloneIssuesButton:SetCallback("OnClick", function()
      local issues = ""
      for i = 1, 200 do
        local enemies = ART.raidEnemies[i]
        local raidIssues
        if enemies then
          for _, enemy in pairs(enemies) do
            local l = #enemy.clones
            local realLength = 0
            for _, _ in pairs(enemy.clones) do
              realLength = realLength + 1
            end
            if l ~= realLength then
              raidIssues = raidIssues or ("--- "..ART.raidList[i]).."\n"
              raidIssues = raidIssues..enemy.name.."\n"
            end
          end
          if raidIssues then
            issues = issues..raidIssues.."\n"
          end
        end
      end
      ART:ExportString(issues)
    end)
    container:AddChild(findCloneIssuesButton)

    local findMissingLocaleButton = AceGUI:Create("Button")
    findMissingLocaleButton:SetText("Find Missing Localizations")
    findMissingLocaleButton:SetCallback("OnClick", function()
      local issues = ""
      for i = 1, 200 do
        local enemies = ART.raidEnemies[i]
        local raidIssues
        if enemies then
          for _, enemy in pairs(enemies) do
            if not ART.L[enemy.name] then
              raidIssues = raidIssues or ("--- "..ART.raidList[i]).."\n"
              raidIssues = raidIssues..("L[\"%s\"] = \"%s\"\n"):format(enemy.name, enemy.name)
            end
          end
          if raidIssues then
            issues = issues..raidIssues.."\n"
          end
        end
      end
      ART:ExportString(issues)
    end)
    container:AddChild(findMissingLocaleButton)

    local button3 = AceGUI:Create("Button")
    button3:SetText("Export to LUA")
    button3:SetCallback("OnClick", function()
      ART:CleanEnemyData(db.currentRaidIndex)
      local export = ART:ExportLuaTable(ART.raidEnemies[db.currentRaidIndex], ART:GetSchema("enemies"))
      ART:ExportString(export)
    end)
    container:AddChild(button3)

    local function updateDropdown(npcId, idx)
      if not ART.raidEnemies[db.currentRaidIndex] then return end
      idx = idx or 1
      local enemies = {}
      for mobIdx, data in ipairs(ART.raidEnemies[db.currentRaidIndex]) do
        tinsert(enemies, mobIdx, data.name)
        if npcId then
          if data.id == npcId then idx = mobIdx end
        end
      end
      dropdown:SetList(enemies)
      dropdown:SetValue(idx)
      currentEnemyIdx = idx
      updateFields(nil, nil, nil, nil, nil, idx)
    end

    dropdown = AceGUI:Create("Dropdown")
    dropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
      currentEnemyIdx = key
      updateFields(nil, nil, nil, nil, nil, key)
      local raidEnemyBlips = ART:GetRaidEnemyBlips()
      for _, v in ipairs(raidEnemyBlips) do
        v.devSelected = nil
      end
      ART:UpdateMap()
    end)

    container:AddChild(dropdown)

    local fields = {
      [1] = "id",
      [2] = "health",
      [3] = "level",
      [4] = "creatureType",
    }
    for idx, name in ipairs(fields) do
      editBoxes[idx] = AceGUI:Create("EditBox")
      editBoxes[idx]:SetLabel(name)
      editBoxes[idx]:SetCallback("OnEnterPressed", function(widget, callbackName, text)
        local value = text
        if name ~= "creatureType" then
          value = tonumber(text)
        end
        local npcIdx = dropdown:GetValue()
        local data = ART.raidEnemies[db.currentRaidIndex][npcIdx]
        data[name] = value
        ART:UpdateMap()
      end)
      container:AddChild(editBoxes[idx])
    end

    scaleSlider = AceGUI:Create("Slider")
    scaleSlider:SetLabel("Scale")
    scaleSlider:SetSliderValues(0, 5, 0.1)
    scaleSlider:SetValue(1)
    scaleSlider:SetCallback("OnMouseUp", function(widget, callbackName, value)
      local npcIdx = tonumber(dropdown:GetValue())
      local data = ART.raidEnemies[db.currentRaidIndex][npcIdx]
      data["scale"] = value
      ART:UpdateMap()
    end)
    container:AddChild(scaleSlider)

    local button1 = AceGUI:Create("Button")
    button1:SetText("Create from Target")
    button1:SetCallback("OnClick", function()
      local npcId = ART:AddNPCFromUnit("target")
      updateDropdown(npcId)
    end)
    container:AddChild(button1)

    --make boss
    local button2 = AceGUI:Create("Button")
    button2:SetText("Make Boss")
    button2:SetCallback("OnClick", function()
      local currentBlip = ART:GetCurrentDevmodeBlip()
      if currentBlip then
        --encounterID
        local encounterID = EJ_GetCreatureInfo(1)
        if not encounterID then
          print("ART: Error - Make sure to open Encounter Journal and navigate to the boss you want to add!")
          return
        end
        for i = 1, 10000 do
          local ixd = EJ_GetCreatureInfo(currentBossEnemyIdx, i)
          if ixd == encounterID then
            encounterID = i
            break
          end
        end
        local data = ART.raidEnemies[db.currentRaidIndex][currentBlip.enemyIdx]
        data.isBoss = true
        local mapID = C_Map.GetBestMapForUnit("player")
        data.instanceID = mapID and EJ_GetInstanceForMap(mapID) or 0
        data.encounterID = encounterID
        --use this data as follows:
        --if (not EncounterJournal) then LoadAddOn('Blizzard_EncounterJournal') end
        --EncounterJournal_OpenJournal(23,data.instanceID,data.encounterID)
        ART:UpdateMap()
      end
    end)
    container:AddChild(button2)

    --blips movable toggle
    local blipsMovableCheckbox = AceGUI:Create("CheckBox")
    blipsMovableCheckbox:SetLabel("Blips Movable")
    blipsMovableCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      db.devModeBlipsMovable = value or nil
    end)
    container:AddChild(blipsMovableCheckbox)

    --blips scrollable toggle
    local blipsScrollableCheckbox = AceGUI:Create("CheckBox")
    blipsScrollableCheckbox:SetLabel("Blips Scrollable")
    blipsScrollableCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      db.devModeBlipsScrollable = value or nil
    end)
    container:AddChild(blipsScrollableCheckbox)

    --bliptext shown toggle
    local blipTextHiddenCheckbox = AceGUI:Create("CheckBox")
    blipTextHiddenCheckbox:SetLabel("Hide Blip Text")
    blipTextHiddenCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      db.devModeBlipTextHidden = value or nil
      ART:UpdateMap()
    end)
    container:AddChild(blipTextHiddenCheckbox)

    --clone options

    --group
    local cloneGroup = AceGUI:Create("EditBox")
    cloneGroup:SetLabel("Group of clone:")
    cloneGroup:SetCallback("OnEnterPressed", function(widget, callbackName, text)
      local value = tonumber(text)
      if value and value > 0 then currentCloneGroup = value else currentCloneGroup = nil end
      local currentBlip = ART:GetCurrentDevmodeBlip()
      if currentBlip then
        local data = ART.raidEnemies[db.currentRaidIndex][currentBlip.enemyIdx]
        data.clones[currentBlip.cloneIdx].g = currentCloneGroup
        ART:UpdateMap()
      end
    end)
    container:AddChild(cloneGroup)

    local cloneGroupMaxButton = AceGUI:Create("Button")
    cloneGroupMaxButton:SetText("New Group")
    cloneGroupMaxButton:SetCallback("OnClick", function(widget, callbackName)
      local maxGroup = 0
      for _, data in pairs(ART.raidEnemies[db.currentRaidIndex]) do
        for _, clone in pairs(data.clones) do
          maxGroup = (clone.g and (clone.g > maxGroup)) and clone.g or maxGroup
        end
      end
      currentCloneGroup = maxGroup + 1
      cloneGroup:SetText(currentCloneGroup)
    end)
    container:AddChild(cloneGroupMaxButton)

    --patrol
    local patrolCheckbox = AceGUI:Create("CheckBox")
    patrolCheckbox:SetLabel("Patrol")
    patrolCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      currentPatrol = value or nil
      local currentBlip = ART:GetCurrentDevmodeBlip()
      if currentBlip then
        local data = ART.raidEnemies[db.currentRaidIndex][currentBlip.enemyIdx]
        data.clones[currentBlip.cloneIdx].patrol = currentPatrol and (data.clones[currentBlip.cloneIdx].patrol or {}) or
            nil
        if not data.clones[currentBlip.cloneIdx].patrol then
          currentBlip.patrolActive = false
        end
        ART:UpdateMap()
      end
    end)
    container:AddChild(patrolCheckbox)

    --stealthdetect
    local stealthDetectCheckbox = AceGUI:Create("CheckBox")
    stealthDetectCheckbox:SetLabel("Stealth Detect")
    stealthDetectCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      local currentBlip = ART:GetCurrentDevmodeBlip()
      local data = ART.raidEnemies[db.currentRaidIndex][currentBlip.enemyIdx]
      data.stealthDetect = value or nil
      ART:UpdateMap()
    end)
    container:AddChild(stealthDetectCheckbox)

    --stealth
    local stealthCheckbox = AceGUI:Create("CheckBox")
    stealthCheckbox:SetLabel("Stealthed")
    stealthCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      local currentBlip = ART:GetCurrentDevmodeBlip()
      local data = ART.raidEnemies[db.currentRaidIndex][currentBlip.enemyIdx]
      data.stealth = value or nil
      ART:UpdateMap()
    end)
    container:AddChild(stealthCheckbox)

    --neutral
    local neutralCheckbox = AceGUI:Create("CheckBox")
    neutralCheckbox:SetLabel("Neutral")
    neutralCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      local currentBlip = ART:GetCurrentDevmodeBlip()
      local data = ART.raidEnemies[db.currentRaidIndex][currentBlip.enemyIdx]
      data.neutral = value or nil
      ART:UpdateMap()
    end)
    container:AddChild(neutralCheckbox)

    --sublevel
    local sublevel = AceGUI:Create("EditBox")
    sublevel:SetLabel("Sublevel:")
    sublevel:SetCallback("OnEnterPressed", function(widget, callbackName, text)
      local value = tonumber(text)
      local currentBlip = ART:GetCurrentDevmodeBlip()
      if currentBlip then
        local data = ART.raidEnemies[db.currentRaidIndex][currentBlip.enemyIdx]
        data.clones[currentBlip.cloneIdx].sublevel = value
        ART:UpdateMap()
      end
    end)
    container:AddChild(sublevel)

    --enter clone options into the GUI (red)
    local currentBlip = ART:GetCurrentDevmodeBlip()
    if currentBlip then
      cloneGroup:SetText(currentBlip.clone.g)
      currentCloneGroup = currentBlip.clone.g
      currentCloneScale = currentBlip.clone.scale
      currentPatrol = currentBlip.patrol and true or nil
      patrolCheckbox:SetValue(currentBlip.clone.patrol)
      stealthDetectCheckbox:SetValue(currentBlip.data.stealthDetect)
      stealthCheckbox:SetValue(currentBlip.data.stealth)
      neutralCheckbox:SetValue(currentBlip.data.neutral)
      sublevel:SetText(currentBlip.clone.sublevel)
    else
      cloneGroup:SetText(currentCloneGroup)
    end
    blipsMovableCheckbox:SetValue(db.devModeBlipsMovable)
    blipsScrollableCheckbox:SetValue(db.devModeBlipsScrollable)
    blipTextHiddenCheckbox:SetValue(db.devModeBlipTextHidden)

    updateDropdown(nil, currentEnemyIdx)
  end

  local function DrawGroup3(container)
    local toggleDevModeButton = AceGUI:Create("Button")
    toggleDevModeButton:SetText("Toggle Debug Mode")
    toggleDevModeButton:SetCallback("OnClick", function()
      ART:ToggleDevMode()
    end)
    container:AddChild(toggleDevModeButton)

    local loadOnStartUpCheckbox = AceGUI:Create("CheckBox")
    loadOnStartUpCheckbox:SetLabel("Load ART on Startup")
    loadOnStartUpCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      db.loadOnStartUp = value or nil
    end)
    loadOnStartUpCheckbox:SetValue(db.loadOnStartUp)
    container:AddChild(loadOnStartUpCheckbox)

    local loadCacheCheckbox = AceGUI:Create("CheckBox")
    loadCacheCheckbox:SetLabel("Load Cache in debug mode")
    loadCacheCheckbox:SetCallback("OnValueChanged", function(widget, callbackName, value)
      db.loadCache = value or nil
      if value then
        ReloadUI()
      end
    end)
    loadCacheCheckbox:SetValue(db.loadCache)
    container:AddChild(loadCacheCheckbox)

    local clearCacheButton = AceGUI:Create("Button")
    clearCacheButton:SetText("Clear Cache + DC")
    clearCacheButton:SetCallback("OnClick", function()
      ART:ResetDataCache()
    end)
    container:AddChild(clearCacheButton)

    local resetDbButton = AceGUI:Create("Button")
    resetDbButton:SetText("Hard Reset DB")
    resetDbButton:SetCallback("OnClick", function()
      ART:OpenConfirmationFrame(300, 150, "Reset ART DB", "Confirm", "Do you want to reset ART DB?", function()
        ART:HardReset()
      end, "Cancel", nil)
    end)
    container:AddChild(resetDbButton)

    local vdtDbButton = AceGUI:Create("Button")
    vdtDbButton:SetText("VDT DB")
    vdtDbButton:SetCallback("OnClick", function()
      DevTool:AddData(db)
    end)
    container:AddChild(vdtDbButton)
  end

  local function DrawGroup4(container)
    local value = ART:GetMapCalibration()
    if not value then return end

    local enabled = AceGUI:Create("CheckBox")
    enabled:SetLabel("Show calibration overlay")
    enabled:SetValue(value.enabled)
    enabled:SetCallback("OnValueChanged", function(_, _, checked)
      value.enabled = checked
      ART:UpdateMapCalibrationOverlay()
      enabled:SetValue(value.enabled)
    end)
    container:AddChild(enabled)

    for _, field in ipairs({
      { "offsetX", "Offset X" }, { "offsetY", "Offset Y" },
      { "scaleX", "Scale X" }, { "scaleY", "Scale Y" },
      { "rotation", "Rotation °" }, { "alpha", "Alpha" },
    }) do
      local input = AceGUI:Create("EditBox")
      input:SetLabel(field[2])
      input:SetText(value[field[1]])
      input:SetCallback("OnEnterPressed", function(_, _, text)
        value[field[1]] = tonumber(text) or value[field[1]]
        ART:UpdateMapCalibrationOverlay()
      end)
      container:AddChild(input)
    end

    local reset = AceGUI:Create("Button")
    reset:SetText("Reset")
    reset:SetCallback("OnClick", function() ART:ResetMapCalibration(); devPanel:SelectTab("tab4") end)
    container:AddChild(reset)
    local dump = AceGUI:Create("Button")
    dump:SetText("Print values")
    dump:SetCallback("OnClick", function() ART:PrintMapCalibration() end)
    container:AddChild(dump)
  end

  -- Callback function for OnGroupSelected
  local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "tab1" then
      DrawGroup1(container)
    elseif group == "tab2" then
      DrawGroup2(container)
    elseif group == "tab3" then
      DrawGroup3(container)
    elseif group == "tab4" then
      DrawGroup4(container)
    end
  end

  devPanel:SetCallback("OnGroupSelected", SelectGroup)
  devPanel:SelectTab("tab2")

  --hook UpdateMap
  local originalFunc = ART.UpdateMap
  function ART:UpdateMap(...)
    originalFunc(...)
    ART:UpdateMapCalibrationOverlay()
    if not db.devMode then return end
    local selectedTab
    for k, v in pairs(devPanel.tabs) do
      if v.selected == true then
        selectedTab = v.value; break
      end
    end
    --currentEnemyIdx
    local currentBlip = ART:GetCurrentDevmodeBlip()
    if currentBlip then
      currentEnemyIdx = currentBlip.enemyIdx
    end
    devPanel:SelectTab(selectedTab)
    --show patrol
    local raidEnemyBlips = ART:GetRaidEnemyBlips()
    for _, v in ipairs(raidEnemyBlips) do
      v:DisplayPatrol(v.devSelected)
    end
  end
end

---AddCloneAtCursorPosition
---Adds a clone at the cursor position to the raid enemy table
---bound to hotkey and used to add new npcs to the map
function ART:AddCloneAtCursorPosition()
  if not ARTScrollFrame:IsMouseOver() then return end
  if currentEnemyIdx then
    local data = ART.raidEnemies[db.currentRaidIndex][currentEnemyIdx]
    local cursorx, cursory = ART:GetCursorPosition()
    local scale = self:GetScale()
    cursorx = cursorx * (1 / scale)
    cursory = cursory * (1 / scale)
    tinsert(data.clones,
      {
        x = cursorx,
        y = cursory,
        sublevel = ART:GetCurrentSubLevel(),
        g = currentCloneGroup,
        scale = currentCloneScale
      })
    print(string.format("ART: Created clone %s %d at %d,%d", data.name, #data.clones, cursorx, cursory))
    ART:UpdateMap()
  end
end

---AddPatrolWaypointAtCursorPosition
---Adds a patrol waypoint to the selected enemy
function ART:AddPatrolWaypointAtCursorPosition()
  if not ARTScrollFrame:IsMouseOver() then return end
  local currentBlip = ART:GetCurrentDevmodeBlip()
  if currentBlip then
    local data = ART.raidEnemies[db.currentRaidIndex][currentBlip.enemyIdx]
    local cloneData = data.clones[currentBlip.cloneIdx]
    cloneData.patrol = cloneData.patrol or {}
    cloneData.patrol[1] = { x = cloneData.x, y = cloneData.y }
    local cursorx, cursory = ART:GetCursorPosition()
    local scale = ART:GetScale()
    cursorx = cursorx * (1 / scale)
    cursory = cursory * (1 / scale)
    --snap onto other waypoints
    local patrolBlips = ART:GetPatrolBlips()
    for idx, waypoint in pairs(patrolBlips) do
      if waypoint:IsMouseOver() then
        cursorx = waypoint.x
        cursory = waypoint.y
      end
    end
    --snap onto blip
    if currentBlip:IsMouseOver() then
      cursorx = currentBlip.clone.x
      cursory = currentBlip.clone.y
    end
    tinsert(cloneData.patrol, { x = cursorx, y = cursory })
    print(string.format("ART: Created Waypoint %d of %s %d at %d,%d", 1, data.name, #cloneData.patrol, cursorx, cursory))
    ART:UpdateMap()
  end
end
