package net.runelite.test;

import net.runelite.api.coords.WorldPoint;
import net.runelite.api.coords.WorldLocation;

public class CompilationTest 
{
    public static void main(String[] args) 
    {
        // Test that WorldLocation can be created and used
        WorldLocation loc = new WorldLocation(100, 200, 0);
        WorldPoint point = new WorldPoint(100, 200, 0);
        
        // Test that conversion works
        WorldLocation fromPoint = WorldLocation.from(point);
        WorldPoint toPoint = loc.toWorldPoint();
        
        // Test basic methods
        int x = loc.getX();
        int y = loc.getY();
        int plane = loc.getPlane();
        
        System.out.println("Test completed successfully");
    }
}
