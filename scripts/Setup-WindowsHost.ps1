param([string]$Root = (Join-Path $env:USERPROFILE 'rcc-aps-production'))
$ErrorActionPreference = 'Stop'
if (!(Get-Command docker -ErrorAction SilentlyContinue)) { throw 'Install Docker Desktop and enable Linux containers / WSL2 first.' }
if (!(Get-Command node -ErrorAction SilentlyContinue)) { throw 'Install Node.js 22 or newer first.' }
& docker version --format '{{.Server.Version}}'
if ($LASTEXITCODE -ne 0) { throw 'Start Docker Desktop and wait until its Linux engine is ready.' }
& docker compose version
if ($LASTEXITCODE -ne 0) { throw 'Docker Compose v2 is required.' }
New-Item -ItemType Directory -Path $Root -Force | Out-Null
if (!(Test-Path -LiteralPath (Join-Path $Root '.env'))) {
    & node (Join-Path $PSScriptRoot 'configure-demo.cjs') $Root
    if ($LASTEXITCODE -ne 0) { throw 'Could not create host secrets.' }
}
Write-Host ('Production directory: ' + $Root)
Write-Host 'Keep .env private. Add your tunnel token there after choosing a domain.'
Write-Host 'Use a dedicated SSH key for CI. Follow DEPLOYMENT.md for Windows OpenSSH and Tailscale.'
