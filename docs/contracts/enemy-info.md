# Enemy Info Contract v1

Enemy information is keyed by raid key and NPC ID. Each independently asserted fact
retains provenance rather than inheriting confidence from the containing record.

```lua
---@class ARTEnemyInfoFact
---@field value any
---@field source ARTProvenance

---@class ARTEnemySpellInfo
---@field spellId integer
---@field events table<string, integer> -- bounded event counts
---@field interruptible boolean|nil
---@field source ARTProvenance

---@class ARTEnemyInfo
---@field raidKey string
---@field npcId integer
---@field name ARTEnemyInfoFact|nil
---@field level ARTEnemyInfoFact|nil
---@field creatureType ARTEnemyInfoFact|nil
---@field maxHealth ARTEnemyInfoFact|nil
---@field spells table<integer, ARTEnemySpellInfo>
```

The live recorder accepts cast start/success, aura applied/removed, interrupt,
dispel, death, and kill events. It deduplicates equivalent observations, stores
counts/latest evidence instead of unbounded raw logs, and persists UTC observation
timestamps. AzerothCore spell/script data remains `candidate`; visually distinguish
it from `verified` live/manual facts.

Repository reads return merged facts without silently upgrading confidence. Unknown
events or malformed GUIDs are ignored with bounded diagnostics. Recorder failure
must not prevent route planning or raid registration.
