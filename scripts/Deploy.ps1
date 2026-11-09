param(
    [Parameter(Mandatory = $true)][string]$Image,
    [Parameter(Mandatory = $true)][string]$Release,
    [string]$Root = (Join-Path $env:USERPROFILE 'rcc-aps-production')
)
$ErrorActionPreference = 'Stop'
if ($Image -notmatch '^ghcr\.io/[a-z0-9._/-]+@sha256:[a-f0-9]{64}$') { throw 'Expected an immutable GHCR image digest.' }
$envFile = Join-Path $Root '.env'
if (!(Test-Path -LiteralPath $envFile)) { throw 'Create the host .env before enabling deployment.' }
if (!(Select-String -LiteralPath $envFile -Pattern '^CLOUDFLARE_TUNNEL_TOKEN=\S+$' -Quiet)) {
    throw 'Add the Cloudflare Tunnel token to the host .env before enabling public deployment.'
}
$composeFile = Join-Path $Release 'compose.yaml'
$compose = @('compose', '--project-directory', $Root, '--env-file', $envFile, '-f', $composeFile)
$originalImage = $env:APP_IMAGE
$env:APP_IMAGE = $Image
function Invoke-Compose {
    & docker @compose @args
    if ($LASTEXITCODE -ne 0) { throw ('Docker Compose failed: ' + ($args -join ' ')) }
}
try {
    Invoke-Compose config --quiet
    Invoke-Compose pull app
    Invoke-Compose up -d --wait --wait-timeout 180 db
    & (Join-Path $Release 'scripts/Backup.ps1') -Root $Root -ComposeFile $composeFile
    Invoke-Compose --profile tunnel up -d --no-build --wait --wait-timeout 240
    Invoke-Compose exec -T app node -e "fetch('http://127.0.0.1:3000/api/ready').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
    $active = Join-Path $Root '.release.env'
    if ((Test-Path -LiteralPath $active) -and ((Get-Content -LiteralPath $active -Raw).Trim() -ne "APP_IMAGE=$Image")) {
        Copy-Item -LiteralPath $active -Destination (Join-Path $Root '.previous-release.env') -Force
        Copy-Item -LiteralPath (Join-Path $Root 'compose.yaml') -Destination (Join-Path $Root 'compose.previous.yaml') -Force
    }
    Copy-Item -LiteralPath $composeFile -Destination (Join-Path $Root 'compose.yaml') -Force
    [System.IO.File]::WriteAllText($active, "APP_IMAGE=$Image`n", [System.Text.UTF8Encoding]::new($false))
    Write-Host 'Containers passed readiness checks. The workflow will now check the public URL.'
} finally {
    $env:APP_IMAGE = $originalImage
}
