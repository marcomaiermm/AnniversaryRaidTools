# Agent Task Graph

Shared contracts freeze at ART-000. No dependent implementation starts before that
freeze; a contract change repeats the gate for affected tasks.

```text
ART-000 Contracts ─┬─> ART-010 Bootstrap ─> ART-020 Planner ─┐
                  ├─> ART-030 Data ─────────────────────────┤
                  ├─> ART-031 Maps ─────────────────────────┤
                  ├─> ART-040 Marks ────────────────────────┤
                  ├─> ART-050 Enemy Info ───────────────────┤
                  └─> ART-060 Validation ───────────────────┴─> ART-070 Gruul
ART-001 Retail audit ───────────────> ART-010
ART-070 ─> ART-080 Black Temple / ART-081 Hyjal / later raid-data tasks
```

| Task | Owner / paths | Depends on | Gate/output |
|---|---|---|---|
| ART-000 Architecture | Orchestrator: `AGENTS.md`, `docs/{architecture,contracts,agent}/**`, PR template | none | contracts frozen |
| ART-001 Retail audit | Source explorer, read-only | none | blocker inventory for ART-010 |
| ART-010 Bootstrap | Bootstrap: TOCs, bindings, `locales.xml` loader, bootstrap/loaders, compat, SavedVariables root rename and initial migration boundary, `Transmission.lua`, `FocusMarker.lua` compatibility | 000, 001 | both clients open/reload/export |
| ART-020 Planner | Planner: registry/preset and assigned route-domain modules, including `LiveSession.lua`, `EnemyForces.lua`, and `API.lua` | 010 | fixture route/waves round-trip |
| ART-030 TBC data pipeline | Data: `tools/{ac,generator,validators}/**`, generated/overrides, data tests | 000 | deterministic Gruul data |
| ART-031 Maps | Map: maps/transforms/calibration/map tests | 000 | calibrated Gruul map |
| ART-040 Marks | Marks: resolver, raid-mark modules/tests | 000 | deterministic pure-Lua resolver |
| ART-050 Enemy Info | Enemy info: repository, recorder, data/tests | 000 | bounded sourced observations |
| ART-060 Validation | Test agent: `tests/**`, `scripts/validate-*`, `scripts/smoke-*` | 000 | automated matrix + manual protocol |
| ART-070 Gruul slice | Integrator: central registration/wiring, shared SavedVariables migrations after ART-010, existing `Modules/EnemyInfo.lua` adapter, and paired locale strings | 010, 020, 030, 031, 040, 050, 060 | end-to-end vertical slice; v1 freeze |
| ART-080+ Raid data | One owner per raid: only its generated, override, map, transform, tests | 070 | validated raid coverage |

ART-030 through ART-060 may develop in parallel after their dependencies. Integrate
in order: 000, 010, 060, 020, 030, 031, 040, 050, 070, then raid data. Feature
agents do not edit central loaders or registries; ART-070 owns cross-stream wiring.

Each bounded task records allowed paths, forbidden paths, base SHA, validation, and
handover. Review is independent: contract/path review, domain review, then test
runner evidence. Review severities are `BLOCKING`, `IMPORTANT`, `NON_BLOCKING`, and
`VERIFIED`; reviewers do not fix the code they review.

## Authoritative path ownership matrix

Only the paths in **Allowed** may be edited by that task. Every unlisted path is
forbidden. Explicitly listed forbidden paths document the boundaries most likely to
overlap. A path marked **after ART-010 handover** has one writer at a time; ART-070
must wait for ART-010's accepted handover before touching that path.

