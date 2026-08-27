# ART-0018: Persistent Live Session routes

## Status

Accepted

## Date

2026-08-27

## Context

ART-0013 required users to opt in again after every UI reload. A reload also
discarded Live Session state, while floor-wide NPC marks lived in the separate
raid-route preset and were never sent through the legacy Live Preset channel.

## Decision

1. Enabling Live Session stores its preset UID; disabling or losing the route
   clears it. The always-loaded core loads the UI after a reload and restores
   that explicit opt-in without announcing another chat link.
2. Live Session sends the validated raid-route preset after the legacy preset
   and whenever the planner changes. This includes floor-wide NPC marks.
3. Only raid leaders and assistants may send route state. Receivers verify the
   sender against the current raid roster and ignore invalid route payloads.

## Alternatives considered

- **Prompt after every reload:** replaced because reload is not withdrawal of
  the user's explicit Live Session opt-in.
- **Copy floor marks into the legacy preset:** rejected because it creates two
  persisted owners for the same route-planner state.

## Consequences

- Live sharing resumes after `/reload` until explicitly disabled or the route
  can no longer be found.
- New participants receive floor marks, and later floor-mark changes stay live.
- The route message reuses the planner's existing validation and authority
  model without duplicating mark rules.

## Supersedes

ART-0013.
