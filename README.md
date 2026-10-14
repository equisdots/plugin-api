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

MIT — see `LICENSE`.
