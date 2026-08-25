# ART-0012: Hyjal wave mode

## Status

Accepted

## Date

2026-08-25

## Context

Hyjal is a scripted sequence of 37 immutable waves rather than a spatial trash
route. Its source data repeats many actors at shared scripted spawn points, so
normal enemy pins overlap and imply a positional accuracy the data cannot
support. The patrol sequences and camp assignments are still useful for raid
orientation.

## Decision

1. Raids with `mode = "waves"` may opt into a dedicated presentation through
   map `waveMode.groups` metadata. Hyjal groups its waves by the five bosses.
2. Wave mode hides normal enemy pins. The selected wave is represented by an
   aggregated NPC composition card, its camp POI, and deduplicated approximate
   patrol paths.
3. Wave selection continues to use the immutable pull projection, preserving
   the existing planner, tracker, and live-mark activation boundaries.
4. Marker toggles on the composition card write an NPC marker pool only to the
   selected step. The existing `step.marks` schema remains authoritative.
5. In instance 534, Classic UI widget 3121 is the authoritative local wave
   signal. Boss combat establishes boss steps and group transitions. Automatic
   selections reuse the normal pull-selection and Live Session boundaries, but
   are deferred while the map planner is visible so manual marking work is not
   replaced. Closing the planner applies the latest observed wave.

## Alternatives considered

- **Correct every Hyjal spawn coordinate:** rejected because scripted actors do
  not have one meaningful static combat position.
- **Remove the map entirely:** rejected because camps and movement direction are
  useful orientation context.
- **Keep one pin per active-wave actor:** rejected because even a single wave has
  many overlapping actors at shared spawn points.

## Consequences

- Hyjal presents honest composition and movement information without hundreds
  of overlapping pins.
- Patrol paths are explicitly approximate and do not participate in live unit
  matching.
- Normal route raids retain their existing map and pull UI unchanged.
- Hyjal's floating tracker has no manual Next button; map-card arrows and the
  wave list remain available for offline planning.
