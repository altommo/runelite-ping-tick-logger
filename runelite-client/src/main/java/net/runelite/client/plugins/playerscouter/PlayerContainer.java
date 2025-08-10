package net.runelite.client.plugins.playerscouter;

import net.runelite.api.Player;
import java.util.LinkedHashMap;
import java.util.Map;

public class PlayerContainer
{
    private final Player player;
    private final String name;
    private final int combatLevel;
    private boolean scouted;
    private int scoutTimer;
    private boolean httpRetry;

    public PlayerContainer(Player player)
    {
        this.player = player;
        this.name = player.getName();
        this.combatLevel = player.getCombatLevel();
        this.scouted = false;
        this.scoutTimer = 500; // Default value
        this.httpRetry = false;
    }

    public Player getPlayer()
    {
        return player;
    }

    public String getName()
    {
        return name;
    }

    public int getCombatLevel()
    {
        return combatLevel;
    }

    public boolean isScouted()
    {
        return scouted;
    }

    public void setScouted(boolean scouted)
    {
        this.scouted = scouted;
    }

    public int getScoutTimer()
    {
        return scoutTimer;
    }

    public void setScoutTimer(int scoutTimer)
    {
        this.scoutTimer = scoutTimer;
    }

    public boolean isHttpRetry()
    {
        return httpRetry;
    }

    public void setHttpRetry(boolean httpRetry)
    {
        this.httpRetry = httpRetry;
    }

    // Placeholder methods for complex functionality
    public Object getSkills()
    {
        return null; // Placeholder
    }

    public int getRisk()
    {
        return 0; // Placeholder
    }

    public int getWeapon()
    {
        return 0; // Placeholder
    }

    public LinkedHashMap<Integer, Integer> getRiskedGear()
    {
        return new LinkedHashMap<>(); // Placeholder
    }

    public String getLocation()
    {
        return "Unknown"; // Placeholder
    }

    public String getTargetString()
    {
        return "Unknown"; // Placeholder
    }

    public int getWildyLevel()
    {
        return 0; // Placeholder
    }
}
