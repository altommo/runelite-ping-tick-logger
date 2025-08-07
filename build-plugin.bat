@echo off
echo 🔧 RuneLite Plugin Builder
echo ==========================
echo.

REM Set Maven environment
set MAVEN_HOME=C:\Users\hp\Tools\apache-maven-3.9.4
set PATH=%MAVEN_HOME%\bin;%PATH%

REM Navigate to project
cd /d "C:\Users\hp\Development\runelite\runelite-client"

echo 🔨 Building RuneLite Client with Ping & Tick Logger...
echo This will take 2-5 minutes - please wait...
echo.

REM Compile and package
mvn compile package -DskipTests -T 1C

if errorlevel 1 (
    echo.
    echo ❌ Build failed! Check errors above.
    echo.
    echo Common fixes:
    echo 1. Make sure you're not running RuneLite
    echo 2. Check plugin syntax in PingLoggerPlugin.java
    echo 3. Try: mvn clean compile package -DskipTests
    echo.
    pause
    exit /b 1
)

echo.
echo 🎉 Build completed!
echo.

REM Find the JAR file
cd target
for %%f in (client-*-shaded.jar) do (
    if exist "%%f" (
        echo 📦 Created: %%f
        echo.
        echo 🚀 To run: java -jar "%%f"
        echo.
        goto :found
    )
)

for %%f in (client-*.jar) do (
    if exist "%%f" (
        if not "%%f"=="*tests*" (
            echo 📦 Created: %%f
            echo.
            echo 🚀 To run: java -jar "%%f"
            echo.
            goto :found
        )
    )
)

echo ⚠️  No JAR files found in target directory
echo Build may have failed silently.

:found
echo Files in target directory:
dir /b *.jar 2>nul || echo No JAR files found

echo.
echo Ready! Your enhanced plugin includes:
echo • Ping monitoring → ~/.runelite/ping.txt  
echo • Tick length tracking → ~/.runelite/tick.txt
echo • Combined data → ~/.runelite/ping_tick_data.txt
echo.

pause
