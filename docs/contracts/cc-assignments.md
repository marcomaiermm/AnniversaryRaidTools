# CC Assignment Contract v1

CC assignments extend the normal exported preset with optional fields:

```lua
---@class ARTCCAssignee
---@field name string       -- canonical Name-Realm, maximum 80 bytes
---@field classFile string  -- must match the selected CC catalog entry

---@class ARTCCAssignment
---@field ccKey string
---@field assignee ARTCCAssignee

---@class ARTPull
---@field artCCAssignments table<string, ARTCCAssignment>|nil -- spawnKey -> override

---@class ARTPresetValue
---@field artCCDefaults table<integer, table<integer, ARTCCAssignment>>|nil -- npcId -> marker -> default
```

`ccKey` is one of `POLYMORPH`, `SAP`, `BANISH`, `SHACKLE_UNDEAD`,
`HIBERNATE`, `FREEZING_TRAP`, `FEAR`, `REPENTANCE`, `SCARE_BEAST`, or
`TURN_EVIL`. Marker keys are integers 1 through 8. Pull keys must reference a
spawn contained in that pull. The referenced enemy must advertise the matching
CC characteristic; Freezing Trap additionally accepts a non-boss with at least
one supported long-CC characteristic.

Resolution is pull spawn override, then `(npcId, actual marker)` raid default,
then none. Removing an override is not a tombstone. Invalid imported entries are
discarded individually; valid route data and assignments remain.

The `ARTCCAssign` Live message contains `version = 1`, raid key/index, preset UID,
sublevel, `scope` (`pull` or `default`), `operation` (`set` or `clear`), and a
scope-specific target. Pull targets carry pull index, spawn key, and marker;
default targets carry NPC ID and marker. Set operations carry an assignment.
Only authorized leader/assistant messages for the current Live preset are
accepted, and received mutations never echo.

