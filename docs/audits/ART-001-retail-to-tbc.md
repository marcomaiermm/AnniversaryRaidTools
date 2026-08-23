# ART-001: Retail-to-TBC Source Audit

Read-only audit of the current fork. Line numbers describe the audited HEAD and may
move. An API named below is a port checkpoint, not a claim that it is absent on both
TBC Anniversary builds; verify against clients `20505` and `20506` in ART-010/060.

## Decisive findings

| Symbol / path | Category | Severity | TBC replacement or action | Owner | Runtime blocker |
|---|---|---:|---|---|---|
| `MythicDungeonTools.toc:1-21` | Retail TOC/branding | critical | interfaces `20505, 20506`, ART title/SavedVariables/icon path | ART-010 | yes |
| `MythicDungeonTools_UI/MythicDungeonTools_UI.toc:1-20` | Retail UI TOC/path | critical | ART dependency and sibling paths; remove mainline-only Midnight load | ART-010 | yes |
| `Core/Bootstrap.lua:5,111,141,154` | load-on-demand API/name | critical | ART UI addon name through `Core/Compat.lua`; validate enable/load APIs | ART-010 | yes |
| `Core/Bootstrap.lua:117` | Retail template | critical | replace `LoadingSpinnerTemplate` with a TBC-safe frame or no spinner | ART-010 | yes |
| `Modules/MainFrame.lua:991` | Retail template | critical | replace `LoadingSpinnerTemplate` with a TBC-safe frame or no spinner | ART-020 | yes |
| `Modules/LiveSession.lua:113` | Retail template/difficulty session | critical | use a TBC-safe frame and route-domain session semantics | ART-020 | yes |
| `Core/Bootstrap.lua:357-381` | Retail tooltip/scenario API | critical | remove the bootstrap enemy-forces tooltip path; do not port `TooltipDataProcessor`/`C_ScenarioInfo` | ART-010 | yes |
| `Modules/EnemyForces.lua:29-40` | Mythic+ enemy-forces module | critical | remove the module's forces semantics and expose only neutral route status if needed | ART-020 | yes |
| `Modules/Transmission.lua:16-31` | Retail encoding API | critical | AceSerializer + LibDeflate primary codec; retain deliberate legacy reader only | ART-010 | yes |
| `MythicDungeonTools.lua:23-26` and callers in `Modules/FocusMarker.lua` | Retail menu API | critical | ART-010 owns the compatibility slice; use a wrapper backed by TBC menu/dropdown facilities | ART-010 | yes |
| `Modules/{Pointsofinterest,PresetObjects,DungeonEnemies}.lua` menu callers | Retail menu API | critical | use the compatibility wrapper inside the ART-020-owned planner modules | ART-020 | yes |
| `Core/Bootstrap.lua:111,141,154,437,527`; `Modules/{VersionCheck,Conflicts,ErrorHandling}.lua` | `C_AddOns` | high | central addon API wrapper using available TBC globals/API | ART-010 | likely |
| `Modules/{MapView,MainFrame}.lua` | `C_AddOns` | high | consume the compatibility wrapper inside the ART-020 route-domain modules | ART-020 | likely |
| `Core/Lifecycle.lua:111` | `C_Spell` | high | compat spell request/link/texture lookup with legacy globals where available | ART-010 | likely |
| `Modules/DungeonSelect.lua:234` | `C_Spell` in planner selection | high | route through the compatibility boundary while converting to raid selection | ART-020 | likely |
| `Modules/EnemyInfo.lua:594-614` | `C_Spell` in legacy enemy-info UI | high | ART-070 owns the existing-module adapter/replacement; ART-050 writes only the new repository/recorder boundary | ART-070 | likely |
| `Modules/MapView.lua:686-687`; `Modules/DungeonSelect.lua:234`; `Modules/API.lua:16` | challenge/map API | critical | remove `C_ChallengeMode`; verify/wrap `C_Map` and use the raid registry inside the ART-020 route-domain surface | ART-020 | yes |
| `Modules/FocusMarker.lua:1136-1181` | Retail Settings UI | high | TBC keybinding/options fallback; isolate settings navigation; do not use the new pack-mark resolver boundary | ART-010 | likely |
| `Core/Bootstrap.lua:46-64`; `Core/SavedVariables.lua:4-110`; TOC SavedVariables | old persistence root | critical | `AnniversaryRaidToolsDB`, explicit migration, no silent field guessing | ART-010 | yes |
| `Core/SavedVariables.lua:12,15,28,59,68-77` | M+ persistence model | critical | ART-010 owns the `AnniversaryRaidToolsDB` root rename/bootstrap compatibility and initial migration boundary; ART-020 converts route-domain fields only in its assigned route surface/contract; ART-070 alone integrates shared migrations after ART-010 handover | ART-010 → ART-020 (route surface only) → ART-070 | no startup, yes product |
| `MythicDungeonTools.lua:59-87` | dungeon/forces globals | critical | raid registry and stable raid/pack/spawn keys | ART-020 | no startup, yes product |
| `Modules/MainFrame.lua:872-911`; `Modules/DungeonEnemies.lua:475,493,520` | difficulty/forces UI | critical | remove slider/scaling/progress; neutral route status only | ART-020 | no startup, yes product |
| `Modules/EnemyInfo.lua:594-614` | difficulty/forces UI in legacy enemy-info module | critical | ART-070 owns adapter/replacement integration; no new recorder code in this file | ART-070 | no startup, yes product |
| `Modules/Pulls.lua:11-65,315`; `Modules/Presets.lua`; `Modules/PresetDialogs.lua` | index-based pull/preset domain | critical | `routeSteps`, stable references, explicit v1 import/export | ART-020 | no startup, yes product |
| `Modules/API.lua:3-54` | public enemy-forces API | high | retire/version behind raid-domain API; do not preserve M+ result semantics | ART-020 | no |
| `Modules/LiveSession.lua:30-35,53,218,239` | MDT live-session schema | high | convert session payloads to the route-domain contract; no difficulty/forces semantics | ART-020 | no |
| `Modules/Transmission.lua:129-360,434-501` | MDT comms transport/schema | high | ART-010 owns codec, prefix, and intentional legacy-reader compatibility; ART-020 consumes the resulting route payload contract without editing the transport file | ART-010 | no |
| hardcoded `Interface\\AddOns\\MythicDungeonTools` in `Core/Bootstrap.lua` and `Modules/{Toolbar,ExternalLinks,ErrorHandling,Settings,FocusMarker}.lua` | addon path | critical | ART path helper/constant or corrected literal in the ART-010 compatibility slices | ART-010 | yes (missing textures) |
| hardcoded `Interface\\AddOns\\MythicDungeonTools` in `Modules/{Pointsofinterest,PresetObjects,DungeonEnemies,PullOutlines}.lua` | addon path | critical | ART path helper/constant or corrected literal inside the ART-020-owned planner modules | ART-020 | yes (missing textures) |
| `Midnight/**`, loaded by UI TOC | Retail data | critical | exclude from TBC load; replace only with generated/override TBC raids | ART-010/030/070 | yes/product |

