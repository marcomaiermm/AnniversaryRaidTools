# Architecture Decision Records

This directory contains accepted Architecture Decision Records (ADRs). ADRs
explain durable decisions and their trade-offs; contracts in `../contracts/`
define exact data shapes and validation rules.

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
