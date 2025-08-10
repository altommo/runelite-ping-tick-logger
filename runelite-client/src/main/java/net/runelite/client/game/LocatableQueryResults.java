/*
 * OpenOSRS compatibility class
 * Copyright (c) 2025
 */
package net.runelite.client.game;

import net.runelite.api.Locatable;
import java.util.List;
import java.util.stream.Stream;

/**
 * OpenOSRS compatibility class for query results of locatable objects
 */
public class LocatableQueryResults<T extends Locatable>
{
	private final List<T> results;
	
	public LocatableQueryResults(List<T> results)
	{
		this.results = results;
	}
	
	/**
	 * Get the first result
	 */
	public T first()
	{
		return results.isEmpty() ? null : results.get(0);
	}
	
	/**
	 * Check if empty
	 */
	public boolean isEmpty()
	{
		return results.isEmpty();
	}
	
	/**
	 * Get size
	 */
	public int size()
	{
		return results.size();
	}
	
	/**
	 * Get as stream
	 */
	public Stream<T> stream()
	{
		return results.stream();
	}
	
	/**
	 * Get as list
	 */
	public List<T> asList()
	{
		return results;
	}
}
