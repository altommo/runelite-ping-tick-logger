$ErrorActionPreference = "Stop"

Write-Host "🚀 RuneLite Build Script" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host ""

# Set environment variables
$env:MAVEN_HOME = "C:\Users\hp\Tools\apache-maven-3.9.4"
$env:PATH = "$env:MAVEN_HOME\bin;" + $env:PATH

# Verify prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Maven
try {
    $mavenVersion = mvn --version | Select-Object -First 1
    Write-Host "✅ Maven: $mavenVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Maven not found. Please install Maven 3.6+" -ForegroundColor Red
    exit 1
}

# Check Java
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "✅ Java: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Java not found. Please install Java 11+" -ForegroundColor Red
    exit 1
}

# Check Git
try {
    $gitVersion = git --version
    Write-Host "✅ Git: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git not found. Please install Git" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Navigate to project directory
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "Building RuneLite with custom plugins..." -ForegroundColor Green
Write-Host "Project directory: $projectRoot" -ForegroundColor Gray
Write-Host ""

# Show custom plugins
$pluginsDir = "runelite-client\src\main\java\net\runelite\client\plugins"
$customPlugins = Get-ChildItem $pluginsDir -Directory | Where-Object { 
    $_.Name -notmatch '^[a-z]+$' -or $_.Name -eq 'pinglogger' 
} | Select-Object -ExpandProperty Name

if ($customPlugins) {
    Write-Host "📦 Custom plugins detected:" -ForegroundColor Cyan
    foreach ($plugin in $customPlugins) {
        Write-Host "  • $plugin" -ForegroundColor White
    }
    Write-Host ""
}

# Clean previous build
Write-Host "🧹 Cleaning previous build..." -ForegroundColor Yellow
try {
    mvn clean | Out-Null
    Write-Host "✅ Clean completed" -ForegroundColor Green
} catch {
    Write-Host "❌ Clean failed: $_" -ForegroundColor Red
    exit 1
}

# Build with parallel compilation
Write-Host ""
Write-Host "🔨 Building RuneLite (this may take 2-5 minutes)..." -ForegroundColor Yellow
Write-Host "Using parallel compilation for faster builds..." -ForegroundColor Gray

$buildStart = Get-Date

try {
    mvn install -DskipTests -T 1C
    $buildEnd = Get-Date
    $buildTime = $buildEnd - $buildStart
    
    Write-Host ""
    Write-Host "🎉 Build completed successfully!" -ForegroundColor Green
    Write-Host "⏱️  Build time: $($buildTime.ToString('mm\:ss'))" -ForegroundColor Green
    
} catch {
    Write-Host ""
    Write-Host "❌ Build failed!" -ForegroundColor Red
    Write-Host "Check the output above for errors." -ForegroundColor Red
    exit 1
}

# Verify build output
$clientTarget = "runelite-client\target"
$jarFiles = Get-ChildItem "$clientTarget\client-*-shaded.jar" -ErrorAction SilentlyContinue

if ($jarFiles) {
    $jarFile = $jarFiles[0]
    $jarSize = [math]::Round($jarFile.Length / 1MB, 1)
    
    Write-Host ""
    Write-Host "📦 Build artifacts:" -ForegroundColor Cyan
    Write-Host "  • JAR file: $($jarFile.Name)" -ForegroundColor White
    Write-Host "  • Size: $jarSize MB" -ForegroundColor White
    Write-Host "  • Location: $clientTarget" -ForegroundColor White
    
} else {
    Write-Host ""
    Write-Host "⚠️  Warning: No shaded JAR found in $clientTarget" -ForegroundColor Yellow
    Write-Host "Build may have completed but JAR creation failed." -ForegroundColor Yellow
    
    # Show available JARs
    $allJars = Get-ChildItem "$clientTarget\*.jar" -ErrorAction SilentlyContinue
    if ($allJars) {
        Write-Host "Available JARs:" -ForegroundColor Gray
        foreach ($jar in $allJars) {
            Write-Host "  • $($jar.Name)" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "🚀 Ready to launch!" -ForegroundColor Green
Write-Host "Run: .\scripts\launch.ps1" -ForegroundColor Cyan
Write-Host ""

Read-Host "Press Enter to continue"
