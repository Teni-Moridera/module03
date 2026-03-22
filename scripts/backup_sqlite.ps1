# Резервная копия SQLite (онлайн-копия через API sqlite3)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Db = Join-Path $Root "sqlite\bookstore_lab.db"
$BackupDir = Join-Path $Root "backups"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Out = Join-Path $BackupDir "bookstore_lab_$Stamp.db"

if (-not (Test-Path $Db)) {
  Write-Error "Нет файла БД: $Db (сначала запустите init_sqlite.ps1)"
}

New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

# Встроенная команда .backup создаёт согласованный снимок
$sql = ".backup '$($Out.Replace('\','/'))'"
& sqlite3 $Db $sql

Write-Host "Копия: $Out"
