@echo off
echo 🎮 RuneLite Launcher - Enhanced Plugin
echo ======================================
echo.

cd /d "C:\Users\hp\Development\runelite\runelite-client\target"

REM Find JAR file
set JAR_FILE=
for %%f in (client-*-shaded.jar) do set JAR_FILE=%%f
if not defined JAR_FILE (
    for %%f in (client-*.jar) do (
        if not "%%f"=="*tests*" set JAR_FILE=%%f
    )
)

if not defined JAR_FILE (
    echo ❌ No RuneLite JAR found!
    echo Run build-plugin.bat first to build the project.
    echo.
    pause
    exit /b 1
)

echo 📦 Found: %JAR_FILE%
echo.
echo 🚀 Starting RuneLite with Ping & Tick Logger...
echo.
echo After RuneLite loads:
echo 1. Go to Settings ^> Plugin Configuration
echo 2. Find "Ping & Tick Logger"  
echo 3. Enable it and configure options
echo 4. Log into OSRS to start data collection
echo.
echo Output files will be created in:
echo   %USERPROFILE%\.runelite\ping.txt
echo   %USERPROFILE%\.runelite\tick.txt  
echo   %USERPROFILE%\.runelite\ping_tick_data.txt
echo.

java -jar "%JAR_FILE%"

echo.
echo RuneLite closed.
echo.

REM Show current data if available
if exist "%USERPROFILE%\.runelite\ping.txt" (
    set /p PING=<"%USERPROFILE%\.runelite\ping.txt"
    echo Current ping: !PING! ms
)

if exist "%USERPROFILE%\.runelite\tick.txt" (
    set /p TICK=<"%USERPROFILE%\.runelite\tick.txt"  
    echo Current tick: !TICK! ms
)

pause
