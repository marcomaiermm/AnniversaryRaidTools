# Roster and Player Mark Contract v1

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

Global player marks belong to the preset and use normal export/import:

```lua
preset.value.artPlayerMarks[marker] = {
  name = "Name-Realm",
  classFile = "MAGE",
  ccKey = "POLYMORPH", -- optional, must match the player's class
}
```

A player may hold at most one configured marker. A mark may include one optional
class-compatible long CC from the assignment catalog. Invalid entries are
removed during preset normalization. Live changes use the `ARTPlayerMark` prefix
with the current raid, preset UID, marker, operation, and optional player.

The Active Pull and automatic marker reconciliation use this priority:

1. Pull marker and optional pull CC.
2. Current-floor All Mark, only when its NPC occurs in the active pull.
3. Global player mark.

The visible mark owner and its CC are resolved separately. The highest available
layer supplies the row target, while a missing CC falls through in the same
order: pull CC, floor CC, then global player CC. This produces one merged row per
marker, for example a pull NPC with Star plus the global Star player's CC and
assignee. Missing configured players remain visible and class-colored as
`not in raid`. Auto Mark restores suppressed player assignments when their
marker becomes free and never overwrites a foreign holder.
