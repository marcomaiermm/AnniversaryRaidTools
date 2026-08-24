# ART-0009: Separate spatial packs from pull linking

## Status

Accepted

## Date

2026-08-23

## Context

Raid-map packs serve two different purposes: they define compact visual bubbles
for overlapping blips, and they approximate which enemies enter combat together.
CMaNGOS `creature_linking` data and live Anniversary observations show that one
pull can contain several spatially distinct packs. Merging those packs makes the
map explosion layout unusable; ignoring the links makes route selection incomplete.
Pulls are also stored per floor, so a link must not select invisible floors.

## Decision

Keep `ARTPack.spawnKeys` as the spatial grouping. Add the optional stable
`ARTPack.pullGroup` key for packs which mutually enter combat. Selecting any pack
in a pull group selects every pack with that key on the same sublevel. Visual
grouping, dragging, hover, and explosion continue to use only the spatial pack.

CMaNGOS links qualify when both `FLAG_AGGRO_ON_AGGRO` and
`FLAG_TO_AGGRO_ON_AGGRO` are present. One-way encounter links do not define a
mutual pull group. Anniversary live observations may add a pull group when the
reference database differs from the live client.

## Alternatives considered

- Merge linked packs: rejected because it couples combat behavior to map layout.
- Store directed per-spawn links: deferred because current route selection needs
  mutual pack chaining only; encounter-specific one-way behavior is not a pack.
- Select linked packs across floors: rejected because route pulls are floor-local.

## Consequences

- Existing fixtures and presets remain valid because `pullGroup` is optional.
- Link data changes selection only; pack identity and bubble behavior stay stable.
- A future directed encounter graph can be added separately without changing
  spatial packs or the `pullGroup` meaning.
