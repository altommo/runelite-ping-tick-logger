import net.runelite.api.Locatable;
import net.runelite.api.coords.WorldPoint;

public class TestLocatable implements Locatable {
    public WorldPoint getWorldLocation() {
        return new WorldPoint(0, 0, 0);
    }
}
