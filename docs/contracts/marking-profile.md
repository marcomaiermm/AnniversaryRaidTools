# Marking Profile Contract v1

```lua
---@class ARTMarkingProfile
---@field npcDefaults table<integer, integer[]> -- npcId -> ordered marker IDs
---@field packOverrides table<string, ARTMarkingPackOverride>

---@class ARTMarkingPackOverride
---@field npcDefaults table<integer, integer[]>|nil
---@field spawns table<string, integer>|nil -- spawnKey -> marker ID
```

Marker IDs are WoW raid target IDs `1..8`. Pack and spawn keys must exist in the
preset raid. Resolution order is: active-pack spawn override, active-pack NPC rule,
preset NPC default, no mark. A route step's `marks[spawnKey]` is treated as the most
specific active-pack spawn override without mutating the profile.

The core resolver exposes deterministic logic; the module wrapper exposes:

```lua
ART.MarkResolver:ActivateRouteStep(routeStepId)
ART.MarkResolver:ResolveUnit(unitToken)
ART.MarkResolver:ApplyUnit(unitToken)
ART.MarkResolver:ResetActivePack()
ART.MarkResolver:OnUnitDeath(unitGuid)
ART.MarkResolver:GetPreviewForPack(packKey)
```

For duplicate NPCs, the resolver keeps a live GUID-to-marker assignment until
reset/death and chooses the first unused marker in rule order. A spawn override is
used only when the caller can map that live unit to a stable spawn key; otherwise
resolution safely falls through to the NPC rule.

`ApplyUnit` is a no-op with a reason when the unit is missing, friendly, dead,
outside the active step, all slots are exhausted, permission is absent, combat/API
rules forbid marking, or preservation policy finds an existing marker. It never
changes target. Step changes reset active GUID assignments. Preview has no side
effects and follows the same precedence.
