@echo off
setlocal enabledelayedexpansion

echo 🚀 RuneLite Build with Console AND File Logging
echo ================================================
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
echo Logging to both console and file: !LOGFILE!
echo.

REM Clear any existing log file
if exist "!LOGFILE!" del "!LOGFILE!"

echo =============================================== | tee "!LOGFILE!"
echo RuneLite Build Log - %date% %time% | tee -a "!LOGFILE!"
echo =============================================== | tee -a "!LOGFILE!"
echo. | tee -a "!LOGFILE!"

echo [PHASE 1] Starting Maven Clean...
echo [PHASE 1] Starting Maven Clean... >> "!LOGFILE!"
echo Command: mvn clean
echo Command: mvn clean >> "!LOGFILE!"
echo.

:: Use PowerShell to capture and display output in real-time
powershell "& { mvn clean } | Tee-Object -FilePath '!LOGFILE!' -Append"

if !errorlevel! neq 0 (
    echo.
    echo ❌ CLEAN FAILED - Build cannot continue
    echo Clean failed with exit code: !errorlevel! >> "!LOGFILE!"
    goto :show_final_status
)

echo.
echo ✅ Clean completed successfully
echo ✅ Clean completed successfully >> "!LOGFILE!"
echo.

echo [PHASE 2] Starting Maven Compilation...
echo [PHASE 2] Starting Maven Compilation... >> "!LOGFILE!"
echo Command: mvn compile -DskipTests -pl runelite-client -am
echo Command: mvn compile -DskipTests -pl runelite-client -am >> "!LOGFILE!"
echo This may take 2-5 minutes depending on your system...
echo.

:: Use PowerShell to capture and display compilation output in real-time
powershell "& { mvn compile -DskipTests -pl runelite-client -am } | Tee-Object -FilePath '!LOGFILE!' -Append"

if !errorlevel! neq 0 (
    echo.
    echo ❌ COMPILATION FAILED 
    echo ❌ COMPILATION FAILED >> "!LOGFILE!"
    echo.
    echo 🔍 Analyzing compilation errors...
    echo.
    
    echo === COMPILATION ERROR SUMMARY ===
    echo.
    
    echo Top 10 compilation errors:
    findstr /C:"ERROR" "!LOGFILE!" | powershell "Get-Content | Select-Object -First 10"
    
    echo.
    echo Missing symbols:
    findstr /C:"cannot find symbol" "!LOGFILE!" | powershell "Get-Content | Select-Object -First 5"
    
    echo.
    echo Build failure summary:
    findstr /C:"BUILD FAILURE" "!LOGFILE!" -A 5
    
    goto :show_final_status
)

echo.
echo ✅ Compilation completed successfully!
echo ✅ Compilation completed successfully! >> "!LOGFILE!"
echo.

echo [PHASE 3] Starting Maven Package...
echo [PHASE 3] Starting Maven Package... >> "!LOGFILE!"
echo Command: mvn package -DskipTests -pl runelite-client
echo Command: mvn package -DskipTests -pl runelite-client >> "!LOGFILE!"
echo.

:: Use PowerShell to capture and display packaging output in real-time
powershell "& { mvn package -DskipTests -pl runelite-client } | Tee-Object -FilePath '!LOGFILE!' -Append"

if !errorlevel! neq 0 (
    echo.
    echo ❌ PACKAGING FAILED
    echo ❌ PACKAGING FAILED >> "!LOGFILE!"
    goto :show_final_status
)

echo.
echo ✅ BUILD COMPLETED SUCCESSFULLY! 🎉
echo ✅ BUILD COMPLETED SUCCESSFULLY! >> "!LOGFILE!"
echo.

echo 📦 Generated JAR files:
if exist "runelite-client\target\*.jar" (
    dir /b runelite-client\target\*.jar
) else (
    echo No JAR files found in runelite-client\target\
)

echo.
echo 🎯 RuneLite client is ready for testing!
goto :end

:show_final_status
echo.
echo === BUILD STATUS SUMMARY ===
echo Build completed with errors - check the details above
echo Full log available in: !LOGFILE!
echo.
echo Last 20 lines of build log:
echo ===========================
powershell "Get-Content '!LOGFILE!' | Select-Object -Last 20"

:end
echo.
echo 📄 Complete build log saved to: !LOGFILE!
echo 🔧 You can analyze the full log file for detailed information
echo.
pause
