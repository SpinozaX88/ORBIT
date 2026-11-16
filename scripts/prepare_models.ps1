$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$ModelDir = Join-Path $Root "assets\models"
$ModelPath = Join-Path $ModelDir "ggml-tiny.bin"
New-Item -ItemType Directory -Force -Path $ModelDir | Out-Null

if (Test-Path $ModelPath) {
  $size = (Get-Item $ModelPath).Length
  if ($size -gt 10000000) {
    Write-Host "Modele Whisper Tiny deja present ($([math]::Round($size / 1MB)) Mo)."
    exit 0
  }
}

$url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin"
Write-Host "Telechargement du modele multilingue Whisper Tiny depuis Hugging Face..."
Write-Host "Ce telechargement se fait sur le PC de developpement, pas depuis ORBIT."
Invoke-WebRequest -Uri $url -OutFile $ModelPath
if ((Get-Item $ModelPath).Length -lt 10000000) {
  Remove-Item $ModelPath -Force
  throw "Le fichier telecharge semble invalide."
}
$hash = (Get-FileHash $ModelPath -Algorithm SHA256).Hash
Set-Content -Path (Join-Path $ModelDir "ggml-tiny.sha256.txt") -Value $hash
Write-Host "Modele pret : $([math]::Round((Get-Item $ModelPath).Length / 1MB)) Mo"
Write-Host "SHA256 : $hash"
Write-Host "Le modele sera integre dans l'APK a la compilation."
