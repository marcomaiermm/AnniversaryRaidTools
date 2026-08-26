# CC Assignment Contract v1

CC assignments extend the normal exported preset with optional fields:

```lua
---@class ARTCCAssignee
---@field name string       -- canonical Name-Realm, maximum 80 bytes
---@field classFile string

---@class ARTCCAssignment
---@field ccKey string
---@field assignee ARTCCAssignee

---@class ARTPull
---@field artCCAssignments table<string, ARTCCAssignment>|nil -- spawnKey -> override

---@class ARTPresetValue
---@field artCCDefaults table<integer, table<integer, ARTCCAssignment>>|nil -- legacy import field
---@field artCCFloorDefaults table<integer, table<integer, table<integer, ARTCCAssignment>>>|nil
-- sublevel -> npcId -> marker -> default
```

Marker keys are integers 1 through 8. Pull keys must reference a spawn contained
in that pull, and the enemy must support the selected CC.

Resolution is pull spawn override, then the current floor's `(npcId, actual
marker)` default, then none. A floor default is shown only when that NPC occurs
in the active pull. Removing an override is not a tombstone. Legacy
`artCCDefaults` entries are copied to every floor containing the NPC; an existing
floor entry wins. Invalid imported entries are discarded individually.

A pull assignment exists only while its spawn belongs to that pull and retains a
pull marker. Removing the marker, removing the spawn, or moving it to another
pull removes the old pull assignment and refreshes the live tracker projection.

The `ARTCCAssign` Live message contains `version = 1`, raid key/index, preset UID,
sublevel, `scope` (`pull` or `default`), `operation` (`set` or `clear`), and a
scope-specific target. Only authorized leader/assistant messages for the current
Live preset are accepted, and received mutations never echo.
