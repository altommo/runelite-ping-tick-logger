/*
 * OpenOSRS compatibility class
 * Copyright (c) 2025
 */
package net.runelite.api.coords;

/**
 * OpenOSRS compatibility class - alias for WorldPoint
 * This class provides compatibility with OpenOSRS by wrapping WorldPoint functionality
 */
public class WorldLocation
{
	private final WorldPoint worldPoint;
	
	public WorldLocation(int x, int y, int plane)
	{
		this.worldPoint = new WorldPoint(x, y, plane);
	}
	
	private WorldLocation(WorldPoint worldPoint)
	{
		this.worldPoint = worldPoint;
	}
	
	/**
	 * Create from WorldPoint
	 */
	public static WorldLocation from(WorldPoint point)
	{
		return new WorldLocation(point);
	}
	
	/**
	 * Convert to WorldPoint
	 */
	public WorldPoint toWorldPoint()
	{
		return worldPoint;
	}
	
	// Delegate methods to WorldPoint
	public int getX()
	{
		return worldPoint.getX();
	}
	
	public int getY()
	{
		return worldPoint.getY();
	}
	
	public int getPlane()
	{
		return worldPoint.getPlane();
	}
	
	public int getRegionID()
	{
		return worldPoint.getRegionID();
	}
	
	public int getRegionX()
	{
		return worldPoint.getRegionX();
	}
	
	public int getRegionY()
	{
		return worldPoint.getRegionY();
	}
	
	public WorldLocation dx(int dx)
	{
		return new WorldLocation(worldPoint.dx(dx));
	}
	
	public WorldLocation dy(int dy)
	{
		return new WorldLocation(worldPoint.dy(dy));
	}
	
	public WorldLocation dz(int dz)
	{
		return new WorldLocation(worldPoint.dz(dz));
	}
	
	public int distanceTo(WorldLocation other)
	{
		return worldPoint.distanceTo(other.worldPoint);
	}
	
	public int distanceTo(WorldPoint other)
	{
		return worldPoint.distanceTo(other);
	}
	
	public int distanceTo2D(WorldLocation other)
	{
		return worldPoint.distanceTo2D(other.worldPoint);
	}
	
	public int distanceTo2D(WorldPoint other)
	{
		return worldPoint.distanceTo2D(other);
	}
	
	public int distanceTo(WorldArea other)
	{
		return worldPoint.distanceTo(other);
	}
	
	public boolean isInArea(WorldArea... worldAreas)
	{
		return worldPoint.isInArea(worldAreas);
	}
	
	public boolean isInArea2D(WorldArea... worldAreas)
	{
		return worldPoint.isInArea2D(worldAreas);
	}
	
	public WorldArea toWorldArea()
	{
		return worldPoint.toWorldArea();
	}
	
	@Override
	public boolean equals(Object obj)
	{
		if (this == obj) return true;
		if (obj == null) return false;
		if (obj instanceof WorldLocation)
		{
			return worldPoint.equals(((WorldLocation) obj).worldPoint);
		}
		if (obj instanceof WorldPoint)
		{
			return worldPoint.equals(obj);
		}
		return false;
	}
	
	@Override
	public int hashCode()
	{
		return worldPoint.hashCode();
	}
	
	@Override
	public String toString()
	{
		return worldPoint.toString();
	}
}
