# Testing Anniversary Raid Tools

ART has four test boundaries. Choose the narrowest layer that can observe the
behavior, then use the real client when the behavior depends on WoW itself.

## Choose a layer

| Layer | Boundary | Representative paths | Use this layer for |
|---|---|---|---|
| **A — Pure domain logic** | Deterministic data and rules with no WoW calls | `Core/RaidRegistry.lua`, `Core/RoutePreset.lua`, `Core/MarkResolver.lua`, `Core/EnemyInfoRepository.lua` | Schema validation, route/wave invariants, mark resolution, provenance, and generated-data contracts |
| **B — WoW boundary adapters** | Small wrappers around client APIs and persistence | `Core/Compat.lua`, `Core/SavedVariables.lua`, and adapter portions of `Modules/EnemyInfo.lua` and `Modules/RaidEnemyInfo.lua` | API fallbacks, SavedVariables migration, and failure behavior using a minimal API stub |
| **C — WoW UI/runtime behavior** | Frames, widgets, timers, events, and load-on-demand wiring | `AnniversaryRaidTools_UI/Bootstrap.lua`, `Modules/MainFrame.lua`, `Modules/MapView.lua`, `Core/Lifecycle.lua`, `AceGUIWidgets/` | UI orchestration and lifecycle behavior that can be isolated without claiming client implementation compatibility |
| **D — Real-client-only behavior** | Secure or patch-specific behavior that a desktop runtime cannot reproduce | `Modules/QuickMark.lua`, `Modules/LiveMarks.lua`, `Modules/Transmission.lua`, and client-facing bootstrap paths | Secure marking, combat/nameplate state, actual `C_Map` results, ART serialization/compression, AceComm fragmentation/dispatch, taint, and interface-specific behavior |

Static and generated raid data (`Raids/TBC/Generated/`, `Raids/TBC/Maps/`,
`Raids/TBC/Transforms/`, and `Data/EnemyInfo/`) supports layer A. It is not a
separate test layer. The data publication contract is exercised independently
of UI loading and then validated before registration.

A mock can prove that ART calls an adapter correctly; it cannot prove that a WoW
API has the expected behavior on an Anniversary build. Do not turn a C or D
requirement into an A/B test merely to avoid a client run.

## Busted specs

New automated specs live under `spec/**/*_spec.lua`. The existing `.busted`
configuration discovers both the established `spec/core/` specs and the focused
`spec/runtime/` specs; do not add a second discovery path. All specs use the
shared `spec/setup.lua` helper. Busted is the fast, isolated layer for A and
for the testable portions of B and C.

`spec/runtime/` is a deterministic runtime simulation, not a general WoW
emulator. Its explicit event emission exercises ART's event handlers and
observable state transitions. Its minimal unit registries exercise the token,
GUID, marker, eligibility, resolver-ownership, and configured-policy decisions
that ART makes from those observations. Its two-peer queues exercise ART
packet semantics and deterministic delivery between test peers. These prove
ART's wiring and decisions only; they do not prove Blizzard event ordering,
unit-token/nameplate timing, `SetRaidTarget` or secure behavior, taint, icon
clearing, the real ART codec, or AceComm fragmentation/dispatch.

Keep mocks minimal: provide only the WoW functions the unit needs, load the
private addon namespace explicitly, and reset global/module state between
examples so one spec cannot authorize another. The runtime remains canonical
PUC Lua 5.1. Specs must not require a Retail API, a WoW installation, or the
real addon folders.

## Existing standalone checks

The repository's standalone checks remain in `tests/` and are still part of the
validation matrix:

- `tests/data/*.lua`, `tests/maps/*.lua`, `tests/marking/*.lua`,
  `tests/enemy-info/*.lua`, and `tests/route/*.lua` run as dependency-light Lua
  scripts under both PUC Lua 5.1 and LuaJIT.