## Ownership boundary

The task graph's path matrix is authoritative. For the legacy modules called out by
this audit, ownership is intentionally single-writer: ART-010 owns transport/codec
compatibility in `Modules/Transmission.lua` and client/settings compatibility in
`Modules/FocusMarker.lua` plus the menu-compatibility slice of
`MythicDungeonTools.lua`; ART-020 owns route-domain conversion in
`Modules/LiveSession.lua`, `Modules/EnemyForces.lua`, and `Modules/API.lua`; ART-050
owns the new `Core/EnemyInfoRepository.lua` and `Modules/RaidEnemyInfo.lua` boundary
but never `Modules/EnemyInfo.lua`; ART-070 owns the existing `Modules/EnemyInfo.lua`
adapter/replacement and shared integration after ART-010's accepted handover.
ART-020 owns the separate raid-domain slice of `MythicDungeonTools.lua` after that
compatibility slice is handed over. Compatibility slices in shared modules are
explicitly separated from route-domain slices in the matrix and must not be edited
in parallel.

## Mythic+ semantic inventory

- **Dungeon/season selection:** `MythicDungeonTools.lua` defines
  `dungeonTotalCount`, `dungeonMaps`, `dungeonEnemies`, `dungeonSubLevels`, and
  `dungeonList`; `Modules/DungeonSelect.lua` and
  `Modules/NavigationSidebar.lua:137-143` select seasons/dungeons.
- **Enemy forces:** `MythicDungeonTools.lua:84-110`, `Modules/EnemyForces.lua`,
  `Modules/Pulls.lua:11-65`, `Modules/DungeonEnemies.lua:493,520`,
  `Modules/Settings.lua:18-29,247-256`, `Modules/EnemyInfo.lua:214`, and
  `Modules/API.lua:8-54` calculate, render, configure, or expose forces.
- **Key level and scaling:** `Core/SavedVariables.lua:15`,
  `Modules/MainFrame.lua:872-911`, `Modules/Pulls.lua:53`,
  `Modules/DungeonEnemies.lua:475`, `Modules/EnemyInfo.lua:594-614`, and live
  session difficulty messages depend on `currentDifficulty`, Fortified/Tyrannical,
  or dungeon-level health.
- **Pull/index persistence:** `Modules/DungeonEnemies.lua` persists
  `enemyIdx`/`cloneIdx`; `Modules/Pulls.lua` stores `pulls`; Presets and dialogs index
  `db.presets[db.currentDungeonIdx]`. These indices cannot cross a generated-data
  rebuild and require stable spawn/pack keys at persistence boundaries.
