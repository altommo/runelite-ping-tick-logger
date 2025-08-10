/*
 * OpenOSRS compatibility class
 * Copyright (c) 2025
 */
package net.runelite.client.plugins.playerscouter;

/**
 * OpenOSRS compatibility class for Discord field embed
 */
public class FieldEmbed
{
	private String name;
	private String value;
	private boolean inline;
	
	public FieldEmbed(String name, String value, boolean inline)
	{
		this.name = name;
		this.value = value;
		this.inline = inline;
	}
	
	public String getName()
	{
		return name;
	}
	
	public String getValue()
	{
		return value;
	}
	
	public boolean isInline()
	{
		return inline;
	}
}
