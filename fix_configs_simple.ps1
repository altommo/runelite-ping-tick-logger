Write-Host "Fixing OneClick Config annotations..." -ForegroundColor Green

$filePath = "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\externals\oneclick\OneClickConfig.java"
$content = Get-Content $filePath -Raw

# Remove all keyName parameters
$content = $content -replace ',\s*keyName\s*=\s*"[^"]*"', ''
$content = $content -replace 'keyName\s*=\s*"[^"]*",\s*', ''

Set-Content $filePath $content -NoNewline -Encoding UTF8
Write-Host "Fixed OneClickConfig.java"

$filePath2 = "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\menuentryswapperextended\MenuEntrySwapperExtendedConfig.java"
$content2 = Get-Content $filePath2 -Raw

# Remove all keyName parameters
$content2 = $content2 -replace ',\s*keyName\s*=\s*"[^"]*"', ''
$content2 = $content2 -replace 'keyName\s*=\s*"[^"]*",\s*', ''

# Remove unhide parameters
$content2 = $content2 -replace ',\s*unhide\s*=\s*true', ''
$content2 = $content2 -replace ',\s*unhide\s*=\s*false', ''
$content2 = $content2 -replace 'unhide\s*=\s*true,\s*', ''
$content2 = $content2 -replace 'unhide\s*=\s*false,\s*', ''

# Remove disabledBy parameters
$content2 = $content2 -replace ',\s*disabledBy\s*=\s*"[^"]*"', ''
$content2 = $content2 -replace 'disabledBy\s*=\s*"[^"]*",\s*', ''

Set-Content $filePath2 $content2 -NoNewline -Encoding UTF8
Write-Host "Fixed MenuEntrySwapperExtendedConfig.java"

Write-Host "Config annotation fixes applied!" -ForegroundColor Green
