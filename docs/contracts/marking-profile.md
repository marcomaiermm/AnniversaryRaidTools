# Marking Profile Contract v1

```lua
---@class ARTMarkingProfile
---@field npcDefaults table<integer, integer[]> -- legacy import field
---@field floorNpcDefaults table<integer, table<integer, integer[]>> -- sublevel -> npcId -> marker IDs
---@field floorNpcPriority table<integer, integer[]> -- sublevel -> NPC IDs, highest priority first
---@field packOverrides table<string, ARTMarkingPackOverride> -- retained for v1 import compatibility

---@class ARTMarkingPackOverride
---@field npcDefaults table<integer, integer[]>|nil
---@field spawns table<string, integer>|nil
```

Marker IDs are WoW raid target IDs `1..8`. The Auto Marks UI writes a single
marker as `{ marker }` and removes the NPC key for `None`; the array shape keeps
route preset v1 import/export compatible. Importing legacy `npcDefaults` copies
each rule to every floor containing that NPC and clears the legacy field.

Hostile NPC resolution has two layers:

1. Explicit spawn markers for the hovered NPC ID in the current pull form a pool
   ordered as Skull, Cross, Star, Moon, Square, Diamond, Triangle, Circle.
2. If that pool is empty, `floorNpcDefaults[currentSublevel][npcId]` is used.

An exhausted pull pool does not fall back to the floor rule. Hover order assigns
duplicate positionless NPCs without claiming a physical spawn identity. Floor
NPC rules may share markers. `floorNpcPriority[currentSublevel]` decides which
NPC keeps a shared ART-owned marker; a higher-priority NPC may reclaim it from a
lower-priority floor rule outside combat. Existing foreign marks and ART marks
already in combat are preserved.

The planner APIs below read and write the active floor:

```lua
ART.RaidPlanner:GetNpcDefaultMark(npcId) -- marker|nil
ART.RaidPlanner:SetNpcDefaultMark(npcId, markerOrNil) -- marker|0, reason
ART.RaidPlanner:GetNpcDefaultMarks(npcId) -- marker[]
ART.RaidPlanner:SetNpcDefaultMarks(npcId, markers) -- marker[]|nil, reason
ART.RaidPlanner:GetFloorNpcPriority(sublevelOrNil) -- npcId[]
ART.RaidPlanner:SetFloorNpcPriority(npcIds, sublevelOrNil) -- npcId[]|nil, reason
ART.RaidPlanner:GetStepNpcMarks(stepId, npcId) -- marker[]
ART.RaidPlanner:SetStepNpcMarks(stepId, npcId, markers) -- marker[]|nil, reason
```

Step storage remains `step.marks[spawnKey]`; markers are assigned to deterministic
member spawns so preset schema v1 does not change. A pool may not contain more
markers than that NPC has spawns in the step.

`LiveMarks` keeps hostile writes on the intentional `mouseover` boundary.
Configured global player marks are the exception: while Auto Mark is enabled,
they reconcile through stable raid and party unit tokens. Existing foreign
holders are never overwritten. See [Roster and Player Marks](roster-player-marks.md).
