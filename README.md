# Anniversary Raid Tools

Anniversary Raid Tools (ART) is a raid-route planner for the WoW TBC
Anniversary clients `20505` and `20506`. It includes the TBC raids from
Karazhan through Sunwell Plateau.

## Install

1. Copy the repository to
   `World of Warcraft/_anniversary_/Interface/AddOns/AnniversaryRaidTools`.
2. Enable **Anniversary Raid Tools** in the character-selection addon list.

## Use

- `/art` opens the planner.
- `/art minimap` toggles the minimap button.
- `/anniversaryraidtools` is an alias for `/art`.
- Developer mode provides a **Calibration** panel that overlays live `C_Map`
  tiles on every supported raid floor for map alignment.

ART supports two planning modes:

- **Route:** compose and order spatial raid packs.
- **Waves:** annotate raid-defined waves without changing their identity or
  composition.

## Validate

The validation matrix requires Bash, Python 3, `realpath`, Lua 5.1, and LuaJIT.

```sh
./scripts/validate-addon.sh
```

Client behavior must also pass the
[manual smoke protocol](scripts/smoke-clients.md) on both supported interfaces.

## Architecture

- [Architecture decisions](docs/architecture/README.md) record why durable or
  expensive-to-reverse choices were made.
- [Data contracts](docs/contracts/) define the versioned runtime and persistence
  boundaries.
The main runtime boundaries are bootstrap/client compatibility, validated raid
data, route presets, planner UI, deterministic marking, enemy information, and
their integration wiring. See
[ART-0003](docs/architecture/ART-0003-module-boundaries.md) for ownership rules.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Generated files under
`Raids/TBC/Generated/` must not be edited by hand.

## License

ART is distributed under [GPL-2.0](LICENSE). Copyright and attribution notices
are preserved in the source and license files.
