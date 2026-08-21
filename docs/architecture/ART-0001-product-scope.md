# ART-0001: Product Scope

## Decision

AnniversaryRaidTools is a TBC Anniversary raid planner derived from Nnoggie's
Mythic Dungeon Tools and distributed under this repository's GPL-2.0 license.
It plans ordered raid tactics on maps, preserves drawings/notes and route sharing,
supports deterministic NPC marking, and shows enemy information with provenance.

Raids use one of two modes:

- `route`: users compose and order spatial pack-based route steps.
- `waves`: raid data supplies ordered waves; users annotate assignments, marks,
  and notes without redefining wave composition.

The first integration gate is a complete Gruul's Lair vertical slice. Raid data
scales out only after its schema, UI, and marking behavior pass that gate.

## Out of scope

- Mythic+, key levels, enemy forces, timers, affixes, seasons, Fortified, or
  Tyrannical behavior.
- Automatic promotion of AzerothCore data to Anniversary-verified truth.
- A broad internal MDT-to-ART symbol rename.
- Raid-specific exceptions in shared core code.

## Success gate

On both supported clients, the addon opens a raid, displays its floors and enemies,
builds and reorders route steps, previews/applies marks, displays sourced enemy
information, and round-trips a route without Mythic+ dependencies.
