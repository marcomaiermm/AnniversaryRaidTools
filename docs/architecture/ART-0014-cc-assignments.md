# ART-0014: Marker-keyed crowd-control assignments

## Status

Accepted

## Date

2026-08-26

## Context

Raid routes already identify priority targets through raid markers. A separate CC
table would force planners to maintain the same targets twice and would not give
the live tracker a stable way to match combat-log auras to planned enemies.
Assignments must also survive floor changes, Hyjal wave reconstruction, exports,
and temporary roster changes.

## Decision

1. A pull stores optional CC overrides by stable spawn key. The preset stores
   optional raid defaults by NPC ID and marker. A pull override wins; removing it
   reveals the raid default.
2. Assigning an unmarked map target selects a free marker in the same atomic
   action. Raid defaults are edited by right-clicking existing Auto Mark icons.
   No separate assignment table or navigation mode is introduced.
3. The current-pull tracker resolves the same marker-keyed assignments and adds
   local combat-log runtime state. UnitAura is authoritative when the target is
   visible; pinned TBC max-rank durations are the fallback.
4. Live Sessions carry versioned assignment changes. Receivers verify the
   sender is the current raid leader or an assistant and validate the target
   against the active Live preset before mutation.
5. Assignees persist as `Name-Realm` plus class. A missing player remains visible
   and can be replaced instead of silently losing the route plan.

## Alternatives considered

- **Separate assignment tab:** rejected because it duplicates marked targets and
  makes per-pack editing slower.
- **Assignments by NPC ID only:** rejected because duplicate NPCs in one pull can
  require different players.
- **Synchronize timers:** rejected because every client observes the combat log;
  synchronizing derived state adds drift and failure modes.
- **Inspect talents:** rejected because inspection is incomplete and unnecessary;
  talent-dependent options are labelled instead.

## Consequences

- Marks remain the single live identity shared by automarking, the map, and CC.
- Old presets remain valid because both saved fields are optional.
- Pull lifecycle operations must preserve or deliberately remove CC metadata.
- Runtime matching cannot start until the planned target has its raid marker.

