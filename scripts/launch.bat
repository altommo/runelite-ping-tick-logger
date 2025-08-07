@echo off
echo 🎮 RuneLite Launcher
echo ====================
echo.

REM Navigate to project directory
cd /d "%~dp0.."
set CLIENT_TARGET=%CD%\runelite-client\target

REM Find the RuneLite JAR
if exist "%CLIENT_TARGET%\client-*-shaded.jar" (
    for %%f in ("%CLIENT_TARGET%\client-*-shaded.jar") do set JAR_FILE=%%~nxf
) else if exist "%CLIENT_TARGET%\client-*.jar" (
    for %%f in ("%CLIENT_TARGET%\client-*.jar") do (
        if not "%%~nxf"=="*tests*" set JAR_FILE=%%~nxf
    )
) else (
    echo ❌ No RuneLite JAR found!
    echo Please run the build script first:
    echo   scripts\build.bat
    echo.
    pause
    exit /b 1
)

echo 📦 Found RuneLite JAR: %JAR_FILE%
echo.

echo 🚀 Launching RuneLite...
echo.
echo Instructions:
echo 1. Wait for RuneLite to fully load
echo 2. Go to Settings ^> Plugin Configuration  
echo 3. Enable your custom plugins (e.g., 'Ping Logger')
echo 4. Log into OSRS to test plugins
echo.

REM Launch RuneLite
cd /d "%CLIENT_TARGET%"
java -jar "%JAR_FILE%"

echo.
echo RuneLite has closed.
echo.
echo 📝 Plugin logs available at:
echo   %USERPROFILE%\.runelite\logs\client.log
echo.

pause
