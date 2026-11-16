$ErrorActionPreference = "Stop"

Write-Host "=== ORBIT - preparation automatique de Windows 11 ===" -ForegroundColor Cyan
Write-Host "Cette operation installe des outils gratuits. Une connexion Internet est necessaire sur le PC."
Write-Host ""

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  throw "winget est introuvable. Mets a jour 'App Installer' depuis Microsoft Store, puis relance ce script."
}

Write-Host "[1/4] Installation de Git..."
winget install --id Git.Git --exact --silent --accept-package-agreements --accept-source-agreements

Write-Host "[2/4] Installation d'Android Studio..."
winget install --id Google.AndroidStudio --exact --silent --accept-package-agreements --accept-source-agreements

Write-Host "[3/4] Installation de Flutter stable..."
$flutterHome = Join-Path $env:LOCALAPPDATA "Programs\flutter"
$flutterBin = Join-Path $flutterHome "bin"
if (-not (Test-Path (Join-Path $flutterBin "flutter.bat"))) {
  $releases = Invoke-RestMethod "https://storage.googleapis.com/flutter_infra_release/releases/releases_windows.json"
  $stable = $releases.releases | Where-Object { $_.channel -eq "stable" } | Select-Object -First 1
  if (-not $stable) { throw "Impossible de trouver la version stable de Flutter." }
  $zip = Join-Path $env:TEMP "flutter-stable-windows.zip"
  $url = "https://storage.googleapis.com/flutter_infra_release/releases/$($stable.archive)"
  Write-Host "Telechargement Flutter $($stable.version)..."
  Invoke-WebRequest -Uri $url -OutFile $zip
  $programs = Split-Path $flutterHome -Parent
  New-Item -ItemType Directory -Force -Path $programs | Out-Null
  if (Test-Path $flutterHome) { Remove-Item $flutterHome -Recurse -Force }
  Expand-Archive -Path $zip -DestinationPath $programs -Force
  Remove-Item $zip -Force
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (($userPath -split ';') -notcontains $flutterBin) {
  [Environment]::SetEnvironmentVariable("Path", (($userPath.TrimEnd(';') + ";" + $flutterBin).Trim(';')), "User")
}
$env:Path = "$flutterBin;$env:Path"

Write-Host "[4/4] Verification Flutter..."
& (Join-Path $flutterBin "flutter.bat") --version
& (Join-Path $flutterBin "flutter.bat") doctor

Write-Host ""
Write-Host "Outils installes. IMPORTANT :" -ForegroundColor Green
Write-Host "1. Ouvre Android Studio une fois et termine son assistant de premiere configuration."
Write-Host "2. Installe Android SDK Platform, Platform-Tools et Command-line Tools si Android Studio le demande."
Write-Host "3. Ferme puis rouvre PowerShell."
Write-Host "4. Double-clique ensuite sur scripts\build_android_debug.bat dans le dossier ORBIT."
Write-Host ""
Write-Host "Aucun abonnement ou logiciel payant n'est requis."
Read-Host "Appuie sur Entree pour fermer"
