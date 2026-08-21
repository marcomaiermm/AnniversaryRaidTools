# ART-0003: Module Boundaries

## Decision

Boundaries follow ownership and data flow, not speculative layers:

| Boundary | Owns | Must not own |
|---|---|---|
| Bootstrap/Compat | client startup, API adaptation, SavedVariables root, loaders | raid semantics |
| Raid Registry | validated raid definitions and lookup by stable key | generated data creation |
| Route Preset | versioned persistence/import/export model | map rendering |
| Planner UI | route/wave editing and presentation | mark resolution or source confidence |
| Data Pipeline | deterministic generated raid records | loaders, UI, manual corrections |
| Map Calibration | coordinate transforms and floor hints | pack inference |
| Mark Resolver | deterministic profile resolution and live GUID assignments | target switching, planner mutation |
| Enemy Info | sourced metadata and bounded live observations | route mutation |
| Integrator | central registration and cross-boundary wiring | new feature semantics |

Dependencies point from UI/modules to core contracts, and from registry to merged
generated-plus-override raid definitions. Generated data never imports UI code.

## Initialization invariant

Each feature exposes an idempotent `Initialize(dependencies)` entry point and does
not edit a central loader. Initialization validates required dependencies before
registering events. Shutdown/reload must not duplicate event handlers. The
integrator is the sole owner of ordering and registration.

## Failure behavior

Invalid persisted data is rejected or migrated before feature initialization;
unknown schema versions are never guessed. Invalid raid records are omitted with a
diagnostic rather than partially registered. Missing optional enemy info or marking
data degrades that feature only, not the planner.
