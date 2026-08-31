local root = arg and arg[1] or "."

local function frame()
  local value = { shown = true, scripts = {}, rawChildren = {} }
  function value:SetSize(width, height) self.width, self.height = width, height end
  function value:SetHeight(height) self.height = height end
  function value:SetPoint(...) self.point = { ... } end
  function value:ClearAllPoints() self.point = nil end
  function value:SetAllPoints() end
  function value:SetParent(parent) self.parent = parent end
  function value:SetText(text) self.text = text end
  function value:SetScript(event, callback) self.scripts[event] = callback end
  function value:SetShown(shown) self.shown = shown end
  function value:Show() self.shown = true end
  function value:Hide() self.shown = false end
  function value:Enable() self.enabled = true end
  function value:Disable() self.enabled = false end
  function value:EnableMouse(enabled) self.mouseEnabled = enabled end
  function value:SetFrameStrata(strata) self.strata = strata end
  function value:GetEffectiveScale() return 1 end
  function value:RegisterForDrag() self.draggable = true end
  function value:SetAlpha(alpha) self.alpha = alpha end
  function value:IsMouseOver() return self.mouseOver == true end
  function value:CreateTexture()
    local texture = { shown = true }
    for _, method in ipairs({ "SetTexCoord", "SetSize", "SetHeight", "SetPoint", "ClearAllPoints", "SetAllPoints" }) do
      texture[method] = function() end
    end
    function texture:SetTexture(value) self.texture = value end
    function texture:SetColorTexture(...) self.color = { ... } end
    function texture:Show() self.shown = true end
    function texture:Hide() self.shown = false end
    return texture
  end
  function value:CreateFontString()
    local font = {}
    function font:SetPoint() end
    function font:SetText(text) self.text = text end
    function font:SetJustifyH() end
    return font
  end
  return value
end

local widgetMethods, iconPool = {}, {}
for _, name in ipairs({ "SetLayout", "SetFullWidth", "SetWidth", "SetHeight", "SetLabel", "SetColor" }) do
  widgetMethods[name] = function() end
