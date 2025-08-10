@echo off
echo 🔧 Testing Critical Plugin Fixes
echo ================================
echo.

cd /d "C:\Users\hp\Development\runelite"

echo Testing compilation with critical fixes...
echo.

REM Try to compile just to see remaining errors
cd runelite-client
mvn compile -DskipTests -q -Dmaven.test.skip=true 2>build_errors.txt

echo.
echo Checking for remaining errors...
type build_errors.txt | findstr "ERROR"

echo.
echo ✅ Critical fixes applied:
echo - Added missing WidgetMenuOption import
echo - Fixed MenuEntrySwapperExtended config
echo - Simplified MTA plugin
echo.
echo Remaining issues to fix:
type build_errors.txt | findstr "cannot find symbol" | head -10

pause
