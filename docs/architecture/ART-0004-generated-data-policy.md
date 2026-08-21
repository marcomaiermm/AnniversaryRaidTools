# ART-0004: Generated Data Policy

## Decision

`Raids/TBC/Generated/**` is written only by the data generator. Humans never edit
generated output. Reviewed corrections live in `Raids/TBC/Overrides/**` and identify
the stable record key, replacement fields, reason, and provenance.

Generation from the same source snapshot and generator version must be
byte-identical. Ordering, key allocation, numeric formatting, and serialization are
deterministic. Every derived spawn, pack, patrol, and enemy-info fact carries the
provenance contract. AzerothCore observations default to `candidate` or
`review-required`, never `verified` merely because they exist upstream.

## Merge and validation

The raid registry overlays explicit override fields onto generated records by
stable key; overrides may not create dangling references or mutate keys. Validators
reject duplicate keys, missing pack members, invalid coordinates, unordered patrol
points, unknown provenance values, and undeclared schema versions.

Every generated-data handover records the AzerothCore commit/database version,
export timestamp, generator version, map/instance IDs, coverage, overrides, and
uncertainties. Preserve upstream attribution and this repository's GPL-2.0 terms.
