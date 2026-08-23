# ART-0005: Client-map calibration overlay

## Status

Superseded by ART-0007

## Date

2026-08-22

## Context

Raid spawn coordinates and the planner textures use different coordinate spaces.
Guessing transforms from isolated boss positions hid rotation, scale, axis, and
sublevel errors.

## Decision

Developer mode can overlay the current client `UiMap` art on the planner texture.
Calibration is stored per raid and sublevel as normalized X/Y offsets, independent
X/Y scale, rotation, and alpha. It is diagnostic evidence only: changing overlay
values does not move spawns or alter published map transforms.

Where dungeon `UiMap` art is unavailable through `C_Map`, the overlay uses
offline composites of pinned Anniversary CASC minimap tiles. Karazhan, Hyjal, and
Sunwell use these local diagnostic assets. Black Temple currently exposes only
the unencrypted outdoor/training-ground region, so that composite is limited to
the Training Grounds floor. Other maps retain the live `C_Map` fallback.

## Alternatives considered

- **Continue calibrating from individual boss icons:** rejected because one anchor
  cannot distinguish translation from rotation or scale.
- **Ship copied minimap assets:** rejected because the client already provides the
  required art and copied assets would add provenance and maintenance work.

## Consequences

- The playable geometry can be aligned before applying coordinate corrections.
- Calibration values remain debug-only until reviewed and transferred explicitly
  into a raid transform or sublevel override.
