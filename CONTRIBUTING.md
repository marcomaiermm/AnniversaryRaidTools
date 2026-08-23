# Contributing to Anniversary Raid Tools

Run `./scripts/validate-addon.sh` before submitting a change. Changes affecting
client behavior must also follow `scripts/smoke-clients.md` on interfaces `20505`
and `20506`.

- This repository comes with a `.editorconfig` file, so the following requirements will be taken care of if you have [EditorConfig](https://editorconfig.org/) installed. An editorconfig plugin for your specific editor is recommended.
  - Tabs consist of 2 spaces.
  - Files are ending with a newline.
  - Line endings in addon files must use LF.
  - No trailing whitespace at the end of a line.
- All user-facing strings must be localized via using `L["localized phrase"]`. You must use double quoted strings, and name the localization table (found at `MDT.L`) `L` in your code for this to work properly
  - Add and update translations in `Locales/` through GitHub pull requests. `enUS.lua` is the source of truth for localization keys.
- Do not edit `Raids/TBC/Generated/**` by hand. Change its generator or source
  fixture, then regenerate it. Reviewed corrections belong in
  `Raids/TBC/Overrides/**`; see ART-0004.
- Record significant, durable, or expensive-to-reverse decisions using the
  convention in `docs/architecture/README.md`. Do not create ADRs for routine
  implementation details.
- When editing inherited MDT enemy data, use the in-game editor available via
  `/mdt devmode` and export changes through **Enemy > Export to Lua**.
