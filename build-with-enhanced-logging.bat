@echo off
setlocal enabledelayedexpansion

echo 🚀 RuneLite Enhanced Build with Full Logging
echo =============================================
echo.

cd /d "C:\Users\hp\Development\runelite"

:: Generate simple timestamp
for /f "tokens=1-3 delims=/- " %%a in ("%date%") do (
    set "day=%%a"
    set "month=%%b"
    set "year=%%c"
)
for /f "tokens=1-2 delims=: " %%a in ("%time%") do (
    set "hour=%%a"
    set "minute=%%b"
)

set "hour=!hour: =0!"
set "TIMESTAMP=!month!!day!_!hour!!minute!"
set "LOGFILE=build_!TIMESTAMP!.log"

echo Starting build at %date% %time%
echo Logging to: !LOGFILE!
echo.

REM Clear any existing log file
if exist "!LOGFILE!" del "!LOGFILE!"

echo =============================================== >> "!LOGFILE!"
echo RuneLite Enhanced Build Log - %date% %time% >> "!LOGFILE!"
echo =============================================== >> "!LOGFILE!"
echo. >> "!LOGFILE!"

echo [PHASE 1] Maven Clean >> "!LOGFILE!"
echo [%time%] Starting Maven clean... >> "!LOGFILE!"
echo Running: mvn clean >> "!LOGFILE!"
mvn clean >> "!LOGFILE!" 2>&1

if !errorlevel! neq 0 (
    echo ❌ Clean failed - check !LOGFILE!
    echo [%time%] Clean FAILED with error level !errorlevel! >> "!LOGFILE!"
    goto :show_errors
)

echo ✅ Clean completed successfully
echo [%time%] Clean completed successfully >> "!LOGFILE!"
echo. >> "!LOGFILE!"

echo [PHASE 2] Maven Compilation >> "!LOGFILE!"
echo [%time%] Starting compilation... >> "!LOGFILE!"
echo Command: mvn compile -DskipTests -pl runelite-client -am >> "!LOGFILE!"
echo ---------------------------------------------------- >> "!LOGFILE!"

echo 🔄 Starting compilation phase (this may take 2-5 minutes)...
mvn compile -DskipTests -pl runelite-client -am >> "!LOGFILE!" 2>&1

echo [%time%] Compilation command completed with exit code !errorlevel! >> "!LOGFILE!"

if !errorlevel! neq 0 (
    echo. >> "!LOGFILE!"
    echo [%time%] Compilation FAILED >> "!LOGFILE!"
    echo =============================================== >> "!LOGFILE!"
    
    echo.
    echo ❌ Compilation failed - analyzing errors...
    echo.
    
    goto :analyze_errors
) else (
    echo [%time%] Compilation completed successfully! >> "!LOGFILE!"
    echo. >> "!LOGFILE!"
    echo ✅ Compilation successful!
    
    echo [PHASE 3] Maven Package >> "!LOGFILE!"
    echo [%time%] Starting packaging... >> "!LOGFILE!"
    echo Command: mvn package -DskipTests -pl runelite-client >> "!LOGFILE!"
    mvn package -DskipTests -pl runelite-client >> "!LOGFILE!" 2>&1
    
    if !errorlevel! neq 0 (
        echo [%time%] Packaging FAILED >> "!LOGFILE!"
        echo ❌ Packaging failed - check !LOGFILE!
        goto :show_errors
    ) else (
        echo [%time%] Build completed successfully! >> "!LOGFILE!"
        echo ✅ Build completed successfully!
        echo.
        echo 📦 Output JAR files:
        dir /b runelite-client\target\*.jar 2>nul
        echo.
        echo 🎯 Enhanced RuneLite client ready for testing!
        goto :end
    )
)

:analyze_errors
echo 📋 COMPILATION ERROR ANALYSIS:
echo =============================

REM Count different types of errors
echo. >> "!LOGFILE!"
echo ERROR ANALYSIS SECTION >> "!LOGFILE!"
echo ====================== >> "!LOGFILE!"

echo.
echo 🔍 Error Summary:
findstr /C:"ERROR" "!LOGFILE!" | find /C "ERROR" > temp_count.txt
set /p error_count=<temp_count.txt
del temp_count.txt 2>nul
echo   - Total ERROR lines: !error_count!

findstr /C:"cannot find symbol" "!LOGFILE!" | find /C "cannot find symbol" > temp_count.txt
set /p symbol_count=<temp_count.txt
del temp_count.txt 2>nul
echo   - Cannot find symbol: !symbol_count!

echo.
echo 🔍 Top 10 Missing Symbols:
findstr /C:"cannot find symbol" "!LOGFILE!" > temp_symbols.txt
if exist temp_symbols.txt (
    type temp_symbols.txt | powershell "Get-Content | Select-Object -First 10"
    del temp_symbols.txt
)

echo.
echo 🔍 Missing Methods:
findstr /C:"symbol:   method" "!LOGFILE!" > temp_methods.txt
if exist temp_methods.txt (
    type temp_methods.txt | powershell "Get-Content | Select-Object -First 5"
    del temp_methods.txt
)

echo.
echo 🔍 Missing Classes:
findstr /C:"symbol:   class" "!LOGFILE!" > temp_classes.txt
if exist temp_classes.txt (
    type temp_classes.txt | powershell "Get-Content | Select-Object -First 5"
    del temp_classes.txt
)

echo.
echo 🔍 Compilation Failures by Module:
findstr /C:"COMPILATION ERROR" "!LOGFILE!" 2>nul
findstr /C:"BUILD FAILURE" "!LOGFILE!" 2>nul

goto :show_errors

:show_errors
echo.
echo 📋 Last 30 lines of build log:
echo ==============================
powershell "if (Test-Path '!LOGFILE!') { Get-Content '!LOGFILE!' | Select-Object -Last 30 }"

:end
echo.
echo 📄 Complete build log: !LOGFILE!
echo 🔧 Analyze the full log for detailed error information
echo.

endlocal
pause
