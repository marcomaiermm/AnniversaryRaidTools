# ART-0016: Roster and layered marks

## Status

Superseded by ART-0020

## Date

2026-08-26

## Context

Raid leaders need stable player marks as well as pull and floor-wide NPC rules.
Those sources can request the same icon, while NPC and CC defaults must not leak
between raid floors. The roster is personal setup data, but player assignments
must travel with the route preset.

## Decision

1. ART stores an account-local 8-by-5 roster. Presets store global player marks,
   which participate in export, import, and Live Sessions.
2. Marker priority is pull, current-floor All Mark, then global player mark. A
   floor rule reserves its marker only when that NPC occurs in the active pull.
   The highest layer supplies the visible target; if it has no CC, the row
   inherits the first CC available from the lower-priority layers on that marker.
3. NPC and CC defaults are scoped by sublevel. Legacy route-wide values migrate
   to every floor containing the referenced NPC, while existing floor values win.
4. Hostile NPC marks retain ART-0011's intentional mouseover boundary. Global
   player marks reconcile through stable raid and party unit tokens while Auto
   Mark is enabled. Foreign marker holders are never overwritten.
5. Configured players remain visible when absent from the raid. Joining a raid
   loads the UI only when Auto Mark and preset player marks need reconciliation.

## Alternatives considered

- **Share the roster:** rejected because group membership is personal setup and
  the preset already contains the portable assignment identity.
- **One route-wide NPC default:** rejected because repeated NPC IDs on different
  floors need independent plans.
- **Let player marks override NPC marks:** rejected because the active encounter
  plan must remain authoritative.

## Consequences

- The tracker, CC display, and automatic marker writer share one precedence.
- Old presets gain floor-specific behavior without losing valid defaults.
- Absent players remain planned but cannot be marked until they join.

## Superseded by

ART-0020 carries forward the roster, preset player-mark, layered NPC
precedence, floor-scoping, stable group-token reconciliation, and observed
foreign-holder decisions while replacing the nameplate and combat policies.
