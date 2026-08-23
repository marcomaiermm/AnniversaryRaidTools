# ART-0007: Spatial raid-floor assignment

## Status

Accepted

## Date

2026-08-22

## Context

Black Temple and Karazhan contain vertically overlapping rooms and transition
areas. Assigning spawns from X/Y coordinates, NPC type, or texture landmarks
puts valid creatures on the wrong planner floor. Client `UiMap` art is also not
available for every WMO interior.

## Decision

Preserve the source database's complete world X/Y/Z position for every spawn.
Use pinned WMO group bounds and portal references as the authoritative evidence
for room membership and floor transitions. Map textures and calibration overlays
are diagnostic presentation aids only; they must not determine a spawn's floor.

The pinned WMO data remains in WMO-local coordinates. A verified WMO placement
transform and explicit group-to-planner-floor mapping are required before it may
rewrite published sublevels.

Legacy `Interface/WorldMap` textures are extracted by pinned FileDataID for
calibration. Their baked skull markers are valid per-floor position anchors;
they do not by themselves determine transition ownership.

## Alternatives considered

- **Z thresholds:** rejected because stairs and vertically overlapping rooms have
  intersecting height ranges.
- **Texture calibration:** rejected as the primary source because it is 2D and
  unavailable or encrypted for some interiors.
- **NPC-name rules:** rejected because the same trash types occur across floor
  boundaries.
- **Per-floor texture-skeleton offsets:** rejected for sublevel assignment
  because one baked skull anchor cannot separate translation from scale, and
  floors whose drawn extent differs from the client region cannot be corrected
  by translation at all.

## Consequences

- Floor assignment can distinguish vertically overlapping rooms.
- Portal geometry provides exact transition boundaries instead of guessed lines.
- Existing sublevels remain unchanged until the WMO placement and floor labels
  are verified.
- Client `UiMapAssignment` rows are accepted as the verified stand-in for the
  WMO placement: each row pins a floor's world `Region` rectangle, an optional
  base-height gate (`Region_2`), and the owning `WMOGroupID`. A spawn may move
  between published sublevels when row-level containment (region XY plus
  height gate) excludes its current floor and includes exactly one sibling
  floor that already hosts the same creature band.
- Legacy `Interface/WorldMap` Karazhan textures draw extents that differ from
  the client regions on floors 1, 10, 13, and 17 (boss-skull anchors sit up to
  half a texture away from the RZTI projection). Per-floor translation cannot
  reconcile them without pushing spawns outside normalized space; aligning
  those planner textures stays a presentation problem and must not move
  sublevel assignments.
