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
import java.util.ArrayDeque;
import java.util.Deque;

@Slf4j
@PluginDescriptor(
        name = "Ping & Tick Logger",
        description = "Logs ping and tick length to files for automation tools",
        tags = {"ping", "tick", "automation", "timing"}
)
public class PingLoggerPlugin extends Plugin
{
    private static final String PING_FILE_PATH = System.getProperty("user.home") + "/.runelite/ping.txt";
    private static final String TICK_FILE_PATH = System.getProperty("user.home") + "/.runelite/tick.txt";
    private static final String DATA_FILE_PATH = System.getProperty("user.home") + "/.runelite/ping_tick_data.txt";
    
    // Tick timing tracking
    private long lastTickTime = 0;
    private final Deque<Long> tickLengths = new ArrayDeque<>();
    private static final int MAX_TICK_SAMPLES = 10; // Rolling average of last 10 ticks
    
    private List<World> worlds;
    private int gameTickCount = 0;
    private long pluginStartTime;

    @Inject
    private Client client;

    @Inject
    private PingLoggerConfig config;

    @Inject
    private WorldService worldService;

    @Override
    protected void startUp() throws Exception
    {
        log.info("Ping & Tick Logger plugin started!");
        log.info("Output files: ping={}, tick={}, data={}", PING_FILE_PATH, TICK_FILE_PATH, DATA_FILE_PATH);
        
        gameTickCount = 0;
        pluginStartTime = System.currentTimeMillis();
        lastTickTime = System.currentTimeMillis();
        tickLengths.clear();
        
        // Initialize files
        writeToFile(PING_FILE_PATH, "0");
        writeToFile(TICK_FILE_PATH, "600");
        writeToFile(DATA_FILE_PATH, "ping=0,tick=600,samples=0");
        
        loadWorlds();
    }

    @Override
    protected void shutDown() throws Exception
    {
        log.info("Ping & Tick Logger plugin stopped!");
        worlds = null;
        tickLengths.clear();
    }

    private void loadWorlds()
    {
        try {
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
        if (event.getWorldResult() != null) {
            this.worlds = event.getWorldResult().getWorlds();
            log.info("WorldsFetch event received! Got {} worlds", worlds != null ? worlds.size() : 0);
        }
    }

    @Subscribe
    public void onGameTick(GameTick tick)
    {
        long currentTime = System.currentTimeMillis();
        gameTickCount++;
        
        // Calculate tick length
        if (lastTickTime > 0) {
            long tickLength = currentTime - lastTickTime;
            
            // Add to rolling average (ignore first few ticks as they can be irregular)
            if (gameTickCount > 3) {
                tickLengths.addLast(tickLength);
                if (tickLengths.size() > MAX_TICK_SAMPLES) {
                    tickLengths.removeFirst();
                }
            }
        }
        lastTickTime = currentTime;
        
        // Try to load worlds if we don't have them yet
        if (worlds == null || worlds.isEmpty()) {
            if (gameTickCount % 50 == 1) {
                loadWorlds();
            }
        }
        
        if (!config.enabled()) {
            return;
        }
        
        // Update tick length file if monitoring is enabled
        if (config.monitorTick()) {
            updateTickLengthFile();
        }
        
        // Only continue with ping monitoring if it's enabled
        if (!config.monitorPing()) {
            return;
        }
        
        if (worlds == null || worlds.isEmpty()) {
            if (gameTickCount % 100 == 1) {
                log.info("GameTick #{} - No worlds data available yet (Current world: {})", 
                    gameTickCount, client.getWorld());
            }
            return;
        }

        int currentWorld = client.getWorld();
        if (currentWorld == 0) {
            return;
        }

        // Update ping and combined data
        updatePingData(currentWorld);
    }
    
    private void updateTickLengthFile() {
        if (tickLengths.isEmpty()) {
            return;
        }
        
        // Calculate average tick length
        long totalTime = 0;
        for (Long length : tickLengths) {
            totalTime += length;
        }
        long averageTickLength = totalTime / tickLengths.size();
        
        // Write to tick file
        writeToFile(TICK_FILE_PATH, String.valueOf(averageTickLength));
        
        if (config.showTickDebug() && gameTickCount % 10 == 0) {
            log.info("Avg tick length: {}ms (from {} samples)", averageTickLength, tickLengths.size());
        }
    }
    
    private void updatePingData(int currentWorld) {
        for (World w : worlds) {
            if (w.getId() == currentWorld) {
                try {
                    int ping = Ping.ping(w);
                    
                    // Write ping to dedicated ping file
                    writeToFile(PING_FILE_PATH, String.valueOf(ping));
                    
                    // Write combined data for advanced automation if enabled
                    if (config.writeCombinedData() && !tickLengths.isEmpty()) {
                        long totalTime = 0;
                        for (Long length : tickLengths) {
                            totalTime += length;
                        }
                        long averageTickLength = totalTime / tickLengths.size();
                        
                        String combinedData = String.format("ping=%d,tick=%d,samples=%d,world=%d", 
                            ping, averageTickLength, tickLengths.size(), currentWorld);
                        writeToFile(DATA_FILE_PATH, combinedData);
                    }
                    
                    if (config.showPingDebug() && gameTickCount % config.logInterval() == 0) {
                        log.info("Ping: {}ms, World: {}, Tick samples: {}", ping, currentWorld, tickLengths.size());
                    }
                    
                } catch (Exception e) {
                    if (config.showErrors()) {
                        log.error("Failed to ping or write file: {}", e.getMessage());
                    }
                }
                break;
            }
        }
    }
    
    private void writeToFile(String filePath, String content) {
        try (FileWriter fw = new FileWriter(filePath, false)) {
            fw.write(content);
            fw.flush();
        } catch (IOException e) {
            if (config.showErrors()) {
                log.error("Failed to write to {}: {}", filePath, e.getMessage());
            }
        }
    }
}
