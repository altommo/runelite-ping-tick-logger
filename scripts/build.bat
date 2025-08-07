@echo off
echo 🚀 RuneLite Build Script
echo ========================
echo.

REM Set environment variables
set MAVEN_HOME=C:\Users\hp\Tools\apache-maven-3.9.4
set PATH=%MAVEN_HOME%\bin;%PATH%

REM Check Maven
echo Checking prerequisites...
call mvn --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Maven not found. Please install Maven 3.6+
    pause
    exit /b 1
)
echo ✅ Maven found

REM Check Java
call java -version >nul 2>&1
if errorlevel 1 (
    echo ❌ Java not found. Please install Java 11+
    pause
    exit /b 1
)
echo ✅ Java found

echo.
echo 🔨 Building RuneLite with custom plugins...
echo This may take 2-5 minutes...
echo.

REM Navigate to project root
cd /d "%~dp0.."

REM Clean and build
call mvn clean install -DskipTests -T 1C

if errorlevel 1 (
    echo.
    echo ❌ Build failed!
    pause
    exit /b 1
)

echo.
echo 🎉 Build completed successfully!
echo.
echo 🚀 Ready to launch!
echo Run: scripts\launch.bat
echo.

pause