| Task | Allowed (exclusive) | Forbidden (including) |
|---|---|---|
| ART-000 | `AGENTS.md`; `docs/**`; `.github/PULL_REQUEST_TEMPLATE/**` | all production Lua/data, TOCs, loaders, locale files |
| ART-001 | none (read-only audit) | every repository path |
| ART-010 | `*.toc`; `Bindings.xml`; `locales.xml` (loader); `Modules/load_modules.xml` (bootstrap load list); `Core/Bootstrap.lua`; `Core/Compat.lua`; `Core/Lifecycle.lua` (compatibility slice); `Core/SavedVariables.lua` (root rename/bootstrap compatibility and initial migration boundary); `MythicDungeonTools.lua` (menu-compatibility slice only); `MythicDungeonTools_UI/Bootstrap.lua`; `Modules/Transmission.lua`; `Modules/FocusMarker.lua` (client/settings compatibility); `Modules/{Toolbar,ExternalLinks,ErrorHandling,Settings,VersionCheck,Conflicts}.lua` (path/compatibility slices only); root addon path, slash-command, minimap, and integrated UI bootstrap files | route-domain conversion; `Core/RoutePreset.lua`; planner modules; `Modules/LiveSession.lua`; `Modules/EnemyForces.lua`; `Modules/API.lua`; `Modules/EnemyInfo.lua`; feature registration after handover; `Locales/enUS.lua`/`Locales/zhCN.lua` translation strings |
| ART-020 | `MythicDungeonTools.lua` (raid-domain globals after ART-010's accepted handover); `Core/RaidRegistry.lua`; `Core/RoutePreset.lua`; `Modules/RaidSelect.lua`; `Modules/DungeonSelect.lua`; `Modules/RaidPlanner.lua`; `Modules/Pulls.lua`; `Modules/Presets.lua`; `Modules/PresetDialogs.lua`; `Modules/MainFrame.lua`; `Modules/DungeonEnemies.lua`; `Modules/PullOutlines.lua`; `Modules/MapView.lua`; `Modules/{Pointsofinterest,PresetObjects}.lua`; `Modules/LiveSession.lua`; `Modules/EnemyForces.lua`; `Modules/API.lua`; assigned UI widgets | all TOCs; `Bindings.xml`; `locales.xml`; `Modules/load_modules.xml`; `Core/Bootstrap.lua`; `Core/Compat.lua`; `Core/SavedVariables.lua`; `Modules/Transmission.lua`; `Modules/FocusMarker.lua`; `Modules/EnemyInfo.lua`; ART-010 compatibility slices in shared files; data generator/generated/override paths; marking internals; enemy-info recorder |
| ART-030 | `tools/ac/**`; `tools/generator/**`; `tools/validators/**`; `Raids/TBC/Generated/**`; `Raids/TBC/Overrides/**`; `tests/data/**` | UI/modules; TOCs/loaders; `Core/SavedVariables.lua`; marking modules; `Core/RaidRegistry.lua`; central registration |
| ART-031 | `Raids/TBC/Maps/**`; `Raids/TBC/Transforms/**`; `tools/calibration/**`; `tests/maps/**` | UI/modules; TOCs/loaders; contracts; `Core/SavedVariables.lua`; pack inference; generated/override data outside assigned map/transform paths |
| ART-040 | `Core/MarkResolver.lua`; `Modules/RaidMarks.lua`; `Modules/RaidMarksUI.lua`; `tests/marking/**` | `Modules/FocusMarker.lua`; `Modules/load_modules.xml`; `Modules/MainFrame.lua`; `Core/SavedVariables.lua`; central registration; planner and enemy-info modules |
| ART-050 | `Core/EnemyInfoRepository.lua`; `Modules/RaidEnemyInfo.lua`; `Developer/RaidRecorder.lua`; `Data/EnemyInfo/**`; `tests/enemy-info/**` | existing `Modules/EnemyInfo.lua`; `Modules/load_modules.xml`; `Core/SavedVariables.lua` initialization; central registration; planner and marking modules |
| ART-060 | `tests/**`; `scripts/validate-*.*`; `scripts/smoke-*.*`; `.github/workflows/**` only when explicitly assigned | production behavior, contracts, TOCs/loaders, central registration |
| ART-070 | `Modules/load_modules.xml` (feature/raid registration, after ART-010 handover); `Core/SavedVariables.lua` (shared migration integration, after ART-010 handover); `Locales/enUS.lua`; `Locales/zhCN.lua`; `Modules/EnemyInfo.lua` (adapter/replacement integration); central raid/module registration and final UI wiring | `locales.xml` loader; ART-010 root rename/bootstrap code; ART-020 route-domain implementation; generator/generated/override/map data; feature internals outside integration seams |
| ART-080+ | only the assigned raid's `Raids/TBC/Generated/<Raid>.lua`, `Raids/TBC/Overrides/<Raid>.lua`, `Raids/TBC/Maps/<Raid>.lua`, `Raids/TBC/Transforms/<Raid>.lua`, and `tests/data/<Raid>/**` | all `Core/**`; all `Modules/**`; TOCs/loaders; contracts; generator core; `Core/SavedVariables.lua`; shared locale files |

The matrix also resolves the legacy feature paths: `Modules/Transmission.lua` is
ART-010 transport/codec compatibility; `Modules/LiveSession.lua`,
`Modules/EnemyForces.lua`, and `Modules/API.lua` are ART-020 route-domain work;
the existing `Modules/EnemyInfo.lua` is reserved for ART-070 integration;
`Modules/FocusMarker.lua` remains ART-010 compatibility-only and ART-040's new
resolver never edits it. ART-050 uses `Modules/RaidEnemyInfo.lua` instead.

ART-031 may inventory [WoWWiki's Burning Crusade instance-map index](https://wowwiki-archive.fandom.com/wiki/Burning_Crusade_instance_maps#Black_Temple)
as a candidate floor/map-calibration source: it lists `WorldMap-BlackTemple`
through `WorldMap-BlackTemple7` for the patch-2.4.3-era Black Temple layout.
Record the page URL as `sourceRef` and the retrieved snapshot/date in provenance;
do not treat the listing as Anniversary-verified coordinates.
