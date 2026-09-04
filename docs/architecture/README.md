# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs), including
accepted and superseded decisions. ADRs explain durable decisions and their
trade-offs; contracts in `../contracts/` define exact data shapes and
validation rules.

The runtime is split into two addons:

1. `AnniversaryRaidTools.toc` is the always-loaded core for startup, commands,
   communications, combat logging, SavedVariables metadata, and the public API.
   It loads `libs/load_core_libs.xml`, then `BuildCheck.lua`,
   `Core/Compat.lua`, `Core/Bootstrap.lua`, and `Core/CombatLogging.lua`.
2. `AnniversaryRaidTools_UI/AnniversaryRaidTools_UI.toc` is a load-on-demand
   addon depending on the core. It loads `libs/load_libs.xml`, its private
   bootstrap, locales, custom AceGUI widgets, `Core/SavedVariables.lua`, the
   UI runtime, and `Modules/load_modules.xml`. The core calls
   `AnniversaryRaidTools_UI` only when the planner or a UI-backed feature is
   needed.

WoW passes each Lua file its addon name and private addon table through chunk
varargs (`local addonName, ART = ...` or `local _, ART = ...`). ART does not
publish a compatibility `_G.ART`; the core publishes the narrower
`_G.AnniversaryRaidToolsAPI`, and the UI attaches its private table to that
bridge. The UI bootstrap uses an API metatable for core calls rather than
sharing the UI table globally.

The core TOC declares `AnniversaryRaidToolsDB` and
`LoadSavedVariablesFirst: 1`. Core bootstrap establishes the root schema and
the UI-side `Core/SavedVariables.lua` adds the AceDB-backed runtime defaults and
route store. The core library XML loads LibStub, CallbackHandler, AceComm,
LibDataBroker, and LibDBIcon; the UI library XML adds AceDB, AceGUI,
AceSerializer, LibCompress, LibDeflate, and LibAsync. `pkgmeta.yaml` owns the
external library sources.

The source tree keeps the UI nested for development. Packaging moves it beside
the core addon, and `scripts/link-dev-ui.sh` exposes that sibling layout in a
local WoW checkout. See [ART-0015](ART-0015-load-on-demand-performance.md).

## Ownership and test boundaries

Boundaries follow runtime ownership and data flow:

| Category | Boundary | Representative paths | Trustworthy test layer |
|---|---|---|---|
| **A** | Pure domain logic | `Core/RaidRegistry.lua`, `Core/RoutePreset.lua`, `Core/MarkResolver.lua`, `Core/EnemyInfoRepository.lua`; static/generated raid data supports this boundary | Busted specs and existing standalone Lua/Python checks |
| **B** | WoW boundary adapters | `Core/Compat.lua`, `Core/SavedVariables.lua`, adapter portions of `Modules/EnemyInfo.lua` and `Modules/RaidEnemyInfo.lua` | Busted with minimal API/persistence mocks; escalate to client for patch behavior |
| **C** | WoW UI/runtime behavior | `AnniversaryRaidTools_UI/Bootstrap.lua`, `Modules/MainFrame.lua`, `Modules/MapView.lua`, `Core/Lifecycle.lua`, `AceGUIWidgets/` | Isolated Busted orchestration, including `spec/runtime/`, plus `/art test` and smoke where frames/events are real |
| **D** | Real-client-only behavior | Secure/combat/nameplate/actual `C_Map`/AceComm paths in `Modules/QuickMark.lua`, `Modules/LiveMarks.lua`, `Modules/Transmission.lua`, and bootstrap paths | `/art test` and `scripts/smoke-clients.md` on both `20505` and `20506`; self-whisper covers real AceComm without raid fanout |

`spec/runtime/` is discovered by the existing `.busted` pattern. Its event
emission, unit registries, and two-peer queues prove ART-level runtime
transitions, ownership, policy, and packet semantics only. They do not prove
Blizzard event/token timing, secure marking, taint, icon clearing, the real ART
codec, or AceComm fragmentation/dispatch; those remain client checks.

Static-data producers publish through `ART.StaticData` and are validated and
registered by the integration boundary; they do not register themselves or
import UI code. For the test command matrix and escalation rules, see
[`../testing.md`](../testing.md), [ART-0019](ART-0019-layered-testing.md), and
[ART-0021](ART-0021-deterministic-runtime-and-self-whisper.md).

## Index

| ADR | Status | Decision |
|---|---|---|
| [ART-0001](ART-0001-product-scope.md) | Accepted | Product scope and planning modes |
| [ART-0002](ART-0002-client-compatibility.md) | Accepted | Supported clients and compatibility boundary |
| [ART-0003](ART-0003-module-boundaries.md) | Accepted | Module ownership and dependency direction |
| [ART-0004](ART-0004-generated-data-policy.md) | Accepted | Generated raid-data ownership and provenance |
| [ART-0005](ART-0005-map-calibration-overlay.md) | Superseded by ART-0007 | Live client-map calibration overlay |
| [ART-0006](ART-0006-remaining-tbc-raids.md) | Accepted | SSC, The Eye, and Sunwell data integration |
| [ART-0007](ART-0007-spatial-floor-assignment.md) | Accepted | XYZ and WMO portal-based floor assignment |
| [ART-0008](ART-0008-route-step-marking.md) | Superseded by ART-0010 | Route-step marking and activation |
| [ART-0009](ART-0009-spatial-packs-and-pull-linking.md) | Accepted | Spatial packs and pull linking |
| [ART-0010](ART-0010-preset-wide-live-marking.md) | Superseded by ART-0011 | Preset-wide token reconciliation and automatic progress |
| [ART-0011](ART-0011-intentional-mouseover-marking.md) | Superseded by ART-0016 | Intentional mouseover marking with pull/global precedence |
| [ART-0012](ART-0012-hyjal-wave-mode.md) | Accepted | Hyjal wave composition and approximate route presentation |
| [ART-0013](ART-0013-live-raid-progress-sync.md) | Accepted | Authorized pull and wave synchronization through Live Sessions |
| [ART-0014](ART-0014-cc-assignments.md) | Accepted | Marker-keyed pull/default CC assignments and local aura tracking |
| [ART-0015](ART-0015-load-on-demand-performance.md) | Accepted | Load-on-demand UI and active raid projection |
| [ART-0016](ART-0016-roster-and-layered-marks.md) | Superseded by ART-0020 | Local roster, player marks, and three-layer mark precedence |
| [ART-0018](ART-0018-persistent-live-session-routes.md) | Accepted | Persistent Live Session routes and authorized route sharing |
| [ART-0019](ART-0019-layered-testing.md) | Accepted | Layered automated testing and real-client verification (refined by ART-0021) |
| [ART-0020](ART-0020-configurable-nameplate-policy.md) | Accepted | Configurable nameplates and ART-owned marker rebalancing |
| [ART-0021](ART-0021-deterministic-runtime-and-self-whisper.md) | Accepted | Deterministic runtime simulation and real-client AceComm self-whisper |

## Convention

1. Copy [template.md](template.md) to `ART-NNNN-short-title.md` using the next
   number.
2. Use status `Proposed`, `Accepted`, `Deprecated`, or
   `Superseded by ART-NNNN`.
3. Record context, the decision, real alternatives, and consequences.
4. Never delete an ADR. Supersede it with a new one and link both records.
5. Update the index when an ADR is added or changes status.

Write an ADR only when reversing the choice would be costly or when future
contributors would otherwise repeat the same design debate.
