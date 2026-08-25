local _, ART = ...
local L = ART.L
local canvasDrawLayer = "BORDER"

local tinsert, CreateFrame, tonumber, max, min, abs, pairs, ipairs, GetCursorPosition, GameTooltip =
    table.insert, CreateFrame, tonumber, math.max, math.min, math.abs, pairs, ipairs, GetCursorPosition, GameTooltip

local sizex = 840
local sizey = 555
local db

local function initializeDB()
  db = db or ART:GetDB()
end

function ART:OnPan(cursorX, cursorY)
  local scrollFrame = ARTScrollFrame
  local scale = ARTMapPanelFrame:GetScale() / 1.5
  local deltaX = (scrollFrame.cursorX - cursorX) / scale
  local deltaY = (cursorY - scrollFrame.cursorY) / scale

  if (scrollFrame.panning) then
    local newHorizontalPosition = max(0, deltaX + scrollFrame:GetHorizontalScroll())
    newHorizontalPosition = min(newHorizontalPosition, scrollFrame.maxX)
    local newVerticalPosition = max(0, deltaY + scrollFrame:GetVerticalScroll())
    newVerticalPosition = min(newVerticalPosition, scrollFrame.maxY)
    scrollFrame:SetHorizontalScroll(newHorizontalPosition)
    scrollFrame:SetVerticalScroll(newVerticalPosition)
    scrollFrame.cursorX = cursorX
    scrollFrame.cursorY = cursorY

    scrollFrame.wasPanningLastFrame = true;
    scrollFrame.lastDeltaX = deltaX;
    scrollFrame.lastDeltaY = deltaY;
  else
    if (scrollFrame.wasPanningLastFrame) then
      scrollFrame.isFadeOutPanning = true
      scrollFrame.fadeOutXStart = scrollFrame.lastDeltaX
      scrollFrame.fadeOutYStart = scrollFrame.lastDeltaY
      scrollFrame.panDuration = 0

      scrollFrame.wasPanningLastFrame = false;
    end
  end
end

function ART:OnPanFadeOut(deltaTime)
  local scrollFrame = ARTScrollFrame
  local panDuration = 0.5
  local panAtenuation = 7
  if (scrollFrame.isFadeOutPanning) then
    scrollFrame.panDuration = scrollFrame.panDuration + deltaTime

    local phase = scrollFrame.panDuration / panDuration
    local phaseLog = -math.log(phase)
    local stepX = (scrollFrame.fadeOutXStart * phaseLog) / panAtenuation
    local stepY = (scrollFrame.fadeOutYStart * phaseLog) / panAtenuation

    local newHorizontalPosition = max(0, stepX + scrollFrame:GetHorizontalScroll())
    newHorizontalPosition = min(newHorizontalPosition, scrollFrame.maxX)
    local newVerticalPosition = max(0, stepY + scrollFrame:GetVerticalScroll())
    newVerticalPosition = min(newVerticalPosition, scrollFrame.maxY)
    scrollFrame:SetHorizontalScroll(newHorizontalPosition)
    scrollFrame:SetVerticalScroll(newVerticalPosition)

    if (scrollFrame.panDuration > panDuration) then
      scrollFrame.isFadeOutPanning = false
    end
  end
end

function ART:ExportCurrentZoomPanSettings()
  local zoom = ARTMapPanelFrame:GetScale()
  local panH = ARTScrollFrame:GetHorizontalScroll() / ART:GetScale()
  local panV = ARTScrollFrame:GetVerticalScroll() / ART:GetScale()

  local output = "        ["..db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentSublevel.."] = {\n"
  output = output.."            zoomScale = "..zoom..";\n"
  output = output.."            horizontalPan = "..panH..";\n"
  output = output.."            verticalPan = "..panV..";\n"
  output = output.."        };\n"

  ART:HideAllDialogs()
  ART.main_frame.ExportFrame:Show()
  ART.main_frame.ExportFrame:ClearAllPoints()
  ART.main_frame.ExportFrame:SetPoint("CENTER", ART.main_frame, "CENTER", 0, 50)
  ART.main_frame.ExportFrameEditbox:SetText(output)
  ART.main_frame.ExportFrameEditbox:HighlightText(0, string.len(output))
  ART.main_frame.ExportFrameEditbox:SetFocus()
  ART.main_frame.ExportFrameEditbox:SetLabel("Current pan/zoom settings");
