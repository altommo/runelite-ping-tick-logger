
package net.runelite.client.plugins.inferno;

public class NPCManager
{
	public int getHealth(int npcId)
	{
		// TODO: Add a mapping of NPC IDs to their health.
		if (npcId == net.runelite.api.NpcID.TZKAL_ZUK)
		{
			return 1200;
		}
		return -1; // Default or unknown health
	}
}
