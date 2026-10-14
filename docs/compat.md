# Compatibility & versioning

Three different "versions" are easy to conflate; only one gates loading.

| Version | Owner | Where | Meaning |
|---|---|---|---|
| **Host API** (`api`) | the shell | `plugin-api.json` | The plugin *contract* version: manifest schema, host SDK surface, `provides` namespaces. **This is what `compat` gates on.** |
| **Shell release** (`shell`) | the shell | `plugin-api.json` | The product version. Changes on any shell release; not a good compatibility key. Kept for legacy `compat.shell`. |
| **Plugin release** (`version`) | the plugin | `plugin.json` | Display/updates only. |

`plugin-api.json` (published by this repo, deployed with the shell):

```json
{ "api": "1.0.0", "shell": "0.1.0" }
```

## Declaring requirements

A plugin declares ranges in `plugin.json → compat`:

```json
"compat": { "host": ">=1.0.0 <2.0.0", "hyprland": ">=0.55" }
```

- **Absent `compat` = no constraint = load.**
- Keys: `host`, `shell`, `hyprland`, `quickshell`, `qt`.
- Range syntax is shared by both evaluators: `>= > <= < = ^ ~`, bare exact, and
  space/comma = AND (`>=1.0 <2`). `^1.2.0` = same major, `~1.2.0` = same minor.

## Verdicts

`scripts/plugins_compat.sh` (and the Lua mirror `lib/semver.lua`) produce:

| state | Meaning | Loads? |
|---|---|---|
| `ok` | all declared ranges satisfied, or no `compat` | yes |
| `warn` | declared but unverifiable (unknown version, unparsable range) | **yes** |
| `incompat` | a declared range is violated | **no** (inert) |

Fail-open on unknown metadata is deliberate: the gate is a safety rail, not a
security boundary. A missing `plugin-api.json` or unparsable range never bricks
a plugin.

## `api` bump policy

- **Major bump (`1.x → 2.0`)** — removing/renaming a required manifest field,
  changing an SDK signature, changing the settings-page/host contract, or
  renaming a `provides` namespace.
- **Additive (no bump)** — new optional fields, new SDK members, new `provides`
  keys. These ride the `shell` release for display and do **not** gate plugins.

## Drift guard

`fixtures/compat-vectors.json` holds vectors; `scripts/test.sh` runs them through
**both** the bash and Lua evaluators and requires identical verdicts.

```sh
scripts/test.sh
```
