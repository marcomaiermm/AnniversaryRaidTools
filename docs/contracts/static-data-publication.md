# Static Data Publication Contract v1

Lua files loaded through WoW TOC/XML script entries cannot expose chunk return
values to later files. Static raid and enemy-info artifacts therefore publish the
same immutable values that they return for tests and tooling.

The bootstrap boundary creates these tables before any static data loads:

```lua
ART.StaticData = ART.StaticData or {}
ART.StaticData.raids = ART.StaticData.raids or {}
ART.StaticData.enemyInfo = ART.StaticData.enemyInfo or {}
```

Producer artifacts publish by stable raid key:

```lua
ART.StaticData.raids[raid.key] = raid
ART.StaticData.enemyInfo[raidKey] = enemyInfo
return raid -- or enemyInfo
```

Publication does not validate, register, merge, or mutate data. The ART-070
integration boundary loads producers in deterministic order, then passes published
values through the existing Raid Definition v1 and Enemy Info v1 validators before
registration or repository merge. Duplicate or invalid keys are rejected there;
unknown buckets are not consumed.

Generated raid output remains generator-owned. Its generator emits both the
publication assignment and the matching return value, which must reference the
same table. Enemy-info source modules follow the same rule in their owned data
files. Neither producer registers itself or imports UI/feature code.

Existing `ART.MapDefinitions` and `ART.MapTransforms` publication remains a separate
map-calibration interface and is unchanged by this contract.
