# ART-060 manual smoke protocol

Run every step on a clean copy of the addon in **both** TBC Anniversary clients:
Interface **20505** and **20506**. Keep the client error reporter enabled. A
step passes only when the expected result occurs with no Lua error, taint
warning, stuck loading spinner, or duplicate UI/event handler.

## 1. Fresh install and migration

- [ ] Enable `AnniversaryRaidTools` and its UI addon; log in, `/reload`, and
      confirm the addon reaches the world without an error.
- [ ] On a disposable character/profile, verify the initial addon database is
      created and a Gruul's Lair raid can be selected.
- [ ] On a backup of a pre-ART profile containing `MythicDungeonToolsDB`, enable
      ART and reload. Confirm the migration preserves supported settings and
      routes, creates `AnniversaryRaidToolsDB`, and does not delete the legacy
      root until the migration boundary says it is safe.

## 2. Startup, close, reload, and disabled UI

- [ ] Run `/art`; open the planner, close it, reopen it, and `/reload` while it
      is open. The UI remains usable and handlers are not duplicated.
- [ ] Disable the UI addon, reload, and run `/art`. Confirm the addon fails
      safely with an actionable enable/reload prompt rather than a Lua error.
      Re-enable it and reload before continuing.
- [ ] Run `/art minimap` twice and verify the minimap button hides then returns;
      click it to open the planner.

## 3. Route and waves

- [ ] Open Gruul's Lair, inspect each floor and enemy pack, add route steps,
      reorder route steps, add a note, close/reopen, and confirm annotations
      persist.
- [ ] Export the route, import it into a disposable preset, and verify raid,
      floor, step order, pack membership, notes, and marks round-trip. Try an
      invalid/unknown-schema import and confirm no partial mutation occurs.
- [ ] For a waves raid, confirm the declared wave order/composition is shown;
      annotations can change, but wave identity and pack composition cannot.

## 4. Marks

- [ ] Preview marks for a pack and confirm preview has no side effects.
- [ ] Apply marks to duplicate NPCs and confirm deterministic first-unused marker
      assignment, stable assignment while alive, release on death/reset, and
      safe no-op behavior for missing/friendly/dead/out-of-step units.
- [ ] With an existing target marker, verify preservation policy; verify marking
      never changes the player's target.

## 5. Enemy information

- [ ] Open enemy information for a raid NPC and verify source and confidence are
      visible (AzerothCore data is not presented as Anniversary-verified).
- [ ] Record cast/aura/interrupt/dispel/death observations, reload, and confirm
      bounded counts/latest evidence and UTC timestamps persist. Unknown events
      or malformed GUIDs are ignored without blocking route planning.

Record for each client: build/interface, addon version, fresh vs migrated
profile, steps run, result, and any exact error text. Automated evidence comes
from `scripts/validate-addon.sh`; this checklist is intentionally manual and
cannot be substituted by a desktop Lua interpreter.
