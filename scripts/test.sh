#!/usr/bin/env bash
# test.sh — run the shared compat vectors through BOTH evaluators and assert
# they agree. This is the drift guard between scripts/plugins_compat.sh (bash)
# and lib/semver.lua (Lua, used by the compositor loader).
set -euo pipefail

here="$(cd "$(dirname "$0")/.." && pwd)"
vec="$here/fixtures/compat-vectors.json"
compat="$here/scripts/plugins_compat.sh"
fail=0

if ! command -v jq >/dev/null 2>&1; then echo "SKIP: jq missing"; exit 0; fi

count="$(jq '.vectors | length' "$vec")"
for i in $(seq 0 $((count - 1))); do
    c="$(jq -c ".vectors[$i].compat" "$vec")"
    e="$(jq -c ".vectors[$i].env" "$vec")"
    want="$(jq -r ".vectors[$i].state" "$vec")"
    got="$(env \
        HOST_API="$(jq -r '.host // empty' <<<"$e")" \
        SHELL_VERSION="$(jq -r '.shell // empty' <<<"$e")" \
        HYPRLAND_VERSION="$(jq -r '.hyprland // empty' <<<"$e")" \
        QUICKSHELL_VERSION="$(jq -r '.quickshell // empty' <<<"$e")" \
        QT_VERSION="$(jq -r '.qt // empty' <<<"$e")" \
        bash "$compat" <<<"$c" | jq -r .state)"
    if [ "$got" != "$want" ]; then
        echo "FAIL bash vector $i: want=$want got=$got  compat=$c env=$e"
        fail=1
    fi
done
[ "$fail" = 0 ] && echo "bash evaluator: ok ($count vectors)"

lua_bin=""
if command -v lua >/dev/null 2>&1; then lua_bin="lua"
elif command -v luajit >/dev/null 2>&1; then lua_bin="luajit"
fi
if [ -n "$lua_bin" ]; then
    jq -r '.scalar.cases[] | "\(.ver)\t\(.range)\t\(.rc)"' "$vec" \
        | "$lua_bin" "$here/lib/test_semver.lua" || fail=1
else
    echo "lua: SKIPPED (no lua/luajit)"
fi

if [ "$fail" = 0 ]; then echo "ALL OK"; else echo "FAILURES"; exit 1; fi
