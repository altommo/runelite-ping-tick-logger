@echo off
echo 🔧 RuneLite Plugin Compatibility Fixer
echo ======================================
echo.

cd /d "C:\Users\hp\Development\runelite"

echo Fixing plugin compatibility issues...
echo.

REM Backup original files
echo Creating backup of problematic files...
if not exist backup mkdir backup
copy "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java" backup\ >nul 2>&1

echo Removing incompatible MTA plugin references...
REM Create a simplified MTA.java that doesn't reference the problematic AlchemyItem
echo package net.runelite.client.plugins.externals.oneclick.clickables.minigames; > "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"
echo. >> "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"
echo import net.runelite.client.plugins.externals.oneclick.clickables.Clickable; >> "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"
echo. >> "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"
echo public class MTA extends Clickable >> "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"
echo { >> "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"
echo     // Simplified MTA implementation >> "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"
echo     // TODO: Re-implement when AlchemyItem is available >> "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"
echo } >> "runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\clickables\minigames\MTA.java"

echo Fixed most critical issues.
echo.
echo Some features temporarily disabled:
echo - MTA (Mage Training Arena) auto-clicking
echo - Some advanced config features (unhide/keyName)
echo.
echo These can be re-enabled when RuneLite is updated.
echo.

pause
