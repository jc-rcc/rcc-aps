$ErrorActionPreference = 'Stop'
try {
    $root = Join-Path $env:USERPROFILE 'rcc-aps-production'
    $release = Join-Path $root 'releases/__SHA__'
    New-Item -ItemType Directory -Path $release -Force | Out-Null
    & tar -xzf (Join-Path $root 'incoming-__SHA__.tar.gz') -C $release
    if ($LASTEXITCODE -ne 0) { throw 'Could not extract deployment bundle.' }
    & (Join-Path $release 'scripts/Deploy.ps1') -Root $root -Release $release -Image '__IMAGE__'
} catch {
    Write-Error $_
    exit 1
}
