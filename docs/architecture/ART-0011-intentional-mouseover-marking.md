# ART-0011: Intentional mouseover marking

## Status

Accepted

## Date

2026-08-25

## Context

ART-0010 tried to infer physical NPC spawns from hostile unit positions, exposed
unit tokens, and player proximity. TBC Anniversary does not reliably expose the
required hostile positions in instances. Broad token reconciliation and automatic
death-based pull progression also made live marking more active than the player
could predict.

WoW requires a live unit token for `SetRaidTarget`, permits only one holder per
icon, and does not provide a complete list of offscreen icon holders. Identical
NPC IDs therefore cannot be mapped to planner clones without an explicit player
gesture or invented spatial evidence.

## Decision

1. `LiveMarks` may call `SetRaidTarget` only for the `mouseover` unit after
   `UPDATE_MOUSEOVER_UNIT` or after the configured modifier is pressed over an
   existing mouseover. Target, nameplate, roster, and raid-target events only
   observe occupied icons.
2. The current pull supplies an ordered marker pool per NPC ID. Hover order binds
   otherwise identical NPCs to the next free marker; it does not claim physical
   clone identity. Pull rules completely override the global rule for that NPC ID.
3. `marking.npcDefaults[npcId]` stores an ordered global fallback pool for all
   pulls in the route preset. It applies raid-wide only when the active pull has
   no rule for that NPC ID; identical NPCs receive the next free fallback.
4. Existing and observed foreign markers are preserved. In combat ART assigns
   only free icons. Outside combat a deliberate hover may reclaim an icon only
   when the current runtime knows ART assigned its previous holder.
5. Pull selection remains manual. Deaths release ART-owned marker leases but do
   not mark another unit or advance the route. Global marker clearing is not
   exposed.

## Alternatives considered

- **Position/proximity inference:** rejected because unavailable data makes the
  result appear more certain than it is.
- **Automatic nameplate or target marking:** rejected because incidental unit
  discovery should not mutate shared raid state.
- **Out-of-combat-only marking:** rejected because boss adds still need free
  markers during combat.
- **Automatic pull progression:** rejected because MDT pull selection is manual
  and death inference cannot reliably distinguish completion, wipes, or evades.

## Consequences

- Every new mark follows an intentional hover gesture and never changes target.
- Pull-specific clone marks remain useful for duplicate NPC IDs, but hover order
  replaces physical left/right identity.
- Offscreen foreign markers cannot be discovered after reload; observed holders
  are retained conservatively until cleared or seen dead.
- `SpawnMatcher` and `PullProgress` are no longer part of live marking. Generated
  world positions remain available to the planner map.
