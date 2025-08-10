/*
 * OpenOSRS compatibility class
 * Copyright (c) 2025
 */
package net.runelite.client.game;

import net.runelite.api.Client;
import net.runelite.api.GameObject;
import net.runelite.api.coords.WorldPoint;
import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

/**
 * OpenOSRS compatibility class for querying GameObjects
 */
public class GameObjectQuery
{
	private final Client client;
	private Predicate<GameObject> filter = obj -> true;
	
	public GameObjectQuery(Client client)
	{
		this.client = client;
	}
	
	/**
	 * Filter by GameObject IDs
	 */
	public GameObjectQuery idEquals(int... ids)
	{
		List<Integer> idList = Arrays.stream(ids).boxed().collect(Collectors.toList());
		filter = filter.and(obj -> idList.contains(obj.getId()));
		return this;
	}
	
	/**
	 * Filter by distance from point
	 */
	public GameObjectQuery withinDistance(WorldPoint point, int distance)
	{
		filter = filter.and(obj -> obj.getWorldLocation().distanceTo(point) <= distance);
		return this;
	}
	
	/**
	 * Get the result as LocatableQueryResults
	 */
	public LocatableQueryResults<GameObject> result()
	{
		List<GameObject> objects = client.getTopLevelWorldView().getScene().getGameObjects()
			.stream()
			.flatMap(Arrays::stream)
			.flatMap(Arrays::stream)
			.filter(java.util.Objects::nonNull)
			.filter(filter)
			.collect(Collectors.toList());
		
		return new LocatableQueryResults<>(objects);
	}
}
