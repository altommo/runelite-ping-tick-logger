@echo off
setlocal enabledelayedexpansion
echo 🔧 RuneLite Enhanced Plugin Builder
echo ====================================
echo.

REM Check Java version
java -version 2>nul
if errorlevel 1 (
    echo ❌ Java not found! Please install Java 17+ and add to PATH.
    pause
    exit /b 1
)

REM Set Maven environment
set MAVEN_HOME=C:\Users\hp\Tools\apache-maven-3.9.4
set PATH=%MAVEN_HOME%\bin;%PATH%

REM Verify Maven is available
mvn -version 2>nul
if errorlevel 1 (
    echo ❌ Maven not found! Please check MAVEN_HOME path.
    echo Current MAVEN_HOME: %MAVEN_HOME%
    pause
    exit /b 1
)

REM Navigate to project root
cd /d "C:\Users\hp\Development\runelite"

REM Verify we're in the right directory
if not exist "pom.xml" (
    echo ❌ Not in RuneLite project directory! Missing pom.xml
    echo Current directory: %CD%
    pause
    exit /b 1
)

echo ✅ Environment check passed
echo 📁 Project directory: %CD%
echo.

echo 🧹 Cleaning previous builds...
mvn clean -q
if errorlevel 1 (
    echo ❌ Clean failed! Check Maven configuration.
    pause
    exit /b 1
)

echo.
echo 🔨 Building RuneLite with Enhanced Plugins...
echo This will take 2-5 minutes - please wait...
echo.

REM Build with proper phases and error handling
echo [1/3] Compiling dependencies...
mvn compile -DskipTests -q
if errorlevel 1 (
    echo ❌ Compilation failed! Checking for specific errors...
    echo.
    mvn compile -DskipTests 2>compile_errors.txt
    echo Top compilation errors:
    findstr /C:"ERROR" compile_errors.txt 2>nul || echo No specific errors found in log
    echo.
    echo Full error log saved to: compile_errors.txt
    pause
    exit /b 1
)

echo [2/3] Packaging application...
mvn package -DskipTests -q
if errorlevel 1 (
    echo ❌ Packaging failed!
    mvn package -DskipTests 2>package_errors.txt
    echo Package error log saved to: package_errors.txt
    pause
    exit /b 1
)

echo [3/3] Finalizing build...

REM Find the built JAR file
cd runelite-client\target
set JAR_FOUND=0

REM Look for shaded JAR first (preferred)
for %%f in (client-*-shaded.jar) do (
    if exist "%%f" (
        set JAR_FILE=%%f
        set JAR_FOUND=1
        goto :jar_found
    )
)

REM Fallback to regular JAR
for %%f in (client-*.jar) do (
    if exist "%%f" (
        echo %%f | findstr /v "tests" >nul
        if !errorlevel! equ 0 (
            set JAR_FILE=%%f
            set JAR_FOUND=1
            goto :jar_found
        )
    )
)

:jar_found
if %JAR_FOUND%==0 (
    echo ❌ No JAR file found in target directory!
    echo Available files:
    dir /b *.* 2>nul || echo No files found
    pause
    exit /b 1
)

echo.
echo 🎉 Build completed successfully!
echo.
echo 📦 Created: %JAR_FILE%
echo 📍 Location: %CD%\%JAR_FILE%
echo 💾 Size: 
for %%f in ("%JAR_FILE%") do echo    %%~zf bytes

REM Get file size in MB
for %%f in ("%JAR_FILE%") do set /a SIZE_MB=%%~zf/1024/1024
echo    (~%SIZE_MB% MB)

echo.
echo 🚀 To run your enhanced RuneLite:
echo    java -jar "%JAR_FILE%"
echo.
echo 📋 Enhanced features included:
echo    ✅ MenuEntrySwapperExtended with full unhide support
echo    ✅ OneClick plugins with all configurations  
echo    ✅ Ping and Tick logging capabilities
echo    ✅ All teleportation and PvM configurations
echo    ✅ Custom swapping and hotkey systems
echo.

REM Create a launch script
echo @echo off > launch-runelite.bat
echo cd /d "%CD%" >> launch-runelite.bat
echo java -jar "%JAR_FILE%" >> launch-runelite.bat
echo pause >> launch-runelite.bat

echo 💡 Quick launch script created: launch-runelite.bat
echo.

pause
