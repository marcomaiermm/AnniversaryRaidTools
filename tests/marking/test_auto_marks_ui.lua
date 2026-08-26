local root = arg and arg[1] or "."

local function frame()
  local value = { shown = true, scripts = {} }
  function value:SetSize() end
  function value:SetPoint() end
  function value:SetAllPoints() end
  function value:SetParent() end
  function value:SetText(text) self.text = text end
  function value:SetScript(event, callback) self.scripts[event] = callback end
  function value:SetShown(shown) self.shown = shown end
  function value:Show() self.shown = true end
  function value:Hide() self.shown = false end
  function value:Enable() self.enabled = true end
  function value:Disable() self.enabled = false end
  function value:CreateTexture()
    local texture = { shown = true }
    for _, method in ipairs({ "SetTexCoord", "SetSize", "SetPoint" }) do
      texture[method] = function() end
    end
    function texture:SetTexture(value) self.texture = value end
    function texture:Show() self.shown = true end
    function texture:Hide() self.shown = false end
    return texture
  end
  return value
end

local widgetMethods = {}
for _, name in ipairs({ "SetLayout", "SetFullWidth", "SetWidth", "SetHeight", "SetLabel", "SetColor" }) do
  widgetMethods[name] = function() end
end
function widgetMethods:SetText(text) self.text = text end
function widgetMethods:SetValue(value) self.value = value end
function widgetMethods:SetList(values, order) self.values, self.order = values, order end
function widgetMethods:SetImage(image) self.imagePath = image end
function widgetMethods:SetImageSize(width, height) self.imageWidth, self.imageHeight = width, height end
function widgetMethods:SetPoint(...) self.frame:SetPoint(...) end
function widgetMethods:AddChild(child) self.children[#self.children + 1] = child end
function widgetMethods:ReleaseChildren() self.children = {} end
function widgetMethods:SetCallback(event, callback) self.callbacks[event] = callback end
function widgetMethods:SetStatusTable(status) self.status = status end
function widgetMethods:DoLayout() end

local AceGUI = {}
function AceGUI:Create(kind)
  local widget = { kind = kind, frame = frame(), children = {}, callbacks = {} }
  if kind == "Icon" then
    widget.image = { SetAlpha = function(image, alpha) image.alpha = alpha end }
  end
  return setmetatable(widget, { __index = widgetMethods })
end

_G.LibStub = function(name) assert(name == "AceGUI-3.0"); return AceGUI end
_G.CreateFrame = function() return frame() end
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
local selected
local tooltipCall
local liveMarksEnabled
local currentSublevel = 1
local ART = {
  L = setmetatable({}, { __index = function(_, key) return key end }),
  mapInfo = { [160] = { mapID = 565 } },
  main_frame = { Show = function() end },
  RaidPlanner = {
    raid = {
      mapId = 565,
      enemies = {
        ["200"] = { npcId = 200, name = "Zulu", displayId = 2000, spawns = { { sublevel = 2 } } },
        ["100"] = { npcId = 100, name = "Alpha", displayId = 1000, spawns = { { sublevel = 1 } } },
      },
    },
    GetNpcDefaultMarks = function(_, npcId) return npcId == 100 and { 7, 5 } or {} end,
    SetNpcDefaultMarks = function(_, npcId, markers) selected = { npcId, markers } end,
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
assert(#sidePanel.AutoMarksGroup.children == 4, "controls and NPC list render")

local enable, modifier, scroll = sidePanel.AutoMarksGroup.children[1], sidePanel.AutoMarksGroup.children[2],
    sidePanel.AutoMarksGroup.children[4]
enable.callbacks.OnValueChanged(nil, nil, true)
modifier.callbacks.OnValueChanged(nil, nil, "CTRL")
assert(saved.autoMark == true and saved.autoMarkModifier == "CTRL" and liveMarksEnabled == true,
    "activation controls update settings and runtime registration")
assert(#scroll.children == 1 and scroll.children[1].children[1].image.displayId == 1000,
    "Auto Marks renders only NPCs from the current floor")
local firstRow = scroll.children[1]
firstRow.children[1].callbacks.OnEnter()
assert(tooltipCall[1] == firstRow.children[1].frame and tooltipCall[2] == true
    and tooltipCall[1].suppressEnemyInfoHint, "NPC portrait reuses the map model tooltip")
firstRow.children[1].callbacks.OnLeave()
assert(tooltipCall[2] == false, "NPC portrait hides the map model tooltip on leave")
assert(#firstRow.children == 9, "each NPC row contains eight marker toggles")
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
assert(sidePanel.AutoMarksGroup.children[4] == scroll,
    "marker clicks do not rebuild the Auto Marks list")
assert(firstRow.children[3].ccBadge.shown == false,
    "clearing the CC default hides its class badge")
scroll.status.scrollvalue, scroll.status.offset = 640, -120
firstRow.children[2].callbacks.OnClick(nil, nil, "RightButton")
menuAssignmentChanged({ ccKey = "POLYMORPH", assignee = { name = "Mage-Realm", classFile = "MAGE" } })
assert(sidePanel.AutoMarksGroup.children[4] == scroll and firstRow.children[2].ccBadge.shown
    and scroll.status.scrollvalue == 640 and scroll.status.offset == -120,
    "assigning CC updates the badge without replacing or moving the scroll list")
firstRow.children[2].callbacks.OnClick()
assert(selected[1] == 100 and selected[2][1] == 5,
    "marker toggle persists the visible fallback priority")
assert(firstRow.children[2].image.alpha == 0.2, "marker toggle updates its selected opacity immediately")

assert(sidePanel.AutoMarksGroup.children[4] == scroll
    and scroll.status.scrollvalue == 640 and scroll.status.offset == -120,
    "marker changes preserve the exact scroll widget and position")

ART:SetCurrentSubLevel(2)
scroll = sidePanel.AutoMarksGroup.children[4]
assert(#scroll.children == 1 and scroll.children[1].children[1].image.displayId == 2000,
    "changing floors refreshes Auto Marks with that floor's NPCs")

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
