# AnniversaryRaidTools Agent Rules

AnniversaryRaidTools is a raid-route planner for the WoW TBC Anniversary clients
`20505` and `20506`. It is derived from Nnoggie's Mythic Dungeon Tools; preserve
that attribution and the repository's GPL-2.0 license notices.

## Read first

Before implementation, read `docs/architecture/*`, `docs/contracts/*`, and
`docs/agent/task-graph.md`. Shared contracts are frozen until explicitly revised.

## Ownership

- Orchestrator only: `AGENTS.md`, `docs/architecture/**`, `docs/contracts/**`,
  `docs/agent/task-graph.md`.
- The authoritative per-task allowed/forbidden path matrix is in
  `docs/agent/task-graph.md`. A path not listed as allowed is forbidden, and a
  sequenced handoff is never parallel ownership.
- ART-010 owns the port-phase TOCs, `Bindings.xml`, the `locales.xml` loader,
  `Modules/load_modules.xml`'s bootstrap load list, root bootstrap files,
  `Core/Bootstrap.lua`, `Core/Compat.lua`, the SavedVariables root rename and
  initial migration boundary, plus its assigned compatibility fixes. ART-020
  owns route-domain conversion only inside its assigned modules and contracts;
  it does not edit the SavedVariables root or shared migration file.
- After ART-010's accepted handover, ART-070 alone owns central registration and
  final UI wiring, `Modules/load_modules.xml` feature/raid registration, shared
  SavedVariables migration integration, and locale translation strings. ART-010
  and ART-070 never edit those sequenced paths concurrently.
- `locales.xml` is the ART-010 loader boundary. `Locales/enUS.lua` and
  `Locales/zhCN.lua` are ART-070's paired translation-string boundary, unless a
  task row explicitly grants both files to that task without an ART-070 overlap.
- Feature and raid-data agents may edit only the paths assigned in the task graph.
  They must not register their modules in central loaders.
- Reviewers and source explorers are read-only unless their task explicitly grants
  an implementation path.

Never edit another agent's owned paths, merge another agent's branch, or widen the
task to resolve an integration issue. Report the boundary instead.

## Implementation rules

1. Preserve public behavior unless the task and a versioned contract authorize a
   change. Do not perform a broad `MDT` to `ART` rename.
2. Target both client interfaces `20505` and `20506`; isolate client API
   differences in the compatibility boundary.
3. Do not introduce visible Mythic+, key-level, enemy-forces, affix, season,
   Fortified, or Tyrannical semantics.
4. Use stable raid, pack, and spawn keys at persistence boundaries. Runtime array
   indices are not durable identifiers.
5. Generated files are generator-owned and must never be edited manually. Put
   corrections in the matching override file and retain provenance.
6. When adding a localized string, add the key to both `Locales/enUS.lua` and
   `Locales/zhCN.lua` in the same change.
7. Make the smallest change inside the assigned scope. Do not add speculative
   abstractions, dependencies, loaders, migrations, or compatibility shims.

## Contract changes

Do not silently extend a shared schema or interface. Stop at the current boundary
and include a `CONTRACT_CHANGE_REQUEST` in the handover with: contract/version,
existing behavior, required behavior, reason, compatibility, migration, affected
workstreams, and proposed version. The orchestrator updates the contract and
publishes the new contract commit before dependent work continues.

## Validation and handover

Run every check named by the task, record exact commands and results, and separate
automated evidence from manual in-game checks. A handover must include status,
task/branch/base/head/commits, changed files, completed scope, contracts consumed,
public interfaces, verification, manual checks, limitations, contract requests,
integration instructions, and next-agent input. Use the pull-request template.