- `tests/integration/*.lua` run under both runtimes through the existing
  scenario modes (`normal`, `missing-enemy`, `invalid-enemy`, `corrupt-route`,
  and `invalid-store`).
- `tests/data/*.py` checks the data pipeline with Python 3.

Do not delete or rename these checks when adding a Busted spec. The full legacy
matrix is run by `./scripts/validate-addon.sh` and by `./dev check`.

## Commands

Run commands from the repository root.

| Command | What it runs | Gate |
|---|---|---|
| `./dev test` | Busted specs under `spec/` | Required automated behavior check when specs or covered runtime change |
| `./dev coverage` | Busted with `--coverage`, then `luacov` | Local coverage report; not a substitute for the validation matrix or client smoke |
| `./dev check` | Existing `scripts/validate-addon.sh`, then Busted specs | Required full automated check before review/release |
| `./dev static` | `wowlua_ls check .` | Advisory only; diagnostics do not replace tests or client verification |

`./dev check` is intentionally ordered so the existing TOC/XML, syntax,
namespace, provenance, data, and standalone-test validation runs before the
Busted suite. The commands report what they execute; this guide does not claim
that any command has been run for a particular change.

### Prerequisites

The automated commands require Bash, PUC Lua 5.1 (`lua5.1` and `luac5.1`),
LuaJIT, LuaRocks, Subversion, Python 3, and `realpath`. CI pins Busted
`2.3.0-1` and LuaCov `0.16.0-1`; use those versions when reproducing CI
locally. The addon runtime libraries are declared in `pkgmeta.yaml` and loaded
by the two addon XML manifests; they are not a reason to add a second test
framework.

`wowlua_ls` `v0.30.5` is optional and advisory. It is beta, and broad Classic
analysis is not exact patch authority. The `.wowluarc.json` configuration excludes
out-of-client tests and generated release artifacts, omits only the oversized
generated `WorldPositions` data that exceeds the analyzer safety limit, and
keeps vendored libraries as library inputs without diagnostics.

## Real-client verification

Layer D and the client-dependent parts of C require both WoW TBC Anniversary
interfaces: **20505 and 20506**. Use a clean copy of the addon, keep the client
error reporter enabled, and follow [`scripts/smoke-clients.md`](../scripts/smoke-clients.md).
The manual protocol covers fresh and migrated SavedVariables, `/art` open/close
and reload, minimap behavior, route and wave editing/import/export, mark
preview and application, and sourced enemy information. A step passes only
when the expected behavior occurs with no Lua error, taint warning, stuck
loading spinner, or duplicate UI/event handler.

The real-client self-whisper check sends a deliberately large ART payload
through AceComm `WHISPER` to the local player and observes the registered
receive handler. It covers actual ART serialization/compression and AceComm
fragmentation/dispatch without requiring a raid. It does not authorize RAID
fanout or any other client-only behavior; group fanout, secure marking, taint,
nameplate timing, and interface-specific behavior remain client smoke on both
interfaces.

The developer-only `/art test` command is the existing in-client smoke suite.
It exercises the `Developer/Tests/` files after the UI loads and complements,
not replaces, the automated checks. Developer tests are not release content:
`pkgmeta.yaml` excludes `Developer/`, `tests/`, `docs/`, and `scripts/`, and
`scripts/validate-release.sh` rejects ignored/development paths while checking
the packaged core and load-on-demand UI manifests.
Do not add `wow-ui-sim` as a substitute for the real clients. Upstream
`wow-ui-sim` v0.1.32 maps its Anniversary profile to the Vanilla interface
`11507`, not TBC Anniversary interfaces `20505`/`20506`. It cannot authorize the
patch-specific secure, combat, nameplate, map, or communication behavior that
layer D needs.

For the runtime load chain and ownership boundaries, see
[`architecture/README.md`](architecture/README.md),
[`ART-0019`](architecture/ART-0019-layered-testing.md), and
[`ART-0021`](architecture/ART-0021-deterministic-runtime-and-self-whisper.md).
