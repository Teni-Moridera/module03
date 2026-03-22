# Сборка bookstore_lab.db из SQL-скриптов SQLite
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Db = Join-Path $Root "sqlite\bookstore_lab.db"
$SqlDir = Join-Path $Root "sqlite"

if (-not (Get-Command sqlite3 -ErrorAction SilentlyContinue)) {
  Write-Error "Нет sqlite3 в PATH. Установите SQLite CLI или добавьте каталог в PATH."
}

if (Test-Path $Db) { Remove-Item $Db -Force }

$files = @(
  "01_schema.sql",
  "02_triggers.sql",
  "03_seed_roles.sql",
  "04_views_access.sql",
  "05_demo_data.sql",
  "06_integrity_extra.sql"
)

Push-Location $SqlDir
try {
  foreach ($f in $files) {
    Write-Host ">> $f"
    & sqlite3 $Db ".read $f"
  }
} finally {
  Pop-Location
}

Write-Host "Готово: $Db"