end

function ART:SetViewPortPosition(zoomScale, horizontalPan, verticalPan)
  local scaledSizeX = ARTMapPanelFrame:GetWidth() * zoomScale
  local scaledSizeY = ARTMapPanelFrame:GetHeight() * zoomScale
  ARTScrollFrame.maxX = (scaledSizeX - ARTMapPanelFrame:GetWidth()) / zoomScale
  ARTScrollFrame.maxY = (scaledSizeY - ARTMapPanelFrame:GetHeight()) / zoomScale
  ARTScrollFrame.zoomedIn = abs(zoomScale - 1) > 0.02
  ARTMapPanelFrame:SetScale(zoomScale)
  ARTScrollFrame:SetHorizontalScroll(horizontalPan * ART:GetScale())
  ARTScrollFrame:SetVerticalScroll(verticalPan * ART:GetScale())
end

function ART:ZoomMapToDefault()
  local currentMap = db.presets[db.currentRaidIndex]
  local currentSublevel = currentMap[db.currentPreset[db.currentRaidIndex]].value.currentSublevel
  local mainFrame = ARTMapPanelFrame
  local scrollFrame = ARTScrollFrame

  local currentMapInfo = ART.mapInfo[db.currentRaidIndex]
  if (currentMapInfo and currentMapInfo.viewportPositionOverrides and currentMapInfo.viewportPositionOverrides[currentSublevel]) then
    local data = currentMapInfo.viewportPositionOverrides[currentSublevel];

    local scaledSizeX = mainFrame:GetWidth() * data.zoomScale
    local scaledSizeY = mainFrame:GetHeight() * data.zoomScale

    scrollFrame.maxX = (scaledSizeX - mainFrame:GetWidth()) / data.zoomScale
    scrollFrame.maxY = (scaledSizeY - mainFrame:GetHeight()) / data.zoomScale
    scrollFrame.zoomedIn = abs(data.zoomScale - 1) > 0.02

    mainFrame:SetScale(data.zoomScale)

    scrollFrame:SetHorizontalScroll(data.horizontalPan * ART:GetScale())
    scrollFrame:SetVerticalScroll(data.verticalPan * ART:GetScale())
  else
    scrollFrame.maxX = 1
    scrollFrame.maxY = 1
    scrollFrame.zoomedIn = false

    mainFrame:SetScale(1);

    scrollFrame:SetHorizontalScroll(0)
    scrollFrame:SetVerticalScroll(0)
  end
end

function ART:ZoomMap(delta)
  local scrollFrame = ARTScrollFrame
  if not scrollFrame:GetLeft() then return end
  local oldScrollH = scrollFrame:GetHorizontalScroll()
  local oldScrollV = scrollFrame:GetVerticalScroll()

  local mainFrame = ARTMapPanelFrame

  local oldScale = mainFrame:GetScale()
  local newScale = oldScale + delta * 0.3

  newScale = max(1, newScale)
  newScale = min(15, newScale)

  mainFrame:SetScale(newScale)

  local scaledSizeX = mainFrame:GetWidth() * newScale
  local scaledSizeY = mainFrame:GetHeight() * newScale

  scrollFrame.maxX = (scaledSizeX - mainFrame:GetWidth()) / newScale
  scrollFrame.maxY = (scaledSizeY - mainFrame:GetHeight()) / newScale
  scrollFrame.zoomedIn = abs(newScale - 1) > 0.02

  local cursorX, cursorY = GetCursorPosition()
  local frameX = (cursorX / UIParent:GetScale()) - scrollFrame:GetLeft()
  local frameY = scrollFrame:GetTop() - (cursorY / UIParent:GetScale())
  local scaleChange = newScale / oldScale
  local newScrollH = (scaleChange * frameX - frameX) / newScale + oldScrollH
  local newScrollV = (scaleChange * frameY - frameY) / newScale + oldScrollV

  newScrollH = min(newScrollH, scrollFrame.maxX)
  newScrollH = max(0, newScrollH)
  newScrollV = min(newScrollV, scrollFrame.maxY)
  newScrollV = max(0, newScrollV)

  scrollFrame:SetHorizontalScroll(newScrollH)
  scrollFrame:SetVerticalScroll(newScrollV)

  ART:SetPingOffsets(newScale)
