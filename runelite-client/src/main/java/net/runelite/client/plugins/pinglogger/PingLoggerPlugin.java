package net.runelite.client.plugins.pinglogger;

import com.google.inject.Provides;
import javax.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import net.runelite.api.Client;
import net.runelite.api.events.GameTick;
import net.runelite.client.events.WorldsFetch;
import net.runelite.client.config.ConfigManager;
import net.runelite.client.eventbus.Subscribe;
import net.runelite.client.plugins.Plugin;
import net.runelite.client.plugins.PluginDescriptor;
import net.runelite.client.plugins.worldhopper.ping.Ping;
import net.runelite.client.game.WorldService;
import net.runelite.http.api.worlds.World;

import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

@Slf4j
@PluginDescriptor(
        name = "Ping Logger",
        description = "Logs your current world ping to ~/.runelite/ping.txt",
        tags = {"ping", "automation"}
)
public class PingLoggerPlugin extends Plugin
{
    private static final String FILE_PATH =
            System.getProperty("user.home") + "/.runelite/ping.txt";

    private List<World> worlds;
    private int gameTickCount = 0;

    @Inject
    private Client client;

    @Inject
    private PingLoggerConfig config;

    @Inject
    private WorldService worldService;

    @Override
    protected void startUp() throws Exception
    {
        log.info("Ping Logger plugin started! File will be written to: {}", FILE_PATH);
        gameTickCount = 0;
        // Try to get worlds from WorldService directly
        loadWorlds();
    }

    @Override
    protected void shutDown() throws Exception
    {
        log.info("Ping Logger plugin stopped!");
        worlds = null;
    }

    private void loadWorlds()
    {
        try {
            // Try to get worlds from the WorldService
            worlds = worldService.getWorlds();
            if (worlds != null && !worlds.isEmpty()) {
                log.info("Loaded {} worlds from WorldService", worlds.size());
            } else {
                log.info("WorldService returned no worlds, will try again later");
            }
        } catch (Exception e) {
            log.info("Could not load worlds from WorldService: {}", e.getMessage());
        }
    }

    @Provides
    PingLoggerConfig provideConfig(ConfigManager configManager)
    {
        return configManager.getConfig(PingLoggerConfig.class);
    }

    @Subscribe
    public void onWorldsFetch(WorldsFetch event)
    {
        this.worlds = event.getWorldResult().getWorlds();
        log.info("WorldsFetch event received! Got {} worlds", worlds != null ? worlds.size() : 0);
    }

    @Subscribe
    public void onGameTick(GameTick tick)
    {
        gameTickCount++;
        
        // Try to load worlds if we don't have them yet
        if (worlds == null || worlds.isEmpty()) {
            if (gameTickCount % 50 == 1) {
                loadWorlds();
            }
        }
        
        if (!config.enabled())
        {
            return;
        }
        
        if (worlds == null || worlds.isEmpty())
        {
            if (gameTickCount % 100 == 1) {
                log.info("GameTick #{} - No worlds data available yet (Current world: {})", 
                    gameTickCount, client.getWorld());
            }
            return;
        }

        int currentWorld = client.getWorld();
        if (currentWorld == 0) {
            if (gameTickCount % 100 == 1) {
                log.info("Not connected to any world yet");
            }
            return;
        }

        // Find current world and ping it
        for (World w : worlds)
        {
            if (w.getId() == currentWorld)
            {
                try {
                    int ping = Ping.ping(w);
                    
                    try (FileWriter fw = new FileWriter(FILE_PATH, false))
                    {
                        fw.write(Integer.toString(ping));
                        fw.flush();
                    }
                    
                    log.info("Logged ping: {} ms for world {}", ping, currentWorld);
                } catch (Exception e) {
                    log.error("Failed to ping or write file: {}", e.getMessage());
                }
                break;
            }
        }
    }
}
