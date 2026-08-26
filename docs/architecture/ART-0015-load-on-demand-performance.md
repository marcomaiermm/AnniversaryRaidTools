# ART-0015: Load-on-demand UI and active raid projection

## Status

Accepted

## Date

2026-08-26

## Context

ART loaded its complete planner UI, every raid projection, and all map texture
frames during login. Most of that state is unused until the player opens the
planner, and only one raid can be edited at a time.

## Decision

1. `AnniversaryRaidTools` remains the always-loaded core for commands,
   communications, combat logging, and the public API.
2. `AnniversaryRaidTools_UI` is a sibling load-on-demand addon containing the
   planner, raid data, and feature UI. Source files receive their private addon
   table through WoW's addon varargs; no compatibility `ART` global is exposed.
3. Shell metadata is published for every supported raid, but projected enemy
   clones and spawn lookup tables exist only for the active raid. Selecting a
   different raid evicts the previous projection.
4. Large map tiles and continuous event handlers are created or registered only
   while their corresponding map or runtime feature is active.
5. The repository keeps the UI folder nested for packaging. The release packager
   moves it beside the core addon; local checkouts use `scripts/link-dev-ui.sh`.

## Alternatives considered

- **Keep one addon and delay frame creation:** rejected because Lua modules and
  multi-megabyte static raid tables would still load at login.
- **Retain every projected raid:** rejected because source raid data is already
  sufficient to rebuild a projection on selection.
- **Expose a shared global table:** rejected because the existing public API
  bridge provides a smaller and explicit boundary.

## Consequences

- Login loads only the small core; first planner open pays the UI load cost.
- A raid switch rebuilds one projection and releases the previous one.
- Releases must contain two addon folders, and local development needs the
  sibling link.
- In-client performance comparisons use the developer-only
  `/art debug:perf start` and `/art debug:perf report` commands.