end

function ART:GetPullMapCenter(pull)
  local pullData = self:GetCurrentPreset().value.pulls[pull]
  if not pullData then return end

  local currentSublevel = self:GetCurrentSubLevel()
  local scale = self:GetScale()
  local minX, maxX, minY, maxY
  for enemyIdx, clones in pairs(pullData) do
    local enemy = tonumber(enemyIdx) and self.raidEnemies[db.currentRaidIndex][enemyIdx]
    if enemy then
      for _, cloneIdx in pairs(clones) do
        local clone = enemy.clones[cloneIdx]
        if clone and (clone.sublevel == currentSublevel or not clone.sublevel) then
          local x = clone.x * scale
          local y = clone.y * scale
          minX = minX and min(minX, x) or x
          maxX = maxX and max(maxX, x) or x
          minY = minY and min(minY, y) or y
          maxY = maxY and max(maxY, y) or y
        end
      end
    end
  end

  if not minX then return end
  return (minX + maxX) / 2, (minY + maxY) / 2
end

function ART:PanMapToPull(pull)
  local centerX, centerY = self:GetPullMapCenter(pull)
  if not centerX then return end

  local scrollFrame = ARTScrollFrame
  local mapPanelFrame = ARTMapPanelFrame
  if not scrollFrame or not mapPanelFrame or not scrollFrame:GetLeft() then return end

  self:ZoomMap(0)
  local zoomScale = mapPanelFrame:GetScale()
  local targetH = centerX - scrollFrame:GetWidth() / (2 * zoomScale)
  local targetV = -centerY - scrollFrame:GetHeight() / (2 * zoomScale)
  targetH = max(0, min(targetH, scrollFrame.maxX or 0))
  targetV = max(0, min(targetV, scrollFrame.maxY or 0))

  local animationGroup = scrollFrame.autoPanAnimation
  if animationGroup and animationGroup:IsPlaying() then
    animationGroup:Stop()
  end

  scrollFrame.panning = false
  scrollFrame.isFadeOutPanning = false

  local startH = scrollFrame:GetHorizontalScroll()
  local startV = scrollFrame:GetVerticalScroll()
  if abs(startH - targetH) < 1 and abs(startV - targetV) < 1 then
    scrollFrame:SetHorizontalScroll(targetH)
    scrollFrame:SetVerticalScroll(targetV)
    return
  end

  local panData = scrollFrame.autoPanAnimationData
  if not animationGroup then
    panData = {}
    animationGroup = scrollFrame:CreateAnimationGroup()
    local animation = animationGroup:CreateAnimation("Animation")
    animation:SetDuration(0.45)
    animation:SetSmoothing("OUT")
    animation:SetScript("OnUpdate", function()
      local progress = animation:GetSmoothProgress()
      scrollFrame:SetHorizontalScroll(panData.startH + (panData.targetH - panData.startH) * progress)
      scrollFrame:SetVerticalScroll(panData.startV + (panData.targetV - panData.startV) * progress)
    end)
    animation:SetScript("OnFinished", function()
      scrollFrame:SetHorizontalScroll(panData.targetH)
      scrollFrame:SetVerticalScroll(panData.targetV)
    end)
    scrollFrame.autoPanAnimation = animationGroup
    scrollFrame.autoPanAnimationData = panData
  end

  panData.startH = startH
  panData.startV = startV
  panData.targetH = targetH
  panData.targetV = targetV
  animationGroup:Play()
end

function ART:MouseDownHook()

end

