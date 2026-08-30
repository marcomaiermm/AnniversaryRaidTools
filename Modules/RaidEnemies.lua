local _, ART = ...
-- SPDX-FileCopyrightText: 2018-2026 Nnoggie and Mythic Dungeon Tools contributors
-- SPDX-FileCopyrightText: 2026 pyresin and Anniversary Raid Tools contributors
-- SPDX-License-Identifier: GPL-2.0-only
-- Modified for Anniversary Raid Tools beginning 2026-08-21.

local db
local tonumber, tinsert, pairs, ipairs, tostring, twipe, max, min, abs, sqrt, tremove, floor, DrawLine = tonumber,
    table.insert, pairs, ipairs, tostring, table.wipe, math.max, math.min, math.abs, math.sqrt, table.remove, math.floor,
    DrawLine
local L = ART.L
local blips = {}
local blipsByEnemy = {}
local blipsBySpawnKey = {}
local blipsByGroup = {}
local blipsByPullGroup = {}
local blipIndexGeneration = 0
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

local function appendIndex(index, key, blip)
  if key == nil then return end
  index[key] = index[key] or {}
  tinsert(index[key], blip)
end

local function clearBlipIndexes()
  twipe(blips)
  twipe(blipsByEnemy)
  twipe(blipsBySpawnKey)
  twipe(blipsByGroup)
  twipe(blipsByPullGroup)
  blipIndexGeneration = blipIndexGeneration + 1
end

local function indexBlip(blip)
  if blip.artIndexGeneration == blipIndexGeneration then return end
  blip.artIndexGeneration = blipIndexGeneration
  tinsert(blips, blip)
  blipsByEnemy[blip.enemyIdx] = blipsByEnemy[blip.enemyIdx] or {}
  blipsByEnemy[blip.enemyIdx][blip.cloneIdx] = blip
  if blip.clone.artSpawnKey then blipsBySpawnKey[blip.clone.artSpawnKey] = blip end
  appendIndex(blipsByGroup, blip.clone.g, blip)
  if blip.clone.artPullGroup then
    appendIndex(blipsByPullGroup, blip.clone.artPullGroup..":"..tostring(blip.clone.sublevel), blip)
  end
end

local function getLinkedBlips(blip)
  local linked, seen = {}, {}
  local function append(candidates)
    for _, candidate in ipairs(candidates or {}) do
      if not seen[candidate] then
        seen[candidate] = true
        tinsert(linked, candidate)
      end
    end
  end
  if db and db.devMode then
    for _, candidate in ipairs(blips) do
      local sameGroup = blip.clone.g and candidate.clone.g == blip.clone.g
      local samePullGroup = blip.clone.artPullGroup == candidate.clone.artPullGroup
          and blip.clone.artPullGroup ~= nil and blip.clone.sublevel == candidate.clone.sublevel
      if (sameGroup or samePullGroup) and not seen[candidate] then
        seen[candidate] = true
        tinsert(linked, candidate)
      end
    end
    return linked
  end
  append(blipsByGroup[blip.clone.g])
  if blip.clone.artPullGroup then
    append(blipsByPullGroup[blip.clone.artPullGroup..":"..tostring(blip.clone.sublevel)])
  end
  return linked
end

local function notifyLiveMarkPlanChanged()
  if ART.LiveMarks and ART.LiveMarks.OnPlanChanged then ART.LiveMarks:OnPlanChanged() end
end

local function findLegacyBlip(enemyIdx, cloneIdx)
  local blip = blipsByEnemy[enemyIdx] and blipsByEnemy[enemyIdx][cloneIdx]
  if blip then return blip end
  for _, candidate in ipairs(blips) do
    if candidate.enemyIdx == enemyIdx and candidate.cloneIdx == cloneIdx then return candidate end
  end
end

function ART:GetRaidEnemyBlips()
  return blips
end

