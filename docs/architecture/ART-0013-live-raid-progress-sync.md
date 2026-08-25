# ART-0013: Live raid progress synchronization

## Status

Accepted

## Date

2026-08-25

## Context

Live Sessions synchronize route edits but not the selected pull. Raid members
can therefore share one route while their pull tracker, active marks, and Hyjal
wave card point at different steps. Progress must remain an intentional raid
leader action; browsing and passive floor rendering must not move the raid.

## Decision

1. Active Live Sessions synchronize every explicit numeric pull or wave
   selection through the versioned `ARTRaidProgress` message.
2. Only raid leaders and assistants may send progress. Every receiver verifies
   the sender against its current raid roster before applying the message.
3. Route raids require the current Live-Preset UID. Wave raids synchronize by
   raid key and immutable wave index. Invalid, foreign, or out-of-range messages
   are ignored.
4. Remote progress uses the normal selection path so floors, planner state,
   marks, tracker, and wave UI update together. Passive and remote selections do
   not broadcast.
5. All addon users are offered Live Session participation once upon entering a
   supported raid instance. Simultaneous discovery chooses the active raid lead,
   then an assistant, then a member, with full name as the stable tie-breaker.

## Alternatives considered

- **Always-on synchronization:** rejected because joining a shared route and
  accepting remote progress must remain consensual.
- **A second raid-sync channel outside Live Sessions:** rejected because it
  would duplicate route identity, discovery, and lifecycle state.
- **Trust payload-declared authority:** rejected because receivers can verify
  the actual sender directly from the raid roster.

## Consequences

- One explicit selection by a participating lead or assistant advances all
  participating clients without echo loops.
- Members may browse locally, but the next authorized selection restores the
  shared state.
- Users who decline or disable Live do not receive progress synchronization.
- After a UI reload the participation prompt appears again because the Live
  Session itself must be re-established.
