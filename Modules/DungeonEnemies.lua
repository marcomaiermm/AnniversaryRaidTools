local _, MDT = ...
local db
local tonumber, tinsert, pairs, ipairs, tostring, twipe, max, min, abs, sqrt, tremove, floor, DrawLine = tonumber,
    table.insert, pairs, ipairs, tostring, table.wipe, math.max, math.min, math.abs, math.sqrt, table.remove, math.floor,
    DrawLine
local L = MDT.L
local blips = {}
local preset
local patrolColor = { 0, 0.5, 1, 0.8 }
local OVERLAP_BUCKET_SIZE = 9
local OVERLAP_DISTANCE_SQUARED = OVERLAP_BUCKET_SIZE * OVERLAP_BUCKET_SIZE
local TRASH_HEALTH_SCALE_MIN = 0.85
local TRASH_HEALTH_SCALE_MAX = 1.25
local MANUAL_EXPLOSION_RADIUS = 10
local MANUAL_EXPLOSION_GAP = 1
local MANUAL_EXPLOSION_ANIMATION_DURATION = 0.12
local HOVER_SCALE = 1.2
local HOVER_SCALE_ANIMATION_DURATION = 0.12

local function notifyLiveMarkPlanChanged()
  local art = rawget(_G, "ART")
  if art and art.LiveMarks and art.LiveMarks.OnPlanChanged then art.LiveMarks:OnPlanChanged() end
end

function MDT:GetDungeonEnemyBlips()
  return blips
end

function MDT:SetLegacyBlipMark(enemyIdx, cloneIdx, marker)
  local preset = self:GetCurrentPreset()
  local assignments = preset.value.enemyAssignments or {}
  preset.value.enemyAssignments = assignments
  local pull = preset.value.pulls and preset.value.pulls[self:GetCurrentPull()]
  if marker and pull then
    for otherEnemyIdx, cloneIndexes in pairs(pull) do
      for _, otherCloneIdx in ipairs(type(cloneIndexes) == "table" and cloneIndexes or {}) do
        if assignments[otherEnemyIdx] and assignments[otherEnemyIdx][otherCloneIdx] == marker then
          assignments[otherEnemyIdx][otherCloneIdx] = nil
          for _, blip in pairs(blips) do
            if blip.enemyIdx == otherEnemyIdx and blip.cloneIdx == otherCloneIdx then
              blip.assignment = nil
              blip.texture_OverlayIcon:Hide()
            end
          end
        end
      end
    end
  end
  assignments[enemyIdx] = assignments[enemyIdx] or {}
  assignments[enemyIdx][cloneIdx] = marker
  notifyLiveMarkPlanChanged()
end

function MDT:HideDisplacedSpawnMarks(spawnKeys)
  for _, spawnKey in ipairs(spawnKeys or {}) do
    for _, blip in pairs(blips) do
      if blip.clone and blip.clone.artSpawnKey == spawnKey then
        blip.assignment = nil
        blip.texture_OverlayIcon:Hide()
      end
    end
  end
end

local blipScaleAnimations = {}
local blipScaleAnimationFrame
local manualExplosion
local manualExplosionAnimation
local manualExplosionHovered

local function updateBlipScaleAnimation(_, elapsed)
  for blip, animation in pairs(blipScaleAnimations) do
    animation.elapsed = min(animation.duration, animation.elapsed + elapsed)
    local progress = animation.elapsed / animation.duration
    local eased = 1 - (1 - progress) ^ 3
    local scale = animation.from + (animation.to - animation.from) * eased
    blip.hoverScale = scale
    blip:updateSizes(scale)
    if progress >= 1 then
      blip.hoverScale = animation.to
      blip:updateSizes(animation.to)
      blip.sizesDirty = animation.to ~= 1 and true or nil
      blipScaleAnimations[blip] = nil
    end
  end
  if manualExplosionAnimation then
    local animation = manualExplosionAnimation
    animation.elapsed = min(animation.duration, animation.elapsed + elapsed)
    local progress = animation.elapsed / animation.duration
    local eased = 1 - (1 - progress) ^ 3
    for _, item in ipairs(animation.items) do
      local x = item.fromX + (item.toX - item.fromX) * eased
      local y = item.fromY + (item.toY - item.fromY) * eased
      item.blip:ClearAllPoints()
      item.blip:SetPoint("CENTER", MDT.main_frame.mapPanelTile1, "TOPLEFT", x, y)
      if progress >= 1 and item.point then
        item.blip:ClearAllPoints()
        item.blip:SetPoint(unpack(item.point))
      end
    end
    if progress >= 1 then
      manualExplosionAnimation = nil
      if animation.collapse then manualExplosion = nil end
    end
  end
  if not next(blipScaleAnimations) and not manualExplosionAnimation then blipScaleAnimationFrame:Hide() end
end

local function ensureBlipScaleAnimationFrame()
  if blipScaleAnimationFrame then return end
  blipScaleAnimationFrame = CreateFrame("Frame")
  blipScaleAnimationFrame:SetScript("OnUpdate", updateBlipScaleAnimation)
end

function MDT:AnimateBlipScale(blip, target)
  if not blip or blip.isBoss then return end
  target = target or 1
  local from = blip.hoverScale or 1
  local current = blipScaleAnimations[blip]
  if current then
    local progress = current.elapsed / current.duration
    local eased = 1 - (1 - progress) ^ 3
    from = current.from + (current.to - current.from) * eased
    blipScaleAnimations[blip] = nil
  end
  blip.hoverScale = from
  if abs(from - target) < 0.01 then
    blip.hoverScale = target
    blip:updateSizes(target)
    blip.sizesDirty = target ~= 1 and true or nil
    return
  end
  blipScaleAnimations[blip] = {
    elapsed = 0,
    duration = HOVER_SCALE_ANIMATION_DURATION,
    from = from,
    to = target,
  }
  ensureBlipScaleAnimationFrame()
  blipScaleAnimationFrame:Show()
end

function MDT:ResetBlipHoverScales()
  blipScaleAnimations = {}
  for _, blip in pairs(blips) do
    if not blip.isBoss then
      blip.hoverScale = 1
      blip:updateSizes(1)
      blip.sizesDirty = nil
    end
  end
end

local function animateManualExplosion(items, collapse)
  manualExplosionAnimation = {
    elapsed = 0,
    duration = MANUAL_EXPLOSION_ANIMATION_DURATION,
    items = items,
    collapse = collapse,
  }
  ensureBlipScaleAnimationFrame()
  blipScaleAnimationFrame:Show()
end

local function collapseManualExplosion(instant)
  if not manualExplosion then return end
  manualExplosionAnimation = nil
  if not instant then
    local items = {}
    for _, item in ipairs(manualExplosion.items) do
      local _, _, _, x, y = item.blip:GetPoint()
      items[#items + 1] = {
        blip = item.blip,
        fromX = x or item.explodedX,
        fromY = y or item.explodedY,
        toX = item.point[4],
        toY = item.point[5],
        point = item.point,
      }
    end
    animateManualExplosion(items, true)
    return
  end
  for _, item in ipairs(manualExplosion.items) do
    item.blip:ClearAllPoints()
    item.blip:SetPoint(unpack(item.point))
  end
  manualExplosion = nil
end

