@echo off
echo 🚀 RuneLite Build with Full Logging
echo ===================================
echo.

cd /d "C:\Users\hp\Development\runelite"

:: Generate proper timestamp
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
    set MM=%%a
    set DD=%%b
    set YYYY=%%c
)
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (
    set HH=%%a
    set MIN=%%b
)

:: Remove spaces and format
set MM=0%MM%
set MM=%MM:~-2%
set DD=0%DD%
set DD=%DD:~-2%
set HH=0%HH%
set HH=%HH:~-2%
set MIN=0%MIN%
set MIN=%MIN:~-2%

set TIMESTAMP=%YYYY%%MM%%DD%_%HH%%MIN%
set LOGFILE=build_%TIMESTAMP%.log

echo Starting build at %date% %time%
echo Logging to: %LOGFILE%
echo.

REM Clear any existing log file
if exist %LOGFILE% del %LOGFILE%

REM Set Maven environment
set MAVEN_HOME=C:\Users\hp\Tools\apache-maven-3.9.4
set PATH=%MAVEN_HOME%\bin;%PATH%

echo =============================================== >> %LOGFILE%
echo RuneLite Build Log - %date% %time% >> %LOGFILE%
echo =============================================== >> %LOGFILE%
echo. >> %LOGFILE%

echo [%time%] Starting Maven clean... >> %LOGFILE%
echo Running: mvn clean >> %LOGFILE%
mvn clean >> %LOGFILE% 2>&1
if errorlevel 1 (
    echo ❌ Clean failed - check %LOGFILE%
    goto :show_recent
)
echo ✅ Clean completed
echo [%time%] Clean completed successfully >> %LOGFILE%
echo. >> %LOGFILE%

echo [%time%] Starting compilation... >> %LOGFILE%
echo Running: mvn compile -DskipTests -pl runelite-client -am >> %LOGFILE%
echo This will take several minutes - monitoring progress...
mvn compile -DskipTests -pl runelite-client -am >> %LOGFILE% 2>&1

REM Check if compilation succeeded
if errorlevel 1 (
    echo. >> %LOGFILE%
    echo [%time%] Compilation FAILED >> %LOGFILE%
    echo =============================================== >> %LOGFILE%
    
    echo.
    echo ❌ Compilation failed - analyzing errors...
    echo.
    
    echo 📋 COMPILATION ERROR SUMMARY:
    echo =============================
    
    REM Extract and show specific error types
    echo.
    echo 🔍 Missing Client API Methods:
    findstr /C:"cannot find symbol" %LOGFILE% | findstr /C:"location: variable client" 2>nul | powershell "Get-Content | Select-Object -First 5"
    
    echo.
    echo 🔍 Missing Classes/Imports:
    findstr /C:"cannot find symbol" %LOGFILE% | findstr /C:"symbol:   class" 2>nul | powershell "Get-Content | Select-Object -First 5"
    
    echo.
    echo 🔍 Missing Methods:
    findstr /C:"cannot find symbol" %LOGFILE% | findstr /C:"symbol:   method" 2>nul | powershell "Get-Content | Select-Object -First 5"
    
    echo.
    echo 🔍 Missing Variables/Constants:
    findstr /C:"cannot find symbol" %LOGFILE% | findstr /C:"symbol:   variable" 2>nul | powershell "Get-Content | Select-Object -First 5"
    
    echo.
    echo 🔍 Type Errors:
    findstr /C:"bad operand types" %LOGFILE% 2>nul | powershell "Get-Content | Select-Object -First 3"
    
    echo.
    echo 🔍 Compilation Errors:
    findstr /C:"COMPILATION ERROR" %LOGFILE% 2>nul
    
    echo.
    echo 📄 Full build log saved to: %LOGFILE%
    echo.
    
) else (
    echo [%time%] Compilation completed successfully >> %LOGFILE%
    echo. >> %LOGFILE%
    echo ✅ Compilation successful!
    
    echo [%time%] Starting packaging... >> %LOGFILE%
    echo Running: mvn package -DskipTests -pl runelite-client >> %LOGFILE%
    mvn package -DskipTests -pl runelite-client >> %LOGFILE% 2>&1
    
    if errorlevel 1 (
        echo [%time%] Packaging FAILED >> %LOGFILE%
        echo ❌ Packaging failed - check %LOGFILE%
    ) else (
        echo [%time%] Build completed successfully! >> %LOGFILE%
        echo ✅ Build completed successfully!
        echo.
        echo 📦 Output JAR files:
        dir /b runelite-client\target\*.jar 2>nul
        echo.
        echo 🎯 Enhanced RuneLite client ready for testing!
    )
)

:show_recent
echo.
echo 📋 Recent build activity:
echo ========================
REM Show last 20 lines of the log
powershell "if (Test-Path '%LOGFILE%') { Get-Content '%LOGFILE%' | Select-Object -Last 20 }"

echo.
echo 📄 Complete build log: %LOGFILE%
echo 🔧 Use analyze-build-log.bat to analyze errors in detail
echo.

pause
