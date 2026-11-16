@echo off
setlocal
cd /d "%~dp0\.."

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter introuvable. Installe Flutter stable et ajoute flutter\bin au PATH.
  pause
  exit /b 1
)

if not exist "assets\models\ggml-tiny.bin" (
  echo Preparation du modele vocal multilingue...
  powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\prepare_models.ps1"
  if errorlevel 1 (
    echo Echec de preparation du modele.
    pause
    exit /b 1
  )
)

if not exist "android\gradlew.bat" (
  echo Generation du projet Android Flutter...
  if exist "android" ren "android" "android_orbit_stub"
  flutter create --platforms=android --project-name orbit .
  if errorlevel 1 (
    if exist "android_orbit_stub" ren "android_orbit_stub" "android"
    pause
    exit /b 1
  )
  if exist "android_orbit_stub" rmdir /s /q "android_orbit_stub"
)

echo Configuration de la permission microphone et suppression de INTERNET...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p='android\app\src\main\AndroidManifest.xml';" ^
  "$x=Get-Content $p -Raw;" ^
  "$x=$x -replace '(?m)^\s*<uses-permission android:name=\"android.permission.INTERNET\"\s*/>\s*\r?\n','';" ^
  "if ($x -notmatch 'android.permission.RECORD_AUDIO') { $x=$x -replace '<application', '<uses-permission android:name=\"android.permission.RECORD_AUDIO\" />`r`n    <application' };" ^
  "Set-Content -Path $p -Value $x -Encoding UTF8;" ^
  "Get-ChildItem android\app\src -Filter AndroidManifest.xml -Recurse | ForEach-Object { $q=$_.FullName; $t=Get-Content $q -Raw; $t=$t -replace '(?m)^\s*<uses-permission android:name=\"android.permission.INTERNET\"\s*/>\s*\r?\n',''; Set-Content -Path $q -Value $t -Encoding UTF8 }"
if errorlevel 1 (
  echo Attention : verifie le manifeste Android.
  pause
  exit /b 1
)

echo Configuration Android API 24 minimum...
if exist "android\app\build.gradle.kts" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-Content 'android\app\build.gradle.kts' -Raw) -replace 'minSdk\s*=\s*flutter\.minSdkVersion','minSdk = 24' | Set-Content 'android\app\build.gradle.kts' -Encoding UTF8"
)
if exist "android\app\build.gradle" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-Content 'android\app\build.gradle' -Raw) -replace 'minSdkVersion\s+flutter\.minSdkVersion','minSdkVersion 24' | Set-Content 'android\app\build.gradle' -Encoding UTF8"
)

echo Recuperation des dependances...
flutter pub get
if errorlevel 1 (
  pause
  exit /b 1
)

echo Compilation APK debug...
flutter build apk --debug
if errorlevel 1 (
  pause
  exit /b 1
)

echo.
echo APK cree dans :
echo build\app\outputs\flutter-apk\app-debug.apk
pause
