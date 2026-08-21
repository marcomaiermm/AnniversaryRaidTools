# ART-0002: Client Compatibility

## Decision

The only target interfaces are WoW TBC Anniversary `20505` and `20506`. Both are
release gates. TOCs may declare both interfaces, but production code must not fork
domain behavior by interface number.

`Core/Compat.lua` is the boundary for API differences and absent Retail APIs.
Bootstrap and feature modules consume that boundary instead of probing and
polyfilling independently. A compatibility function must fail safely when the
client cannot provide an optional capability; required startup capability failures
must be explicit and actionable.

## Load order

1. Libraries.
2. Core bootstrap and compatibility boundary.
3. SavedVariables initialization/migration.
4. Raid registry and pure domain services.
5. Feature modules.
6. Raid data and maps.
7. UI wiring after its load-on-demand addon is available.

Only the bootstrap agent changes TOCs/loaders. Feature agents expose initialization
entry points without registering themselves; the vertical-slice integrator wires
them after dependency contracts are verified.

## Compatibility gates

- Fresh install and migrated MDT-derived SavedVariables load without Lua errors.
- UI addon enabled and disabled states are safe.
- `/art`, reload, minimap, and route import/export work on `20505` and `20506`.
- No unwrapped Retail-only API occurs on the startup/open/close path.
