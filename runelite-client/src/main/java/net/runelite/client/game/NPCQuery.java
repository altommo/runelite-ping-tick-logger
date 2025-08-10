/*
 * OpenOSRS compatibility class
 * Copyright (c) 2025
 */
package net.runelite.client.game;

import net.runelite.api.Client;
import net.runelite.api.NPC;
import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Collectors;

/**
 * OpenOSRS compatibility class for querying NPCs
 */
public class NPCQuery
{
	private final Client client;
	private Predicate<NPC> filter = npc -> true;
	
	public NPCQuery(Client client)
	{
		this.client = client;
	}
	
	/**
	 * Filter by NPC IDs
	 */
	public NPCQuery idEquals(int... ids)
	{
		List<Integer> idList = Arrays.stream(ids).boxed().collect(Collectors.toList());
		filter = filter.and(npc -> idList.contains(npc.getId()));
		return this;
	}
	
	/**
	 * Filter by name
	 */
	public NPCQuery nameEquals(String name)
	{
		filter = filter.and(npc -> name.equals(npc.getName()));
		return this;
	}
	
	/**
	 * Filter by name containing
	 */
	public NPCQuery nameContains(String name)
	{
		filter = filter.and(npc -> npc.getName() != null && npc.getName().contains(name));
		return this;
	}
	
	/**
	 * Get the result list
	 */
	public List<NPC> result()
	{
		return client.getNpcs().stream()
			.filter(filter)
			.collect(Collectors.toList());
	}
	
	/**
	 * Get the first result
	 */
	public NPC first()
	{
		return client.getNpcs().stream()
			.filter(filter)
			.findFirst()
			.orElse(null);
	}
}
