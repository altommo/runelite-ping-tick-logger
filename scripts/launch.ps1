$ErrorActionPreference = "Stop"

Write-Host "🎮 RuneLite Launcher" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host ""

# Navigate to project directory
$projectRoot = Split-Path -Parent $PSScriptRoot
$clientTarget = "$projectRoot\runelite-client\target"

Set-Location $projectRoot

# Find the RuneLite JAR
$jarFiles = @()
$jarFiles += Get-ChildItem "$clientTarget\client-*-shaded.jar" -ErrorAction SilentlyContinue
if (-not $jarFiles) {
    $jarFiles += Get-ChildItem "$clientTarget\client-*.jar" -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike "*tests*" }
}

if (-not $jarFiles) {
    Write-Host "❌ No RuneLite JAR found!" -ForegroundColor Red
    Write-Host "Please run the build script first:" -ForegroundColor Yellow
    Write-Host "  .\scripts\build.ps1" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

$jarFile = $jarFiles[0]
$jarPath = $jarFile.FullName
$jarSize = [math]::Round($jarFile.Length / 1MB, 1)

Write-Host "📦 Found RuneLite JAR:" -ForegroundColor Green
Write-Host "  • File: $($jarFile.Name)" -ForegroundColor White
Write-Host "  • Size: $jarSize MB" -ForegroundColor White
Write-Host "  • Modified: $($jarFile.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))" -ForegroundColor White
Write-Host ""

# Show custom plugins
$pluginsDir = "runelite-client\src\main\java\net\runelite\client\plugins"
$customPlugins = Get-ChildItem $pluginsDir -Directory | Where-Object { 
    $_.Name -notmatch '^[a-z]+$' -or $_.Name -eq 'pinglogger' 
} | Select-Object -ExpandProperty Name

if ($customPlugins) {
    Write-Host "🔌 Custom plugins included:" -ForegroundColor Cyan
    foreach ($plugin in $customPlugins) {
        Write-Host "  • $plugin" -ForegroundColor White
    }
    Write-Host ""
}

Write-Host "🚀 Launching RuneLite..." -ForegroundColor Green
Write-Host ""
Write-Host "Instructions:" -ForegroundColor Yellow
Write-Host "1. Wait for RuneLite to fully load" -ForegroundColor White
Write-Host "2. Go to Settings > Plugin Configuration" -ForegroundColor White
Write-Host "3. Enable your custom plugins (e.g., 'Ping Logger')" -ForegroundColor White
Write-Host "4. Log into OSRS to test plugins" -ForegroundColor White
Write-Host ""

# Launch RuneLite
try {
    Set-Location $clientTarget
    java -jar $jarFile.Name
} catch {
    Write-Host ""
    Write-Host "❌ Failed to launch RuneLite: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "• Check if Java 11+ is installed: java -version" -ForegroundColor White
    Write-Host "• Verify JAR file integrity" -ForegroundColor White
    Write-Host "• Try rebuilding: .\scripts\build.ps1" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "RuneLite has closed." -ForegroundColor Yellow
Write-Host ""

# Show plugin logs location
Write-Host "📝 Plugin logs available at:" -ForegroundColor Cyan
Write-Host "  $env:USERPROFILE\.runelite\logs\client.log" -ForegroundColor White
Write-Host ""

# Show ping file location if Ping Logger is available
if ($customPlugins -contains "pinglogger") {
    $pingFile = "$env:USERPROFILE\.runelite\ping.txt"
    Write-Host "🏓 Ping Logger output:" -ForegroundColor Cyan
    if (Test-Path $pingFile) {
        $ping = Get-Content $pingFile
        Write-Host "  Current ping: $ping ms" -ForegroundColor Green
        Write-Host "  File: $pingFile" -ForegroundColor White
    } else {
        Write-Host "  No ping data yet - enable plugin and log into OSRS" -ForegroundColor Yellow
    }
    Write-Host ""
}

Read-Host "Press Enter to exit"
