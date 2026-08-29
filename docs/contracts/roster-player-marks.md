# Roster, CC Marks, and Player Marks Contract v2

The roster is local account configuration and is not exported or live-shared:

```lua
ART.db.roster.slots[group][position] = {
  name = "Name-Realm",
  classFile = "MAGE",
}
```

There are eight groups with five positions. Names are canonical and unique
case-insensitively; moving an existing player clears the old slot. Manual names
require a valid TBC class. Removing a roster entry does not delete assignments.

## CC Marks

CC Marks belong to the preset and use normal export/import:

```lua
preset.value.artCCMarks[marker] = {
  name = "Name-Realm",
  classFile = "MAGE",
  ccKey = "POLYMORPH", -- optional, must match the player's class
}
```

A player may own at most one mob marker. A row may include one optional,
class-compatible long CC from the assignment catalog. Invalid entries are
removed during preset normalization. Legacy `artPlayerMarks` tables migrate
once to `artCCMarks` and are then removed.

Live CC Mark edits retain the version 1 `ARTPlayerMark` transport with the
current raid, preset UID, marker, operation, and optional player.

Active Pull CC resolution uses this priority:

1. Pull marker and optional pull CC.
2. Current-floor All Mark, only when its NPC occurs in the active pull.
3. CC Mark assignee and optional CC.

The visible mob owner and its CC are resolved separately. A missing CC falls
through in the same order: pull CC, floor CC, then CC Mark CC.

## Player Mark Loadouts

Player marks are independent preset-scoped working rows and named snapshots:

```lua
preset.value.artPlayerMarkCurrent[marker] = {
  name = "Name-Realm",
  classFile = "MAGE",
}
preset.value.artPlayerMarkLoadouts["Moroes"][marker] = {
  name = "Name-Realm",
  classFile = "MAGE",
}
preset.value.artPlayerMarkSelected = "Moroes"
preset.value.artPlayerMarksEnabled = true
```

The current table is the editable working set. Loading copies a saved snapshot
into it; saving or overwriting copies the working set into a snapshot. Renaming
or deleting a snapshot does not delete the current rows. Loadout names are
non-empty and unique within the preset.

Player-mark entries never contain `ccKey`. Markers and classes are validated,
names are canonicalized, and one player may hold at most one marker in each
table. Empty current tables and empty saved snapshots are removed during
normalization.

Only an enabled current table is applied live. Reconciliation finds matching
group members, never displaces a foreign marker holder, and clears only
ART-managed player marks when disabling, clearing, or changing the working set.
CC assignment resolution never reads player-mark loadouts.
