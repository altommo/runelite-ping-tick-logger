# RuneLite Development Environment

A complete development setup for building RuneLite with custom plugins, including the **Ping Logger** plugin that tracks your connection ping in real-time.

## 🚀 Quick Start

### Prerequisites
- Java 11+ (we tested with Java 17)
- Git
- Maven 3.6+

### Build and Run
```powershell
# Build RuneLite with your plugins
.\build.ps1

# Launch RuneLite with your custom plugins
.\launch.ps1
```

## 📁 Project Structure

```
runelite-dev/
├── runelite/                           # RuneLite source code
│   └── runelite-client/
│       └── src/main/java/net/runelite/client/plugins/
│           ├── pinglogger/             # Your Ping Logger plugin
│           │   ├── PingLoggerPlugin.java
│           │   └── PingLoggerConfig.java
│           └── [your-new-plugins]/     # Add more plugins here
├── scripts/
│   ├── build.ps1                      # PowerShell build script
│   ├── build.bat                      # Batch build script
│   ├── launch.ps1                     # PowerShell launcher
│   └── launch.bat                     # Batch launcher
├── docs/
│   ├── PLUGIN_DEVELOPMENT.md          # Plugin development guide
│   └── TROUBLESHOOTING.md             # Common issues and solutions
└── README.md                          # This file
```

## 🔧 Building RuneLite

### Option 1: PowerShell (Recommended)
```powershell
.\build.ps1
```

### Option 2: Batch File
```cmd
.\build.bat
```

### Option 3: Manual Maven
```bash
cd runelite
mvn clean install -DskipTests -T 1C
```

**Build Output:** `runelite/runelite-client/target/client-*-shaded.jar`

## 🎮 Running Your Custom RuneLite

### Launch Scripts
```powershell
# PowerShell
.\launch.ps1

# Batch
.\launch.bat

# Manual
cd runelite\runelite-client\target
java -jar client-*-shaded.jar
```

## ➕ Adding New Plugins

### 1. Create Plugin Directory
```powershell
mkdir runelite\runelite-client\src\main\java\net\runelite\client\plugins\yourplugin
```

### 2. Create Plugin Files

**YourPlugin.java:**
```java
package net.runelite.client.plugins.yourplugin;

import lombok.extern.slf4j.Slf4j;
import net.runelite.client.plugins.Plugin;
import net.runelite.client.plugins.PluginDescriptor;

@Slf4j
@PluginDescriptor(
    name = "Your Plugin Name",
    description = "Description of what your plugin does",
    tags = {"tag1", "tag2"}
)
public class YourPlugin extends Plugin
{
    @Override
    protected void startUp() throws Exception
    {
        log.info("Your plugin started!");
    }

    @Override
    protected void shutDown() throws Exception
    {
        log.info("Your plugin stopped!");
    }
}
```

**YourPluginConfig.java:**
```java
package net.runelite.client.plugins.yourplugin;

import net.runelite.client.config.Config;
import net.runelite.client.config.ConfigGroup;
import net.runelite.client.config.ConfigItem;

@ConfigGroup("yourplugin")
public interface YourPluginConfig extends Config
{
    @ConfigItem(
        keyName = "enabled",
        name = "Enable Plugin",
        description = "Enable or disable the plugin"
    )
    default boolean enabled()
    {
        return true;
    }
}
```

### 3. Rebuild
```powershell
.\build.ps1
```

## 🎯 Example: Ping Logger Plugin

The included **Ping Logger** plugin demonstrates:
- Real-time ping monitoring
- File output (`~/.runelite/ping.txt`)
- Configuration options
- Event handling (`GameTick`, `WorldsFetch`)
- World service integration

### Features:
- ✅ Tracks ping to current OSRS world
- ✅ Updates every game tick (0.6 seconds)
- ✅ Writes to `C:\Users\{username}\.runelite\ping.txt`
- ✅ Enable/disable in plugin settings
- ✅ Comprehensive logging

### Usage:
1. Enable "Ping Logger" in Settings > Plugin Configuration
2. Log into OSRS
3. Check your ping: `Get-Content "~\.runelite\ping.txt"`

## 📚 Development Resources

- **[Plugin Development Guide](docs/PLUGIN_DEVELOPMENT.md)** - Complete guide to creating plugins
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[RuneLite API Documentation](https://static.runelite.net/api/runelite-client/)** - Official API docs
- **[RuneLite Plugin Hub](https://github.com/runelite/plugin-hub)** - Example plugins

## 🛠️ Development Environment

### Tools Included:
- **Maven 3.9.4** - Build system
- **RuneLite 1.11.14-SNAPSHOT** - Latest development version
- **Build Scripts** - Automated compilation and packaging
- **Launch Scripts** - Easy testing and debugging

### IDE Setup:
1. **IntelliJ IDEA Community** (Recommended)
   - Open `runelite` folder as Maven project
   - Let IntelliJ import dependencies
   - Navigate to your plugins in the project tree

2. **Visual Studio Code**
   - Install Java Extension Pack
   - Open `runelite` folder
   - Use integrated terminal for builds

## 🔍 Testing and Debugging

### View Plugin Logs:
```powershell
# Real-time log monitoring
Get-Content "~\.runelite\logs\client.log" -Wait -Tail 20

# Search for your plugin
Get-Content "~\.runelite\logs\client.log" | Select-String "YourPluginName"
```

### Build Verification:
```powershell
# Check if build succeeded
Test-Path "runelite\runelite-client\target\client-*-shaded.jar"

# View recent build output
Get-ChildItem "runelite\runelite-client\target" -Name "*.jar"
```

## 📋 System Requirements

- **Windows 10/11** (tested)
- **Java 17** (Java 11+ required)
- **Maven 3.6+**
- **Git**
- **4GB+ RAM** (for compilation)
- **OSRS Account** (for testing)

## 🤝 Contributing

1. Fork this repository
2. Create your plugin in `runelite/runelite-client/src/main/java/net/runelite/client/plugins/yourplugin/`
3. Test with `.\build.ps1` and `.\launch.ps1`
4. Document your plugin
5. Submit a pull request

## 📝 Version History

- **v1.0.0** - Initial development environment with Ping Logger plugin
- Includes working build system, launch scripts, and comprehensive documentation

## ⚖️ License

This project uses the RuneLite source code, which is licensed under the BSD 2-Clause License.
Your custom plugins can use any compatible license.

## 🆘 Support

- Check **[Troubleshooting Guide](docs/TROUBLESHOOTING.md)** first
- Review **[Plugin Development Guide](docs/PLUGIN_DEVELOPMENT.md)**
- Check the logs: `~\.runelite\logs\client.log`
- Open an issue on GitHub

---

**Happy Plugin Development!** 🚀

Made with ❤️ for the RuneLite community
