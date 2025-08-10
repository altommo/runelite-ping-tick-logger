package net.runelite.client.plugins.playerscouter;

import net.runelite.api.Client;
import net.runelite.api.Player;
import javax.inject.Inject;
import javax.inject.Singleton;
import java.util.ArrayList;
import java.util.List;

@Singleton
public class PlayerManager
{
    @Inject
    private Client client;

    public List<PlayerContainer> getPlayerContainers()
    {
        List<PlayerContainer> playerContainers = new ArrayList<>();
        for (Player player : client.getCachedPlayers())
        {
            if (player != null)
            {
                playerContainers.add(new PlayerContainer(player));
            }
        }
        return playerContainers;
    }

    public void updateStats(Player player)
    {
        // Placeholder for updating player stats.
        // This would typically involve fetching stats from an external API.
    }

    public PlayerContainer getPlayer(String name)
    {
        // This method is used in BetterEquipmentInspectorPlugin.java
        // It's not directly used in PlayerScouter.java, but it's good to have a placeholder.
        for (Player player : client.getCachedPlayers())
        {
            if (player != null && player.getName().equals(name))
            {
                return new PlayerContainer(player);
            }
        }
        return null;
    }
}
