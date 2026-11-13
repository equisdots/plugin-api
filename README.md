# equisdots · plugin-api

The **normative contract** of the equisdots plugin system. This repository owns
the plugin *interface*: the manifest schema, the host API version, and the
compatibility/versioning rules. It contains no runtime UI.

It is consumed by the shell (`equisdots/shell`), the compositor config
(`equisdots/hyprland`), the installer (`equisdots/dots`) and any plugin.

## Scope

| Concern | Here |
|---|---|
| `plugin.json` manifest schema | `schema/` |
| Host API version (the value plugins gate on) | `plugin-api.json` |
| Compatibility + versioning spec | `docs/` |
| Semver-range evaluators (bash + Lua, kept in lockstep) | `scripts/`, `lib/` |
| Shared compat test vectors (drift guard) | `fixtures/` |

Runtime code (QML/Lua SDK) lives in **`equisdots/plugin-sdk`**. The standard's
narrative lives in `equisdots/plugins → docs/plugins.md`.

## Status

Work in progress on `branch/experimental` (mirrors the branch name used across
the equisdots repositories).

## License

Apache-2.0 — see [LICENSE](LICENSE). Copyright (C) 2026 xscriptor <x@xscriptor.com>.

Licensed under the Apache License, Version 2.0. You may use, modify and distribute it under the terms of that license.

Releases published before 2026-11-13 were distributed under the MIT License and remain available under those terms.

Third-party components, fonts, icons, images, sounds, vendored code and other assets keep their original licenses and are not covered by this license. See THIRD-PARTY.md / CREDITS.md where present.

Third-party plugins may use this SDK/API under Apache-2.0 and keep their own license for the plugin; the shell grants the plugin exception.
