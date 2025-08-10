package net.runelite.client.plugins.externals.oneclick.pojos;

import lombok.AllArgsConstructor;
import lombok.Getter;
import net.runelite.api.ItemComposition;

@Getter
@AllArgsConstructor
public class ItemData
{
	private final int id;
	private final int quantity;
	private final int index;
	private final String name;
	private final ItemComposition definition;
}
