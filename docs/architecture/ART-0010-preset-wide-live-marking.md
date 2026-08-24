# ART-0010: Preset-wide live marking and safe pull progression

## Status

Accepted

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

## Decision

1. **Preset-wide marks.** Existing MDT `enemyAssignments` remain the canonical
   per-clone plan. The selected pull contributes exact `spawnKeys` for matching
   and completion, but does not own those marks. Explicitly marked spawns may be
   resolved outside the active pull without changing the pull selection.
2. **Token reconciliation.** Live marking reacts to target, mouseover, visible
   nameplates, and `partyNtarget`/`raidNtarget`. Selecting a pull rescans every
   currently exposed token. Positionless duplicates in one pack use a stable,
   encounter-local GUID allocation.
3. **Marker leases.** ART observes existing raid icons before applying new ones.
   Current and manual marks are never displaced. An outside-pull assignment whose
   icon is occupied remains pending and is retried after the icon holder dies.
4. **Combat application.** Native `InCombatLockdown()` is not treated as a raid
   marker prohibition. Explicit injected/API restrictions still fail closed.
5. **Safe automatic progression.** A runtime pull advances only after every exact
   planned spawn has been bound to a live GUID and confirmed dead, then the group
   leaves combat. Successful `ENCOUNTER_END` is also authoritative. Wipes,
   evades, partial death sets, outside-pull activity, and combat end alone do not
   advance. Any manual pull selection immediately becomes authoritative.

## Alternatives considered

- **Switch to the pull containing an accidental add:** rejected because it
  changes the tank plan while the current pull is still active.
- **Advance whenever the player leaves combat:** rejected because dead players,
  wipes, evades, and split group combat produce false completion.
- **Move an occupied icon to an accidental add:** rejected because preserving the
  current tank assignment is safer than maximizing mark coverage.
- **Infer exact clone identity from creature GUIDs:** rejected because server
  spawn components are not a portable mapping to ART's generated spawn keys.

## Consequences

- Pre-pull marking works as soon as any supported unit token exists, including a
  distant mob targeted by a raid member.
- Accidental, explicitly planned adds can be marked without moving the pull; icon
  collisions remain pending rather than corrupting current assignments.
- Automatic progression is deliberately conservative. Ambiguous or unseen pull
  members require manual selection of the next pull.
- ART-0008's strict active-step restriction and combat refusal no longer apply;
  its planner input and stable-spawn principles remain valid.