---Handles mouse-down events on the map scrollframe
ART.OnMouseDown = function(self, button)
  local scrollFrame = ART.main_frame.scrollFrame
  if scrollFrame.zoomedIn then
    scrollFrame.panning = true
    scrollFrame.cursorX, scrollFrame.cursorY = GetCursorPosition()
  end
  scrollFrame.oldX = scrollFrame.cursorX
  scrollFrame.oldY = scrollFrame.cursorY
  ART:MouseDownHook()
end

---handles mouse-up events on the map scrollframe
ART.OnMouseUp = function(self, button)
  local scrollFrame = ART.main_frame.scrollFrame
  if scrollFrame.panning then scrollFrame.panning = false end

  --play minimap ping on right click at cursor position
  --only ping if we didnt pan
  if scrollFrame.oldX == scrollFrame.cursorX or scrollFrame.oldY == scrollFrame.cursorY then
    if button == "RightButton" then
      local x, y = ART:GetCursorPosition()
      ART:PingMap(x, y)
      local sublevel = ART:GetCurrentSubLevel()
      if ART.liveSessionActive then ART:LiveSession_SendPing(x, y, sublevel) end
    end
  end
end

---Pings the map
function ART:PingMap(x, y)
  -- self.ping:ClearAllPoints()
  -- self.ping:SetPoint("CENTER", self.main_frame.mapPanelTile1, "TOPLEFT", x, y)
  -- self.ping:SetModel("interface/minimap/ping/minimapping.m2")
  -- local mainFrame = ARTMapPanelFrame
  -- local mapScale = mainFrame:GetScale()
  -- self:SetPingOffsets(mapScale)
  -- self.ping:Show()
  -- UIFrameFadeOut(self.ping, 2, 1, 0)
  -- self.ping:SetSequence(0)
end

function ART:SetPingOffsets(mapScale)
  --local scale = 0.35
  --local offset = (10.25 / 1000) * mapScale
  ---@diagnostic disable-next-line: redundant-parameter
  --self.ping:SetTransform(CreateVector3D(offset, offset, 0), CreateVector3D(0, 0, 0), scale)
end

---Sets the sublevel of the currently active preset, need to UpdateMap to reflect the change in UI
function ART:SetCurrentSubLevel(sublevel)
  if ART.SetPullSublevel then ART:SetPullSublevel(sublevel) else ART:GetCurrentPreset().value.currentSublevel = sublevel end
end

---Returns the sublevel of the currently active preset
function ART:GetCurrentSubLevel()
  return ART:GetCurrentPreset().value.currentSublevel
end

