local root = arg and arg[1] or "."

local db = {}
local preset = { value = {} }
local ART = { AddonName = "AnniversaryRaidTools" }
CLASS_ICON_TCOORDS = { WARLOCK = { 0.75, 1, 0.25, 0.5 }, MAGE = { 0.25, 0.5, 0, 0.25 } }
function ART:RegisterNavigationSection(section) self.rosterSection = section end
function UnitFullName(unit)
  if unit == "player" then return "Leader", "Realm" end
  if unit == "raid1" then return "Mage", "Realm" end
  if unit == "raid2" then return "Warlock", "Realm" end
  return tostring(unit):match("^[^-]+"), tostring(unit):match("%-(.+)$")
end
function UnitClass(unit)
  if unit == "raid1" then return "Mage", "MAGE" end
  if unit == "raid2" then return "Warlock", "WARLOCK" end
end
function UnitIsConnected() return true end
function IsInRaid() return true end
function GetNumGroupMembers() return 2 end
function GetRaidRosterInfo(index)
  if index == 1 then return "Mage-Realm", nil, 2 end
  return "Warlock-Realm", nil, 1
end
function ART:GetDB() return db end
function ART:GetCurrentPreset() return preset end

assert(loadfile(root.."/Modules/Roster.lua"))("AnniversaryRaidTools", ART)
local roster = ART.Roster
ART.CCAssignments = {
  catalogOrder = { "POLYMORPH", "SAP" },
  catalog = {
    POLYMORPH = { key = "POLYMORPH", label = "Polymorph", classFile = "MAGE", icon = "Spell_Mage" },
    SAP = { key = "SAP", label = "Sap", classFile = "ROGUE", icon = "Spell_Rogue" },
  },
}
assert(ART.rosterSection and ART.rosterSection.key == "roster"
    and ART.rosterSection.createSidePanelFrame == false
    and ART.rosterSection.texture:find("Textures\\users", 1, true)
    and ART.rosterSection.iconSize == 25,
    "the roster owns a full-width navigation section with its optimized icon")

assert(roster:SetSlot(1, { name = "Mage-Realm", classFile = "MAGE" }))
assert(roster:GetSlots()[1].name == "Mage-Realm")
assert(not roster:SetSlot(2, { name = "Mage-Realm", classFile = "UNKNOWN" }),
    "roster entries require a supported class")

assert(roster:SetPlayerMark(preset, 1, roster:GetSlots()[1], true))
assert(roster:GetPlayerMark(preset, 1).name == "Mage-Realm",
    "a preset stores a class-bearing snapshot of the selected roster player")
assert(roster:SetPlayerCC(preset, 1, "POLYMORPH", true))
assert(roster:GetPlayerMark(preset, 1).ccKey == "POLYMORPH"
    and not roster:SetPlayerCC(preset, 1, "SAP", true),
    "global player marks accept only class-compatible CC")

assert(roster:SetSlot(2, { name = "Rogue", classFile = "ROGUE" }))
assert(roster:GetSlots()[2].name == "Rogue-Realm", "short manual names use the player's realm")
assert(roster:SwapSlots(1, 2))
assert(roster:GetSlots()[1].name == "Rogue-Realm" and roster:GetSlots()[2].name == "Mage-Realm")
assert(roster:SetSlot(3, { name = "Mage-Realm", classFile = "MAGE" }))
assert(not roster:GetSlots()[2] and roster:GetSlots()[3].name == "Mage-Realm",
    "moving a duplicate roster member clears its old slot")
assert(roster:ClearSlot(3) and not roster:GetSlots()[3])

assert(roster:SetSlot(1, { name = "Mage-Realm", classFile = "MAGE" }))
assert(roster:SetPlayerMark(preset, 7, roster:GetSlots()[1], true))
assert(not roster:GetPlayerMark(preset, 1) and roster:GetPlayerMark(preset, 7).name == "Mage-Realm",
    "one player can own only one global marker in a preset")
assert(roster:ClearPlayerMark(preset, 7, true) and not roster:GetPlayerMark(preset, 7))

