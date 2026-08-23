# ART-0006: Remaining TBC raid data integration

## Status

Accepted

## Date

2026-08-22

## Context

Serpentshrine Cavern, The Eye, and Sunwell Plateau were absent from raid
selection. Their static creatures, patrols, encounter actors, floors, and client
map identities must remain reproducible while still allowing live-client map
calibration.

## Decision

Generate all three raids from CMaNGOS TBC database commit
`da2de07e6606d495872c3fd92ba8363cf79f43c9`. Preserve source world positions and
use the live client's `C_Map` projection at runtime; normalized fixture positions
are deterministic fallbacks. Nearby source-adjacent creatures are candidate
packs, not claims about optimal pulls.

Use documented encounter anchors for bosses created dynamically instead of
inventing static spawns: The Lurker Below uses the Strange Pool location and
Felmyst uses the instance script's movement anchor. Sunwell exposes both client
floors. The generic calibration overlay from ART-0005 applies unchanged.

## Alternatives considered

- **Hand-place every icon from textures:** rejected because it is not
  reproducible and conflates texture alignment with world position.
- **Wait for live recordings:** rejected because pinned upstream data provides a
  complete candidate baseline that can be corrected by reviewed observations.

## Consequences

- The three raids participate in selection, route planning, map display, and
  calibration with the same contracts as existing raids.
- Candidate pack boundaries and dynamic encounter anchors remain reviewable; a
  live Anniversary observation may supersede them with recorded provenance.
