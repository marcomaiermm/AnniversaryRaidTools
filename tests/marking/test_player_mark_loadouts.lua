local root = arg and arg[1] or "."
local preset = { value = {} }
local reconciles = 0
local ART = {
  GetCurrentPreset = function() return preset end,
  LiveMarks = { OnPlanChanged = function() reconciles = reconciles + 1 end },
  RegisterNavigationSection = function(self, section) self.playerMarksSection = section end,
}
function UnitFullName(unit)
  if unit == "player" then return "Leader", "Realm" end
  return tostring(unit):match("^[^-]+"), tostring(unit):match("%-(.+)$")
end
function UnitClass(unit)
  if unit == "player" then return "Mage", "MAGE" end
end

assert(loadfile(root.."/Modules/PlayerMarks.lua"))("AnniversaryRaidTools", ART)
local marks = ART.PlayerMarks
assert(ART.playerMarksSection and ART.playerMarksSection.key == "player-marks"
    and ART.playerMarksSection.name == "Marks" and ART.playerMarksSection.tooltip == "Player Marks",
    "player marks owns its navigation section")
local soloCandidates = marks:GetCandidates()
assert(#soloCandidates == 1 and soloCandidates[1].name == "Leader-Realm"
    and soloCandidates[1].unit == "player",
    "the current character remains a valid player-mark candidate while solo")

preset.value.artPlayerMarkCurrent = {
  [1] = { name = "Mage-Realm", classFile = "MAGE", ccKey = "POLYMORPH" },
  [7] = { name = "Mage-Realm", classFile = "MAGE" },
  [2] = { name = "Bad-Realm", classFile = "UNKNOWN" },
  [9] = { name = "Rogue-Realm", classFile = "ROGUE" },
}
preset.value.artPlayerMarkLoadouts = {
  Moroes = { [8] = { name = "Rogue-Realm", classFile = "ROGUE", ccKey = "SAP" } },
  Empty = {},
}
preset.value.artPlayerMarkSelected = "Empty"
preset.value.artPlayerMarksEnabled = "yes"
assert(marks:NormalizePreset(preset))
assert(preset.value.artPlayerMarkCurrent[7] and not preset.value.artPlayerMarkCurrent[7].ccKey
    and not preset.value.artPlayerMarkCurrent[1] and not preset.value.artPlayerMarkCurrent[2]
    and not preset.value.artPlayerMarkCurrent[9],
    "normalization validates markers, classes, duplicate players, and strips CC")
assert(preset.value.artPlayerMarkLoadouts.Moroes[8]
    and not preset.value.artPlayerMarkLoadouts.Moroes[8].ccKey
    and not preset.value.artPlayerMarkLoadouts.Empty and preset.value.artPlayerMarkSelected == nil
    and preset.value.artPlayerMarksEnabled == nil,
    "normalization drops empty loadouts and invalid selected/enabled state")

assert(marks:SetPlayer(preset, 7, { name = "Rogue-Realm", classFile = "ROGUE" }))
assert(marks:SaveCurrentAs(preset, "Moroes 2") and preset.value.artPlayerMarkSelected == "Moroes 2")
assert(not marks:SaveCurrentAs(preset, "Moroes 2"), "save-as rejects duplicate names")
assert(marks:SetPlayer(preset, 1, { name = "Mage-Realm", classFile = "MAGE" }))
assert(marks:SetPlayer(preset, 8, { name = "Mage-Realm", classFile = "MAGE" }))
assert(not preset.value.artPlayerMarkCurrent[1], "one player can occupy only one current mark")
assert(marks:OverwriteSelected(preset))
assert(preset.value.artPlayerMarkLoadouts["Moroes 2"][8].name == "Mage-Realm")
assert(marks:SetPlayer(preset, 3, { name = "Warlock-Realm", classFile = "WARLOCK" }))
assert(marks:LoadLoadout(preset, "Moroes 2") and not preset.value.artPlayerMarkCurrent[3],
    "loading restores a copied saved snapshot")
assert(marks:RenameSelected(preset, "Moroes Three")
    and preset.value.artPlayerMarkLoadouts["Moroes Three"]
    and not preset.value.artPlayerMarkLoadouts["Moroes 2"])
local current = preset.value.artPlayerMarkCurrent
assert(marks:DeleteSelected(preset) and preset.value.artPlayerMarkSelected == nil
    and preset.value.artPlayerMarkCurrent == current,
    "deleting a snapshot preserves the editable current rows")
assert(marks:SetEnabled(preset, true) and next(marks:GetActiveMarks(preset)))
assert(marks:SetEnabled(preset, false) and next(marks:GetActiveMarks(preset)) == nil)
assert(reconciles > 0, "loadout changes reconcile live marks")

local function edit(marker, text)
  return {
    marker = marker, text = text, dirty = true,
    GetText = function(self) return self.text end,
    SetText = function(self, value) self.text = value end,
    SetTextColor = function() end,
  }
end
local mageEdit, rogueEdit = edit(1, "Mage"), edit(2, "Rogue")
local function label() return { SetText = function(self, text) self.text = text end } end
marks.frame = {
  edits = { [1] = mageEdit, [2] = rogueEdit },
  loadout = label(), toggle = label(), status = label(),
}
ART.Roster = { GetPlayers = function() return {
  { name = "Mage-Realm", classFile = "MAGE", unit = "raid1", online = true },
  { name = "Rogue-Realm", classFile = "ROGUE", unit = "raid2", online = true },
} end }
preset.value.artPlayerMarkCurrent = nil
assert(marks:CommitPendingEdits())
assert(marks:SetEnabled(preset, true))
assert(preset.value.artPlayerMarkCurrent[1].name == "Mage-Realm"
    and preset.value.artPlayerMarkCurrent[2].name == "Rogue-Realm"
    and mageEdit.text == "Mage" and rogueEdit.text == "Rogue",
    "enabling accepts character-only rows without refresh deleting later rows")

assert(marks:SaveCurrentAs(preset, "Delete Me"))
local currentBeforeDelete = preset.value.artPlayerMarkCurrent
local deleteDialog = {
  prompt = { SetText = function(self, text) self.text = text end },
  Show = function(self) self.shown = true end,
  Hide = function(self) self.shown = false end,
}
marks.deleteDialog = deleteDialog
assert(marks:OpenDeleteDialog(preset, "Delete Me")
    and deleteDialog.prompt.text == "Delete 'Delete Me'?\nThe current rows will be kept."
    and deleteDialog.shown)
assert(marks:ConfirmDeleteDialog() and not deleteDialog.shown
    and preset.value.artPlayerMarkSelected == nil
    and preset.value.artPlayerMarkCurrent == currentBeforeDelete,
    "the compact delete dialog removes only the saved snapshot")

print("player mark loadout checks passed")
