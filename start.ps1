<#
  One-command launcher for the scientific-writer web gateway (Windows).

  Starts the Node gateway on -Port; the gateway itself (re)spawns a local opencode
  on -OcPort so it rescans .opencode/skills every launch. Defaults 3100 / 4198 avoid
  clashing with the parent project (3000 / 4098).

  What it sets up before launch:
    - refreshes PATH from Machine+User so pandoc / MiKTeX(xelatex) / node / opencode resolve
    - prepends project .venv so vendored skills' bare 'python' / 'python3' hit THIS venv
    - preflights .venv and web\node_modules (auto npm install if missing)

  Usage:
    powershell -ExecutionPolicy Bypass -File start.ps1
    powershell -ExecutionPolicy Bypass -File start.ps1 -Port 3100 -OcPort 4198
    powershell -ExecutionPolicy Bypass -File start.ps1 -NoAuth     # disable LAN login (localhost is always free)

  ASCII-only on purpose: PowerShell 5.1 reads BOM-less UTF-8 as ANSI and garbles non-ASCII.
#>
param(
  [int]$Port   = 3100,
  [int]$OcPort = 4198,
  [switch]$NoAuth
)
$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$Py   = Join-Path $Root ".venv\Scripts\python.exe"

# 1) PATH: Machine+User (pandoc/MiKTeX/node/opencode) + project venv first (bare python3 -> this venv)
$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
$env:Path = (Join-Path $Root ".venv\Scripts") + ";" + $env:Path

# 2) preflight
if (-not (Test-Path $Py)) {
  Write-Host "[!] .venv not found ($Py). Run:  powershell -ExecutionPolicy Bypass -File install.ps1" -ForegroundColor Red
  exit 1
}
if (-not (Test-Path (Join-Path $Root "web\node_modules"))) {
  Write-Host "[*] web\node_modules missing -- running 'npm install' ..." -ForegroundColor Yellow
  Push-Location (Join-Path $Root "web")
  npm install --no-audit --no-fund
  Pop-Location
}
foreach ($t in "node","opencode") {
  if (-not (Get-Command $t -ErrorAction SilentlyContinue)) {
    Write-Host "[!] '$t' not on PATH. Install it, then retry." -ForegroundColor Red
    exit 1
  }
}
$g = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue
if ($g) {
  Write-Host "[!] Port $Port already in use (PID $($g.OwningProcess | Select-Object -First 1)). Pick another -Port or stop that process." -ForegroundColor Red
  exit 1
}

# 3) env for the gateway
$env:PORT   = "$Port"
$env:OC_URL = "http://127.0.0.1:$OcPort"
if ($NoAuth) { $env:LAN_AUTH = "0" }   # else leave default: LAN requires login, localhost is free

Write-Host "== scientific-writer gateway ==" -ForegroundColor Cyan
Write-Host ("  gateway  -> http://localhost:{0}" -f $Port) -ForegroundColor Green
Write-Host ("  opencode -> http://127.0.0.1:{0}  (cwd = {1})" -f $OcPort, $Root)
Write-Host ("  venv     -> {0}" -f $Py)
Write-Host "  Ctrl+C to stop the gateway. (opencode runs detached; stop it with scripts\serve-opencode.ps1 -Force or by killing port $OcPort.)" -ForegroundColor DarkGray
Write-Host ""

# 4) run gateway in the foreground (prints its own startup lines, incl. LAN URL/login)
Set-Location $Root
node web\server.mjs
