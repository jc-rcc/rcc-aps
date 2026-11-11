param(
    [string]$Root = (Join-Path $env:USERPROFILE 'rcc-aps-production'),
    [string]$ComposeFile = (Join-Path $Root 'compose.yaml')
)
$ErrorActionPreference = 'Stop'
$folder = Join-Path $Root 'backups'
New-Item -ItemType Directory -Path $folder -Force | Out-Null
$destination = Join-Path $folder ((Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') + '-' + [guid]::NewGuid().ToString('N') + '.sql')
$compose = @('compose', '--project-directory', $Root, '--env-file', (Join-Path $Root '.env'), '-f', $ComposeFile)
# Copy the dump as a file to avoid Windows PowerShell redirection encoding changes.
& docker @compose exec -T db sh -c 'export MYSQL_PWD=$MYSQL_PASSWORD; exec mysqldump -u rcc_app --single-transaction --no-tablespaces --set-gtid-purged=OFF rcc_aps > /tmp/rcc-aps-backup.sql'
if ($LASTEXITCODE -ne 0) { throw 'Database dump failed; deployment stopped.' }
& docker @compose cp db:/tmp/rcc-aps-backup.sql $destination
if ($LASTEXITCODE -ne 0) { throw 'Could not copy the database backup.' }
if ((Get-Item -LiteralPath $destination).Length -eq 0) { throw 'Database backup is empty.' }
Write-Host ('Database backup saved: ' + $destination)
