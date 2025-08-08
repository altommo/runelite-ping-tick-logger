# Troubleshooting Guide

Common issues and solutions for the RuneLite development environment and plugins.

## 🚀 Build Issues

### Maven Build Fails
**Problem:** Compilation errors or build timeouts
**Solutions:**
```powershell
# Try clean build
mvn clean install -DskipTests

# Use parallel build  
mvn install -DskipTests -T 1C

# Build only client
mvn -pl runelite-client compile package -DskipTests
```

### Plugin Not Appearing
**Problem:** Plugin doesn't show in configuration
**Check:**
1. Plugin files in correct directory
2. Compilation succeeded without errors
3. Plugin annotation is correct
4. Restart RuneLite after rebuild

### JAR File Issues
**Problem:** "Unable to access jarfile" errors
**Solutions:**
1. Check target directory: `runelite-client\target\`
2. Look for `-shaded.jar` file
3. Try building with `.\build-plugin.bat`

## 🎮 Runtime Issues

### Plugin Not Loading
**Problem:** Plugin appears but doesn't start
**Debug Steps:**
```powershell
# Check logs for startup errors
Get-Content "~\.runelite\logs\client.log" | Select-String "YourPlugin"

# Look for specific error messages
Get-Content "~\.runelite\logs\client.log" | Select-String "ERROR"
```

### Files Not Created
**Problem:** Plugin output files missing
**Requirements:**
1. Plugin must be enabled in settings
2. Must be logged into OSRS (not just RuneLite)
3. Check file permissions in `~\.runelite\` directory

### Ping Logger Specific Issues
**Problem:** No ping.txt or tick.txt files
**Solutions:**
1. Enable "Ping & Tick Logger" in plugin settings
2. Ensure you're logged into a game world
3. Check for WorldsFetch event in logs
4. Verify world data is available

## 🤖 Automation Issues

### AHK Script Not Working
**Problem:** Automation script doesn't respond
**Check:**
1. RuneLite window is active and visible
2. Files exist: `ping.txt`, `tick.txt`
3. AHK script has proper permissions
4. Window coordinates are mapped correctly

### Coordinate Detection Fails
**Problem:** Clicks in wrong locations
**Solutions:**
1. Use "Detect" button to remap coordinates
2. Check screen resolution and DPI scaling
3. Verify RuneLite is in expected mode (fixed/resizable)
4. Test with manual buttons first

### Timing Issues
**Problem:** Actions happening at wrong times
**Debug:**
1. Check if tick.txt contains valid data (500-700ms range)
2. Verify ping.txt has reasonable values (10-200ms)
3. Enable debug logging in plugin configuration
4. Monitor activity log in AHK GUI

## 🛠️ Development Environment

### Java Version Issues
**Problem:** Compilation fails with Java errors
**Solution:**
```powershell
# Check Java version
java -version

# Ensure Java 11+ is installed
# RuneLite requires Java 11 minimum
```

### Maven Not Found
**Problem:** 'mvn' command not recognized
**Solution:**
```powershell
# Set Maven environment
$env:MAVEN_HOME = "C:\Users\hp\Tools\apache-maven-3.9.4"
$env:PATH = "$env:MAVEN_HOME\bin;" + $env:PATH

# Verify Maven works
mvn --version
```

### Git Issues
**Problem:** Cannot push to repository
**Solutions:**
1. Check if remote is set correctly: `git remote -v`
2. Ensure you have push permissions
3. Use personal access token if required

## 📁 File System Issues

### Permission Errors
**Problem:** Cannot write to .runelite directory
**Solutions:**
1. Run RuneLite as administrator
2. Check folder permissions
3. Verify antivirus isn't blocking file creation

### Path Resolution Issues
**Problem:** Files created in wrong location
**Debug:**
```powershell
# Check where files are actually created
Get-ChildItem $env:USERPROFILE -Recurse -Name "ping.txt" -ErrorAction SilentlyContinue

# Verify .runelite directory exists
Test-Path "$env:USERPROFILE\.runelite"
```

## 🎯 Plugin Specific Troubleshooting

### Ping Logger Plugin

**No ping data:**
1. Ensure WorldsFetch event fired (check logs)
2. Must be connected to a game world
3. World service must have world data

**Tick measurement issues:**
1. Plugin needs at least 3 game ticks for accurate measurement
2. Initial ticks may be irregular and are ignored
3. Rolling average uses last 10 ticks

**File writing failures:**
1. Check disk space in user home directory
2. Verify no other process is locking files
3. Enable error logging in plugin config

## 🚨 Emergency Procedures

### Reset Everything
```powershell
# Stop all processes
Get-Process | Where-Object {$_.ProcessName -like "*java*"} | Stop-Process -Force
Get-Process | Where-Object {$_.ProcessName -like "*autohotkey*"} | Stop-Process -Force

# Clean build
cd "C:\Users\hp\Development\runelite"
mvn clean
.\build-plugin.bat

# Fresh start
.\launch-plugin.bat
```

### Backup Working State
```powershell
# Backup working JAR
Copy-Item "runelite-client\target\client-*-shaded.jar" "backup-working.jar"

# Backup plugin source
Copy-Item "runelite-client\src\main\java\net\runelite\client\plugins\pinglogger" "backup-pinglogger" -Recurse
```

## 📞 Getting Help

1. **Check this troubleshooting guide first**
2. **Review plugin logs:** `~\.runelite\logs\client.log`
3. **Test with working baseline versions**
4. **Document specific error messages**
5. **Create minimal reproduction case**

Remember: Most issues are configuration or timing related, not fundamental problems with the code!
