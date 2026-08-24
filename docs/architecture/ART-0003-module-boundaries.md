# ART-0003: Module Boundaries

## Status

Accepted

## Date

2026-08-21

## Context

ART combines inherited UI code, pure raid-domain services, generated data, and
client lifecycle wiring. Explicit ownership is needed to prevent generated data,
UI behavior, and compatibility concerns from becoming mutually dependent.

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
| Spawn Matcher | exact spawn evidence and ambiguous allocation pools | marker assignment, pull progress |
| Mark Resolver | deterministic profile resolution and live GUID assignments | target switching, planner mutation |
| Pull Progress | exclusive exact-spawn or pool GUID bindings and death completion | unit discovery, marker assignment |
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

Static data loaded by TOC/XML publishes through the versioned static-data contract;
chunk return values are retained only for tests and tooling. Publication is not
registration: the integrator validates and registers published values explicitly.

## Alternatives considered

- **Let feature modules self-register:** rejected because loader order and reload
  behavior would be distributed across modules.
- **Introduce a generic service framework:** rejected because the listed ownership
  boundaries and injected dependencies are sufficient.

## Consequences

- The integrator owns ordering and registration, while feature initialization is
  idempotent.
- UI modules depend on core contracts; generated data never depends on UI code.
- Boundary changes require updating the related contract or this ADR rather than
  adding cross-layer exceptions.
