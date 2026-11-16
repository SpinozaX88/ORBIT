@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\install_orbit_tools.ps1"
if errorlevel 1 (
  echo.
  echo Une erreur est survenue. Copie le message et envoie-le dans ChatGPT.
  pause
)
