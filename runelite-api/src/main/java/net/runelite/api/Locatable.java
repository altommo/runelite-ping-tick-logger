/*
 * OpenOSRS compatibility interface
 * Copyright (c) 2025
 */
package net.runelite.api;

import net.runelite.api.coords.WorldPoint;

/**
 * OpenOSRS compatibility interface for objects that have a location
 * This interface represents objects that can provide their world location
 */
public interface Locatable
{
	/**
	 * Gets the world location of this object
	 * @return the WorldPoint representing the location of this object
	 */
	WorldPoint getWorldLocation();
}
