/*
 * ******************************************************************************
 *  * Copyright (c) 2019 openosrs
 *  *  Redistributions and modifications of this software are permitted as long as this notice remains in its original unmodified state at the top of this file.
 *  *  If there are any questions comments, or feedback about this software, please direct all inquiries directly to the file authors:
 *  *  ST0NEWALL#9112
 *  *   openosrs Discord: https://discord.gg/Q7wFtCe
 *  *   openosrs website: https://openosrs.com
 *  *****************************************************************************
 */

package net.runelite.client.plugins.pvptools;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import javax.inject.Inject;
import javax.inject.Singleton;
import net.runelite.api.Client;
import net.runelite.api.Varbits;
import net.runelite.api.WorldType;
import net.runelite.client.ui.overlay.Overlay;
import net.runelite.client.ui.overlay.OverlayLayer;
import net.runelite.client.ui.overlay.OverlayPosition;
import net.runelite.client.ui.overlay.OverlayPriority;
import net.runelite.client.ui.overlay.components.PanelComponent;
import org.apache.commons.lang3.ArrayUtils;

@Singleton
public class PlayerCountOverlay extends Overlay
{
	private static final int[] CLAN_WARS_REGIONS = {9520, 13135, 13134, 13133, 13131, 13130, 13387, 13386};

	private final PvpToolsPlugin plugin;
	private final PvpToolsConfig config;
	private final Client client;
	private final PanelComponent panelComponent = new PanelComponent();

	@Inject
	public PlayerCountOverlay(final PvpToolsPlugin plugin, final PvpToolsConfig config, final Client client)
	{
		this.plugin = plugin;
		this.config = config;
		this.client = client;
		setLayer(OverlayLayer.ABOVE_WIDGETS);
		setPriority(OverlayPriority.HIGHEST);
		setPosition(OverlayPosition.TOP_LEFT);
		setPreferredPosition(OverlayPosition.TOP_LEFT);
	}

	@Override
	public Dimension render(Graphics2D graphics)
	{
		if (config.countPlayers() &&
			(client.getVarbitValue(Varbits.IN_WILDERNESS) == 1 || WorldType.isPvpWorld(client.getWorldType())
				|| ArrayUtils.contains(CLAN_WARS_REGIONS, client.getMapRegions()[0]) ||
				WorldType.isDeadmanWorld(client.getWorldType())))
		{
			panelComponent.getChildren().clear();
			panelComponent.setPreferredSize(new Dimension(100, 50));
			
			// Draw friendly count
			graphics.setColor(Color.GREEN);
			graphics.drawString("Friendly: " + plugin.getFriendlyPlayerCount(), 10, 20);
			
			// Draw enemy count
			graphics.setColor(Color.RED);
			graphics.drawString("Enemy: " + plugin.getEnemyPlayerCount(), 10, 35);
			
			return new Dimension(100, 50);
		}
		return null;
	}
}