function ART:MakeMapTexture(frame)
  initializeDB()
  ART.contextMenuList = {}

  tinsert(ART.contextMenuList, {
    text = "Close",
    notCheckable = 1,
    func = frame.contextDropdown:Hide()
  })

  -- Scroll Frame
  if frame.scrollFrame == nil then
    frame.scrollFrame = CreateFrame("ScrollFrame", "ARTScrollFrame", frame)
    frame.scrollFrame:ClearAllPoints()
    frame.scrollFrame:SetSize(sizex * db.scale, sizey * db.scale)
    --frame.scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.scrollFrame:SetAllPoints(frame)

    -- Enable mousewheel scrolling
    frame.scrollFrame:EnableMouseWheel(true)
    local lastModifiedScroll
    frame.scrollFrame:SetScript("OnMouseWheel", function(self, delta)
      if IsControlKeyDown() and IsShiftKeyDown() then
        if not lastModifiedScroll or lastModifiedScroll < GetTime() - 0.1 then
          lastModifiedScroll = GetTime()
          delta = delta * -1
          local target = ART:GetCurrentSubLevel() + delta
          if ART.raidFloors[db.currentRaidIndex][target] then
            ART:SetCurrentSubLevel(target)
            ART:UpdateMap()
          end
        end
      else
        ART:ZoomMap(delta)
      end
    end)

    --PAN
    frame.scrollFrame:EnableMouse(true)
    frame.scrollFrame:SetScript("OnMouseDown", ART.OnMouseDown)
    frame.scrollFrame:SetScript("OnMouseUp", ART.OnMouseUp)


    frame.scrollFrame:SetScript("OnUpdate", function(self, elapsed)
      local x, y = GetCursorPosition()
      ART:OnPan(x, y)
      ART:OnPanFadeOut(elapsed)
    end)

    if frame.mapPanelFrame == nil then
      frame.mapPanelFrame = CreateFrame("frame", "ARTMapPanelFrame", nil)
      frame.mapPanelFrame:ClearAllPoints()
      frame.mapPanelFrame:SetSize(sizex * db.scale, sizey * db.scale)
      --frame.mapPanelFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
      frame.mapPanelFrame:SetAllPoints(frame)
    end

    --create the 12 tiles and set the scrollchild
    for i = 1, 12 do
      frame["mapPanelTile"..i] = frame.mapPanelFrame:CreateTexture("ARTmapPanelTile"..i, "BACKGROUND", nil, 0)
      frame["mapPanelTile"..i]:SetDrawLayer(canvasDrawLayer, 0)
      --frame["mapPanelTile"..i]:SetAlpha(0.3)
      frame["mapPanelTile"..i]:SetSize(frame:GetWidth() / 4 + (5 * db.scale), frame:GetWidth() / 4 + (5 * db.scale))
    end
    frame.mapPanelTile1:SetPoint("TOPLEFT", frame.mapPanelFrame, "TOPLEFT", 0, 0)
    frame.mapPanelTile2:SetPoint("TOPLEFT", frame.mapPanelTile1, "TOPRIGHT")
    frame.mapPanelTile3:SetPoint("TOPLEFT", frame.mapPanelTile2, "TOPRIGHT")
    frame.mapPanelTile4:SetPoint("TOPLEFT", frame.mapPanelTile3, "TOPRIGHT")
    frame.mapPanelTile5:SetPoint("TOPLEFT", frame.mapPanelTile1, "BOTTOMLEFT")
    frame.mapPanelTile6:SetPoint("TOPLEFT", frame.mapPanelTile5, "TOPRIGHT")
    frame.mapPanelTile7:SetPoint("TOPLEFT", frame.mapPanelTile6, "TOPRIGHT")
    frame.mapPanelTile8:SetPoint("TOPLEFT", frame.mapPanelTile7, "TOPRIGHT")
    frame.mapPanelTile9:SetPoint("TOPLEFT", frame.mapPanelTile5, "BOTTOMLEFT")
    frame.mapPanelTile10:SetPoint("TOPLEFT", frame.mapPanelTile9, "TOPRIGHT")
    frame.mapPanelTile11:SetPoint("TOPLEFT", frame.mapPanelTile10, "TOPRIGHT")
    frame.mapPanelTile12:SetPoint("TOPLEFT", frame.mapPanelTile11, "TOPRIGHT")

    --create the 150 large map tiles
    for i = 1, 10 do
      for j = 1, 15 do
        frame["largeMapPanelTile"..i..j] = frame.mapPanelFrame:CreateTexture("ARTLargeMapPanelTile"..i..j, "BACKGROUND")
        local tile = frame["largeMapPanelTile"..i..j]
        tile:SetDrawLayer(canvasDrawLayer, 5)
        tile:SetSize(frame:GetWidth() / 15, frame:GetWidth() / 15)
        if i == 1 and j == 1 then
          --to mapPanel
          tile:SetPoint("TOPLEFT", frame.mapPanelFrame, "TOPLEFT", 0, 0)
        elseif j == 1 then
          --to tile above
          tile:SetPoint("TOPLEFT", frame["largeMapPanelTile"..(i - 1)..j], "BOTTOMLEFT", 0, 0)
        else
          --to tile to the left
          tile:SetPoint("TOPLEFT", frame["largeMapPanelTile"..i..(j - 1)], "TOPRIGHT", 0, 0)
        end
        tile:SetColorTexture(i / 10, j / 10, 0, 1)
        tile:Hide()
      end
    end

    frame.scrollFrame:SetScrollChild(frame.mapPanelFrame)
    frame.scrollFrame.cursorX = 0
    frame.scrollFrame.cursorY = 0
    frame.scrollFrame.queuedDeltaX = 0;
    frame.scrollFrame.queuedDeltaY = 0;
  end
