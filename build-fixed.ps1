$timestamp = Get-Date -Format "MMdd_HHmm"
$logFile = "build_$timestamp.log"

Set-Location "C:\Users\hp\Development\runelite"

Write-Host "Starting build - logging to $logFile"

"Build started at $(Get-Date)" | Out-File -FilePath $logFile

Write-Host "Phase 1: Clean"
$cleanOutput = mvn clean 2>&1
$cleanOutput | Out-File -FilePath $logFile -Append
$cleanOutput

if ($LASTEXITCODE -ne 0) {
    Write-Host "Clean failed"
    exit 1
}

Write-Host "Phase 2: Install Maven Plugin"
$pluginOutput = mvn clean install -pl runelite-maven-plugin -DskipTests 2>&1
$pluginOutput | Out-File -FilePath $logFile -Append
$pluginOutput

if ($LASTEXITCODE -ne 0) {
    Write-Host "Plugin installation failed"
    exit 1
}

Write-Host "Phase 3: Compile without plugin dependencies"
$compileOutput = mvn compile -DskipTests -pl cache,runelite-api 2>&1
$compileOutput | Out-File -FilePath $logFile -Append
$compileOutput

if ($LASTEXITCODE -ne 0) {
    Write-Host "Basic compilation failed - check errors above"
    Write-Host "Log saved to $logFile"
    exit 1
}

Write-Host "Phase 4: Compile client"
$clientOutput = mvn compile -DskipTests -pl runelite-client 2>&1
$clientOutput | Out-File -FilePath $logFile -Append
$clientOutput

if ($LASTEXITCODE -ne 0) {
    Write-Host "Client compilation failed - check errors above"
    Write-Host "Log saved to $logFile"
    exit 1
}

Write-Host "Build completed successfully"
Write-Host "Log saved to $logFile"
