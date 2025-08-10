package net.runelite.client.plugins.pinglogger;

import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import javax.inject.Inject;
import net.runelite.client.ui.overlay.Overlay;
import net.runelite.client.ui.overlay.OverlayLayer;
import net.runelite.client.ui.overlay.OverlayPosition;
import net.runelite.client.ui.overlay.OverlayPriority;
import net.runelite.client.ui.overlay.components.LineComponent;
import net.runelite.client.ui.overlay.components.PanelComponent;

class MouseCoordsOverlay extends Overlay
{
    private final PingLoggerPlugin plugin;
    private final PingLoggerConfig config;
    private final PanelComponent panelComponent = new PanelComponent();

    @Inject
    private MouseCoordsOverlay(PingLoggerPlugin plugin, PingLoggerConfig config)
    {
        this.plugin = plugin;
        this.config = config;
        setPosition(OverlayPosition.TOP_LEFT);
        setLayer(OverlayLayer.ABOVE_SCENE);
        setPriority(OverlayPriority.HIGH);
    }

    @Override
    public Dimension render(Graphics2D graphics)
    {
        if (!config.showMouseCoords())
        {
            return null;
        }

        panelComponent.getChildren().clear();

        Point mousePosition = plugin.getMousePosition();
        if (mousePosition != null)
        {
            panelComponent.getChildren().add(LineComponent.builder()
                .left("Mouse Coords:")
                .right(mousePosition.x + ", " + mousePosition.y)
                .build());
        }

        Rectangle rect = plugin.getRectangle();
        if (rect != null)
        {
            panelComponent.getChildren().add(LineComponent.builder()
                .left("Rect Start:")
                .right(rect.x + ", " + rect.y)
                .build());
            panelComponent.getChildren().add(LineComponent.builder()
                .left("Rect End:")
                .right((rect.x + rect.width) + ", " + (rect.y + rect.height))
                .build());
            panelComponent.getChildren().add(LineComponent.builder()
                .left("Rect Size:")
                .right(rect.width + "x" + rect.height)
                .build());
        }

        return panelComponent.render(graphics);
    }
}
