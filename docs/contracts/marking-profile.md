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
lower-priority ART rule or configured player mark, including during combat.
Existing observed foreign marks are preserved.

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

`LiveMarks` keeps hostile mouseover writes on the intentional `mouseover`
boundary. Visible hostile nameplate writes are the explicit configurable
exception described below. Configured global player marks reconcile through
stable raid and party unit tokens while Auto Mark is enabled. Existing foreign
holders are never overwritten. See [Roster and Player Marks](roster-player-marks.md).

## Visible-nameplate policy
The account setting `autoMarkNameplates` is exposed at runtime as
`ART:GetDB().autoMarkNameplates`. Its saved-variable default is `true`, and the
Settings checkbox labelled **Automatically mark visible nameplates** edits the
value. The master `autoMark` setting remains a separate gate and defaults to
`false`.

With Auto Mark enabled and this policy `true`, a newly visible eligible
nameplate may be marked using the normal pull-then-current-floor NPC rules.
The policy does not promise that every nameplate receives a marker: eligibility,
permissions, available markers, and existing ownership still apply. Pull and
floor NPC rules outrank configured player marks, including during combat when
ART owns the competing marker; observed foreign marker holders remain protected.

When `autoMarkNameplates` is `false`, `NAME_PLATE_UNIT_ADDED` remains an
observation path only. ART records visible tokens and occupied markers for
ownership decisions but does not write a raid target from that event. A
`UNIT_DIED` observation releases ART's runtime and resolver ownership; desktop
tests do not claim that this clears the client's icon.
