# Provenance Contract v1

All externally sourced, observed, manual, or derived facts use:

```lua
---@class ARTProvenance
---@field source "azerothcore"|"live-observed"|"manual"|"client-data"|"derived"
---@field confidence "verified"|"high"|"candidate"|"review-required"
---@field sourceRef string|nil -- commit/query, observation batch, reviewer, or derivation
---@field observedAt string|nil -- UTC ISO-8601 timestamp
```

`verified` means live Anniversary observation or documented manual review; source
alone never implies it. AzerothCore facts are at most `candidate` until corroborated.
Deterministic transforms of verified inputs may be `high`; heuristic inference is
`review-required`. Consumers display or preserve provenance and never silently
upgrade confidence.

The five source values and four confidence values are closed in v1. A subtype such
as `smartai` belongs in `sourceRef`, not a new source value.
