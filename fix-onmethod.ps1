$files = @(
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\cluescrolls\clues\ClueScroll.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\timetracking\farming\FarmingPatch.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\PrayerBonus.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\driftnet\DriftNet.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\SmithingBonus.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\ConstructionBonus.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\herbiboars\TrailToSpot.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\wiki\WikiDpsManager.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\FiremakingBonus.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\FishingBonus.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\barrows\BarrowsBrothers.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\MiningBonus.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\AgilityBonus.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\blastfurnace\BarsOres.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\FarmingBonus.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\skillcalculator\skills\WoodcuttingBonus.java"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Fixing $file"
        $content = Get-Content $file -Raw
        
        # Replace onMethod_ patterns
        $content = $content -replace '@Getter\(onMethod_ = \{@[^}]+\}\)', '@Getter'
        $content = $content -replace '@Getter\(onMethod_ = @[^)]+\)', '@Getter'
        
        Set-Content $file -Value $content -NoNewline
        Write-Host "Fixed $file"
    } else {
        Write-Host "File not found: $file"
    }
}

Write-Host "Completed fixing onMethod_ issues"
