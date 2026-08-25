# ART-0001: Product Scope

## Status

Accepted

## Date

2026-08-21

## Context

ART targets TBC Anniversary raids. The project needs a narrow target that
keeps unrelated dungeon and Retail systems outside the raid domain.

## Decision

AnniversaryRaidTools is a TBC Anniversary raid planner distributed under this
repository's GPL-2.0 license.
It plans ordered raid tactics on maps, preserves drawings/notes and route sharing,
supports deterministic NPC marking, and shows enemy information with provenance.

Raids use one of two modes:

- `route`: users compose and order spatial pack-based route steps.
- `waves`: raid data supplies ordered waves; users annotate assignments, marks,
  and notes without redefining wave composition.

The first integration gate is a complete Gruul's Lair vertical slice. Raid data
scales out only after its schema, UI, and marking behavior pass that gate.

## Out of scope

- Dungeon keys, timers, affixes, seasonal routing, or difficulty modifiers.
- Automatic promotion of AzerothCore data to Anniversary-verified truth.
- Raid-specific exceptions in shared core code.

## Alternatives considered

- **Rewrite the addon before shipping a raid:** rejected because a vertical slice
  validates the inherited UI and new contracts with less risk.

## Success gate

On both supported clients, the addon opens a raid, displays its floors and enemies,
builds and reorders route steps, previews/applies marks, displays sourced enemy
information, and round-trips a route without dungeon-routing dependencies.

## Consequences

- Domain code uses raid, route, and wave concepts.
- Gruul's Lair remains the integration gate before broad raid-data expansion.