local function manualExplosionCluster(anchor)
  local cluster, seen = { anchor }, { [anchor] = true }
  local index = 1
  while cluster[index] do
    local current = cluster[index]
    for _, candidate in pairs(blips) do
      if not seen[candidate] and candidate.data and not candidate.data.isBoss and candidate.clone
          and candidate:IsShown() and candidate:IsEnabled() and MDT:DoFramesOverlap(current, candidate) then
        seen[candidate] = true
        cluster[#cluster + 1] = candidate
      end
    end
    index = index + 1
  end
  if #cluster < 2 then return end
  table.sort(cluster, function(a, b)
    local enemyA, enemyB = tonumber(a.enemyIdx) or 0, tonumber(b.enemyIdx) or 0
    if enemyA == enemyB then return (tonumber(a.cloneIdx) or 0) < (tonumber(b.cloneIdx) or 0) end
    return enemyA < enemyB
  end)
  return cluster
end

local function manualExplosionLayout(cluster, anchor)
  local markerSize = MANUAL_EXPLOSION_RADIUS - MANUAL_EXPLOSION_GAP
  local movable = {}
  for _, blip in ipairs(cluster) do
    markerSize = max(markerSize, blip:GetWidth() or 0)
    if blip ~= anchor then movable[#movable + 1] = blip end
  end
  local spacing = max(MANUAL_EXPLOSION_RADIUS, markerSize + MANUAL_EXPLOSION_GAP)
  local count = #movable
  local radius = count > 1 and max(spacing, spacing / (2 * math.sin(math.pi / count))) or spacing
  local targets = {}
  for index, blip in ipairs(movable) do
    local angle = -math.pi / 2 + 2 * math.pi * (index - 1) / count
    targets[index] = { blip = blip, x = radius * math.cos(angle), y = radius * math.sin(angle), size = blip:GetWidth() or 0 }
  end
  return targets
end

local function avoidManualExplosionCollisions(targets, cluster, centerX, centerY)
  local members, placed = {}, {}
  for _, blip in ipairs(cluster) do members[blip] = true end
  local scale = MDT:GetScale()
  for _, target in ipairs(targets) do
    local baseX, baseY = target.x, target.y
    local function collides(x, y)
      for _, obstacle in pairs(blips) do
        if not members[obstacle] and obstacle.clone and obstacle:IsShown() and obstacle:IsEnabled() then
          local _, _, _, obstacleX, obstacleY = obstacle:GetPoint()
          obstacleX, obstacleY = obstacleX or obstacle.clone.x * scale, obstacleY or obstacle.clone.y * scale
          local clearance = (target.size + (obstacle:GetWidth() or 0)) / 2 + MANUAL_EXPLOSION_GAP
          local dx, dy = centerX + x - obstacleX, centerY + y - obstacleY
          if dx * dx + dy * dy < clearance * clearance then return true end
        end
      end
      for _, other in ipairs(placed) do
        local clearance = (target.size + other.size) / 2 + MANUAL_EXPLOSION_GAP
        local dx, dy = x - other.x, y - other.y
        if dx * dx + dy * dy < clearance * clearance then return true end
      end
      return false
    end
    if collides(baseX, baseY) then
      for step = 1, 35 do
        local direction = step % 2 == 1 and 1 or -1
        local angle = math.ceil(step / 2) * direction * math.pi / 18
        local angleCos, angleSin = math.cos(angle), math.sin(angle)
        local x, y = baseX * angleCos - baseY * angleSin, baseX * angleSin + baseY * angleCos
        if not collides(x, y) then target.x, target.y = x, y break end
      end
    end
    placed[#placed + 1] = target
  end
end

local function expandManualBlipExplosion(anchor)
  if manualExplosion then
    if manualExplosion.members[anchor] then return end
    collapseManualExplosion(true)
  end
  local cluster = manualExplosionCluster(anchor)
  if not cluster then return end
  local _, _, _, centerX, centerY = anchor:GetPoint()
  local scale = MDT:GetScale()
  centerX, centerY = centerX or anchor.clone.x * scale, centerY or anchor.clone.y * scale
  local targets = manualExplosionLayout(cluster, anchor)
  avoidManualExplosionCollisions(targets, cluster, centerX, centerY)
  local items, members = {}, {}
  for _, blip in ipairs(cluster) do
    local item = { blip = blip, point = { blip:GetPoint() } }
    items[#items + 1] = item
    members[blip] = item
  end
  manualExplosion = { items = items, members = members }
  local animationItems = {}
  for _, target in ipairs(targets) do
    local item = members[target.blip]
    item.explodedX, item.explodedY = centerX + target.x, centerY + target.y
    animationItems[#animationItems + 1] = {
      blip = target.blip,
      fromX = item.point[4],
      fromY = item.point[5],
      toX = item.explodedX,
      toY = item.explodedY,
    }
  end
  animateManualExplosion(animationItems)
end

function MDT:SetManualExplosionHover(blip)
  manualExplosionHovered = blip
  if blip and IsShiftKeyDown() then expandManualBlipExplosion(blip) end
end

local manualExplosionModifierFrame = CreateFrame("Frame")
manualExplosionModifierFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
manualExplosionModifierFrame:SetScript("OnEvent", function(_, _, key, state)
  if key ~= "LSHIFT" and key ~= "RSHIFT" then return end
  if state == 1 and manualExplosionHovered then
    expandManualBlipExplosion(manualExplosionHovered)
  elseif not IsShiftKeyDown() then
    collapseManualExplosion()
  end
end)

function MDT:DoFramesOverlap(frameA, frameB, offset)
  if not frameA or not frameB then return end
  offset = offset or 0
  --frameA = frameA.texture_Background
  --frameB = frameB.texture_Background

  local sA, sB = frameA:GetEffectiveScale(), frameB:GetEffectiveScale();
  if not sA or not sB then return end

  local frameALeft = frameA:GetLeft() - offset
  local frameARight = frameA:GetRight() + offset
  local frameABottom = frameA:GetBottom() - offset
  local frameATop = frameA:GetTop() + offset

  local frameBLeft = frameB:GetLeft()
  local frameBRight = frameB:GetRight()
  local frameBBottom = frameB:GetBottom()
  local frameBTop = frameB:GetTop()

  if not frameALeft or not frameARight or not frameABottom or not frameATop then return end
  if not frameBLeft or not frameBRight or not frameBBottom or not frameBTop then return end

  return ((frameALeft * sA) < (frameBRight * sB))
      and ((frameBLeft * sB) < (frameARight * sA))
      and ((frameABottom * sA) < (frameBTop * sB))
      and ((frameBBottom * sB) < (frameATop * sA));
end

MDTDungeonEnemyMixin = {};

local defaultSizes = {
  ["texture_Background"] = 20,
  ["texture_Portrait"] = 15,
  ["texture_MouseHighlight"] = 20,
  ["texture_SelectedHighlight"] = 20,
  ["texture_Dragon"] = 26,
  ["texture_Indicator"] = 20,
  ["texture_PullIndicator"] = 23,
  ["texture_DragDown"] = 8,
  ["texture_DragLeft"] = 8,
  ["texture_DragRight"] = 8,
  ["texture_DragUp"] = 8,
  ["texture_OverlayIcon"] = 12,
  ["mask_PortraitMask"] = 20,
}

local function getTrashHealthRange(enemies)
  local minHealth, maxHealth
  for _, data in pairs(enemies) do
    local health = data.health
    if not data.isBoss and type(health) == "number" and health > 0 then
      minHealth = minHealth and min(minHealth, health) or health
      maxHealth = maxHealth and max(maxHealth, health) or health
    end
  end
  return minHealth, maxHealth
end

local function getTrashHealthScale(data, minHealth, maxHealth)
  if data.isBoss or type(data.health) ~= "number" or not minHealth or not maxHealth or maxHealth <= minHealth then
    return 1
  end
  local ratio = (data.health - minHealth) / (maxHealth - minHealth)
  ratio = max(0, min(1, ratio))
  return TRASH_HEALTH_SCALE_MIN + (TRASH_HEALTH_SCALE_MAX - TRASH_HEALTH_SCALE_MIN) * sqrt(ratio)
end

function MDTDungeonEnemyMixin:updateSizes(scale)
  for tex, size in pairs(defaultSizes) do
    self[tex]:SetSize(size * self.normalScale * scale, size * self.normalScale * scale)
  end
end

function MDT:DisplayBlipModifierLabels(modifier)
  for _, blip in pairs(blips) do
    blip.textLocked = true
    local text = (modifier == "alt" and blip.clone.g and "G"..blip.clone.g) or (modifier == "ctrl" and blip.data.count) or ""
    blip.fontstring_Text1:SetText(text)
    blip.fontstring_Text1:Show()
  end
end

function MDT:HideAllBlipLabels(force)
  for _, blip in pairs(blips) do
    if force or blip.textLocked then
      blip.fontstring_Text1:Hide()
      blip.textLocked = nil
    end
  end
end

function MDT:SetUpModifiers(frame)
  if MDT:GetDB().devMode then return end
  local ONUPDATE_INTERVAL = 0.1
  local timeSinceLastUpdate = 0
  frame:SetScript("OnUpdate", function(self, elapsed)
    timeSinceLastUpdate = timeSinceLastUpdate + elapsed
    if timeSinceLastUpdate >= ONUPDATE_INTERVAL then
      timeSinceLastUpdate = 0
      local modifier = (IsAltKeyDown() and "alt") or (IsControlKeyDown() and "ctrl")
      local overMDT = frame:IsMouseOver() or frame.sidePanel:IsMouseOver() or frame.topPanel:IsMouseOver() or frame.bottomPanel:IsMouseOver()
      if modifier and overMDT then
        MDT:DisplayBlipModifierLabels(modifier)
        local statusText = (modifier == "alt" and L["altKeyDownStatusText"]) or (modifier == "ctrl" and L["ctrlKeyDownStatusText"])
        MDT.main_frame.statusString:SetText(statusText)
        MDT.main_frame.statusString:Show()
      else
        MDT:HideAllBlipLabels()
        MDT.main_frame.statusString:Hide()
      end
    end
  end)
end

function MDTDungeonEnemyMixin:OnEnter()
  if MDT.QuickMark then MDT.QuickMark:Arm(self) end
  MDT:SetManualExplosionHover(self)
  if not self.isBoss then
    MDT:AnimateBlipScale(self, HOVER_SCALE)
  end
  self.preHoverFrameLevel = self:GetFrameLevel()
  self:SetFrameLevel(self.preHoverFrameLevel + 5)
  self:DisplayPatrol(true)
  MDT:DisplayBlipTooltip(self, true)
  if not db.devMode then
    if self.textLocked then return end
    self.fontstring_Text1:SetText(self.data.count)
    self.fontstring_Text1:Show()
    if self.clone.g then
      for _, blip in pairs(blips) do
        if blip.clone.g == self.clone.g then
          blip.fontstring_Text1:SetText(blip.data.count)
          blip.fontstring_Text1:Show()
        end
      end
    end
  end
end

function MDTDungeonEnemyMixin:OnLeave()
  if MDT.QuickMark then MDT.QuickMark:Disarm(self) end
  if manualExplosionHovered == self then MDT:SetManualExplosionHover(nil) end
  if not self.isBoss then
    MDT:AnimateBlipScale(self, 1)
  end
  if self.preHoverFrameLevel then
    self:SetFrameLevel(self.preHoverFrameLevel)
    self.preHoverFrameLevel = nil
  end
  if db.devMode then
    if not self.devSelected then self:DisplayPatrol(false) end
  else
    self:DisplayPatrol(false)
  end
  MDT:DisplayBlipTooltip(self, false)
  if not db.devMode then
    if self.textLocked then return end
    self.fontstring_Text1:Hide()
    if not self.clone.g then return end
    for _, blip in pairs(blips) do
      if blip.clone.g == self.clone.g then
        blip.fontstring_Text1:Hide()
      end
    end
  end
end

local function updateDragPreviewPosition(preview, cursorX, cursorY)
  preview:ClearAllPoints()
  preview:SetPoint("CENTER", MDT.main_frame.mapPanelTile1, "TOPLEFT", cursorX + preview.offsetX, cursorY + preview.offsetY)
end

local function setupDragPreview(preview, blip, cursorX, cursorY)
  local _, _, _, blipX, blipY = blip:GetPoint()
  preview.offsetX = (blipX or cursorX) - cursorX
  preview.offsetY = (blipY or cursorY) - cursorY
  preview:SetFrameStrata("HIGH")
  preview:SetFrameLevel(120)
  preview:SetAlpha(0.5)
  preview:EnableMouse(false)
  preview:SetSize(blip.normalScale * 13, blip.normalScale * 13)
  preview.texture_Background:SetSize(blip.normalScale * 20, blip.normalScale * 20)
  preview.texture_Background:SetVertexColor(1, 1, 1, 1)
  preview.texture_Portrait:SetSize(blip.normalScale * 15, blip.normalScale * 15)
  preview.texture_Portrait:SetVertexColor(1, 1, 1, 1)
  preview.texture_Portrait:SetDesaturated(false)
  if blip.data.iconTexture then
    preview.texture_Portrait:SetTexture(blip.data.iconTexture)
  else
    SetPortraitTextureFromCreatureDisplayID(preview.texture_Portrait, blip.data.displayId or 39490)
  end
  updateDragPreviewPosition(preview, cursorX, cursorY)
  preview:Show()
end

local function getDraggedBlips(blip, ignoreGrouped)
  local draggedBlips = { blip }
  if ignoreGrouped or not blip.clone.g then return draggedBlips end
  for _, otherBlip in pairs(blips) do
    if otherBlip ~= blip and otherBlip.clone.g == blip.clone.g and otherBlip:IsShown() and otherBlip:IsEnabled() then
      tinsert(draggedBlips, otherBlip)
    end
  end
  return draggedBlips
end

local function showDragPreviews(blip, ignoreGrouped)
  MDT.dungeonEnemyDragPreview_framePool:ReleaseAll()
  local cursorX, cursorY = MDT:GetCursorPosition()
  for _, draggedBlip in pairs(getDraggedBlips(blip, ignoreGrouped)) do
    setupDragPreview(MDT.dungeonEnemyDragPreview_framePool:Acquire(), draggedBlip, cursorX, cursorY)
  end
end

local function updateDragPreviews(cursorX, cursorY)
  for _, preview in pairs(MDT.dungeonEnemyDragPreview_framePool.active) do
    updateDragPreviewPosition(preview, cursorX, cursorY)
  end
end

local DRAG_TARGET_UPDATE_INTERVAL = 0.1

local function setUpMouseHandlers(self)
  self:SetScript("OnMouseDown", function(self, button)

  end)
  local tempPulls
  local targetPull
  local dragPreviewIgnoreGrouped
  local dragPreviewHullState
  self:SetScript("OnDragStart", function()
    local x, y, scale
    local dragTargetUpdateElapsed = DRAG_TARGET_UPDATE_INTERVAL
    preset = MDT:GetCurrentPreset()
    tempPulls = CopyTable(preset.value.pulls)
    targetPull = nil
    dragPreviewHullState = nil
    dragPreviewIgnoreGrouped = IsControlKeyDown()
    showDragPreviews(self, dragPreviewIgnoreGrouped)
    local _, _, _, blipX, blipY = self:GetPoint()
    self:SetScript("OnUpdate", function(_, elapsed)
      local nx, ny = MDT:GetCursorPosition()
      if x ~= nx or y ~= ny then
        x, y = nx, ny
        local ignoreGrouped = IsControlKeyDown()
        if ignoreGrouped ~= dragPreviewIgnoreGrouped then
          dragPreviewIgnoreGrouped = ignoreGrouped
          tempPulls = CopyTable(preset.value.pulls)
          targetPull = nil
          dragPreviewHullState = nil
          dragTargetUpdateElapsed = DRAG_TARGET_UPDATE_INTERVAL
          showDragPreviews(self, dragPreviewIgnoreGrouped)
        end
        updateDragPreviews(x, y)
        dragTargetUpdateElapsed = dragTargetUpdateElapsed + (elapsed or 0)
        if dragTargetUpdateElapsed < DRAG_TARGET_UPDATE_INTERVAL then return end
        dragTargetUpdateElapsed = 0
        --find closest pull and measure distance
        local pullIdx, centerX, centerY = MDT:FindClosestPull(x, y)
        if not centerX then
          targetPull = nil
          return
        end
        local distBlip = (centerX - blipX) ^ 2 + (centerY - blipY) ^ 2
        local distCursor = (centerX - x) ^ 2 + (centerY - y) ^ 2
        local isClose = distCursor < 1 / 3 * distBlip or distBlip < 150
        if not isClose then
          MDT:DungeonEnemies_AddOrRemoveBlipToCurrentPull(self, false, ignoreGrouped, tempPulls, nil, true)
          MDT:DungeonEnemies_UpdateSelected(MDT:GetCurrentPull(), tempPulls)
          targetPull = nil
          if dragPreviewHullState ~= false then
            dragPreviewHullState = false
            MDT:DrawAllHulls(CopyTable(tempPulls), true)
          end
        elseif pullIdx ~= targetPull or dragPreviewHullState ~= pullIdx then
          targetPull = pullIdx
          MDT:DungeonEnemies_AddOrRemoveBlipToCurrentPull(self, true, ignoreGrouped, tempPulls, pullIdx, true)
          MDT:DungeonEnemies_UpdateSelected(MDT:GetCurrentPull(), tempPulls)
          dragPreviewHullState = pullIdx
          MDT:DrawAllHulls(CopyTable(tempPulls), true)
        end
      end
    end)
  end)
  self:SetScript("OnDragStop", function()
    self:SetScript("OnUpdate", nil)
    MDT.dungeonEnemyDragPreview_framePool:ReleaseAll()
    MDT:CancelAsync("DrawAllHulls")
    preset.value.pulls = tempPulls
    MDT:DungeonEnemies_UpdateSelected(MDT:GetCurrentPull(), tempPulls)
    MDT:SetSelectionToPull(targetPull)
    MDT:ReloadPullButtons(true)
    MDT:UpdateProgressbar()
    if MDT.liveSessionActive and MDT:GetCurrentPreset().uid == MDT.livePresetUID then
      MDT:LiveSession_SendPulls(MDT:GetPulls())
    end
  end)
end

local iconColors = {
  { 1,   .92, 0,    1 },
  { .98, .57, 0,    1 },
  { .83, .22, .9,   1 },
  { .04, .95, 0,    1 },
  { .7,  .82, .875, 1 },
  { 0,   .71, 1,    1 },
  { 1,   .24, .168, 1 },
  { .98, .98, .98,  1 },
}

local createEnemyContextMenu = function(frame)
  MDT:GetCurrentPreset().value.enemyAssignments = MDT:GetCurrentPreset().value.enemyAssignments or {}
  local assignments = MDT:GetCurrentPreset().value.enemyAssignments
  local planner = MDT.RaidPlanner
  -- Route-step marks only apply to ART spawns with a stable pack/spawn key.
  local useRouteMarks = planner and planner.initialized
      and frame.clone.artPackKey ~= nil and frame.clone.artSpawnKey ~= nil
      and #planner:FindStepsForPack(frame.clone.artPackKey) > 0
  MDT:CreateContextMenu(MDT.main_frame, function(ownerRegion, rootDescription)
    rootDescription:CreateTitle(L[frame.data.name])

    if useRouteMarks then
      local packKey, spawnKey = frame.clone.artPackKey, frame.clone.artSpawnKey
      local function IsSelected(data)
        local mark = planner:GetSpawnMark(packKey, spawnKey)
        return (data.index == 0 and not mark) or mark == data.index
      end
      local function SetSelected(data)
        local _, displaced = planner:SetSpawnMark(packKey, spawnKey, data.index ~= 0 and data.index or nil)
        MDT:HideDisplacedSpawnMarks(displaced)
        frame:SetUp(frame.data, frame.clone)
      end
      local submenu = rootDescription:CreateButton(L["Set Target Marker"], function() end);
      for i = 1, 8 do
        local iconPath = ICON_LIST[i].."16:16:|t"
        local color = CreateColor(unpack(iconColors[i]))
        local iconName = WrapTextInColor(_G["RAID_TARGET_"..i], color)
        submenu:CreateRadio(iconPath.." "..iconName, IsSelected, SetSelected, { index = i })
      end
      submenu:CreateRadio(L["None"], IsSelected, SetSelected, { index = 0 })
    else
      local function IsSelected(data)
        local assignment = assignments[data.enemyIdx] and assignments[data.enemyIdx][data.cloneIdx]
        return assignment and assignment == data.index or false
      end
      local function SetSelected(data)
        MDT:SetLegacyBlipMark(data.enemyIdx, data.cloneIdx, data.index ~= 0 and data.index or nil)
        frame:SetUp(frame.data, frame.clone)
        if not db.hasSeenAssignmentWarning then
          MDT:OpenConfirmationFrame(450, 150, L["Warning"], L["Okay"], L["assignmentWarning"])
          db.hasSeenAssignmentWarning = true
        end
      end
      local submenu = rootDescription:CreateButton(L["Set Target Marker"], function() end);
      for i = 1, 8 do
        local iconPath = ICON_LIST[i].."16:16:|t"
        local color = CreateColor(unpack(iconColors[i]))
        local iconName = WrapTextInColor(_G["RAID_TARGET_"..i], color)
        submenu:CreateRadio(iconPath.." "..iconName, IsSelected, SetSelected,
            { enemyIdx = frame.enemyIdx, cloneIdx = frame.cloneIdx, index = i })
      end
      submenu:CreateRadio(L["None"], IsSelected, SetSelected,
          { enemyIdx = frame.enemyIdx, cloneIdx = frame.cloneIdx, index = 0 })
      submenu:CreateButton(L["Clear all Markers"], function()
        twipe(assignments)
        notifyLiveMarkPlanChanged()
        MDT:Async(function()
          MDT:DungeonEnemies_UpdateEnemiesAsync()
        end, "ClearAllMarkers")
      end)
    end
    if useRouteMarks then
      rootDescription:CreateButton(L["Clear all Markers"], function()
        planner:ClearAllSpawnMarks()
        MDT:Async(function()
          MDT:DungeonEnemies_UpdateEnemiesAsync()
        end, "ClearAllMarkers")
      end)
    end
    rootDescription:CreateButton(L["Open Enemy Info"], function()
      MDT:ShowEnemyInfoFrame(frame)
    end)
  end)
end

function MDTDungeonEnemyMixin:OnClick(button, down)
  --always deselect toolbar tool
  MDT:UpdateSelectedToolbarTool()
  if button == "LeftButton" then
    MDT:DungeonEnemies_AddOrRemoveBlipToCurrentPull(self, not self.selected, IsControlKeyDown())
    MDT:DungeonEnemies_UpdateSelected(MDT:GetCurrentPull())
    MDT:UpdateProgressbar()
    MDT:ReloadPullButtons()
    if MDT.liveSessionActive and MDT:GetCurrentPreset().uid == MDT.livePresetUID then
      MDT:LiveSession_SendPulls(MDT:GetPulls())
    end
  elseif button == "RightButton" then
    if db.devMode then
      if IsAltKeyDown() then
        MDT.dungeonEnemies[db.currentDungeonIdx][self.enemyIdx].clones[self.cloneIdx] = nil
        self:Hide()
      else
        self.devSelected = (not self.devSelected) or nil
        self:DisplayPatrol(self.devSelected)
        for blipIdx, blip in pairs(blips) do
          if blip ~= self then
            blip.devSelected = nil
          end
          if blip.devSelected then
            blip.texture_Portrait:SetVertexColor(1, 0, 0, 1)
          else
            blip.texture_Portrait:SetVertexColor(1, 1, 1, 1)
          end
        end
      end
      MDT:UpdateMap()
    else
      createEnemyContextMenu(self)
    end
  end
end

local patrolPoints = {}
local patrolLines = {}

function MDT:GetPatrolBlips()
  return patrolPoints
end

function MDTDungeonEnemyMixin:DisplayPatrol(shown)
  local scale = MDT:GetScale()

  --Hide all points/line
  for _, point in pairs(patrolPoints) do point:Hide() end
  for _, line in pairs(patrolLines) do line:Hide() end
  if not shown then return end

  if self.clone.patrol then
    local firstWaypointBlip
    local oldWaypointBlip
    for patrolIdx, waypoint in ipairs(self.clone.patrol) do
      patrolPoints[patrolIdx] = patrolPoints[patrolIdx] or
          MDT.main_frame.mapPanelFrame:CreateTexture("MDTDungeonPatrolPoint"..patrolIdx, "BACKGROUND", nil, 0)


      patrolPoints[patrolIdx]:SetDrawLayer("OVERLAY", 2)
      patrolPoints[patrolIdx]:SetTexture("Interface\\Worldmap\\X_Mark_64Grey")
      patrolPoints[patrolIdx]:SetSize(4 * scale, 4 * scale)
      patrolPoints[patrolIdx]:SetVertexColor(0, 0.2, 0.5, 0.6)
      patrolPoints[patrolIdx]:ClearAllPoints()
      patrolPoints[patrolIdx]:SetPoint("CENTER", MDT.main_frame.mapPanelTile1, "TOPLEFT", waypoint.x * scale,
        waypoint.y * scale)
      patrolPoints[patrolIdx].x = waypoint.x
      patrolPoints[patrolIdx].y = waypoint.y
      patrolPoints[patrolIdx]:Show()

      patrolLines[patrolIdx] = patrolLines[patrolIdx] or
          MDT.main_frame.mapPanelFrame:CreateTexture("MDTDungeonPatrolLine"..patrolIdx, "BACKGROUND", nil, 0)
      patrolLines[patrolIdx]:SetDrawLayer("OVERLAY", 1)
      patrolLines[patrolIdx]:SetTexture(MDT.AddonPath.."Textures\\Square_White")
      patrolLines[patrolIdx]:SetVertexColor(0, 0.2, 0.5, 0.6)
      patrolLines[patrolIdx]:Show()

      --connect 2 waypoints
      if oldWaypointBlip then
        local _, _, _, startX, startY = patrolPoints[patrolIdx]:GetPoint()
        local _, _, _, endX, endY = oldWaypointBlip:GetPoint()
        DrawLine(patrolLines[patrolIdx], MDT.main_frame.mapPanelTile1, startX, startY, endX, endY, 1 * scale, 1,
          "TOPLEFT")
        patrolLines[patrolIdx]:Show()
      else
        firstWaypointBlip = patrolPoints[patrolIdx]
      end
      oldWaypointBlip = patrolPoints[patrolIdx]
    end
    --connect last 2 waypoints
    if firstWaypointBlip and oldWaypointBlip then
      local _, _, _, startX, startY = firstWaypointBlip:GetPoint()
      local _, _, _, endX, endY = oldWaypointBlip:GetPoint()
      DrawLine(patrolLines[1], MDT.main_frame.mapPanelTile1, startX, startY, endX, endY, 1 * scale, 1, "TOPLEFT")
      patrolLines[1]:Show()
    end
  else
    --find patrol leader if no patrol
    for _, blip in pairs(blips) do
      if blip:IsShown() and blip.clone.g and self.clone.g then
        if blip.clone.g == self.clone.g and blip.clone.patrol then
          blip:DisplayPatrol(shown)
        end
      end
    end
  end
end

local ranOnce
function MDT:DisplayBlipTooltip(blip, shown)
  if not ranOnce then
    MDT.tooltip:ClearAllPoints()
    MDT.tooltip:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT")
    MDT.tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")
    MDT.tooltip:Show()
    MDT.tooltip:Hide()
    ranOnce = true
  end

  local tooltip = MDT.tooltip
  local data = blip.data
  if shown then
    tooltip.Model:SetCreature(data.id)
    tooltip.Model:SetPosition(0, 0, 0)
    tooltip.String:Show()
    tooltip:Show()
  else
    tooltip.String:Hide()
    tooltip:Hide()
    return
  end

  local health = data.health
  local group = blip.clone.g and " "..string.format(L["(G %d)"], blip.clone.g) or ""
  local occurence = (blip.data.isBoss and "") or blip.cloneIdx

  if not L[data.name] then print("MDT: Could not find localization for "..data.name) end
  local text = L[data.name]..
      " "..
      occurence..
      group..
      "\n"..
      string.format(L["Level %d %s"], data.level, L[data.creatureType]).." "..data.id..
      "\n"..string.format(L["%s HP"], MDT:FormatEnemyHealth(health)).."\n"

  if db.devMode then
    text = L["devModeShiftDragHint"].."\n"..L["devModeCtrlDragHint"].."\n\n"..text
  end

  if not blip.suppressEnemyInfoHint then
    text = text.."\n\n["..L["Right click for more info"].."]"
  end
  tooltip.String:SetText(text)

  tooltip:ClearAllPoints()
  tooltip:SetPoint("TOPLEFT", blip, "BOTTOMRIGHT", 30, 0)
  tooltip:SetPoint("BOTTOMRIGHT", blip, "BOTTOMRIGHT", 30 + tooltip.mySizes.x, -tooltip.mySizes.y)
  local bottomOffset = 0
  local rightOffset = 0
  local tooltipBottom = tooltip:GetBottom()
  local mainFrameBottom = MDT.main_frame:GetBottom()
  if tooltipBottom < mainFrameBottom then
    bottomOffset = tooltip.mySizes.y
  end
  local tooltipRight = tooltip:GetRight()
  local mainFrameRight = MDT.main_frame:GetRight()
  if tooltipRight > mainFrameRight then
    rightOffset = -(tooltip.mySizes.x + 60)
  end

  tooltip:SetPoint("TOPLEFT", blip, "BOTTOMRIGHT", 30 + rightOffset, bottomOffset)
  tooltip:SetPoint("BOTTOMRIGHT", blip, "BOTTOMRIGHT", 30 + tooltip.mySizes.x + rightOffset,
    -tooltip.mySizes.y + bottomOffset)
end

function MDT:GetEfficiencyScoreString(count, health)
  local totalCount = MDT.dungeonTotalCount[db.currentDungeonIdx].normal
  local score = 2.5 * (count / totalCount) * 13000 / (health / 20000)
  local formattedScore = MDT:Round(score, 1)
  local value = score / 10
  --https://stackoverflow.com/a/7947812/17380548
  local colorHex = MDT:RGBToHex(math.max(0, math.min(1, 2 * (1 - value))), math.min(1, 2 * value), 0)
  return ("|cFF%s%s|r"):format(colorHex, formattedScore)
end

function MDT:GetCurrentDevmodeBlip()
  for blipIdx, blip in pairs(blips) do
    if blip.devSelected then
      return blip
    end
  end
end

--make blip movable in devMode and store new position
local function blipDevModeSetup(blip)
  blip:SetMovable(true)
  blip:RegisterForDrag("LeftButton")

  local groupColors = {
    [1] = { 1, 0, 0, 1 },
    [2] = { 0, 1, 0, 1 },
    [3] = { 0, 0, 1, 1 },
    [4] = { 1, 0, 1, 1 },
    [5] = { 0, 1, 1, 1 },
  }
  local function updateBlipText()
    if db.devModeBlipTextHidden then
      blip.fontstring_Text1:SetText("")
      return
    end
    blip.fontstring_Text1:Show()
    blip.fontstring_Text1:SetText((blip.clone.g or "").."  "..
      WrapTextInColorCode((blip.clone.scale or ""), "ffffffff"))
    if blip.clone.g then blip.fontstring_Text1:SetTextColor(unpack(groupColors[blip.clone.g % 5 + 1])) end
  end
  blip.UpdateBlipText = updateBlipText

  local xOffset, yOffset
  blip:SetScript("OnMouseDown", function()
    local x, y = MDT:GetCursorPosition()
    local scale = MDT:GetScale()
    x = x * (1 / scale)
    y = y * (1 / scale)
    local nx = MDT.dungeonEnemies[db.currentDungeonIdx][blip.enemyIdx].clones[blip.cloneIdx].x
    local ny = MDT.dungeonEnemies[db.currentDungeonIdx][blip.enemyIdx].clones[blip.cloneIdx].y
    xOffset = x - nx
    yOffset = y - ny
  end)
  local moveGroup
  local movePatrol
  blip:SetScript("OnDragStart", function()
    if not db.devModeBlipsMovable then return end
    if IsShiftKeyDown() then
      moveGroup = true
    end
    if not IsControlKeyDown() then
      movePatrol = true
    end
    blip:StartMoving()
  end)
  blip:SetScript("OnDragStop", function()
    if not db.devModeBlipsMovable then return end
    if IsShiftKeyDown() then
      moveGroup = true
    end
    if not IsControlKeyDown() then
      movePatrol = true
    end
    local x, y = MDT:GetCursorPosition()
    local scale = MDT:GetScale()
    x = x * (1 / scale)
    y = y * (1 / scale)
    x = x - xOffset
    y = y - yOffset
    local deltaX = x - MDT.dungeonEnemies[db.currentDungeonIdx][blip.enemyIdx].clones[blip.cloneIdx].x
    local deltaY = y - MDT.dungeonEnemies[db.currentDungeonIdx][blip.enemyIdx].clones[blip.cloneIdx].y
    if moveGroup then
      for enemyIdx, data in pairs(MDT.dungeonEnemies[db.currentDungeonIdx]) do
        for cloneIdx, clone in pairs(data.clones) do
          if clone.g == blip.clone.g then
            clone.x = clone.x + deltaX
            clone.y = clone.y + deltaY
            --move blip
            local cloneBlip = MDT:GetBlip(enemyIdx, cloneIdx)
            if cloneBlip then
              cloneBlip:ClearAllPoints()
              cloneBlip:SetPoint("CENTER", MDT.main_frame.mapPanelTile1, "TOPLEFT", clone.x * scale, clone.y * scale)
            end
          end
        end
      end
    end

    if movePatrol and blip.clone.patrol then
      for patrolIdx, waypoint in pairs(blip.clone.patrol) do
        waypoint.x = waypoint.x + deltaX
        waypoint.y = waypoint.y + deltaY
        MDT.dungeonEnemies[db.currentDungeonIdx][blip.enemyIdx].clones[blip.cloneIdx].patrol[patrolIdx].x = waypoint.x
        MDT.dungeonEnemies[db.currentDungeonIdx][blip.enemyIdx].clones[blip.cloneIdx].patrol[patrolIdx].y = waypoint.y
      end
      blip:DisplayPatrol(true)
      movePatrol = nil
    end

    blip:StopMovingOrSizing()
    blip:ClearAllPoints()
    blip:SetPoint("CENTER", MDT.main_frame.mapPanelTile1, "TOPLEFT", x * scale, y * scale)
    MDT.dungeonEnemies[db.currentDungeonIdx][blip.enemyIdx].clones[blip.cloneIdx].x = x
    MDT.dungeonEnemies[db.currentDungeonIdx][blip.enemyIdx].clones[blip.cloneIdx].y = y
    moveGroup = nil
  end)
  blip:SetScript("OnMouseWheel", function(self, delta)
    if not db.devModeBlipsScrollable then return end
    -- alt scroll to scale blip and connected blips
    if IsAltKeyDown() then
      if IsShiftKeyDown() then
        -- scale whole sublevel
        for _, data in pairs(MDT.dungeonEnemies[db.currentDungeonIdx]) do
          for _, clone in pairs(data.clones) do
            if clone.sublevel == MDT:GetCurrentSubLevel() then
              clone.scale = (clone.scale or 1) + delta * 0.1
            end
          end
        end
      elseif IsControlKeyDown() then
        -- only scale this specific blip
        local clone = MDT.dungeonEnemies[db.currentDungeonIdx][self.enemyIdx].clones[self.cloneIdx]
        clone.scale = (clone.scale or 1) + delta * 0.1
      else
        -- only scale this blip and it's connected blips
        if blip.clone.g then
          for _, data in pairs(MDT.dungeonEnemies[db.currentDungeonIdx]) do
            for _, clone in pairs(data.clones) do
              if clone.g == blip.clone.g then
                clone.scale = (clone.scale or 1) + delta * 0.1
              end
            end
          end
        else
          blip.clone.scale = (blip.clone.scale or 1) + delta * 0.1
        end
      end
      MDT:UpdateMap()
    else
      if not blip.clone.g then
        local maxGroup = 0
        for _, data in pairs(MDT.dungeonEnemies[db.currentDungeonIdx]) do
          for _, clone in pairs(data.clones) do
            maxGroup = (clone.g and (clone.g > maxGroup)) and clone.g or maxGroup
          end
        end
        if IsControlKeyDown() then
          maxGroup = maxGroup + 1
        end
        blip.clone.g = maxGroup
      else
        local blipGroup = blip.clone.g
        if IsShiftKeyDown() then
          --change group of all connected blips
          for enemyIdx, data in pairs(MDT.dungeonEnemies[db.currentDungeonIdx]) do
            for cloneIdx, clone in pairs(data.clones) do
              if clone.g == blipGroup then
                clone.g = blipGroup + delta
                local cloneBlip = MDT:GetBlip(enemyIdx, cloneIdx)
                cloneBlip.UpdateBlipText()
              end
            end
          end
        else
          blip.clone.g = blip.clone.g + delta
          updateBlipText()
        end
      end
    end
  end)
  updateBlipText()
end

local function resetBlipDevModeSetup(blip)
  blip.textLocked = nil
  blip.fontstring_Text1:Hide()
  if blip.devModeSetup then
    blip.devSelected = nil
    blip.UpdateBlipText = nil
    blip.fontstring_Text1:SetTextColor(1, 1, 1, 1)
    setUpMouseHandlers(blip)
    blip:SetScript("OnMouseWheel", nil)
    blip:SetMovable(false)
    blip.devModeSetup = nil
  end
end

function MDTDungeonEnemyMixin:SetUp(data, clone, overlapCandidates, currentPreset, trashMinHealth, trashMaxHealth)
  local scale = MDT:GetScale()
  local explosionItem = manualExplosion and manualExplosion.members[self]
  local _, _, _, explosionX, explosionY = self:GetPoint()
  self:ClearAllPoints()
  self:SetPoint("CENTER", MDT.main_frame.mapPanelTile1, "TOPLEFT", clone.x * scale, clone.y * scale)
  if explosionItem and explosionX and explosionY then
    self:ClearAllPoints()
    self:SetPoint("CENTER", MDT.main_frame.mapPanelTile1, "TOPLEFT", explosionX, explosionY)
  end
  if not self.setupInitialized then
    self.texture_Portrait:SetDesaturated(false)
    self.texture_MouseHighlight:SetAlpha(0.4)
    self.fontstring_Text1:SetFontObject("GameFontNormal")
    setUpMouseHandlers(self)
    self.setupInitialized = true
  end
  local cloneScale = clone.scale or 1
  local healthScale = getTrashHealthScale(data, trashMinHealth, trashMaxHealth)
  local normalScale = cloneScale * data.scale * healthScale * (data.isBoss and 1.7 or 1) *
      (MDT.scaleMultiplier[db.currentDungeonIdx] or 1) * scale * 0.6
  if self.normalScale ~= normalScale or self.sizesDirty then
    self.normalScale = normalScale
    self.sizesDirty = nil
    self:SetSize(normalScale * 13, normalScale * 13)
    self:updateSizes(self.hoverScale or 1)
    local textScale = math.max(0.2, normalScale * 10)
    self.fontstring_Text1:SetFont(self.fontstring_Text1:GetFont(), textScale, "OUTLINE", "")
  end
  local raise = 4
  for _, v in ipairs(overlapCandidates or blips) do
    --only check neighboring blips - saves performance on big maps
    if ((clone.x - v.clone.x) ^ 2 + (clone.y - v.clone.y) ^ 2 < OVERLAP_DISTANCE_SQUARED) and
        MDT:DoFramesOverlap(self, v, 5) then
      raise = max(raise
      , v:GetFrameLevel() + 1)
    end
  end
  self:SetFrameLevel(raise)
  self.fontstring_Text1:SetText((clone.isBoss and data.count == 0 and "") or data.count)
  local isBoss = data.isBoss and true or false
  if self.isBoss ~= isBoss then
    self.isBoss = isBoss
    if isBoss then self.texture_Dragon:Show() else self.texture_Dragon:Hide() end
  end
  local hasPatrol = clone.patrol and true or false
  if self.hasPatrol ~= hasPatrol then
    self.hasPatrol = hasPatrol
    if hasPatrol then
      self.texture_Background:SetVertexColor(unpack(patrolColor))
    else
      self.texture_Background:SetVertexColor(1, 1, 1, 1)
    end
  end
  self.data = data
  self.clone = clone
  self:Show()
  self:SetScript("OnUpdate", nil)
  tinsert(blips, self)
  local portrait = data.iconTexture or data.displayId or 39490
  local portraitIsTexture = data.iconTexture and true or false
  if self.portrait ~= portrait or self.portraitIsTexture ~= portraitIsTexture then
    self.portrait = portrait
    self.portraitIsTexture = portraitIsTexture
    if portraitIsTexture then
      self.texture_Portrait:SetTexture(portrait)
    else
      SetPortraitTextureFromCreatureDisplayID(self.texture_Portrait, portrait)
    end
  end
  self.texture_Indicator:Hide()
  local planner = MDT.RaidPlanner
  local useRouteMarks = planner and planner.initialized and self.clone.artPackKey ~= nil
      and #planner:FindStepsForPack(self.clone.artPackKey) > 0
  local assignment
  if useRouteMarks then
    assignment = planner:GetSpawnMark(self.clone.artPackKey, self.clone.artSpawnKey)
  else
    local assignments = (currentPreset or MDT:GetCurrentPreset()).value.enemyAssignments
    assignment = assignments and assignments[self.enemyIdx] and assignments[self.enemyIdx][self.cloneIdx]
  end
  if not self.assignmentInitialized or self.assignment ~= assignment then
    self.assignmentInitialized = true
    self.assignment = assignment
    if assignment then
      self.texture_OverlayIcon:Show()
      if assignment >= 1 and assignment <= 8 then
        self.texture_OverlayIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..assignment)
      else
        --TODO: other pre set icons, sheep, sap etc they will have specific indexes
      end
    else
      self.texture_OverlayIcon:Hide()
    end
  end
  if db.devMode then
    blipDevModeSetup(self)
    self.devModeSetup = true
  else
    resetBlipDevModeSetup(self)
  end
end

---DungeonEnemies_HideAllBlips
---Used to hide blips during scaling changes to the map
function MDT:DungeonEnemies_HideAllBlips()
  collapseManualExplosion(true)
  MDT:ResetBlipHoverScales()
  MDT.dungeonEnemyDragPreview_framePool:ReleaseAll()
  MDT.dungeonEnemies_framePool:ReleaseAll()
end

function MDT:DungeonEnemies_UpdateEnemiesAsync()
  if not MDT.dungeonEnemies_framePool or not MDT.dungeonEnemyDragPreview_framePool then return end
  collapseManualExplosion(true)
  MDT:ResetBlipHoverScales()
  MDT.dungeonEnemyDragPreview_framePool:ReleaseAll()
  MDT.dungeonEnemies_framePool:ReleaseAll()
  coroutine.yield()
  twipe(blips)
  if not db then db = MDT:GetDB() end
  local enemies = MDT.dungeonEnemies[db.currentDungeonIdx]
  if not enemies then return end
  preset = MDT:GetCurrentPreset()

  local currentSublevel = MDT:GetCurrentSubLevel()
  local waveMode = preset.value.artWaveRaid ~= nil
  local trashMinHealth, trashMaxHealth = getTrashHealthRange(enemies)
  local overlapBuckets = {}
  local overlapCandidates = {}

  for enemyIdx, data in pairs(enemies) do
    for cloneIdx, clone in pairs(data["clones"]) do
      --check sublevel
      if (clone.sublevel == currentSublevel or (not clone.sublevel))
          and not clone.hidden
          and not waveMode
          and (not clone.artWave or clone.artWave == preset.value.currentPull) then
        twipe(overlapCandidates)
        local bucketX = floor(clone.x / OVERLAP_BUCKET_SIZE)
        local bucketY = floor(clone.y / OVERLAP_BUCKET_SIZE)
        for x = bucketX - 1, bucketX + 1 do
          local column = overlapBuckets[x]
          if column then
            for y = bucketY - 1, bucketY + 1 do
              local bucket = column[y]
              if bucket then
                for _, candidate in ipairs(bucket) do
                  tinsert(overlapCandidates, candidate)
                end
              end
            end
          end
        end
        local blip = MDT.dungeonEnemies_framePool:Acquire()
        blip.enemyIdx = enemyIdx
        blip.cloneIdx = cloneIdx
        blip:SetUp(data, clone, overlapCandidates, preset, trashMinHealth, trashMaxHealth)
        local column = overlapBuckets[bucketX]
        if not column then
          column = {}
          overlapBuckets[bucketX] = column
        end
        local bucket = column[bucketY]
        if not bucket then
          bucket = {}
          column[bucketY] = bucket
        end
        tinsert(bucket, blip)
        coroutine.yield()
      end
    end
  end
end

function MDT:DungeonEnemies_CreateFramePools()
  db = self:GetDB()
  MDT.dungeonEnemies_framePool = MDT.CreateFramePool("Button", MDT.main_frame.mapPanelFrame, "MDTDungeonEnemyTemplate")
  MDT.dungeonEnemyDragPreview_framePool = MDT.CreateFramePool("Frame", MDT.main_frame.mapPanelFrame,
    "MDTDungeonEnemyDragPreviewTemplate")
end

function MDT:GetBlip(enemyIdx, cloneIdx)
  for blipIdx, blip in pairs(blips) do
    if blip.enemyIdx == enemyIdx and blip.cloneIdx == cloneIdx then
      return blip
    end
  end
end

local function isCloneConstrained(clone)
  if not clone.constrained then return false end
  local amount = 0
  local data = MDT.dungeonEnemies[db.currentDungeonIdx]
  for enemyIdx, enemy in pairs(data) do
    for cloneIdx, c in pairs(enemy.clones) do
      if c.constrained and c.constrained.index == clone.constrained.index and MDT:IsCloneInPulls(enemyIdx, cloneIdx) then
        amount = amount + 1
      end
    end
  end
  if amount >= clone.constrained.amount then
    print(L["MDT: Cannot add enemy - you are trying to add too many enemies of the same kind"])
    return true
  end
  return false
end

---DungeonEnemies_AddOrRemoveBlipToCurrentPull
---Adds or removes an enemy clone and all it's linked npcs to the currently selected pull
function MDT:DungeonEnemies_AddOrRemoveBlipToCurrentPull(blip, add, ignoreGrouped, pulls, pull, ignoreUpdates)
  local preset = self:GetCurrentPreset()
  local enemyIdx = blip.enemyIdx
  local cloneIdx = blip.cloneIdx
  pull = pull or preset.value.currentPull
  pulls = pulls or preset.value.pulls or {}
  pulls[pull] = pulls[pull] or {}
  pulls[pull][enemyIdx] = pulls[pull][enemyIdx] or {}
  --remove clone from all other pulls first
  for pullIdx, p in pairs(pulls) do
    if pullIdx ~= pull and p[enemyIdx] then
      for k, v in pairs(p[enemyIdx]) do
        if v == cloneIdx then
          tremove(pulls[pullIdx][enemyIdx], k)
        end
      end
    end
    -- if not ignoreUpdates then self:UpdatePullButtonNPCData(pullIdx) end
  end
  if add then
    if isCloneConstrained(blip.clone) then return end
    if blip then blip.selected = true end
    local found = false
    for _, v in pairs(pulls[pull][enemyIdx]) do
      if v == cloneIdx then found = true end
    end
    if found == false and blip:IsEnabled() then
      tinsert(pulls[pull][enemyIdx], cloneIdx)
    end
  else
    blip.selected = false
    for k, v in pairs(pulls[pull][enemyIdx]) do
      if v == cloneIdx then
        tremove(pulls[pull][enemyIdx], k)
      end
    end
  end
  --linked npcs
  if not ignoreGrouped then
    for idx, otherBlip in pairs(blips) do
      local samePack = blip.clone.g and otherBlip.clone.g == blip.clone.g
      local samePullGroup = blip.clone.artPullGroup
          and otherBlip.clone.artPullGroup == blip.clone.artPullGroup
          and otherBlip.clone.sublevel == blip.clone.sublevel
      if (samePack or samePullGroup) and blip ~= otherBlip then
        self:DungeonEnemies_AddOrRemoveBlipToCurrentPull(otherBlip, add, true, pulls, pull, ignoreUpdates)
      end
    end
  end
  -- if not ignoreUpdates then self:UpdatePullButtonNPCData(pull) end
end

---DungeonEnemies_UpdateBlipColors
---Updates the colors of all selected blips of the specified pull
function MDT:DungeonEnemies_UpdateBlipColors(pull, r, g, b, pulls)
  pulls = pulls or preset.value.pulls
  local p = pulls[pull]
  if not p then return end
  for enemyIdx, clones in pairs(p) do
    if tonumber(enemyIdx) then
      for _, cloneIdx in pairs(clones) do
        for _, blip in pairs(blips) do
          if (blip.enemyIdx == enemyIdx) and (blip.cloneIdx == cloneIdx) then
            if not db.devMode then
              blip.texture_Portrait:SetVertexColor(r, g, b, 1)
              blip.texture_SelectedHighlight:SetVertexColor(r, g, b, 0.7)
            end
            break
          end
        end
      end
    end
  end
end

---Updates the selected Enemies on the map and marks them according to their pull color
function MDT:DungeonEnemies_UpdateSelected(pull, pulls, ignoreHulls)
  preset = MDT:GetCurrentPreset()
  pulls = pulls or preset.value.pulls
  --deselect all
  for _, blip in pairs(blips) do
    blip.texture_SelectedHighlight:Hide()
    blip.selected = false
    blip.texture_PullIndicator:Hide()
    if not db.devMode then
      blip.texture_Portrait:SetVertexColor(1, 1, 1, 1)
    end
  end
  --highlight all pull enemies
  for pullIdx, p in pairs(pulls) do
    local r, g, b = MDT:DungeonEnemies_GetPullColor(pullIdx)
    for enemyIdx, clones in pairs(p) do
      if tonumber(enemyIdx) then
        for _, cloneIdx in pairs(clones) do
          for _, blip in pairs(blips) do
            if (blip.enemyIdx == enemyIdx) and (blip.cloneIdx == cloneIdx) then
              blip.texture_SelectedHighlight:Show()
              blip.selected = true
              if not db.devMode then
                blip.texture_Portrait:SetVertexColor(r, g, b, 1)
                blip.texture_SelectedHighlight:SetVertexColor(r, g, b, 0.7)
              end
              if pullIdx == pull then
                blip.texture_PullIndicator:Show()
              end
              break
            end
          end
        end
      end
    end
  end
  -- if not ignoreHulls then MDT:DrawAllHulls(pulls) end
end

---DungeonEnemies_SetPullColor
---Sets a custom color for a pull
function MDT:DungeonEnemies_SetPullColor(pull, r, g, b)
  preset = MDT:GetCurrentPreset()
  if not preset.value.pulls[pull] then return end
  preset.value.pulls[pull]["color"] = MDT:RGBToHex(r, g, b)
end

---DungeonEnemies_GetPullColor
---Returns the custom color for a pull
function MDT:DungeonEnemies_GetPullColor(pull, pulls)
  pulls = pulls or preset.value.pulls
  local r, g, b = MDT:HexToRGB(pulls[pull]["color"])
  if not r then
    r, g, b = MDT:HexToRGB("228b22")
    MDT:DungeonEnemies_SetPullColor(pull, r, g, b)
  end
  return r, g, b
end

function MDT:IsCloneInPulls(enemyIdx, cloneIdx)
  local pulls = MDT:GetCurrentPreset().value.pulls
  local numClones = 0
  for _, pull in pairs(pulls) do
    if pull[enemyIdx] then
      if cloneIdx then
        for _, pullCloneIndex in pairs(pull[enemyIdx]) do
          if pullCloneIndex == cloneIdx then return true end
        end
      else
        for _, pullCloneIndex in pairs(pull[enemyIdx]) do
          numClones = numClones + 1
        end
      end
    end
  end
  return numClones > 0
end

local function ArrayRemove(t, fnKeep)
  local j, n = 1, #t;

  for i = 1, n do
    if (fnKeep(t, i, j)) then
      -- Move i's kept value to j's position, if it's not already there.
      if (i ~= j) then
        t[j] = t[i];
        t[i] = nil;
      end
      j = j + 1; -- Increment position of where we'll place the next kept value.
    else
      t[i] = nil;
    end
  end

  return t;
end

---removes enemies of the current dungeon without any clones
function MDT:CleanEnemyData(dungeonIdx)
  local enemies = MDT.dungeonEnemies[dungeonIdx]
  ArrayRemove(enemies, function(t, i, j)
    local countClones = 0
    for _, _ in pairs(t[i].clones) do
      countClones = countClones + 1
    end
    return countClones > 0
  end)
end
