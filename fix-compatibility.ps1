# RuneLite Plugin Compatibility Fixer
Write-Host "🔧 Fixing RuneLite Plugin Compatibility Issues..." -ForegroundColor Green
Write-Host "This will remove incompatible features temporarily." -ForegroundColor Yellow
Write-Host ""

$basePath = "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client"

# Files that need 'unhide' and 'keyName' attributes removed
$configFiles = @(
    "$basePath\plugins\fightcavespawnrotation\FightCavesSpawnRotationConfig.java",
    "$basePath\plugins\pvptools\PvpToolsConfig.java", 
    "$basePath\plugins\effecttimers\EffectTimersConfig.java",
    "$basePath\plugins\externals\customswapper\CustomSwapperConfig.java",
    "$basePath\plugins\kalphitequeen\KQConfig.java",
    "$basePath\plugins\coxhelper\CoxConfig.java",
    "$basePath\plugins\theatre\TheatreConfig.java",
    "$basePath\plugins\npcstatus\NpcStatusConfig.java",
    "$basePath\plugins\inferno\InfernoConfig.java"
)

Write-Host "Removing unsupported config attributes..." -ForegroundColor Cyan

foreach ($file in $configFiles) {
    if (Test-Path $file) {
        Write-Host "  Fixing: $(Split-Path $file -Leaf)" -ForegroundColor Gray
        
        # Read content
        $content = Get-Content $file -Raw
        
        # Remove unhide attributes  
        $content = $content -replace ',\s*unhide\s*=\s*[^"]*"', ''
        $content = $content -replace 'unhide\s*=\s*[^"]*"\s*,?', ''
        
        # Remove keyName attributes
        $content = $content -replace ',\s*keyName\s*=\s*[^"]*"', ''  
        $content = $content -replace 'keyName\s*=\s*[^"]*"\s*,?', ''
        
        # Remove hidden attributes
        $content = $content -replace ',\s*hidden\s*=\s*[^,)]*', ''
        $content = $content -replace 'hidden\s*=\s*[^,)]*\s*,?', ''
        
        # Remove unsupported Units.POINTS
        $content = $content -replace 'Units\.POINTS', 'Units.PERCENT'
        
        # Write back
        Set-Content $file -Value $content -Encoding UTF8
    }
}

Write-Host ""
Write-Host "Fixed configuration files" -ForegroundColor Green

# Fix Lombok issues by removing unsupported features
Write-Host "Fixing Lombok compatibility issues..." -ForegroundColor Cyan

$lombokFiles = @(
    "$basePath\config\ProfileManager.java",
    "$basePath\ui\components\colorpicker\ColorPickerManager.java", 
    "$basePath\plugins\banktags\tabs\PotionStorage.java",
    "$basePath\plugins\timetracking\farming\FarmingTracker.java",
    "$basePath\plugins\timetracking\farming\CompostTracker.java",
    "$basePath\plugins\timetracking\farming\PaymentTracker.java",
    "$basePath\plugins\prayer\PrayerReorder.java",
    "$basePath\util\ImageCapture.java",
    "$basePath\plugins\cluescrolls\clues\CoordinateClue.java",
    "$basePath\plugins\cluescrolls\clues\ClueScroll.java",
    "$basePath\plugins\timetracking\farming\FarmingPatch.java",
    "$basePath\plugins\skillcalculator\skills\PrayerBonus.java",
    "$basePath\plugins\driftnet\DriftNet.java"
)

foreach ($file in $lombokFiles) {
    if (Test-Path $file) {
        Write-Host "  Fixing: $(Split-Path $file -Leaf)" -ForegroundColor Gray
        
        $content = Get-Content $file -Raw
        
        # Remove unsupported Lombok features
        $content = $content -replace 'onMethod_\(\)', 'value'
        $content = $content -replace ',\s*onMethod_\s*=\s*[^,)]*', ''
        $content = $content -replace 'onMethod_\s*=\s*[^,)]*\s*,?', ''
        $content = $content -replace 'class __', 'Object'
        
        Set-Content $file -Value $content -Encoding UTF8
    }
}

Write-Host "Fixed Lombok issues" -ForegroundColor Green

Write-Host ""
Write-Host "Compatibility fixes complete!" -ForegroundColor Green
Write-Host "Some advanced features are temporarily disabled." -ForegroundColor Yellow
Write-Host "You can now try building the project." -ForegroundColor Green
