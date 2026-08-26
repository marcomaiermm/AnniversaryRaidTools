<p align="center">
  <img src="Textures/ARTLogo.png" alt="Anniversary Raid Tools logo" width="320">
</p>

<p align="center">
  <a href="https://github.com/marcomaiermm/AnniversaryRaidTools/releases/latest"><img src="https://img.shields.io/github/v/release/marcomaiermm/AnniversaryRaidTools?display_name=tag&sort=semver" alt="Latest release"></a>
  <a href="https://github.com/marcomaiermm/AnniversaryRaidTools/actions/workflows/release.yml"><img src="https://github.com/marcomaiermm/AnniversaryRaidTools/actions/workflows/release.yml/badge.svg" alt="Package and release status"></a>
  <img src="https://img.shields.io/badge/WoW-TBC%20Anniversary-c79c6e" alt="WoW TBC Anniversary">
  <a href="LICENSE"><img src="https://img.shields.io/github/license/marcomaiermm/AnniversaryRaidTools" alt="License"></a>
</p>

<h1 align="center">Anniversary Raid Tools</h1>

<p align="center">
  Raid route planning and live mark coordination for WoW TBC Anniversary.
</p>

## Features

- Interactive raid maps with enemies, packs and patrol routes.
- Route planning for freely composed pulls.
- Wave planning for Battle for Mount Hyjal.
- Pull-specific and raid-wide target markers.
- Intentional mouseover marking that preserves existing raid marks.
- Live synchronization of routes and raid progress.

## Supported Raids

- Gruul's Lair
- Magtheridon's Lair
- Serpentshrine Cavern
- The Eye
- Battle for Mount Hyjal
- Black Temple

ART supports the TBC Anniversary client interfaces `20505` and `20506`.

## Usage

- `/art` opens the planner.
- `/art minimap` toggles the minimap button.
- `/anniversaryraidtools` is an alias for `/art`.

## Development

Run the validation matrix with Bash, Python 3, Lua 5.1 and LuaJIT:

```sh
./scripts/validate-addon.sh
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for development rules. Generated files
under `Raids/TBC/Generated/` must not be edited manually.

## License

Anniversary Raid Tools is distributed under [GPL-2.0](LICENSE).