local players = roster:GetPlayers(true)
assert(#players == 2 and players[1].name == "Mage-Realm" and players[1].unit == "raid1"
    and players[2].name == "Warlock-Realm",
    "configured roster and current raid merge without duplicate names: "
      ..tostring(#players).."/"..tostring(players[1] and players[1].name).."/"
      ..tostring(players[1] and players[1].unit).."/"..tostring(players[2] and players[2].name))

assert(roster:LoadCurrentRaid())
assert(roster:GetSlots()[1].name == "Warlock-Realm" and roster:GetSlots()[6].name == "Mage-Realm",
    "loading the current raid preserves subgroup positions")

function GetNumGuildMembers() return 2 end
function GetGuildRosterInfo(index)
  if index == 1 then return "GuildMage-Realm", nil, nil, nil, nil, nil, nil, nil, nil, nil, "MAGE" end
  return "Invalid-Realm", nil, nil, nil, nil, nil, nil, nil, nil, nil, "UNKNOWN"
end
local guild = roster:RefreshGuildPlayers()
assert(#guild == 1 and guild[1].name == "GuildMage-Realm" and guild[1].classFile == "MAGE",
    "guild autocomplete keeps only class-bearing player suggestions")

preset.value.artPlayerMarks = {
  [1] = { name = "Mage-Realm", classFile = "MAGE" },
  [7] = { name = "Mage-Realm", classFile = "MAGE" },
  [9] = { name = "Bad-Realm", classFile = "UNKNOWN" },
}
assert(roster:NormalizePreset(preset))
local normalizedCount = 0
for _ in pairs(preset.value.artPlayerMarks) do normalizedCount = normalizedCount + 1 end
assert(normalizedCount == 1 and not preset.value.artPlayerMarks[9],
    "preset normalization rejects invalid and duplicate global player marks")
preset.value.artPlayerMarks = nil

local sent, reconciles = {}, 0
preset.uid = "preset-a"
preset.value.currentRaidIndex = 1
ART.liveSessionActive, ART.livePresetUID = true, preset.uid
ART.liveSessionPrefixes = { playerMark = "ARTPlayerMark" }
ART.RaidPlanner = { raid = { key = "raid-a" } }
ART.LiveMarks = { OnPlanChanged = function() reconciles = reconciles + 1 end }
ART.RaidMarksUI = { RefreshPullTracker = function() end }
ART.commsObject = { SendCommMessage = function(_, ...) sent[#sent + 1] = { ... } end }
function ART:LiveSession_CanControlProgress() return true end
function ART:IsPlayerInGroup() return "RAID" end
function ART:TableToString(value) return value end
function ART:GetCurrentLivePreset() return preset end

assert(roster:SetPlayerMark(preset, 8, { name = "Mage-Realm", classFile = "MAGE" }))
assert(sent[1][1] == "ARTPlayerMark" and sent[1][2].operation == "set" and reconciles == 1,
    "player mark edits reconcile locally and send a versioned live mutation")
assert(roster:SetPlayerCC(preset, 8, "POLYMORPH"))
assert(sent[2][2].player.ccKey == "POLYMORPH",
    "global CC changes use the existing player-mark live mutation")
assert(roster:ReceiveChange({
  version = 1, raidKey = "raid-a", raidIndex = 1, presetUID = "preset-a",
  operation = "clear", marker = 8,
}, "RAID", "Assist-Realm"))
assert(not roster:GetPlayerMark(preset, 8) and #sent == 2,
    "received player mark changes apply without echo")

local markFont = { SetTextColor = function(self, ...) self.color = { ... } end }
local markButton = {
  SetText = function(self, text) self.label = text end,
  GetFontString = function() return markFont end,
}
local ccButton = {
  SetText = function(self, text) self.label = text end,
  Enable = function(self) self.enabled = true end,
  Disable = function(self) self.enabled = false end,
}
local classTexture = {
  SetTexCoord = function(self, ...) self.coords = { ... } end,
  SetTexture = function(self, asset) self.asset = asset or false end,
}
local classButton = {
  SetText = function(self, text) self.label = text end,
  SetNormalTexture = function(self, path)
    assert(path ~= nil, "SetNormalTexture requires an asset")
    self.path = path
  end,
  GetNormalTexture = function() return classTexture end,
}
local slotEdit = {
  SetText = function() end,
  SetTextColor = function() end,
  classButton = classButton,
}
roster.frame = { edits = { slotEdit }, markButtons = { [8] = markButton }, ccButtons = { [8] = ccButton } }
roster:RefreshUI()
assert(markButton.label == "Unassigned" and markFont.color,
    "roster mark buttons use the UIPanelButton font-string API")
assert(ccButton.label == "CC" and ccButton.enabled == false,
    "CC selection is disabled until the mark has a player")
assert(classButton.path and classTexture.coords and classButton.label == "",
    "populated roster class buttons show the class icon")
roster:ClearSlot(1)
roster:RefreshUI()
assert(classButton.path:find("UI%-Panel%-Button%-Up") and classButton.label == "?",
    "empty roster slots restore the button texture without passing nil to SetNormalTexture")

local classLabels = {}
function ART:CreateContextMenu(_, generator)
  generator(nil, {
    CreateTitle = function() end,
    CreateButton = function(_, label) classLabels[#classLabels + 1] = label end,
  })
end
roster:OpenClassMenu({ classButton = classButton })
assert(classLabels[7] and classLabels[7]:find("|T", 1, true)
    and classLabels[7]:find("Mage", 1, true) and not classLabels[7]:find("MAGE", 1, true),
    "class choices contain an icon and a Pascal-case class name")

roster:SetPlayerMark(preset, 8, { name = "Mage-Realm", classFile = "MAGE" }, true)
roster:SetPlayerCC(preset, 8, "POLYMORPH", true)
roster:RefreshUI()
assert(ccButton.enabled and ccButton.label:find("Spell_Mage", 1, true),
    "a configured global CC is represented by its spell icon")
local ccLabels = {}
function ART:CreateContextMenu(_, generator)
  generator(nil, {
    CreateTitle = function() end,
    CreateDivider = function() end,
    CreateButton = function(_, label) ccLabels[#ccLabels + 1] = label end,
  })
end
roster:OpenPlayerCCMenu(8, ccButton)
assert(ccLabels[1] == "Clear CC" and ccLabels[2]:find("Polymorph", 1, true)
    and not ccLabels[3], "the CC menu contains only class-compatible choices")

print("roster model checks passed")
