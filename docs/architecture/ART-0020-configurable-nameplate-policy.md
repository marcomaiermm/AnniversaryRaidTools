# ART-0020: Configurable nameplates and owned-marker rebalancing

## Status

Accepted

## Date

2026-09-04

## Context

ART-0016 established the local roster, preset-scoped player marks, layered NPC
precedence, and stable group-token reconciliation, but it did not record the
user-selected policy for visible nameplates. ART has a separate `autoMark`
master switch, which defaults to disabled, and now exposes a setting for
whether visible hostile nameplates may trigger automatic marking once that
master switch is enabled.

The policy must remain conservative around marker ownership. Pull and
current-floor NPC rules are encounter plan data; configured player marks are a
separate layer, and an observed foreign marker holder must not be displaced
merely to satisfy ART configuration.

The runtime also needs one explicit combat rule. ART can distinguish its own
known leases from observed foreign holders, so higher-priority encounter rules
can safely rebalance the former without claiming ownership of the latter.

## Decision

1. This ADR supersedes ART-0016. It carries forward its roster, preset
   player-mark, layered NPC, floor-scoping, reconciliation, and observed
   foreign-holder decisions while replacing its nameplate and combat policies.
2. Persist the account setting `autoMarkNameplates` in the global SavedVariables
   table; at runtime it is exposed as `ART:GetDB().autoMarkNameplates`, with a
   saved default of `true`. The Settings checkbox **Automatically mark visible
   nameplates** edits this value. The separate `autoMark` master switch remains
   the gate for all automatic marking and defaults to `false`.
3. When Auto Mark and `autoMarkNameplates` are both enabled, a
   `NAME_PLATE_UNIT_ADDED` observation may mark an eligible visible hostile NPC
   using the normal pull-then-current-floor NPC rules. The event is an
   opportunity, not a promise that every nameplate receives a marker: unit
   eligibility, permission, available markers, and current ownership still
   apply.
4. Pull and current-floor NPC rules outrank configured player marks whenever
   ART owns the competing marker, including during combat. ART may likewise
   rebalance known ART-owned NPC leases by the existing pull/floor priority.
   Existing observed foreign marker holders remain protected and are never
   overwritten.
5. When `autoMarkNameplates` is `false`, nameplate events are observation-only:
   ART may record visible tokens and occupied markers for ownership decisions,
   but it does not write a raid target because a nameplate appeared. The
   existing intentional mouseover boundary remains for hostile mouseover
   writes.
6. A `UNIT_DIED` observation releases ART's runtime and resolver ownership for
   the dead GUID. Desktop runtime tests do not claim that this operation clears
   the client's visible raid icon.

## Alternatives considered

- **Preserve every occupied ART marker during combat:** rejected because a stale
  lower-priority ART lease must not block the active pull plan. Only known
  ART-owned holders are eligible for combat rebalancing.
- **Keep nameplates observation-only:** rejected because users who enable Auto
  Mark need a direct, configurable way to mark eligible visible hostile units.
- **Enable nameplate writes regardless of a setting:** rejected because
  incidental nameplate discovery would remove the user's ability to choose
  observation-only behavior.
- **Let configured player marks displace NPC marks, or displace observed foreign
  marks:** rejected because encounter pull/floor rules and other players'
  observed marker ownership must remain authoritative and safe.

## Consequences

- Existing users have an explicit nameplate policy: once they enable Auto Mark,
  visible-nameplate marking is on by default and can be disabled without
  disabling observation or player-mark reconciliation.
- The same resolver and ownership rules govern mouseover and nameplate paths;
  the toggle changes the trigger, not the mark precedence or safety rules.
- Combat changes when ART may rebalance its own known leases, not the rule that
  observed foreign holders remain protected.
- Runtime specs can prove the setting branch, event wiring, and ART ownership
  transitions, while actual nameplate timing, secure marking, taint, and icon
  behavior remain real-client checks.

## Supersedes

ART-0016. Its roster, preset player-mark, layered NPC, floor-scoping,
reconciliation, and observed foreign-holder decisions are carried forward;
this ADR replaces its visible-nameplate and combat policies.
