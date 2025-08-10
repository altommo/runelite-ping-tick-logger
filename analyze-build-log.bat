@echo off
echo 🔍 RuneLite Build Log Analyzer
echo ==============================
echo.

cd /d "C:\Users\hp\Development\runelite"

:: Find the most recent build log
set LATEST_LOG=
for /f "delims=" %%i in ('dir /b /o-d build_*.log 2^>nul') do (
    if not defined LATEST_LOG set LATEST_LOG=%%i
)

if "%LATEST_LOG%"=="" (
    echo ❌ No build log files found.
    echo Run build-with-logging.bat first to generate a log file.
    pause
    exit /b 1
)

set LOGFILE=%LATEST_LOG%
echo 📄 Analyzing log file: %LOGFILE%
echo.

if not exist "%LOGFILE%" (
    echo ❌ Log file not found: %LOGFILE%
    pause
    exit /b 1
)

echo 📊 BUILD LOG ANALYSIS REPORT
echo ===============================
echo Log file: %LOGFILE%
echo Generated: 
powershell "Get-Item '%LOGFILE%' | Select-Object -ExpandProperty LastWriteTime"
echo.

:: Check if build was successful
findstr /C:"BUILD SUCCESS" %LOGFILE% >nul 2>&1
if not errorlevel 1 (
    echo ✅ BUILD STATUS: SUCCESS
    echo.
    echo 📦 JAR Files Created:
    dir /b runelite-client\target\*.jar 2>nul
    goto :end
)

findstr /C:"BUILD FAILURE" %LOGFILE% >nul 2>&1
if not errorlevel 1 (
    echo ❌ BUILD STATUS: FAILURE
) else (
    echo ⚠️  BUILD STATUS: UNKNOWN
)
echo.

:: Count total errors
echo 📈 ERROR STATISTICS:
echo ====================
for /f %%i in ('findstr /C:"[ERROR]" %LOGFILE% 2^>nul ^| find /c /v ""') do echo Total errors found: %%i
echo.

:: Analyze specific error types
echo 🔍 ERROR CATEGORIES:
echo ===================

echo.
echo 📋 1. MISSING CLIENT API METHODS:
echo ----------------------------------
findstr /C:"cannot find symbol" %LOGFILE% | findstr /C:"location: variable client" 2>nul | powershell "Get-Content | ForEach-Object { if ($_ -match 'method\s+(\w+)\(') { $matches[1] } } | Sort-Object | Get-Unique"

echo.
echo 📋 2. MISSING CLASSES:
echo ----------------------
findstr /C:"cannot find symbol" %LOGFILE% | findstr /C:"symbol:   class" 2>nul | powershell "Get-Content | ForEach-Object { if ($_ -match 'class\s+(\w+)') { $matches[1] } } | Sort-Object | Get-Unique"

echo.
echo 📋 3. MISSING METHODS:
echo ----------------------
findstr /C:"cannot find symbol" %LOGFILE% | findstr /C:"symbol:   method" 2>nul | powershell "Get-Content | ForEach-Object { if ($_ -match 'method\s+(\w+)\(') { $matches[1] } } | Sort-Object | Get-Unique"

echo.
echo 📋 4. MISSING VARIABLES/CONSTANTS:
echo ----------------------------------
findstr /C:"cannot find symbol" %LOGFILE% | findstr /C:"symbol:   variable" 2>nul | powershell "Get-Content | ForEach-Object { if ($_ -match 'variable\s+(\w+)') { $matches[1] } } | Sort-Object | Get-Unique"

echo.
echo 📋 5. TYPE ERRORS:
echo ------------------
findstr /C:"bad operand types" %LOGFILE% 2>nul

echo.
echo 📋 6. IMPORT ERRORS:
echo --------------------
findstr /C:"package.*does not exist" %LOGFILE% 2>nul
findstr /C:"cannot find symbol.*import" %LOGFILE% 2>nul

echo.
echo 📋 7. COMPILATION ERRORS BY FILE:
echo ---------------------------------
powershell "Get-Content '%LOGFILE%' | Where-Object { $_ -match '\[ERROR\].*\.java.*cannot find symbol' } | ForEach-Object { if ($_ -match '(/[^:]+\.java)') { $matches[1] } } | Group-Object | Sort-Object Count -Descending | Select-Object -First 10 | ForEach-Object { '{0,3} errors: {1}' -f $_.Count, ($_.Name -replace '.*[/\\]', '') }"

echo.
echo 📋 8. RECENT ERROR LINES:
echo -------------------------
powershell "Get-Content '%LOGFILE%' | Where-Object { $_ -match '\[ERROR\]' } | Select-Object -Last 10"

echo.
echo 🔧 SUGGESTED FIXES:
echo ===================
echo 1. Missing Client API methods: Add method signatures to Client.java interface
echo 2. Missing classes: Create missing classes in appropriate packages
echo 3. Missing constants: Add missing constants to respective classes
echo 4. Type errors: Fix parameter types and null handling
echo 5. Import errors: Fix import statements and package references
echo.

echo 📄 Full error details available in: %LOGFILE%
echo 💡 Run this script again after making fixes to see progress
echo.

:end
echo Press any key to exit...
pause >nul