end

function ART:GetTileFormat(raidIndex, sublevel)
  local mapInfo = ART.mapInfo[raidIndex]
  return mapInfo and mapInfo.tileFormat and mapInfo.tileFormat[sublevel] or 4
end

function ART:UpdateMap(ignoreSetSelection, ignoreReloadPullButtons, ignoreUpdateProgressBar, async)
  initializeDB()
  ART:CancelAsync("UpdateMap")
  ART:CancelAsync("ReloadPullButtons")
  ART:CancelAsync("DrawAllHulls")
  if not ART:AreFramesInitialized() then coroutine.yield() end
  local mapName
  local frame = ART.main_frame
  mapName = ART.raidMaps[db.currentRaidIndex][0]
  ART:EnsureDBTables()
  if not ART:AreFramesInitialized() then coroutine.yield() end
  local preset = ART:GetCurrentPreset()
  if not ART:AreFramesInitialized() then coroutine.yield() end
  local textureInfo = ART.raidMaps[db.currentRaidIndex][preset.value.currentSublevel]
  if type(textureInfo) == "string" then --textures from blizzard files
    local path = "Interface\\WorldMap\\"..mapName.."\\"
    local tileFormat = ART:GetTileFormat(db.currentRaidIndex, preset.value.currentSublevel)
    if not ART:AreFramesInitialized() then coroutine.yield() end
    for i = 1, 12 do
      if tileFormat == 4 then
        local texName = path..textureInfo..i
        if frame["mapPanelTile"..i] then
          frame["mapPanelTile"..i]:SetTexture(texName)
          frame["mapPanelTile"..i]:Show()
        end
      else
        if frame["mapPanelTile"..i] then
          frame["mapPanelTile"..i]:Hide()
        end
      end
    end
    if not ART:AreFramesInitialized() then coroutine.yield() end
    for i = 1, 10 do
      for j = 1, 15 do
        if tileFormat == 15 then
          local texName = path..textureInfo..((i - 1) * 15 + j)
          frame["largeMapPanelTile"..i..j]:SetTexture(texName)
          frame["largeMapPanelTile"..i..j]:Show()
        else
          frame["largeMapPanelTile"..i..j]:Hide()
        end
      end
    end
  elseif type(textureInfo) == "table" then --textures from custom files
    local sublevel = preset.value.currentSublevel
    for i = 1, 12 do
      if frame["mapPanelTile"..i] then
        frame["mapPanelTile"..i]:Hide()
      end
    end
    for i = 1, 10 do
      for j = 1, 15 do
        local fileSuffix = (i - 1) * 15 + j
        local texName = textureInfo.customTextures..'\\'..sublevel..'_'..fileSuffix..".png"
        local tile = frame["largeMapPanelTile"..i..j]
        tile:SetTexture(texName)
        tile:Show()
      end
    end
  end
  if not ART:AreFramesInitialized() then coroutine.yield() end
  ART:Async(function()
    coroutine.yield()
    if not db.devMode then ART:ZoomMapToDefault() end
    ART:RaidEnemies_UpdateEnemiesAsync()
    ART:POI_UpdateAll()
    if not ignoreReloadPullButtons then
      ART:ReloadPullButtons(true)
    end
    if not ART:AreFramesInitialized() then coroutine.yield() end
    --handle delete button disable/enable
    local presetCount = 0
    for k, v in pairs(db.presets[db.currentRaidIndex]) do
      presetCount = presetCount + 1
    end
    if (db.currentPreset[db.currentRaidIndex] == 1 or db.currentPreset[db.currentRaidIndex] == presetCount) or
        ART.liveSessionActive then
      ART.main_frame.sidePanelDeleteButton:SetDisabled(true)
      ART.main_frame.sidePanelDeleteButton.text:SetTextColor(0.5, 0.5, 0.5)
    else
      ART.main_frame.sidePanelDeleteButton:SetDisabled(false)
      ART.main_frame.sidePanelDeleteButton.text:SetTextColor(1, 0.8196, 0)
    end
    if not ART:AreFramesInitialized() then coroutine.yield() end
    --live mode
    local livePreset = ART:GetCurrentLivePreset()
    if ART.liveSessionActive and preset ~= livePreset then
      ART.main_frame.liveReturnButton:Show()
      ART.main_frame.setLivePresetButton:Show()
    else
      ART.main_frame.liveReturnButton:Hide()
      ART.main_frame.setLivePresetButton:Hide()
    end
    ART:UpdatePresetDropdownTextColor()
    if not ART:AreFramesInitialized() then coroutine.yield() end
    if not ignoreSetSelection then ART:SetSelectionToPull(preset.value.currentPull, nil, true) end
    if ART.pendingAutoPanToPull then
      local pull = ART.pendingAutoPanToPull
      ART.pendingAutoPanToPull = nil
      if db.autoPanToPull ~= false then ART:PanMapToPull(pull) end
    end
    ART:UpdateRaidDropDown()
    if not ART:AreFramesInitialized() then coroutine.yield() end
    ART:DrawAllPresetObjects()
    if not ART:AreFramesInitialized() then coroutine.yield() end
  end, "UpdateMap", true)
