# ART-0021: Deterministic runtime simulation and AceComm self-whisper

## Status

Accepted

## Date

2026-09-04

## Context

ART-0019 established four test boundaries, but the runtime paths need a
focused deterministic layer for event-driven nameplate ownership and
communication delivery. These paths can be exercised without pretending that
an offline Lua process is a WoW client or a general emulator.

The new runtime specs use explicit event emission, small unit registries, and a
bounded two-peer queue. Those test doubles make ART's own state transitions
repeatable. Communication has a separate boundary: offline delivery can prove
ART packet semantics, while only a real client can establish the actual ART
codec path and AceComm fragmentation/dispatch.

## Decision

1. Retain ART-0019's four boundaries and canonical PUC Lua 5.1 runtime. New
   specs under `spec/runtime/**/*_spec.lua` are discovered by the existing
   `.busted` pattern alongside `spec/core/`; no second test framework or
   discovery path is added.
2. Runtime specs may emit the events that ART registers and inspect observable
   state after each emission. They prove ART event wiring, policy branches,
   eligibility decisions, resolver and runtime ownership transitions, and
   deterministic cleanup. They do not prove Blizzard event ordering, unit-token
   lifecycle, actual nameplate timing, secure API behavior, taint, or client
   icon clearing.
3. Runtime specs may provide a minimal unit registry for token-to-GUID,
   identity, marker, friendliness, death, and availability observations. The
   registry proves ART's decisions from those observations, not the behavior or
   completeness of Blizzard's `Unit*` APIs.
4. Offline communication specs use two isolated peer namespaces and explicit
   queues. They prove ART packet/envelope semantics, sender and distribution
   handling, and deterministic delivery after a controlled flush. They do not
   claim the real ART codec, AceComm fragmentation, throttling, or dispatch
   fidelity.
5. A real-client self-whisper check sends a deliberately large ART payload via
   AceComm `WHISPER` to the local player and observes the registered receive
   handler. This is the only test boundary that may claim actual ART
   serialization/compression and AceComm fragmentation/dispatch, and it
   requires no raid.
6. RAID fanout, secure marking, taint, actual nameplate timing, and all
   interface-specific behavior for **20505** and **20506** remain client smoke
   coverage. Passing an offline runtime spec or the self-whisper does not imply
   any of those behaviors.

## Alternatives considered

- **Build a broad WoW emulator:** rejected because reproducing Blizzard's
  secure, event, unit-token, nameplate, and interface behavior would be both
  larger and less authoritative than the supported clients.
- **Treat two-peer queues as AceComm coverage:** rejected because a queue can
  verify ART's packet contract and deterministic handler delivery, but it does
  not implement AceComm's wire and dispatch behavior.
- **Require a raid for every communication check:** rejected because a
  self-whisper isolates the real ART codec and AceComm receive/fragmentation
  path without introducing group state or fanout noise.

## Consequences

- Runtime regressions are fast and deterministic, with each test owning its
  namespace, event source, unit observations, and peer queue.
- Test reports must state whether they prove ART semantics or real-client
  behavior; mocks never authorize a Blizzard compatibility claim.
- Client smoke remains required for raid communication, secure marking, taint,
  nameplate timing, and interfaces 20505/20506 even when all desktop specs
  pass.

## Refines

ART-0019. Its four-boundary model remains accepted; this ADR narrows the
runtime simulation contract and adds the real-client self-whisper boundary.
