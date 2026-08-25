# ART-0010: Preset-wide live marking and safe pull progression

## Status

Superseded by ART-0011

## Date

2026-08-23

## Context

ART-0008 made live marks strictly dependent on the active pull and refused new
assignments during combat. Live raid use exposed three problems with that model:

- TBC Anniversary frequently withholds hostile `UnitPosition`, while nameplates
  appear only at short range. Target, mouseover, and group-member target tokens
  are therefore the reliable discovery surface.
- A mark configured on a planner clone is part of the raid plan even when that
  clone is moved between pulls or omitted from the route. An accidental add must
  not change the active pull or steal an icon from its planned targets.
- Advancing on combat end alone treats wipes and evades as successful pulls.

WoW still requires a live unit token for `SetRaidTarget`; a GUID or combat-log
record alone cannot mark a hidden unit. Identical positionless creatures also
cannot be mapped to physical left/right clones with certainty.

The previous implementation nevertheless allocated such creatures to free
static spawn slots in list order. That made a deterministic allocation look like
physical identity and allowed a death to complete the wrong planned spawn.

## Decision

1. **Preset-wide marks.** Existing MDT `enemyAssignments` remain the canonical
   per-clone plan. The selected pull contributes exact `spawnKeys` for matching
   and completion, but does not own those marks. Explicitly marked spawns may be
   resolved outside the active pull without changing the pull selection.
2. **Evidence-preserving spawn matches.** `SpawnMatcher` returns one of:
   `exact`, `packPool`, or `unresolved`. Only `exact` carries a `spawnKey`.
   `packPool` carries a pack-scoped allocation key and candidate spawn keys;
   it never claims which physical clone was observed. Multiple matching packs
   without spatial evidence remain unresolved. List and pull order are not
   identity evidence.
3. **Token reconciliation.** Live marking reacts to target, mouseover, visible
   nameplates, and `partyNtarget`/`raidNtarget`. Selecting a pull rescans every
   currently exposed token. Positionless duplicates in one pack receive sticky
   markers from the planned candidate-mark pool without acquiring fake spawn
   identities. When multiple packs remain, only local target, mouseover, or
   nameplate observations may use clear player proximity as pack evidence;
   `partyNtarget` and `raidNtarget` never borrow the local player's position.
4. **Marker leases.** ART observes existing raid icons before applying new ones.
   Current and manual marks are never displaced. After `/reload`, an existing icon
   matching the current plan reconstructs ART's ownership lease; nonmatching icons
   remain manual. An outside-pull assignment whose icon is occupied remains pending
   and is retried after the icon holder dies.
5. **Combat application.** Native `InCombatLockdown()` is not treated as a raid
   marker prohibition. Explicit injected/API restrictions still fail closed.
6. **Exact-and-pool pull progress.** Every observed GUID has exactly one progress
   binding: either an exact `spawnKey` or an allocation pool. Exact deaths satisfy
   exact requirements; pool deaths satisfy the pool's required count. A later pool
   classification atomically replaces related exact bindings and transfers prior
   deaths once. Unresolved observations never count. A runtime pull advances only
   after all exact requirements and pool counts are complete and the group leaves
   combat. Successful `ENCOUNTER_END` remains authoritative. Wipes, evades,
   partial deaths, outside-pull activity, and combat end alone do not advance.
   Manual pull selection immediately resets and replaces runtime progress.

## Alternatives considered

- **Switch to the pull containing an accidental add:** rejected because it
  changes the tank plan while the current pull is still active.
- **Advance whenever the player leaves combat:** rejected because dead players,
  wipes, evades, and split group combat produce false completion.
- **Move an occupied icon to an accidental add:** rejected because preserving the
  current tank assignment is safer than maximizing mark coverage.
- **Infer exact clone identity from creature GUIDs:** rejected because server
  spawn components are not a portable mapping to ART's generated spawn keys.
- **Allocate ambiguous GUIDs to spawn slots in pull/list order:** rejected because
  allocation order is not evidence of physical spawn identity.

## Consequences

- Pre-pull marking works as soon as any supported unit token exists, including a
  distant mob targeted by a raid member.
- Accidental, explicitly planned adds can be marked without moving the pull; icon
  collisions remain pending rather than corrupting current assignments.
- Positionless duplicates in one known pack can be marked and can complete a
  count-based pool without corrupting physical spawn identity.
- Ambiguity across packs and unseen pull members remain conservative and require
  better evidence or manual pull selection.
- ART-0008's strict active-step restriction and combat refusal no longer apply;
  its planner input and stable-spawn principles remain valid.