end
function widgetMethods:SetWidth(width) self.width = width end
function widgetMethods:SetHeight(height) self.height = height end
function widgetMethods:SetText(text) self.text = text end
function widgetMethods:SetValue(value) self.value = value end
function widgetMethods:SetList(values, order) self.values, self.order = values, order end
function widgetMethods:SetImage(image) self.imagePath = image end
function widgetMethods:SetImageSize(width, height) self.imageWidth, self.imageHeight = width, height end
function widgetMethods:SetPoint(...) self.frame:SetPoint(...) end
function widgetMethods:AddChild(child)
  self.children[#self.children + 1] = child
  if self.kind == "ScrollFrame" and self.status then self.status.scrollvalue = 0 end
end
local function releaseWidget(widget)
  for _, child in ipairs(widget.children or {}) do releaseWidget(child) end
  if widget.kind == "Icon" then iconPool[#iconPool + 1] = widget end
end
function widgetMethods:ReleaseChildren()
  for _, child in ipairs(self.children) do releaseWidget(child) end
  self.children = {}
end
function widgetMethods:SetCallback(event, callback) self.callbacks[event] = callback end
function widgetMethods:SetStatusTable(status) self.status = status end
function widgetMethods:DoLayout() end
function widgetMethods:SetScroll(value)
  self.appliedScroll = value
  if self.status then self.status.scrollvalue = value end
end

local AceGUI = {}
function AceGUI:Create(kind)
  local widget = kind == "Icon" and table.remove(iconPool) or nil
  if widget then
    widget.children, widget.callbacks = {}, {}
    return widget
  end
  widget = { kind = kind, frame = frame(), children = {}, callbacks = {} }
  if kind == "Icon" then
    widget.image = {
      SetAlpha = function(image, alpha) image.alpha = alpha end,
      ClearAllPoints = function() end,
      SetPoint = function() end,
    }
  end
  return setmetatable(widget, { __index = widgetMethods })
end

local timers = {}
_G.C_Timer = { After = function(_, callback) timers[#timers + 1] = callback end }
local function runTimers()
  local pending = timers
  timers = {}
  for _, callback in ipairs(pending) do callback() end
end
_G.LibStub = function(name) assert(name == "AceGUI-3.0"); return AceGUI end
_G.CreateFrame = function(_, _, parent)
  local child = frame()
  if parent and parent.rawChildren then parent.rawChildren[#parent.rawChildren + 1] = child end
  return child
end
_G.UIParent = frame()
_G.GetCursorPosition = function() return 400, 300 end
_G.SetPortraitTextureFromCreatureDisplayID = function(texture, displayId) texture.displayId = displayId end
_G.RAID_CLASS_COLORS = { MAGE = { r = 0.25, g = 0.78, b = 0.92 } }
_G.GameTooltip = {
  SetOwner = function(self, owner) self.owner = owner end,
  AddLine = function(self, text, r, g, b) self.line = { text, r, g, b } end,
  Show = function(self) self.shown = true end,
  Hide = function(self) self.shown = false end,
}
for marker = 1, 8 do _G["RAID_TARGET_"..marker] = tostring(marker) end

local saved = { autoMark = false, autoMarkModifier = "ALT", currentRaidIndex = 160 }
local selected, savedPriority
local clearedFloorMarks, clearedFloorCC
local tooltipCall
local liveMarksEnabled
local currentSublevel = 1
local ART = {
  L = setmetatable({}, { __index = function(_, key) return key end }),
  mapInfo = { [160] = { mapID = 565 } },
  main_frame = { Show = function() end },
  raidEnemies = { [160] = { { id = 400, isBoss = true } } },
  RaidPlanner = {
    raid = {
      key = "first-raid",
      mapId = 565,
      enemies = {
        ["200"] = { npcId = 200, name = "Zulu", displayId = 2000, spawns = { { sublevel = 2 } } },
        ["100"] = { npcId = 100, name = "Alpha", displayId = 1000, spawns = { { sublevel = 1 } } },
        ["300"] = { npcId = 300, name = "Beta", displayId = 3000, spawns = { { sublevel = 1 } } },
        ["400"] = { npcId = 400, name = "Boss", displayId = 4000, spawns = { { sublevel = 1 } } },
    },
    },
    GetNpcDefaultMarks = function(_, npcId) return npcId == 100 and { 7, 5 } or {} end,
    SetNpcDefaultMarks = function(_, npcId, markers) selected = { npcId, markers } end,
    ClearFloorDefaultMarks = function(_, sublevel) clearedFloorMarks = sublevel return true end,
    GetFloorNpcPriority = function() return savedPriority or {} end,
    SetFloorNpcPriority = function(_, priority) savedPriority = priority return priority end,
  },
}
ART.LiveMarks = { SetEnabled = function(_, enabled) liveMarksEnabled = enabled end }
local clearedDefault
local menuAssignmentChanged
local defaultAssignment = { ccKey = "POLYMORPH", assignee = { name = "Mage-Realm", classFile = "MAGE" } }
ART.CCAssignments = {
  catalog = { POLYMORPH = { icon = "Interface\\Icons\\Spell_Nature_Polymorph" } },
  EnsureDefaultMarkers = function() end,
  GetDefaultAssignment = function(_, _, npcId, marker)
    if npcId == 100 and marker == 7 then return defaultAssignment end
  end,
  ClearDefaultAssignment = function(_, _, npcId, marker)
    clearedDefault, defaultAssignment = { npcId, marker }, nil
    return true
  end,
  OpenDefaultMenu = function(_, _, _, _, assignmentChanged)
    menuAssignmentChanged = assignmentChanged
  end,
  ClearFloorAssignments = function(_, _, sublevel) clearedFloorCC = sublevel return true end,
}
_G.ART = ART
function ART:GetDB() return saved end
function ART:GetCurrentPreset() return { value = {} } end
function ART:GetCurrentSubLevel() return currentSublevel end
function ART:SetCurrentSubLevel(sublevel) currentSublevel = sublevel end
function ART:GetCurrentSection() return "maps" end
function ART:UpdateSectionVisibility() end
function ART:DisplayBlipTooltip(anchor, shown) tooltipCall = { anchor, shown } end
function ART:MakePullSelectionButtons(sidePanel)
  sidePanel.PullButtonScrollGroup = AceGUI:Create("SimpleGroup")
end
ART.main_frame.sidePanel = {}

assert(loadfile(root.."/Modules/AutoMarksUI.lua"))("AnniversaryRaidTools", ART)
ART:MakePullSelectionButtons(ART.main_frame.sidePanel)
local sidePanel = ART.main_frame.sidePanel
assert(sidePanel.markingTabBar and sidePanel.AutoMarksGroup, "side-panel tabs are created")

ART.AutoMarksUI:SetTab("autoMarks")
assert(sidePanel.PullButtonScrollGroup.frame.shown == false and sidePanel.AutoMarksGroup.frame.shown == true,
    "Auto Marks replaces only the pull list")
assert(#sidePanel.AutoMarksGroup.children == 5, "controls, floor clear action, and NPC list render")

local enable, modifier, clear, scroll = sidePanel.AutoMarksGroup.children[1], sidePanel.AutoMarksGroup.children[2],
    sidePanel.AutoMarksGroup.children[4], sidePanel.AutoMarksGroup.children[5]
assert(clear.text == "Clear All Marks", "floor clear action is explicitly labeled")
enable.callbacks.OnValueChanged(nil, nil, true)
modifier.callbacks.OnValueChanged(nil, nil, "CTRL")
assert(saved.autoMark == true and saved.autoMarkModifier == "CTRL" and liveMarksEnabled == true,
    "activation controls update settings and runtime registration")
assert(#scroll.children == 2 and scroll.children[1].children[1].image.displayId == 1000
    and scroll.children[2].children[1].image.displayId == 3000,
    "Auto Marks renders current-floor trash and hides bosses")
local firstRow = scroll.children[1]
assert(#firstRow.children[1].dragHandle.gripLines == 3,
    "each portrait slot starts with a purpose-built three-line drag grip")
firstRow.children[1].callbacks.OnEnter()
assert(tooltipCall[1] == firstRow.children[1].frame and tooltipCall[2] == true
    and tooltipCall[1].suppressEnemyInfoHint, "NPC portrait reuses the map model tooltip")
firstRow.children[1].callbacks.OnLeave()
assert(tooltipCall[2] == false, "NPC portrait hides the map model tooltip on leave")
assert(#firstRow.children == 9, "the grip overlays the portrait slot without adding an AceGUI child")
local rowWidth = 0
for _, child in ipairs(firstRow.children) do rowWidth = rowWidth + child.width end
assert(rowWidth == 224, "each Auto Marks row stays within the original single-line width budget")
assert(firstRow.children[2].image.alpha == 0.2 and firstRow.children[3].image.alpha == 1
    and firstRow.children[5].image.alpha == 1, "stored fallback markers show selected opacity")
firstRow.children[3].callbacks.OnEnter()
assert(GameTooltip.line[1] == "Mage" and GameTooltip.line[2] == RAID_CLASS_COLORS.MAGE.r
    and GameTooltip.line[3] == RAID_CLASS_COLORS.MAGE.g and GameTooltip.line[4] == RAID_CLASS_COLORS.MAGE.b,
    "CC badge tooltip shows the class-colored assignee")
firstRow.children[3].callbacks.OnLeave()
assert(GameTooltip.shown == false, "CC badge tooltip hides on leave")
assert(firstRow.children[3].ccBadge.texture == "Interface\\Icons\\Spell_Nature_Polymorph",
    "CC badge uses the assigned crowd-control icon")
firstRow.children[3].callbacks.OnClick()
assert(clearedDefault and clearedDefault[1] == 100 and clearedDefault[2] == 7,
    "deselecting a marker clears its CC default")
assert(sidePanel.AutoMarksGroup.children[5] == scroll,
    "marker clicks do not rebuild the Auto Marks list")
assert(firstRow.children[3].ccBadge.shown == false,
    "clearing the CC default hides its class badge")
scroll.status.scrollvalue, scroll.status.offset = 640, -120
firstRow.children[2].callbacks.OnClick(nil, nil, "RightButton")
menuAssignmentChanged({ ccKey = "POLYMORPH", assignee = { name = "Mage-Realm", classFile = "MAGE" } })
assert(sidePanel.AutoMarksGroup.children[5] == scroll and firstRow.children[2].ccBadge.shown
    and scroll.status.scrollvalue == 640 and scroll.status.offset == -120,
    "assigning CC updates the badge without replacing or moving the scroll list")
firstRow.children[2].callbacks.OnClick()
assert(selected[1] == 100 and selected[2][1] == 5,
    "marker toggle persists the visible fallback priority")
assert(firstRow.children[2].image.alpha == 0.2, "marker toggle updates its selected opacity immediately")
local previousDropStatus = scroll.status
local secondRow, handle = scroll.children[2], scroll.children[2].children[1].dragHandle
handle.scripts.OnDragStart()
assert(secondRow.frame.alpha == 0.2 and ART.AutoMarksUI.dragPreview.shown
    and ART.AutoMarksUI.dragPreview.name.text == "Beta",
    "dragging leaves a source placeholder and shows the mob preview")
firstRow.frame.mouseOver = true
ART.AutoMarksUI.dragPreview.scripts.OnUpdate()
assert(ART.AutoMarksUI.dropIndicator.shown and ART.AutoMarksUI.dragTargetNpcId == 100,
    "dragging highlights the destination insertion slot")
handle.scripts.OnDragStop()
assert(savedPriority[1] == 300 and savedPriority[2] == 100
    and sidePanel.AutoMarksGroup.children[5] == scroll and #timers == 1
    and not ART.AutoMarksUI.dragPreview.shown and not ART.AutoMarksUI.dropIndicator.shown
    and ART.AutoMarksUI.dragTargetNpcId == nil and secondRow.frame.alpha == 1,
    "drop cleans overlays, persists priority, and defers the AceGUI rebuild")
runTimers()
assert(sidePanel.AutoMarksGroup.children[5].children[1].children[1].image.displayId == 3000,
    "deferred refresh renders the new floor mark priority")
scroll = sidePanel.AutoMarksGroup.children[5]

assert(sidePanel.AutoMarksGroup.children[5] == scroll and scroll.status ~= previousDropStatus
    and scroll.status.scrollvalue == 640 and scroll.status.offset == -120
    and scroll.appliedScroll == 640,
    "drop isolates status and explicitly reapplies the preserved scroll position after layout")
clear.callbacks.OnClick()
assert(clearedFloorMarks == 1 and clearedFloorCC == 1 and sidePanel.AutoMarksGroup.children[5] == scroll,
    "floor clear defers rebuilding while its AceGUI callback is active")
runTimers()
assert(sidePanel.AutoMarksGroup.children[5] ~= scroll,
    "floor clear refreshes after the callback returns")

ART:SetCurrentSubLevel(2)
scroll = sidePanel.AutoMarksGroup.children[5]
assert(#scroll.children == 1 and scroll.children[1].children[1].image.displayId == 2000,
    "changing floors refreshes Auto Marks with that floor's NPCs")

local previousStatus = ART.AutoMarksUI.scrollStatus
ART.AutoMarksUI:QueueRefresh()
assert(#timers == 1, "old raid refresh is pending")
currentSublevel = 1
saved.currentRaidIndex = 161
ART.mapInfo[161] = { mapID = 580 }
ART.RaidPlanner.raid = {
  key = "second-raid", mapId = 580,
  enemies = {
    ["500"] = { npcId = 500, name = "New Raid Mob", displayId = 5000, spawns = { { sublevel = 1 } } },
  },
}
ART.AutoMarksUI:OnRaidChanged()
local raidScroll = sidePanel.AutoMarksGroup.children[5]
assert(ART.AutoMarksUI.scrollStatus ~= previousStatus
    and #raidScroll.children == 1 and raidScroll.children[1].children[1].image.displayId == 5000,
    "raid changes reset scroll state and synchronously render the new raid")
runTimers()
assert(sidePanel.AutoMarksGroup.children[5] == raidScroll,
    "a deferred refresh from the previous raid cannot rebuild the new raid list")
for _ = 1, 2 do ART.AutoMarksUI:Refresh() end
raidScroll = sidePanel.AutoMarksGroup.children[5]
for _, row in ipairs(raidScroll.children) do
  for index, icon in ipairs(row.children) do
    local handles = 0
    for _, child in ipairs(icon.frame.rawChildren) do
      if child.gripLines then handles = handles + 1 end
    end
    assert(handles <= 1, "pooled Icon frames never accumulate drag handles")
    if index == 1 then
      assert(icon.dragHandle and icon.dragHandle.shown, "pooled portrait Icons reuse their drag handle")
    elseif icon.dragHandle then
      assert(not icon.dragHandle.shown, "pooled marker Icons hide stale portrait drag handles")
    end
  end
end

ART.AutoMarksUI:SetTab("pulls")
assert(sidePanel.PullButtonScrollGroup.frame.shown == true and sidePanel.AutoMarksGroup.frame.shown == false)

local waveRefreshes = 0
ART.WaveModeUI = { IsActive = function() return true end, Refresh = function() waveRefreshes = waveRefreshes + 1 end }
sidePanel.WaveModeGroup = frame()
ART.AutoMarksUI:SetTab("pulls")
assert(sidePanel.PullButtonScrollGroup.frame.shown == false and sidePanel.WaveModeGroup.shown == true
    and sidePanel.pullTabButton.text == "Waves" and waveRefreshes == 1,
    "wave raids replace the native pull list without replacing Auto Marks")

print("Auto Marks side-panel checks passed")