end

---Updates the map to the specified raid
function ART:UpdateToRaid(raidIndex, ignoreUpdateMap, init)
  initializeDB()
  if raidIndex == db.currentRaidIndex then return end
  db.currentRaidIndex = raidIndex
  if not db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentSublevel then
    db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentSublevel = 1
  end
  if init then return end
  ART:UpdatePresetDropDown()
  if not ignoreUpdateMap then ART:UpdateMap() end
  ART:ZoomMapToDefault()
  --Colors the first pull in "Default" presets
  if db.currentPreset[db.currentRaidIndex] == 1 then ART:ColorPull() end
end

--contains zoneIds to auto swap to corresponding raid when opening the AddOn
--ids are added in each raid file
--https://wowpedia.fandom.com/wiki/UiMapID
ART.zoneIdToRaidIndex = {}
ART.zoneIdToSublevel = {}

local lastUpdatedRaidIndex
function ART:CheckCurrentZone(init)
  initializeDB()
  local zoneId = ART.Compat:GetBestMapForUnit("player")
  local raidIndex = ART.zoneIdToRaidIndex[zoneId]
  if not raidIndex then return end

  local sublevel = ART.zoneIdToSublevel[zoneId]
  local raidChanged = db.currentRaidIndex ~= raidIndex
  if raidChanged or lastUpdatedRaidIndex ~= raidIndex then
    lastUpdatedRaidIndex = raidIndex
    ART:UpdateToRaid(raidIndex, sublevel ~= nil, init)
  end

  local floorChanged = sublevel and ART:GetCurrentSubLevel() ~= sublevel
  if floorChanged then ART:SetCurrentSubLevel(sublevel) end
  if sublevel and not init and (raidChanged or floorChanged) then ART:UpdateMap() end
end

function ART:SetMapSublevel(pull)
  --set map sublevel
  local shouldResetZoom = false
  local lastSubLevel
  for enemyIdx, clones in pairs(db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.pulls[
  pull]) do
    if tonumber(enemyIdx) then
      for idx, cloneIdx in pairs(clones) do
        if ART.raidEnemies[db.currentRaidIndex][enemyIdx]["clones"][cloneIdx] then
          lastSubLevel = ART.raidEnemies[db.currentRaidIndex][enemyIdx]["clones"][cloneIdx].sublevel
        end
      end
    end
  end
  if lastSubLevel then
    shouldResetZoom = db.presets[db.currentRaidIndex][db.currentPreset[db.currentRaidIndex]].value.currentSublevel ~=
        lastSubLevel
    ART:SetCurrentSubLevel(lastSubLevel)
    if shouldResetZoom then
      ART:UpdateMap(true, true, true)
    end
  end

  ART:UpdateRaidDropDown()
  return shouldResetZoom
end
