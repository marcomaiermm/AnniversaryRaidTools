# ART-0019: Layered testing and client verification

## Status

Accepted

## Date

2026-09-04

## Context

ART crosses pure raid-domain rules, WoW API adapters, UI/runtime lifecycle, and
behavior that only the Anniversary client can provide. The repository already
has dependency-light standalone checks in `tests/`, while the new Busted suite
under `spec/` provides isolated unit and contract coverage. A single test layer
would either make deterministic logic slow to diagnose or give mocks authority
over secure and patch-specific client behavior.

ART also supports two explicit interfaces, `20505` and `20506`. Desktop Lua and
UI simulators do not establish compatibility with either interface.

## Decision

Use four explicit test boundaries:

- **A — Pure domain logic:** Busted specs and the existing standalone checks
  cover deterministic validators, route/wave models, mark resolution, enemy
  information, and static/generated-data contracts.
- **B — WoW boundary adapters:** Busted specs use minimal API and persistence
  stubs for adapter behavior, fallback paths, and migration failure handling.
- **C — WoW UI/runtime behavior:** Busted may verify isolated orchestration, but
  frame, timer, event, and load-on-demand behavior is verified in the existing
  developer suite and client smoke where the real runtime matters.
- **D — Real-client-only behavior:** Secure marking, combat/nameplate state,
  actual `C_Map` results, AceComm delivery, taint, and interface behavior must
  be exercised on both `20505` and `20506` using `/art test` and
  `scripts/smoke-clients.md`.

The stable automated entry points are `./dev test` (Busted), `./dev coverage`
(Busted `--coverage`, then LuaCov), `./dev check` (the existing
`scripts/validate-addon.sh`, then Busted), and `./dev static`
(`wowlua_ls check .`, advisory). PUC Lua 5.1 is canonical; CI pins Busted
`2.3.0-1` and LuaCov `0.16.0-1`.

Keep the standalone validation matrix and the developer-only `/art test` suite.
Development tests and documentation remain excluded from release packaging by
`pkgmeta.yaml` and `scripts/validate-release.sh`.

Do not add `wow-ui-sim`: upstream v0.1.32 maps Anniversary to Vanilla interface
`11507`, not TBC Anniversary `20505`/`20506`, so it cannot be a compatibility
authority for layer D.

## Alternatives considered

- **Run all behavior only in a real client:** rejected because pure contracts
  and data failures would be slower and harder to isolate, while the client is
  still required for D.
- **Use broad mocks or a UI simulator for every layer:** rejected because a
  mock cannot establish secure, combat, map, communication, taint, or
  interface-specific behavior; `wow-ui-sim` targets the wrong Anniversary
  profile.
- **Replace the standalone scripts with Busted specs:** rejected because the
  existing Lua/LuaJIT/Python matrix validates source, data, and compatibility
  paths that must remain release gates.

## Consequences

- Contributors can select the narrowest trustworthy layer and still have a
  clear escalation path to both real clients.
- Automated checks remain deterministic and dependency-light; full checks keep
  the legacy matrix intact.
- Client smoke remains a required manual release signal and cannot be inferred
  from unrun desktop tests.
- `wowlua_ls` helps find static issues but remains advisory and is not exact
  patch authority for broad Classic analysis.

## Refined by

ART-0021 retains the four test boundaries and refines their deterministic
runtime-simulation and real-client AceComm coverage.
