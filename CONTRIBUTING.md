# Contributing to Anniversary Raid Tools

## Before opening a change

The canonical automated runtime is PUC Lua 5.1. Install Bash, PUC Lua 5.1
(`lua5.1` and `luac5.1`), LuaJIT, LuaRocks, Subversion, Python 3, and
`realpath`. CI pins Busted `2.3.0-1` and LuaCov `0.16.0-1`.

Run the applicable command from the repository root:

```sh
./dev test       # Busted specs
./dev coverage   # Busted --coverage, then luacov
./dev check      # scripts/validate-addon.sh, then Busted
./dev static     # wowlua_ls check . (advisory)
```

`./dev check` is the required full automated gate and preserves the existing
standalone checks in `tests/`. `./dev static` is advisory only; `wowlua_ls`
v0.30.5 is beta and broad Classic analysis is not exact patch authority. The
full layer-selection guide is [`docs/testing.md`](docs/testing.md).

## Test and client boundaries

Use Busted specs under `spec/**/*_spec.lua` with `spec/setup.lua` for pure
domain logic and testable WoW adapter/UI orchestration. Keep mocks minimal and
isolated. Existing standalone Lua/LuaJIT/Python checks remain release gates.
Secure marking, combat/nameplate state, actual `C_Map`/AceComm behavior, taint,
and other real-client-only behavior must be checked with `/art test` and
[`scripts/smoke-clients.md`](scripts/smoke-clients.md) on both interfaces
`20505` and `20506`; a desktop mock does not replace that check.

The interface is a separate load-on-demand addon. In a local WoW checkout, run
`./scripts/link-dev-ui.sh` once to expose the nested UI folder as the required
sibling addon. Developer tests are intentionally not release content:
`pkgmeta.yaml` excludes `Developer/` and `tests/`, and
`scripts/validate-release.sh` checks the cleaned bundle.

- This repository comes with a `.editorconfig` file, so the following requirements will be taken care of if you have [EditorConfig](https://editorconfig.org/) installed. An editorconfig plugin for your specific editor is recommended.
  - Tabs consist of 2 spaces.
  - Files are ending with a newline.
  - Line endings in addon files must use LF.
  - No trailing whitespace at the end of a line.
- All user-facing strings must be localized via using `L["localized phrase"]`. You must use double quoted strings, and name the localization table (found at `ART.L`) `L` in your code for this to work properly
  - Add and update translations in `Locales/`. `enUS.lua` is the source of truth for localization keys.
- Do not edit `Raids/TBC/Generated/**` by hand. Change its generator or source
  fixture, then regenerate it. Reviewed corrections belong in
  `Raids/TBC/Overrides/**`; see ART-0004.
- Record significant, durable, or expensive-to-reverse decisions using the
  convention in `docs/architecture/README.md`. Do not create ADRs for routine
  implementation details.
- When editing inherited ART enemy data, use the in-game editor available via
  `/art devmode` and export changes through **Enemy > Export to Lua**.
