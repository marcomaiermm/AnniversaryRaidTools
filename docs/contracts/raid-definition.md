# Raid Definition Contract v1

Raid definitions are immutable registry inputs. Keys are lowercase ASCII slugs.

```lua
---@class ARTPoint
---@field x number
---@field y number

---@class ARTSublevel
---@field index integer -- contiguous, one-based
---@field name string
---@field mapId integer

---@class ARTEnemySpawn
---@field key string
---@field npcId integer
---@field x number -- normalized planner coordinate, 0..1
---@field y number -- normalized planner coordinate, 0..1
---@field sublevel integer
---@field packKey string|nil
---@field patrol ARTPoint[]|nil
---@field source ARTProvenance

---@class ARTEnemy
---@field npcId integer
---@field name string
---@field spawns ARTEnemySpawn[]
---@field source ARTProvenance

---@class ARTPack
---@field key string
---@field label string|nil
---@field spawnKeys string[]
---@field pullGroup string|nil -- packs with the same key join one pull on the same sublevel
---@field source ARTProvenance

---@class ARTPOI
---@field x number
---@field y number
---@field sublevel integer
---@field label string|nil
---@field source ARTProvenance

---@class ARTWaveDefinition
---@field waveKey string -- stable identity within raid; never an ordinal
---@field camp string|nil
---@field packKeys string[] -- immutable, validated wave-composition snapshot
---@field source ARTProvenance

---@class ARTRaidDefinition
---@field schemaVersion 1
---@field key string
---@field name string
---@field expansion "TBC"
---@field instanceId integer
---@field mapId integer
---@field mode "route"|"waves"
---@field sublevels ARTSublevel[]
---@field enemies table<string, ARTEnemy> -- decimal npcId string -> enemy
---@field packs table<string, ARTPack> -- packKey -> pack
---@field pois table<integer, ARTPOI[]> -- sublevel -> POIs
---@field waves ARTWaveDefinition[]|nil
```

Raid keys are `<raid-slug>`. Pack keys are `<raid>:pack:<stable-id>` and spawn keys
are `<raid>:spawn:<npcId>:<stable-id>`, for example
`black-temple:spawn:22844:01`. Keys never depend on output order and must not be
reused. Runtime `enemyIdx`/`cloneIdx` may exist only as transient projections.

Every pack member names an existing spawn in the same raid; each spawn's optional
`packKey` agrees with membership. Coordinates are finite and patrol points use the
same sublevel transform. Packs sharing a `pullGroup` remain separate spatial packs
but are selected together when they are on the active sublevel. `waves` is required
only when `mode == "waves"`; its array
order is the authoritative wave order, while `waveKey` is the only persistent wave
identity. Wave keys are unique and never derived from array position or an integer
ordinal. Each wave's `packKeys` is a validated immutable snapshot: every key must
name an existing pack, and the snapshot is not user-editable. Unknown schema
versions and invalid references are rejected.
