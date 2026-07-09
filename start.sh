#!/usr/bin/env bash
# One-command launcher for the scientific-writer web gateway (Linux / macOS).
# Starts the Node gateway on $PORT; the gateway (re)spawns a local opencode on
# $OC_PORT so it rescans .opencode/skills every launch.
#
# Usage:
#   bash start.sh
#   PORT=3100 OC_PORT=4198 bash start.sh
#   NO_AUTH=1 bash start.sh        # disable LAN login (localhost is always free)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
PORT="${PORT:-3100}"
OC_PORT="${OC_PORT:-4198}"
PY="$ROOT/.venv/bin/python"

# venv first so vendored skills' bare 'python3' resolves to THIS venv
export PATH="$ROOT/.venv/bin:$PATH"

# preflight
[ -x "$PY" ] || { echo "[!] .venv not found ($PY). Run: bash install.sh"; exit 1; }
[ -d "$ROOT/web/node_modules" ] || { echo "[*] web/node_modules missing -- running npm install ..."; ( cd "$ROOT/web" && npm install --no-audit --no-fund ); }
command -v node     >/dev/null 2>&1 || { echo "[!] node not on PATH";     exit 1; }
command -v opencode >/dev/null 2>&1 || { echo "[!] opencode not on PATH"; exit 1; }

export PORT
export OC_URL="http://127.0.0.1:$OC_PORT"
[ "${NO_AUTH:-0}" = "1" ] && export LAN_AUTH=0

echo "== scientific-writer gateway =="
echo "  gateway  -> http://localhost:$PORT"
echo "  opencode -> http://127.0.0.1:$OC_PORT  (cwd = $ROOT)"
echo "  Ctrl+C to stop."
cd "$ROOT"
exec node web/server.mjs
