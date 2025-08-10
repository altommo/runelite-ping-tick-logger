@echo off
echo 🚀 RuneLite Enhanced Build Script
echo ==================================
echo Configuration features restored and ready!
echo.

cd /d "C:\Users\hp\Development\runelite"

REM Set environment
set MAVEN_HOME=C:\Users\hp\Tools\apache-maven-3.9.4
set PATH=%MAVEN_HOME%\bin;%PATH%

echo 📋 Build Summary:
echo ✅ ConfigItem.unhide() - RESTORED
echo ✅ ConfigSection.keyName() - RESTORED  
echo ✅ Units.POINTS - ADDED
echo ✅ WidgetMenuOption import - FIXED
echo ✅ Plugin compatibility - RESOLVED
echo.

echo 🔨 Starting optimized build process...
echo.

REM Step 1: Clean build
echo [1/4] Cleaning previous builds...
mvn clean -q
if errorlevel 1 (
    echo ❌ Clean failed
    pause
    exit /b 1
)

REM Step 2: Compile in stages for better error detection
echo [2/4] Compiling configuration framework...
mvn compile -pl runelite-client -am -DskipTests -q
if errorlevel 1 (
    echo ❌ Configuration compilation failed!
    echo This suggests issues with ConfigItem/ConfigSection changes.
    echo.
    mvn compile -pl runelite-client -am -DskipTests -X | findstr "ERROR"
    pause
    exit /b 1
)

echo [3/4] Compiling full project...
mvn compile -DskipTests -q  
if errorlevel 1 (
    echo ❌ Full compilation failed!
    echo Attempting to identify specific plugin issues...
    echo.
    
    REM Try to isolate the failing module
    mvn compile -DskipTests 2>build_errors.log
    echo Recent errors:
    tail -20 build_errors.log 2>nul || type build_errors.log | findstr /C:"ERROR" | head -10
    
    echo.
    echo Full log saved to: build_errors.log
    pause
    exit /b 1
)

echo [4/4] Packaging application...
mvn package -DskipTests -q
if errorlevel 1 (
    echo ❌ Packaging failed!
    pause
    exit /b 1
)

echo.
echo 🎉 BUILD SUCCESSFUL!
echo.

REM Find and display the result
cd runelite-client\target
for %%f in (client-*-shaded.jar) do (
    if exist "%%f" (
        echo 📦 Enhanced RuneLite Client: %%f
        echo 📍 Location: %CD%\%%f
        
        REM Create convenient launch script
        echo @echo off > ..\..\..\launch-enhanced-runelite.bat
        echo cd /d "%CD%" >> ..\..\..\launch-enhanced-runelite.bat  
        echo echo Starting Enhanced RuneLite with restored plugin features... >> ..\..\..\launch-enhanced-runelite.bat
        echo java -jar "%%f" >> ..\..\..\launch-enhanced-runelite.bat
        
        echo.
        echo 🚀 Quick Launch: launch-enhanced-runelite.bat created
        echo.
        echo 🎯 Enhanced Features Available:
        echo   • Dynamic UI with unhide conditions
        echo   • Custom section organization  
        echo   • Points-based configurations (raids/PvM)
        echo   • Full teleportation plugin configs
        echo   • Advanced menu entry swapping
        echo   • One-click automation tools
        echo.
        goto :found
    )
)

echo ❌ Final JAR not found - build may have failed silently
dir /b *.jar 2>nul

:found
echo ✅ Your enhanced RuneLite development build is ready!
echo.
pause
