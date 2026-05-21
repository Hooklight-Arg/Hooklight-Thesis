param(
  [string]$BackupDir = "$PSScriptRoot\\backups",
  [string]$DbName = $env:POSTGRES_DB,
  [string]$DbUser = $env:POSTGRES_USER
)

if ([string]::IsNullOrWhiteSpace($DbName)) { $DbName = "phishing_awareness" }
if ([string]::IsNullOrWhiteSpace($DbUser)) { $DbUser = "postgres" }

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "hooklight_${DbName}_backup_${timestamp}.sql"
$backupPath = Join-Path $BackupDir $backupFile

New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null

Write-Host "Creating backup for database '$DbName' as user '$DbUser'..."
Write-Host "Output: $backupPath"

docker compose exec -T postgres pg_dump -U $DbUser -d $DbName --no-owner --no-privileges --format=plain > $backupPath

if ($LASTEXITCODE -ne 0) {
  Write-Error "Backup failed. Check Docker and database credentials."
  exit 1
}

Write-Host "Backup created successfully."
Write-Host "Restore example:"
Write-Host "  docker compose exec -T postgres psql -U $DbUser -d $DbName < `"$backupPath`""
