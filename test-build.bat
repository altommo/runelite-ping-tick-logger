@echo off
echo 🔧 Quick Plugin Test Build
echo ==========================
echo.

cd /d "C:\Users\hp\Development\runelite"

echo Testing compilation of fixed files...
echo.

REM Set Maven environment
set MAVEN_HOME=C:\Users\hp\Tools\apache-maven-3.9.4
set PATH=%MAVEN_HOME%\bin;%PATH%

REM Build just the client module
echo Building runelite-client only...
cd runelite-client
mvn compile -DskipTests -q

if errorlevel 1 (
    echo.
    echo ❌ Client compilation failed!
    echo The Java files have syntax errors that need to be fixed.
    pause
    exit /b 1
) else (
    echo.
    echo ✅ Client compilation successful!
    echo Plugin files are syntactically correct.
)

echo.
pause
