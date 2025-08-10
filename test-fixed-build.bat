@echo off
echo 🔧 Testing Build After Configuration Fixes
echo ==========================================
echo.

cd /d "C:\Users\hp\Development\runelite"

echo Summary of fixes applied:
echo ✅ Added ConfigItem.unhide attribute
echo ✅ Added ConfigSection.keyName and hidden attributes  
echo ✅ Added Units.POINTS constant
echo ✅ Fixed MenuEntrySwapperExtended configuration
echo ✅ Added missing WidgetMenuOption import
echo ✅ Simplified MTA plugin
echo.

echo Testing compilation...
echo.

REM Navigate to client and try compilation
cd runelite-client
mvn compile -DskipTests -q > build_test.log 2>&1

if errorlevel 1 (
    echo ❌ Build still has errors. Checking remaining issues...
    echo.
    echo Top remaining errors:
    findstr /C:"ERROR" build_test.log | head -5
    echo.
    echo Full error log saved to build_test.log
) else (
    echo ✅ Compilation successful!
    echo.
    echo The critical configuration features have been restored.
    echo Your plugins should now compile without missing feature errors.
)

echo.
pause