function ART:SetLegacyBlipMark(enemyIdx, cloneIdx, marker)
  local preset = self:GetCurrentPreset()
  local assignments = preset.value.enemyAssignments or {}
  preset.value.enemyAssignments = assignments
  local pulls, pullIndex = preset.value.pulls or {}
  for candidateIndex, candidate in pairs(pulls) do
    local cloneIndexes = candidate[enemyIdx]
    if type(cloneIndexes) == "table" then
      for _, candidateCloneIdx in pairs(cloneIndexes) do
        if candidateCloneIdx == cloneIdx then pullIndex = candidateIndex break end
      end
    end
    if pullIndex then break end
  end
  local pull = pullIndex and pulls[pullIndex]
  if marker and pull then
    for otherEnemyIdx, cloneIndexes in pairs(pull) do
      for _, otherCloneIdx in ipairs(type(cloneIndexes) == "table" and cloneIndexes or {}) do
        if assignments[otherEnemyIdx] and assignments[otherEnemyIdx][otherCloneIdx] == marker then
          assignments[otherEnemyIdx][otherCloneIdx] = nil
          local blip = findLegacyBlip(otherEnemyIdx, otherCloneIdx)
          if blip then
            blip.assignment = nil
            blip.texture_OverlayIcon:Hide()
          end
        end
      end
    end
  end
  assignments[enemyIdx] = assignments[enemyIdx] or {}
  assignments[enemyIdx][cloneIdx] = marker
  if not marker and self.CCAssignments then
    local blip = findLegacyBlip(enemyIdx, cloneIdx)
    local spawnKey = blip and blip.clone and blip.clone.artSpawnKey
    if spawnKey and pullIndex then self.CCAssignments:ClearPullAssignment(preset, pullIndex, spawnKey, true) end
  end
  notifyLiveMarkPlanChanged()
end

function ART:HideDisplacedSpawnMarks(spawnKeys)
  for _, spawnKey in ipairs(spawnKeys or {}) do
    local blip = blipsBySpawnKey[spawnKey]
    if blip then
      blip.assignment = nil
      blip.texture_OverlayIcon:Hide()
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
      item.blip:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", x, y)
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

function ART:AnimateBlipScale(blip, target)
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

function ART:ResetBlipHoverScales()
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
          and candidate:IsShown() and candidate:IsEnabled() and ART:DoFramesOverlap(current, candidate) then
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
  local scale = ART:GetScale()
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
  local scale = ART:GetScale()
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

function ART:SetManualExplosionHover(blip)
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

function ART:DoFramesOverlap(frameA, frameB, offset)
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

ARTRaidEnemyMixin = {};

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
  ["texture_CCIcon"] = 9,
  ["mask_CCIconMask"] = 9,
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

function ARTRaidEnemyMixin:updateSizes(scale)
  for tex, size in pairs(defaultSizes) do
    self[tex]:SetSize(size * self.normalScale * scale, size * self.normalScale * scale)
  end
end

function ART:DisplayBlipModifierLabels(modifier)
  for _, blip in pairs(blips) do
    blip.textLocked = true
    local text = (modifier == "alt" and blip.clone.g and "G"..blip.clone.g) or ""
    blip.fontstring_Text1:SetText(text)
    blip.fontstring_Text1:Show()
  end
end

function ART:HideAllBlipLabels(force)
  for _, blip in pairs(blips) do
    if force or blip.textLocked then
      blip.fontstring_Text1:Hide()
      blip.textLocked = nil
    end
  end
end

function ART:SetUpModifiers(frame)
  if ART:GetDB().devMode then return end
  local ONUPDATE_INTERVAL = 0.1
  local timeSinceLastUpdate = 0
  frame:SetScript("OnUpdate", function(self, elapsed)
    timeSinceLastUpdate = timeSinceLastUpdate + elapsed
    if timeSinceLastUpdate >= ONUPDATE_INTERVAL then
      timeSinceLastUpdate = 0
      local modifier = IsAltKeyDown() and "alt"
      local overART = frame:IsMouseOver() or frame.sidePanel:IsMouseOver() or frame.topPanel:IsMouseOver() or frame.bottomPanel:IsMouseOver()
      if modifier and overART then
        ART:DisplayBlipModifierLabels(modifier)
        ART.main_frame.statusString:SetText(L["altKeyDownStatusText"])
        ART.main_frame.statusString:Show()
      else
        ART:HideAllBlipLabels()
        ART.main_frame.statusString:Hide()
      end
    end
  end)
end

function ARTRaidEnemyMixin:OnEnter()
  if ART.QuickMark then ART.QuickMark:Arm(self) end
  ART:SetManualExplosionHover(self)
  if not self.isBoss then
    ART:AnimateBlipScale(self, HOVER_SCALE)
  end
  self.preHoverFrameLevel = self:GetFrameLevel()
  self:SetFrameLevel(self.preHoverFrameLevel + 5)
  self:DisplayPatrol(true)
  ART:DisplayBlipTooltip(self, true)
end

