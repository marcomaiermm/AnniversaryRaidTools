# ART-0002: Client Compatibility

## Status

Accepted

## Date

2026-08-21

## Context

Interfaces `20505` and `20506` expose a smaller and potentially different API
surface than Retail. Scattered feature-level probes would make startup behavior
and client support difficult to verify.

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
7. UI wiring inside the root addon.

The bootstrap boundary initializes the static-data publication tables defined by
`docs/contracts/static-data-publication.md` before raid or enemy-info data loads.
Client API payload differences, including combat-log event retrieval, remain in
`Core/Compat.lua` and are injected into feature modules by the integrator.

Only the bootstrap agent changes TOCs/loaders. Feature agents expose initialization
entry points without registering themselves; the vertical-slice integrator wires
them after dependency contracts are verified.

## Alternatives considered

- **Probe client APIs inside each feature:** rejected because fallback behavior
  and failure messages would diverge.
- **Support one interface per release:** rejected because both Anniversary
  interfaces are explicit release targets.

## Consequences

- Client API differences are centralized in `Core/Compat.lua`.
- Every release requires automated validation plus manual smoke coverage on both
  target interfaces.
- Optional missing capabilities degrade safely; required capability failures must
  remain actionable.

## Compatibility gates

- Fresh install and migrated MDT-derived SavedVariables load without Lua errors.
- The integrated UI opens without a second addon folder.
- `/art`, reload, minimap, and route import/export work on `20505` and `20506`.
- No unwrapped Retail-only API occurs on the startup/open/close path.
