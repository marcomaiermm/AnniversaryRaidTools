# Marking Profile Contract v1

```lua
---@class ARTMarkingProfile
---@field npcDefaults table<integer, integer[]> -- npcId -> ordered fallback marker IDs
---@field packOverrides table<string, ARTMarkingPackOverride> -- retained for v1 import compatibility

---@class ARTMarkingPackOverride
---@field npcDefaults table<integer, integer[]>|nil
---@field spawns table<string, integer>|nil
```

Marker IDs are WoW raid target IDs `1..8`. The Auto Marks UI writes a single
marker as `{ marker }` and removes the NPC key for `None`; the existing array
shape keeps route preset v1 import/export compatible.

Live resolution is deliberately limited to two layers:

1. All explicit spawn markers for the hovered NPC ID in the current pull form a
   pool ordered as Skull, Cross, Star, Moon, Square, Diamond, Triangle, Circle.
2. If that pool is empty, `npcDefaults[npcId]` is the ordered global marker pool.

An exhausted pull pool does not fall back to the global rule. Hover order assigns
duplicate positionless NPCs without claiming a physical spawn identity. Global
rules apply anywhere in the selected raid route preset.

The planner exposes:

```lua
ART.RaidPlanner:GetNpcDefaultMark(npcId) -- marker|nil
ART.RaidPlanner:SetNpcDefaultMark(npcId, markerOrNil) -- marker|0, reason
ART.RaidPlanner:GetNpcDefaultMarks(npcId) -- marker[]
ART.RaidPlanner:SetNpcDefaultMarks(npcId, markers) -- marker[]|nil, reason
ART.RaidPlanner:GetStepNpcMarks(stepId, npcId) -- marker[]
ART.RaidPlanner:SetStepNpcMarks(stepId, npcId, markers) -- marker[]|nil, reason
```

The step methods expose the same ordered pool for a single NPC ID inside one
route step. Storage remains `step.marks[spawnKey]`; marker entries are assigned
to deterministic member spawns so preset schema v1 does not change. A pool may
not contain more markers than that NPC has spawns in the step, and a marker
selected for one NPC is displaced from any other NPC in the same step.

The resolver exposes deterministic logic through:

```lua
ART.MarkResolver:ActivateRouteStep(routeStepId)
ART.MarkResolver:ResolveUnit(unitToken)
ART.MarkResolver:ResetActivePack()
ART.MarkResolver:OnUnitDeath(unitGuid)
ART.MarkResolver:GetPreviewForPack(packKey)
ART.MarkResolver:GetRuleForNpcId(npcId)
```

`LiveMarks` is the only automatic application boundary. It writes only to the
`mouseover` token after the configured deliberate gesture. Existing unit markers
and observed foreign holders are preserved. Non-mouseover events may update
occupancy but must never call `SetRaidTarget`.
