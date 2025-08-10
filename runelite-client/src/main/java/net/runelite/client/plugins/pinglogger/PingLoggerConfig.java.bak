package net.runelite.client.plugins.pinglogger;

import net.runelite.client.config.Config;
import net.runelite.client.config.ConfigGroup;
import net.runelite.client.config.ConfigItem;
import net.runelite.client.config.ConfigSection;

@ConfigGroup("pinglogger")
public interface PingLoggerConfig extends Config
{
    @ConfigSection(
        name = "General Settings",
        description = "Basic plugin settings",
        position = 0
    )
    String generalSection = "general";
    
    @ConfigSection(
        name = "Monitoring Settings", 
        description = "Control what data to monitor and log",
        position = 1
    )
    String monitoringSection = "monitoring";
    
    @ConfigSection(
        name = "Debug Settings",
        description = "Debugging and logging options", 
        position = 2,
        closedByDefault = true
    )
    String debugSection = "debug";

    // === General Settings ===
    
    @ConfigItem(
        keyName = "enabled",
        name = "Enable Plugin",
        description = "Enable or disable the entire plugin",
        section = generalSection
    )
    default boolean enabled()
    {
        return true;
    }

    // === Monitoring Settings ===
    
    @ConfigItem(
        keyName = "monitorPing",
        name = "Monitor Ping", 
        description = "Track and log ping to current world",
        section = monitoringSection
    )
    default boolean monitorPing()
    {
        return true;
    }
    
    @ConfigItem(
        keyName = "monitorTick",
        name = "Monitor Tick Length",
        description = "Track and log game tick length for timing optimization", 
        section = monitoringSection
    )
    default boolean monitorTick()
    {
        return true;
    }
    
    @ConfigItem(
        keyName = "writeDataFile",
        name = "Write Combined Data File",
        description = "Write ping_tick_data.txt with combined information for advanced automation",
        section = monitoringSection  
    )
    default boolean writeCombinedData()
    {
        return true;
    }

    // === Debug Settings ===
    
    @ConfigItem(
        keyName = "showPingDebug",
        name = "Show Ping Debug",
        description = "Show ping information in console logs",
        section = debugSection
    )
    default boolean showPingDebug()
    {
        return false;
    }
    
    @ConfigItem(
        keyName = "showTickDebug", 
        name = "Show Tick Debug",
        description = "Show tick length information in console logs",
        section = debugSection
    )
    default boolean showTickDebug()
    {
        return false;
    }
    
    @ConfigItem(
        keyName = "showErrors",
        name = "Show Errors",
        description = "Show error messages in console logs", 
        section = debugSection
    )
    default boolean showErrors()
    {
        return true;
    }
    
    @ConfigItem(
        keyName = "logInterval",
        name = "Log Interval",
        description = "How often to log debug info (in game ticks, 1 = every tick)",
        section = debugSection
    )
    default int logInterval()
    {
        return 50;
    }
}
