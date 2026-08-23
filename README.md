# Anniversary Raid Tools

Anniversary Raid Tools (ART) is a raid-route planner for the WoW TBC
Anniversary clients `20505` and `20506`. It is derived from Nnoggie's Mythic
Dungeon Tools and includes the TBC raids from Karazhan through Sunwell Plateau.

## Install

1. Copy the repository to
   `World of Warcraft/_anniversary_/Interface/AddOns/AnniversaryRaidTools`.
2. Install the bundled addon libraries when they are absent:

   ```sh
   python3 scripts/install_addon_libs.py
   ```

3. Enable **Anniversary Raid Tools** in the character-selection addon list.

## Use

- `/art` opens the planner.
- `/art minimap` toggles the minimap button.
- `/mdt` and `/anniversaryraidtools` are aliases for `/art`.
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
- [Retail-to-TBC audit](docs/audits/ART-001-retail-to-tbc.md) tracks inherited
  compatibility work.

The main runtime boundaries are bootstrap/client compatibility, validated raid
data, route presets, planner UI, deterministic marking, enemy information, and
their integration wiring. See
[ART-0003](docs/architecture/ART-0003-module-boundaries.md) for ownership rules.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Generated files under
`Raids/TBC/Generated/` must not be edited by hand.

## License and origin

ART is derived from [Mythic Dungeon Tools](https://github.com/Nnoggie/MythicDungeonTools)
and distributed under [GPL-2.0](LICENSE).
