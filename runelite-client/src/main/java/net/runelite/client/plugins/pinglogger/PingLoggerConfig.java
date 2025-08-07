package net.runelite.client.plugins.pinglogger;

import net.runelite.client.config.Config;
import net.runelite.client.config.ConfigGroup;
import net.runelite.client.config.ConfigItem;

@ConfigGroup("pinglogger")
public interface PingLoggerConfig extends Config
{
    @ConfigItem(
        keyName = "enabled",
        name = "Enable Ping Logging",
        description = "Enable or disable ping logging to file"
    )
    default boolean enabled()
    {
        return true;
    }
}
