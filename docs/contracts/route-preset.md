# Route Preset Contract v1

The persisted/exported value is:

```lua
---@class ARTRouteStep
---@field id string -- unique within preset, stable across reorder
---@field label string
---@field packKeys string[] -- route selection; immutable wave snapshot in waves mode
---@field notes string
---@field marks table<string, integer> -- optional step-local spawnKey -> marker
---@field waveKey string|nil -- required only for waves mode; stable wave identity
---@field camp string|nil -- optional only for waves mode
---@field tankAssignments table|nil -- optional only for waves mode

---@class ARTRoutePreset
---@field schemaVersion 1
---@field raidKey string
---@field currentSublevel integer
---@field routeSteps ARTRouteStep[]
---@field marking ARTMarkingProfile
```

In `route` mode, users choose and order pack keys. In `waves` mode, raid data owns
wave order/composition; a preset contains exactly one step for each raid wave, in
the raid's declared order, with a unique `waveKey`. Each step's `packKeys` is a
validated immutable snapshot equal to the referenced raid wave's `packKeys` (same
keys and order); users cannot add, remove, reorder, or otherwise redefine it. If a
step carries `camp`, it must match the referenced wave. Notes, marks, and tank
assignments remain user annotations. Drawings and notes may be persisted as existing
compatible preset extensions, but cannot use array indices as identity.

Import validates the exact schema version, raid existence, sublevel, unique step
IDs, pack references, and marking profile before mutation. For `waves` mode it also
rejects unknown or duplicate `waveKey` values, missing or extra wave steps, any
order mismatch, and any `packKeys`/wave-composition mismatch. Unknown versions are
rejected with no partial import. Export ordering is deterministic. Migrations are
explicit version-to-version functions; no field guessing.
