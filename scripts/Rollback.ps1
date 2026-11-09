param([string]$Root = (Join-Path $env:USERPROFILE 'rcc-aps-production'))
$ErrorActionPreference = 'Stop'
$previous = Join-Path $Root '.previous-release.env'
$previousCompose = Join-Path $Root 'compose.previous.yaml'
if (!(Test-Path -LiteralPath $previous) -or !(Test-Path -LiteralPath $previousCompose)) {
    throw 'No previous successful application release is recorded.'
}
# This restores application code only. Review migration compatibility first.
$compose = @('compose', '--project-directory', $Root, '--env-file', (Join-Path $Root '.env'), '--env-file', $previous, '-f', $previousCompose)
$originalImage = $env:APP_IMAGE
$env:APP_IMAGE = $null
try {
    & docker @compose --profile tunnel up -d --no-build --wait --wait-timeout 240
    if ($LASTEXITCODE -ne 0) { throw 'Previous release did not become healthy.' }
    Copy-Item -LiteralPath $previous -Destination (Join-Path $Root '.release.env') -Force
    Copy-Item -LiteralPath $previousCompose -Destination (Join-Path $Root 'compose.yaml') -Force
    Write-Host 'Previous application image restored. Verify the public URL and login.'
} finally {
    $env:APP_IMAGE = $originalImage
}
