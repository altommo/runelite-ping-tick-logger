# Plugin Development Guide

This guide covers everything you need to know about developing RuneLite plugins in this development environment.

## 📚 Table of Contents

1. [Getting Started](#getting-started)
2. [Plugin Architecture](#plugin-architecture)
3. [Creating Your First Plugin](#creating-your-first-plugin)
4. [Plugin Configuration](#plugin-configuration)
5. [Event System](#event-system)
6. [Best Practices](#best-practices)
7. [Testing and Debugging](#testing-and-debugging)

## 🚀 Getting Started

### Prerequisites
- Completed the main setup (Maven, Java, etc.)
- Basic Java knowledge
- Understanding of OSRS game mechanics

### Development Workflow
1. **Create** your plugin files
2. **Build** with `.\build-plugin.bat`
3. **Test** with `.\launch-plugin.bat`
4. **Debug** using logs and console output
5. **Iterate** and improve

## 🏗️ Plugin Architecture

### Core Components

```java
@PluginDescriptor(/* metadata */)
public class YourPlugin extends Plugin {
    // 1. Dependencies (injected)
    @Inject private Client client;
    @Inject private YourConfig config;
    
    // 2. Lifecycle methods
    @Override protected void startUp() { }
    @Override protected void shutDown() { }
    
    // 3. Event handlers
    @Subscribe public void onGameTick(GameTick event) { }
    
    // 4. Configuration provider
    @Provides YourConfig getConfig(ConfigManager cm) { }
}
```

## 🎯 Creating Your First Plugin

### 1. Create Plugin Structure
```powershell
mkdir "runelite-client\src\main\java\net\runelite\client\plugins\yourplugin"
```

### 2. Main Plugin Class

**YourPlugin.java:**
```java
package net.runelite.client.plugins.yourplugin;

import com.google.inject.Provides;
import javax.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import net.runelite.api.Client;
import net.runelite.api.events.GameTick;
import net.runelite.client.config.ConfigManager;
import net.runelite.client.eventbus.Subscribe;
import net.runelite.client.plugins.Plugin;
import net.runelite.client.plugins.PluginDescriptor;

@Slf4j
@PluginDescriptor(
    name = "Your Plugin Name",
    description = "What your plugin does",
    tags = {"utility", "helper"}
)
public class YourPlugin extends Plugin
{
    @Inject
    private Client client;

    @Inject  
    private YourConfig config;

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

    @Provides
    YourConfig provideConfig(ConfigManager configManager)
    {
        return configManager.getConfig(YourConfig.class);
    }

    @Subscribe
    public void onGameTick(GameTick event)
    {
        if (!config.enabled()) {
            return;
        }
        
        // Your plugin logic here
    }
}
```

### 3. Configuration Interface

**YourConfig.java:**
```java
package net.runelite.client.plugins.yourplugin;

import net.runelite.client.config.Config;
import net.runelite.client.config.ConfigGroup;
import net.runelite.client.config.ConfigItem;

@ConfigGroup("yourplugin")
public interface YourConfig extends Config
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

## ⚙️ Plugin Configuration

### Configuration Types

```java
// Boolean checkbox
default boolean enableFeature() { return true; }

// Integer input
default int maxValue() { return 100; }

// String input  
default String customMessage() { return "Hello World"; }

// Color picker
default Color highlightColor() { return Color.RED; }
```

## 🎭 Event System

### Common Events

```java
// Game state events
@Subscribe public void onGameStateChanged(GameStateChanged event) { }
@Subscribe public void onGameTick(GameTick event) { }

// Player events  
@Subscribe public void onActorDeath(ActorDeath event) { }
@Subscribe public void onHitsplatApplied(HitsplatApplied event) { }

// Chat events
@Subscribe public void onChatMessage(ChatMessage event) { }

// World events
@Subscribe public void onGameObjectSpawned(GameObjectSpawned event) { }
@Subscribe public void onNpcSpawned(NpcSpawned event) { }

// Interface events  
@Subscribe public void onWidgetLoaded(WidgetLoaded event) { }
@Subscribe public void onItemContainerChanged(ItemContainerChanged event) { }
```

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
# Build and test
.\build-plugin.bat
.\launch-plugin.bat
```

## ✅ Best Practices

1. **Use descriptive plugin names and descriptions**
2. **Add comprehensive configuration options**
3. **Handle errors gracefully with try-catch blocks**
4. **Use appropriate logging levels (info, debug, error)**
5. **Respect game performance - avoid heavy operations**
6. **Test thoroughly before publishing**

---

This completes your RuneLite plugin development environment!
