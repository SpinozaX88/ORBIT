@echo off
echo === Verification de l'environnement ORBIT ===
where flutter
if errorlevel 1 echo Flutter absent du PATH.
where adb
if errorlevel 1 echo ADB absent du PATH.
echo.
echo Si Flutter est installe :
flutter doctor -v
pause
