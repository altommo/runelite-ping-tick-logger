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

    @ConfigSection(
        name = "Mouse Coordinates",
        description = "Settings for displaying mouse coordinates",
        position = 3
    )
    String mouseCoordsSection = "mouseCoords";

    // === General Settings ===
    
    @ConfigItem(
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

    @ConfigItem(
        keyName = "writeActivePrayers",
        name = "Write Active Prayers",
        description = "Write active_prayers.txt with a list of active prayers",
        section = monitoringSection
    )
    default boolean writeActivePrayers()
    {
        return false;
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

    // === Mouse Coordinates ===

    @ConfigItem(
        keyName = "showMouseCoords",
        name = "Show Mouse Coords",
        description = "Displays an overlay with the current mouse coordinates",
        section = mouseCoordsSection
    )
    default boolean showMouseCoords()
    {
        return false;
    }

    @ConfigItem(
        keyName = "drawRectangle",
        name = "Draw Rectangle",
        description = "Allows drawing a rectangle on the screen to get its coordinates",
        section = mouseCoordsSection
    )
    default boolean drawRectangle()
    {
        return false;
    }

    @ConfigItem(
        keyName = "rectangleInstructions",
        name = "How to use Draw Rectangle",
        description = "Press and hold the mouse button to start drawing, and release to finish.",
        section = mouseCoordsSection
    )
    default String rectangleInstructions()
    {
        return "";
    }
}