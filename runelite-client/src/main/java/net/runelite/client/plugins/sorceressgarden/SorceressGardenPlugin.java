package net.runelite.client.plugins.sorceressgarden;

import com.google.inject.Provides;
import javax.inject.Inject;
import net.runelite.api.Client;
import net.runelite.api.ItemID;
import net.runelite.api.Skill;
import net.runelite.client.config.ConfigManager;
import net.runelite.client.eventbus.Subscribe;
import net.runelite.api.events.StatChanged;

import net.runelite.client.plugins.Plugin;
import net.runelite.client.plugins.PluginDependency;
import net.runelite.client.plugins.PluginDescriptor;
import net.runelite.client.plugins.xptracker.XpTrackerPlugin;
import net.runelite.client.ui.overlay.OverlayManager;
import org.apache.commons.lang3.ArrayUtils;

@PluginDescriptor(
	name = "Sorceress Garden",
	enabledByDefault = false,
	description = "Provides various utilities for the Sorceress's Garden minigame",
	tags = {"sorceress", "garden", "sqirk", "sq'irk", "thieving", "farming"}
)

@PluginDependency(XpTrackerPlugin.class)
public class SorceressGardenPlugin extends Plugin
{
	private static final int GARDEN_REGION = 11605;

	@Inject
	private SorceressGardenConfig config;

	@Inject
	private OverlayManager overlayManager;

	@Inject
	private SorceressGardenOverlay sorceressGardenOverlay;

	@Inject
	private SorceressSqirkOverlay sorceressSqirkOverlay;

	@Inject
	private SorceressSession sorceressSession;

	@Inject
	private Client client;

	@Provides
	SorceressGardenConfig provideConfig(ConfigManager configManager)
	{
		return configManager.getConfig(SorceressGardenConfig.class);
	}

	@Override
	protected void startUp()
	{
		// runs on plugin startup
		overlayManager.add(sorceressGardenOverlay);
		overlayManager.add(sorceressSqirkOverlay);

		for (Skill skill : Skill.values())
		{
			skillXp.put(skill, client.getSkillExperience(skill));
		}
	}

	@Override
	protected void shutDown()
	{
		// runs on plugin shutdown
		overlayManager.remove(sorceressGardenOverlay);
		overlayManager.remove(sorceressSqirkOverlay);
	}


	@Subscribe
	public void onStatChanged(net.runelite.api.events.StatChanged statChanged)
	{
		if (!config.showSqirksStats())
		{
			return;
		}

		final Skill skill = statChanged.getSkill();
		final int currentXp = statChanged.getXp();

		Integer previousXp = skillXp.put(skill, currentXp);
		if (previousXp == null)
		{
			return;
		}

		final int xpGained = currentXp - previousXp;
		if (xpGained == 0)
		{
			return;
		}

		if (skill == Skill.FARMING && isInGarden())
		{
			switch (xpGained)
			{
				case 30:
					sorceressSession.incrementSqirks(ItemID.WINTER_SQIRK);
					break;
				case 40:
					sorceressSession.incrementSqirks(ItemID.SPRING_SQIRK);
					break;
				case 50:
					sorceressSession.incrementSqirks(ItemID.AUTUMN_SQIRK);
					break;
				case 60:
					sorceressSession.incrementSqirks(ItemID.SUMMER_SQIRK);
					break;
			}
		}
	}

	boolean isInGarden()
	{
		return client.getMapRegions() != null && ArrayUtils.contains(client.getMapRegions(), GARDEN_REGION);
	}
}