function ARTRaidEnemyMixin:OnLeave()
  if ART.QuickMark then ART.QuickMark:Disarm(self) end
  if manualExplosionHovered == self then ART:SetManualExplosionHover(nil) end
  if not self.isBoss then
    ART:AnimateBlipScale(self, 1)
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
  ART:DisplayBlipTooltip(self, false)
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
  preview:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", cursorX + preview.offsetX, cursorY + preview.offsetY)
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
  local candidates = db and db.devMode and blips or blipsByGroup[blip.clone.g] or {}
  for _, otherBlip in ipairs(candidates) do
    if otherBlip ~= blip and otherBlip.clone.g == blip.clone.g and otherBlip:IsShown() and otherBlip:IsEnabled() then
      tinsert(draggedBlips, otherBlip)
    end
  end
  return draggedBlips
end

local function showDragPreviews(blip, ignoreGrouped)
  ART.raidEnemyDragPreview_framePool:ReleaseAll()
  local cursorX, cursorY = ART:GetCursorPosition()
  for _, draggedBlip in pairs(getDraggedBlips(blip, ignoreGrouped)) do
    setupDragPreview(ART.raidEnemyDragPreview_framePool:Acquire(), draggedBlip, cursorX, cursorY)
  end
end

local function updateDragPreviews(cursorX, cursorY)
  for _, preview in pairs(ART.raidEnemyDragPreview_framePool.active) do
    updateDragPreviewPosition(preview, cursorX, cursorY)
  end
end

local DRAG_TARGET_UPDATE_INTERVAL = 0.1