- **Retail content/settings:** `Midnight/**`, Xal'atath controls,
  `Modules/PrePatchWarning.lua`, change-log forces entries, challenge-mode checks,
  and combat-log content values `mythic_dungeon`/`mythic_plus` are not raid domain.
- **Visible wording:** TOC notes/locales/UI contain Mythic+, dungeon, key, forces,
  Fortified, Tyrannical, affix, and season language. ART-020/070 must remove it from
  reachable UI; ART-060 should scan user-facing occurrences rather than internal
  legacy symbol names.

## Load and dependency facts

The root TOC loads only core libraries, `BuildCheck.lua`, `Core/Bootstrap.lua`, and
`Core/CombatLogging.lua`. `Core/Bootstrap.lua` creates defaults, commands, minimap,
comms registrations, ready-check behavior, and lazy-loads `MythicDungeonTools_UI`.
The UI TOC then loads full libraries, locales/widgets, `Utility.lua`,
`Core/SavedVariables.lua`, `MythicDungeonTools.lua`, `Core/Lifecycle.lua`, all files
from `Modules/load_modules.xml`, developer code in non-packaged builds, and finally
`Midnight/load_midnight.xml [AllowLoadGameType mainline]`.

This creates two persistence/bootstrap implementations: direct table setup in
`Core/Bootstrap.lua:46-64` and AceDB initialization in
`Core/SavedVariables.lua:83-110`. ART-010 must establish one migration sequence
before UI attachment. `MythicDungeonTools_UI/Bootstrap.lua:2` asserts the exported
core API, and `Core/Bootstrap.lua:88-107` requires specific handler/plugin methods;
renaming either side independently breaks load-on-demand attachment.

`Modules/load_modules.xml` is the single conflict-heavy feature load list. Its order
starts MainFrame/MapView/Presets/Pulls, then enemy/preset/toolbar/transmission
features, and ends with API/conflict/warning/error/version modules. Feature agents
must not edit it; ART-070 wires validated entry points after SavedVariables, raid
registry, and pure services exist.

Comms are registered in `Core/Bootstrap.lua:453-455`. The receiver dispatch in
`Modules/Transmission.lua:129-360` recognizes preset/version/live-session prefixes
including pull, difficulty, POI, focus-marker, object, command, note, and preset
payloads. Schema and prefix changes therefore cross ART-010 bootstrap and ART-020
route contracts and must be integrated, not independently replaced.

## Uncertainties requiring client evidence

- Exact TBC availability/signatures for `C_AddOns`, `C_Map`, `C_Spell`,
  `C_ChatInfo`, and timer helpers; route all through compatibility checks and test on
  both target clients.
- Availability and shape of modern menu/settings/loading-spinner/tooltip templates;
  assume unavailable until an in-client smoke test proves otherwise.
- Which legacy MDT export and addon-message formats must remain import-compatible.
  Do not promise bidirectional compatibility without fixtures.
- Mapping a live unit GUID to a static generated `spawnKey`; absent reliable map
  evidence, marking must fall through to NPC rules as the v1 contract states.
- Retail map IDs and Midnight records do not establish TBC raid map/floor IDs.
  ART-031 must calibrate from target-client and source evidence.

## Owner sequence

1. **ART-010** replaces TOCs/names/paths, establishes Compat, owns the
   `AnniversaryRaidToolsDB` root rename/bootstrap compatibility and initial
   migration boundary, repairs load-on-demand startup, and provides a TBC-safe
   codec. It owns `Transmission.lua` transport compatibility and the existing
   `FocusMarker.lua` client/settings compatibility; ART-040 does not edit that
   file.
2. **ART-060** pins path/parse/forbidden-API/migration/round-trip checks immediately
   after bootstrap so later domain work cannot restore Retail blockers.
3. **ART-020** replaces season/dungeon/forces/difficulty/pull persistence with the
   frozen raid and route contracts while preserving useful map/drawing behavior.
   Its conversion is limited to the assigned route-domain surface and contracts;
   it owns `LiveSession.lua`, `EnemyForces.lua`, and `API.lua` but not the shared
   SavedVariables migration file.
4. **ART-030/031/040/050** supply generated data, calibrated maps, marks, and sourced
   enemy info behind their exclusive boundaries. ART-050 writes the new
   `RaidEnemyInfo` repository/recorder boundary and leaves the existing
   `Modules/EnemyInfo.lua` untouched.
5. **ART-070**, only after ART-010's accepted handover, alone edits central
   registration, shared SavedVariables migration integration, the existing
   `Modules/EnemyInfo.lua` adapter, and paired `enUS`/`zhCN` translation strings;
   ART-010 remains the exclusive owner of the `locales.xml` loader. It proves the
   complete Gruul slice before raid-data agents scale out.
