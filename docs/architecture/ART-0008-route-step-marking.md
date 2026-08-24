# ART-0008: Route-step marking and step activation

## Status

Superseded by ART-0010

## Date

2026-08-23

## Context

External auto-mark WeakAuras resolve raid targets by NPC id alone and re-assign
fresh markers on mouseover during combat, which accidentally marks unplanned or
already-planned packs. ART plans routes on a map, so marking must instead be a
planned artifact: the planner decides which spawn instances receive which raid
marker, and only those instances are ever marked in the world.

Constraints:

- Generated raid data provides stable spawn keys per spawn instance; route steps
  already validate `step.marks[spawnKey]` against their own packs.
- The MarkResolver contract (marking-profile.md) already enforces active-step
  restriction, GUID-sticky assignments, combat refusal, and foreign-marker
  preservation, but nothing activates a step at runtime and no UI writes
  `step.marks`.
- Spawn coordinates for Gruul's Lair, Hyjal, and Magtheridon's Lair are
  fixture-derived ("review-required"), so position-based live matching cannot be
  trusted yet.

## Decision

1. **Strict step-bound marks.** The context menu and quick-mark input write
   `step.marks[spawnKey]` on the route step containing that spawn's pack
   (preferring the active step when several steps contain it). Packs outside
   every route step cannot receive marks; the UI states this instead of storing
   marks elsewhere. `marking.packOverrides` remains a documented escape hatch,
   not a second UI storage location.
2. **Mixed step activation.** The preset carries `currentStepId` and
   `currentStepPinned`. Without a pin the planner derives the active step from
   the selected pull: waves raids map pull index to wave step directly; route
   raids match the pull enemies' packs against step packs with hysteresis (the
   currently active step wins ties). An explicit selection pins the step until
   unpinned; unpinning re-syncs from the last seen pull.
3. **Plan-side assignment input.** Hovering a planner blip and pressing 1-8, or
   the player's own Blizzard `RAIDTARGET1..8` bindings read via
   `GetBindingKey`, assigns the marker in the plan. No ART-specific binding
   entries are added.
4. **Live application stays resolver-only.** Target changes apply one planned
   mark. Mouseover of an active-pack member scans the currently visible
   nameplate unit tokens and applies marks only to members resolved to that same
   pack. Every world change still passes through `MarkResolver:ApplyUnit`; the
   resolver refuses fresh assignments in combat. Position matching is preferred,
   with the existing unambiguous npc-id fallback when measurement data is absent.
5. **Legacy compatibility.** Non-ART presets keep MDT `enemyAssignments`
   behavior; ART blips render markers from `step.marks` with legacy fallback.

## Alternatives considered

- **npcId-only live matching:** rejected as primary strategy - it reproduces the
  WeakAura misfire inside the active step when one npc id spans multiple packs.
- **Position-based live matching only:** deferred - accurate in principle (both
  sides share the uiMap projection), but three raids lack verified world
  positions; a measurement tool will decide before enabling it.
- **Pack-bound marks independent of steps:** rejected for v1 - two storage
  locations for marks increase explanation cost; kept as escape hatch.
- **Always-explicit activation:** rejected - friction on every pull selection.
- **Always-auto activation:** rejected - breaks "mark pack 3 while pulling pack
  1" workflows.
- **Mark every visible active-step nameplate immediately:** rejected - mouseover
  is the deliberate pack-level trigger, so merely approaching a planned pack has
  no world-side effect.

## Consequences

- Marking is fail-closed: without an active step, or for spawns outside it,
  nothing is marked; the worst case is a missing marker, never a wrong-pack
  marker.
- The preset schema gains two roundtrip-safe fields (`currentStepId`,
  `currentStepPinned`); absent fields default to auto mode.
- The resolver stays pure; activation logic lives in the planner boundary.
- Follow-ups: in-client verification of the candidate-derived world positions.
