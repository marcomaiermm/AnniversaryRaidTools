# ART-0004: Generated Data Policy

## Decision

`Raids/TBC/Generated/**` is written only by the data generator. Humans never edit
generated output. Reviewed corrections live in `Raids/TBC/Overrides/**` and identify
the stable record key, replacement fields, reason, and provenance.

Generation from the same source snapshot and generator version must be
byte-identical. Ordering, key allocation, numeric formatting, and serialization are
deterministic. Every derived spawn, pack, patrol, and enemy-info fact carries the
provenance contract.

For TBC raid spawns, patrol paths, and spawn-entry alternatives, the primary
upstream is a pinned CMaNGOS TBC database snapshot. AzerothCore WotLK is only a
secondary cross-check or fallback when TBC data is absent. Anniversary live-client
observations may calibrate or override either source when their provenance is
recorded explicitly. Upstream observations default to `candidate` or
`review-required`, never `verified` merely because they exist upstream.

## Merge and validation

The raid registry overlays explicit override fields onto generated records by
stable key; overrides may not create dangling references or mutate keys. Validators
reject duplicate keys, missing pack members, invalid coordinates, unordered patrol
points, unknown provenance values, and undeclared schema versions.

Every generated-data handover records the primary source repository, pinned commit
and database version, export timestamp, generator version, map/instance IDs,
coverage, overrides, and uncertainties. Preserve upstream attribution and this
repository's GPL-2.0 terms.

Generated Lua artifacts publish and return the same immutable value according to
`docs/contracts/static-data-publication.md`. The publication wrapper is emitted by
the generator and never edited in generated output.