local function setUpMouseHandlers(self)
  local tempPulls
  local targetPull
  local pullCenters
  local dragPreviewIgnoreGrouped
  local dragPreviewHullState
  self:SetScript("OnDragStart", function()
    local x, y, scale
    local dragTargetUpdateElapsed = DRAG_TARGET_UPDATE_INTERVAL
    preset = ART:GetCurrentPreset()
    pullCenters = ART:GetPullCenters(preset.value.pulls)
    tempPulls = CopyTable(preset.value.pulls)
    targetPull = nil
    dragPreviewHullState = nil
    dragPreviewIgnoreGrouped = IsControlKeyDown()
    showDragPreviews(self, dragPreviewIgnoreGrouped)
    local _, _, _, blipX, blipY = self:GetPoint()
    self:SetScript("OnUpdate", function(_, elapsed)
      local nx, ny = ART:GetCursorPosition()
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
        local pullIdx, centerX, centerY = ART:FindClosestPull(x, y, pullCenters)
        if not centerX then
          targetPull = nil
          return
        end
        local distBlip = (centerX - blipX) ^ 2 + (centerY - blipY) ^ 2
        local distCursor = (centerX - x) ^ 2 + (centerY - y) ^ 2
        local isClose = distCursor < 1 / 3 * distBlip or distBlip < 150
        if not isClose then
          ART:RaidEnemies_AddOrRemoveBlipToCurrentPull(self, false, ignoreGrouped, tempPulls, nil, true)
          ART:RaidEnemies_UpdateSelected(ART:GetCurrentPull(), tempPulls)
          targetPull = nil
          if dragPreviewHullState ~= false then
            dragPreviewHullState = false
            ART:DrawAllHulls(CopyTable(tempPulls), true)
          end
        elseif pullIdx ~= targetPull or dragPreviewHullState ~= pullIdx then
          targetPull = pullIdx
          ART:RaidEnemies_AddOrRemoveBlipToCurrentPull(self, true, ignoreGrouped, tempPulls, pullIdx, true)
          ART:RaidEnemies_UpdateSelected(ART:GetCurrentPull(), tempPulls)
          dragPreviewHullState = pullIdx
          ART:DrawAllHulls(CopyTable(tempPulls), true)
        end
      end
    end)
  end)
  self:SetScript("OnDragStop", function()
    self:SetScript("OnUpdate", nil)
    ART.raidEnemyDragPreview_framePool:ReleaseAll()
    ART:CancelAsync("DrawAllHulls")
    preset.value.pulls = tempPulls
    ART:RaidEnemies_UpdateSelected(ART:GetCurrentPull(), tempPulls)
    ART:SetSelectionToPull(targetPull)
    ART:ReloadPullButtons(true)
    if ART.liveSessionActive and ART:GetCurrentPreset().uid == ART.livePresetUID then
      ART:LiveSession_SendPulls(ART:GetPulls())
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
  ART:GetCurrentPreset().value.enemyAssignments = ART:GetCurrentPreset().value.enemyAssignments or {}
  local assignments = ART:GetCurrentPreset().value.enemyAssignments
  local planner = ART.RaidPlanner
  -- Route-step marks only apply to ART spawns with a stable pack/spawn key.
  local useRouteMarks = planner and planner.initialized
      and frame.clone.artPackKey ~= nil and frame.clone.artSpawnKey ~= nil
      and #planner:FindStepsForPack(frame.clone.artPackKey) > 0
  ART:CreateContextMenu(ART.main_frame, function(ownerRegion, rootDescription)
    rootDescription:CreateTitle(L[frame.data.name])
    local ccSetMarker, clearMarker, markerMenu

    if useRouteMarks then
      local packKey, spawnKey = frame.clone.artPackKey, frame.clone.artSpawnKey
      local function IsSelected(data)
        local mark = planner:GetSpawnMark(packKey, spawnKey)
        return (data.index == 0 and not mark) or mark == data.index
      end
      local function SetSelected(data)
        local _, displaced = planner:SetSpawnMark(packKey, spawnKey, data.index ~= 0 and data.index or nil)
        ART:HideDisplacedSpawnMarks(displaced)
        frame:SetUp(frame.data, frame.clone)
      end
      ccSetMarker = function(marker)
        local applied, displaced = planner:SetSpawnMark(packKey, spawnKey, marker)
        ART:HideDisplacedSpawnMarks(displaced)
        frame:SetUp(frame.data, frame.clone)
        return applied ~= nil
      end
      markerMenu = rootDescription:CreateButton(L["Set Target Marker"], function() end);
      for i = 1, 8 do
        local iconPath = ICON_LIST[i].."16:16:|t"
        local color = CreateColor(unpack(iconColors[i]))
        local iconName = WrapTextInColor(_G["RAID_TARGET_"..i], color)
        markerMenu:CreateRadio(iconPath.." "..iconName, IsSelected, SetSelected, { index = i })
      end
      clearMarker = function()
        planner:SetSpawnMark(packKey, spawnKey, nil)
        frame:SetUp(frame.data, frame.clone)
      end
    else
      local function IsSelected(data)
        local assignment = assignments[data.enemyIdx] and assignments[data.enemyIdx][data.cloneIdx]
        return assignment and assignment == data.index or false
      end
      local function SetSelected(data)
        ART:SetLegacyBlipMark(data.enemyIdx, data.cloneIdx, data.index ~= 0 and data.index or nil)
        frame:SetUp(frame.data, frame.clone)
        if not db.hasSeenAssignmentWarning then
          ART:OpenConfirmationFrame(450, 150, L["Warning"], L["Okay"], L["assignmentWarning"])
          db.hasSeenAssignmentWarning = true
        end
      end
      ccSetMarker = function(marker)
        ART:SetLegacyBlipMark(frame.enemyIdx, frame.cloneIdx, marker)
        frame:SetUp(frame.data, frame.clone)
        return true
      end
      markerMenu = rootDescription:CreateButton(L["Set Target Marker"], function() end);
      for i = 1, 8 do
        local iconPath = ICON_LIST[i].."16:16:|t"
        local color = CreateColor(unpack(iconColors[i]))
        local iconName = WrapTextInColor(_G["RAID_TARGET_"..i], color)
        markerMenu:CreateRadio(iconPath.." "..iconName, IsSelected, SetSelected,
            { enemyIdx = frame.enemyIdx, cloneIdx = frame.cloneIdx, index = i })
      end
      clearMarker = function()
        ART:SetLegacyBlipMark(frame.enemyIdx, frame.cloneIdx, nil)
        frame:SetUp(frame.data, frame.clone)
      end
    end
    markerMenu:CreateButton(L["Clear Mark"], clearMarker)
    if useRouteMarks then
      rootDescription:CreateButton(L["Clear all Markers"], function()
        planner:ClearAllSpawnMarks()
        ART:Async(function()
          ART:RaidEnemies_UpdateEnemiesAsync()
        end, "ClearAllMarkers")
      end)
    else
      rootDescription:CreateButton(L["Clear all Markers"], function()
        twipe(assignments)
        notifyLiveMarkPlanChanged()
        ART:Async(function()
          ART:RaidEnemies_UpdateEnemiesAsync()
        end, "ClearAllMarkers")
      end)
    end
    if ART.CCAssignments then ART.CCAssignments:AddNpcMenu(rootDescription, frame, ccSetMarker) end
    rootDescription:CreateButton(L["Open Enemy Info"], function()
      ART:ShowEnemyInfoFrame(frame)
    end)
  end)
end

function ARTRaidEnemyMixin:OnClick(button, down)
  --always deselect toolbar tool
  ART:UpdateSelectedToolbarTool()
  if button == "LeftButton" then
    ART:RaidEnemies_AddOrRemoveBlipToCurrentPull(self, not self.selected, IsControlKeyDown())
    ART:RaidEnemies_UpdateSelected(ART:GetCurrentPull())
    ART:ReloadPullButtons()
    if ART.liveSessionActive and ART:GetCurrentPreset().uid == ART.livePresetUID then
      ART:LiveSession_SendPulls(ART:GetPulls())
    end
  elseif button == "RightButton" then
    if db.devMode then
      if IsAltKeyDown() then
        ART.raidEnemies[db.currentRaidIndex][self.enemyIdx].clones[self.cloneIdx] = nil
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
      ART:UpdateMap()
    else
      createEnemyContextMenu(self)
    end
  end
end

local patrolPoints = {}
local patrolLines = {}

function ART:GetPatrolBlips()
  return patrolPoints
end

function ARTRaidEnemyMixin:DisplayPatrol(shown)
  local scale = ART:GetScale()

  --Hide all points/line
  for _, point in pairs(patrolPoints) do point:Hide() end
  for _, line in pairs(patrolLines) do line:Hide() end
  if not shown then return end

  if self.clone.patrol then
    local firstWaypointBlip
    local oldWaypointBlip
    for patrolIdx, waypoint in ipairs(self.clone.patrol) do
      patrolPoints[patrolIdx] = patrolPoints[patrolIdx] or
          ART.main_frame.mapPanelFrame:CreateTexture("ARTRaidPatrolPoint"..patrolIdx, "BACKGROUND", nil, 0)


      patrolPoints[patrolIdx]:SetDrawLayer("OVERLAY", 2)
      patrolPoints[patrolIdx]:SetTexture("Interface\\Worldmap\\X_Mark_64Grey")
      patrolPoints[patrolIdx]:SetSize(4 * scale, 4 * scale)
      patrolPoints[patrolIdx]:SetVertexColor(0, 0.2, 0.5, 0.6)
      patrolPoints[patrolIdx]:ClearAllPoints()
      patrolPoints[patrolIdx]:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", waypoint.x * scale,
        waypoint.y * scale)
      patrolPoints[patrolIdx].x = waypoint.x
      patrolPoints[patrolIdx].y = waypoint.y
      patrolPoints[patrolIdx]:Show()

      patrolLines[patrolIdx] = patrolLines[patrolIdx] or
          ART.main_frame.mapPanelFrame:CreateTexture("ARTRaidPatrolLine"..patrolIdx, "BACKGROUND", nil, 0)
      patrolLines[patrolIdx]:SetDrawLayer("OVERLAY", 1)
      patrolLines[patrolIdx]:SetTexture(ART.AddonPath.."Textures\\Square_White")
      patrolLines[patrolIdx]:SetVertexColor(0, 0.2, 0.5, 0.6)
      patrolLines[patrolIdx]:Show()

      --connect 2 waypoints
      if oldWaypointBlip then
        local _, _, _, startX, startY = patrolPoints[patrolIdx]:GetPoint()
        local _, _, _, endX, endY = oldWaypointBlip:GetPoint()
        DrawLine(patrolLines[patrolIdx], ART.main_frame.mapPanelTile1, startX, startY, endX, endY, 1 * scale, 1,
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
      DrawLine(patrolLines[1], ART.main_frame.mapPanelTile1, startX, startY, endX, endY, 1 * scale, 1, "TOPLEFT")
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
function ART:DisplayBlipTooltip(blip, shown)
  if not ranOnce then
    ART.tooltip:ClearAllPoints()
    ART.tooltip:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT")
    ART.tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT")
    ART.tooltip:Show()
    ART.tooltip:Hide()
    ranOnce = true
  end

  local tooltip = ART.tooltip
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

  if not L[data.name] then print("ART: Could not find localization for "..data.name) end
  local text = L[data.name]..
      " "..
      occurence..
      group..
      "\n"..
      string.format(L["Level %d %s"], data.level, L[data.creatureType]).." "..data.id..
      "\n"..string.format(L["%s HP"], ART:FormatEnemyHealth(health)).."\n"

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
  local mainFrameBottom = ART.main_frame:GetBottom()
  if tooltipBottom < mainFrameBottom then
    bottomOffset = tooltip.mySizes.y
  end
  local tooltipRight = tooltip:GetRight()
  local mainFrameRight = ART.main_frame:GetRight()
  if tooltipRight > mainFrameRight then
    rightOffset = -(tooltip.mySizes.x + 60)
  end

  tooltip:SetPoint("TOPLEFT", blip, "BOTTOMRIGHT", 30 + rightOffset, bottomOffset)
  tooltip:SetPoint("BOTTOMRIGHT", blip, "BOTTOMRIGHT", 30 + tooltip.mySizes.x + rightOffset,
    -tooltip.mySizes.y + bottomOffset)
end

function ART:GetCurrentDevmodeBlip()
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
    local x, y = ART:GetCursorPosition()
    local scale = ART:GetScale()
    x = x * (1 / scale)
    y = y * (1 / scale)
    local nx = ART.raidEnemies[db.currentRaidIndex][blip.enemyIdx].clones[blip.cloneIdx].x
    local ny = ART.raidEnemies[db.currentRaidIndex][blip.enemyIdx].clones[blip.cloneIdx].y
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
    local x, y = ART:GetCursorPosition()
    local scale = ART:GetScale()
    x = x * (1 / scale)
    y = y * (1 / scale)
    x = x - xOffset
    y = y - yOffset
    local deltaX = x - ART.raidEnemies[db.currentRaidIndex][blip.enemyIdx].clones[blip.cloneIdx].x
    local deltaY = y - ART.raidEnemies[db.currentRaidIndex][blip.enemyIdx].clones[blip.cloneIdx].y
    if moveGroup then
      for enemyIdx, data in pairs(ART.raidEnemies[db.currentRaidIndex]) do
        for cloneIdx, clone in pairs(data.clones) do
          if clone.g == blip.clone.g then
            clone.x = clone.x + deltaX
            clone.y = clone.y + deltaY
            --move blip
            local cloneBlip = ART:GetBlip(enemyIdx, cloneIdx)
            if cloneBlip then
              cloneBlip:ClearAllPoints()
              cloneBlip:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", clone.x * scale, clone.y * scale)
            end
          end
        end
      end
    end

    if movePatrol and blip.clone.patrol then
      for patrolIdx, waypoint in pairs(blip.clone.patrol) do
        waypoint.x = waypoint.x + deltaX
        waypoint.y = waypoint.y + deltaY
        ART.raidEnemies[db.currentRaidIndex][blip.enemyIdx].clones[blip.cloneIdx].patrol[patrolIdx].x = waypoint.x
        ART.raidEnemies[db.currentRaidIndex][blip.enemyIdx].clones[blip.cloneIdx].patrol[patrolIdx].y = waypoint.y
      end
      blip:DisplayPatrol(true)
      movePatrol = nil
    end

    blip:StopMovingOrSizing()
    blip:ClearAllPoints()
    blip:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", x * scale, y * scale)
    ART.raidEnemies[db.currentRaidIndex][blip.enemyIdx].clones[blip.cloneIdx].x = x
    ART.raidEnemies[db.currentRaidIndex][blip.enemyIdx].clones[blip.cloneIdx].y = y
    moveGroup = nil
  end)
  blip:SetScript("OnMouseWheel", function(self, delta)
    if not db.devModeBlipsScrollable then return end
    -- alt scroll to scale blip and connected blips
    if IsAltKeyDown() then
      if IsShiftKeyDown() then
        -- scale whole sublevel
        for _, data in pairs(ART.raidEnemies[db.currentRaidIndex]) do
          for _, clone in pairs(data.clones) do
            if clone.sublevel == ART:GetCurrentSubLevel() then
              clone.scale = (clone.scale or 1) + delta * 0.1
            end
          end
        end
      elseif IsControlKeyDown() then
        -- only scale this specific blip
        local clone = ART.raidEnemies[db.currentRaidIndex][self.enemyIdx].clones[self.cloneIdx]
        clone.scale = (clone.scale or 1) + delta * 0.1
      else
        -- only scale this blip and it's connected blips
        if blip.clone.g then
          for _, data in pairs(ART.raidEnemies[db.currentRaidIndex]) do
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
      ART:UpdateMap()
    else
      if not blip.clone.g then
        local maxGroup = 0
        for _, data in pairs(ART.raidEnemies[db.currentRaidIndex]) do
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
          for enemyIdx, data in pairs(ART.raidEnemies[db.currentRaidIndex]) do
            for cloneIdx, clone in pairs(data.clones) do
              if clone.g == blipGroup then
                clone.g = blipGroup + delta
                local cloneBlip = ART:GetBlip(enemyIdx, cloneIdx)
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

function ARTRaidEnemyMixin:SetUp(data, clone, overlapCandidates, currentPreset, trashMinHealth, trashMaxHealth)
  local scale = ART:GetScale()
  local explosionItem = manualExplosion and manualExplosion.members[self]
  local _, _, _, explosionX, explosionY = self:GetPoint()
  self:ClearAllPoints()
  self:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", clone.x * scale, clone.y * scale)
  if explosionItem and explosionX and explosionY then
    self:ClearAllPoints()
    self:SetPoint("CENTER", ART.main_frame.mapPanelTile1, "TOPLEFT", explosionX, explosionY)
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
      (ART.scaleMultiplier[db.currentRaidIndex] or 1) * scale * 0.6
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
        ART:DoFramesOverlap(self, v, 5) then
      raise = max(raise
      , v:GetFrameLevel() + 1)
    end
  end
  self:SetFrameLevel(raise)
  self.fontstring_Text1:SetText("")
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
  indexBlip(self)
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
  local planner = ART.RaidPlanner
  local useRouteMarks = planner and planner.initialized and self.clone.artPackKey ~= nil
      and #planner:FindStepsForPack(self.clone.artPackKey) > 0
  local assignment
  if useRouteMarks then
    assignment = planner:GetSpawnMark(self.clone.artPackKey, self.clone.artSpawnKey)
  else
    local assignments = (currentPreset or ART:GetCurrentPreset()).value.enemyAssignments
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
  if ART.CCAssignments then ART.CCAssignments:UpdateBlipBadge(self) end
  if db.devMode then
    blipDevModeSetup(self)
    self.devModeSetup = true
  else
    resetBlipDevModeSetup(self)
  end
end

---RaidEnemies_HideAllBlips
---Used to hide blips during scaling changes to the map
function ART:RaidEnemies_HideAllBlips()
  collapseManualExplosion(true)
  ART:ResetBlipHoverScales()
  ART.raidEnemyDragPreview_framePool:ReleaseAll()
  ART.raidEnemies_framePool:ReleaseAll()
  clearBlipIndexes()
end

function ART:RaidEnemies_UpdateEnemiesAsync()
  if not ART.raidEnemies_framePool or not ART.raidEnemyDragPreview_framePool then return end
  collapseManualExplosion(true)
  ART:ResetBlipHoverScales()
  ART.raidEnemyDragPreview_framePool:ReleaseAll()
  ART.raidEnemies_framePool:ReleaseAll()
  coroutine.yield()
  clearBlipIndexes()
  if not db then db = ART:GetDB() end
  local enemies = ART.raidEnemies[db.currentRaidIndex]
  if not enemies then return end
  preset = ART:GetCurrentPreset()

  local currentSublevel = ART:GetCurrentSubLevel()
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
        local blip = ART.raidEnemies_framePool:Acquire()
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

function ART:RaidEnemies_UpdateCCBadges()
  for _, frame in ipairs(ART.raidEnemies_framePool and ART.raidEnemies_framePool.active or {}) do
    ART.CCAssignments:UpdateBlipBadge(frame)
  end
end

function ART:RaidEnemies_CreateFramePools()
  db = self:GetDB()
  ART.raidEnemies_framePool = ART.CreateFramePool("Button", ART.main_frame.mapPanelFrame, "ARTRaidEnemyTemplate")
  ART.raidEnemyDragPreview_framePool = ART.CreateFramePool("Frame", ART.main_frame.mapPanelFrame,
    "ARTRaidEnemyDragPreviewTemplate")
end

function ART:GetBlip(enemyIdx, cloneIdx)
  return blipsByEnemy[enemyIdx] and blipsByEnemy[enemyIdx][cloneIdx]
end

local function isCloneConstrained(clone)
  if not clone.constrained then return false end
  local amount = 0
  local data = ART.raidEnemies[db.currentRaidIndex]
  for enemyIdx, enemy in pairs(data) do
    for cloneIdx, c in pairs(enemy.clones) do
      if c.constrained and c.constrained.index == clone.constrained.index and ART:IsCloneInPulls(enemyIdx, cloneIdx) then
        amount = amount + 1
      end
    end
  end
  if amount >= clone.constrained.amount then
    print(L["ART: Cannot add enemy - you are trying to add too many enemies of the same kind"])
    return true
  end
  return false
end

---RaidEnemies_AddOrRemoveBlipToCurrentPull
---Adds or removes an enemy clone and all it's linked npcs to the currently selected pull
function ART:RaidEnemies_AddOrRemoveBlipToCurrentPull(blip, add, ignoreGrouped, pulls, pull, ignoreUpdates)
  local preset = self:GetCurrentPreset()
  local storedPulls = pulls == nil
  local enemyIdx = blip.enemyIdx
  local cloneIdx = blip.cloneIdx
  local spawnKey = blip.clone and blip.clone.artSpawnKey
  pull = pull or self:GetCurrentPull()
  if not pull then return false end
  pulls = pulls or preset.value.pulls or {}
  pulls[pull] = pulls[pull] or {}
  pulls[pull][enemyIdx] = pulls[pull][enemyIdx] or {}
  --remove clone from all other pulls first
  for pullIdx, p in pairs(pulls) do
    if pullIdx ~= pull and p[enemyIdx] then
      for k, v in pairs(p[enemyIdx]) do
        if v == cloneIdx then
          tremove(pulls[pullIdx][enemyIdx], k)
          local assignments = p.artCCAssignments
          if spawnKey and assignments then
            assignments[spawnKey] = nil
            if not next(assignments) then p.artCCAssignments = nil end
          end
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
    local assignments = pulls[pull].artCCAssignments
    if spawnKey and assignments then
      assignments[spawnKey] = nil
      if not next(assignments) then pulls[pull].artCCAssignments = nil end
    end
  end
  --linked npcs
  if not ignoreGrouped then
    for _, otherBlip in ipairs(getLinkedBlips(blip)) do
      if blip ~= otherBlip then
        self:RaidEnemies_AddOrRemoveBlipToCurrentPull(otherBlip, add, true, pulls, pull, ignoreUpdates)
      end
    end
  end
  if storedPulls and not ignoreUpdates then notifyLiveMarkPlanChanged() end
  -- if not ignoreUpdates then self:UpdatePullButtonNPCData(pull) end
end

---RaidEnemies_UpdateBlipColors
---Updates the colors of all selected blips of the specified pull
function ART:RaidEnemies_UpdateBlipColors(pull, r, g, b, pulls)
  pulls = pulls or preset.value.pulls
  local p = pulls[pull]
  if not p then return end
  for enemyIdx, clones in pairs(p) do
    if tonumber(enemyIdx) then
      for _, cloneIdx in pairs(clones) do
        local blip = ART:GetBlip(enemyIdx, cloneIdx)
        if blip and not db.devMode then
          blip.texture_Portrait:SetVertexColor(r, g, b, 1)
          blip.texture_SelectedHighlight:SetVertexColor(r, g, b, 0.7)
        end
      end
    end
  end
end

---Updates the selected Enemies on the map and marks them according to their pull color
function ART:RaidEnemies_UpdateSelected(pull, pulls, ignoreHulls)
  preset = ART:GetCurrentPreset()
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
    local r, g, b = ART:RaidEnemies_GetPullColor(pullIdx)
    for enemyIdx, clones in pairs(p) do
      if tonumber(enemyIdx) then
        for _, cloneIdx in pairs(clones) do
          local blip = ART:GetBlip(enemyIdx, cloneIdx)
          if blip then
            blip.texture_SelectedHighlight:Show()
            blip.selected = true
            if not db.devMode then
              blip.texture_Portrait:SetVertexColor(r, g, b, 1)
              blip.texture_SelectedHighlight:SetVertexColor(r, g, b, 0.7)
            end
            if pullIdx == pull then blip.texture_PullIndicator:Show() end
          end
        end
      end
    end
  end
  -- if not ignoreHulls then ART:DrawAllHulls(pulls) end
end

---RaidEnemies_SetPullColor
---Sets a custom color for a pull
function ART:RaidEnemies_SetPullColor(pull, r, g, b)
  preset = ART:GetCurrentPreset()
  if not preset.value.pulls[pull] then return end
  preset.value.pulls[pull]["color"] = ART:RGBToHex(r, g, b)
end

---RaidEnemies_GetPullColor
---Returns the custom color for a pull
function ART:RaidEnemies_GetPullColor(pull, pulls)
  pulls = pulls or preset.value.pulls
  local r, g, b = ART:HexToRGB(pulls[pull]["color"])
  if not r then
    r, g, b = ART:HexToRGB("228b22")
    ART:RaidEnemies_SetPullColor(pull, r, g, b)
  end
  return r, g, b
end

function ART:IsCloneInPulls(enemyIdx, cloneIdx)
  local pulls = ART:GetCurrentPreset().value.pulls
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

---removes enemies of the current raid without any clones
function ART:CleanEnemyData(raidIndex)
  local enemies = ART.raidEnemies[raidIndex]
  ArrayRemove(enemies, function(t, i, j)
    local countClones = 0
    for _, _ in pairs(t[i].clones) do
      countClones = countClones + 1
    end
    return countClones > 0
  end)
end
