/*
 * Copyright (c) 2018, Adam <Adam@sigterm.info>
 * All rights reserved.
 *
 *
 * Modified by farhan1666
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package net.runelite.client.plugins.aoewarnings;

import java.util.HashMap;
import java.util.Map;



public enum AoeProjectileInfo
{
	LIZARDMAN_SHAMAN_AOE(1293, 5), // LIZARDMAN_SHAMAN_AOE
	CRAZY_ARCHAEOLOGIST_AOE(1260, 3), // CRAZY_ARCHAEOLOGIST_AOE
	ICE_DEMON_RANGED_AOE(1324, 3), // ICE_DEMON_RANGED_AOE

	/**
	 * When you don't have pray range on ice demon does an ice barrage
	 */
	ICE_DEMON_ICE_BARRAGE_AOE(1325, 3), // ICE_DEMON_ICE_BARRAGE_AOE

	/**
	 * The AOE when vasa first starts
	 */
	VASA_AWAKEN_AOE(1327, 3), // VASA_AWAKEN_AOE
	VASA_RANGED_AOE(1329, 3), // VASA_RANGED_AOE
	TEKTON_METEOR_AOE(1698, 3), // TEKTON_METEOR_AOE

	/**
	 * The AOEs of Vorkath
	 */
	VORKATH_BOMB(1481, 3), // VORKATH_BOMB_AOE
	VORKATH_POISON_POOL(1483, 1), // VORKATH_POISON_POOL_AOE
	VORKATH_SPAWN(1484, 1), // VORKATH_SPAWN_AOE - extra tick because hard to see otherwise
	VORKATH_TICK_FIRE(1482, 1), // VORKATH_TICK_FIRE_AOE

	/**
	 * the AOEs of Galvek
	 */
	GALVEK_MINE(1495, 3), // GALVEK_MINE
	GALVEK_BOMB(1491, 3), // GALVEK_BOMB

	/**
	 * the AOEs of Grotesque Guardians
	 */
	DAWN_FREEZE(1445, 3), // DAWN_FREEZE
	DUSK_CEILING(1435, 3), // DUSK_CEILING

	/**
	 * the AOE of Vet'ion
	 */
	VETION_LIGHTNING(280, 1), // VETION_LIGHTNING

	/**
	 * the AOE of Chaos Fanatic
	 */
	CHAOS_FANATIC(551, 1), // CHAOS_FANATIC_AOE

	/**
	 * The AOE of Mage Arena 2 Bosses
	 */
	JUSTICIAR_LEASH(1516, 1), // JUSTICIAR_LEASH
	MAGE_ARENA_BOSS_FREEZE(1675, 1), // MAGE_ARENA_BOSS_FREEZE


	/**
	 * the AOE of the Corporeal Beast
	 */
	CORPOREAL_BEAST(315, 1), // CORPOREAL_BEAST_AOE
	CORPOREAL_BEAST_DARK_CORE(319, 3), // CORPOREAL_BEAST_DARK_CORE_AOE

	/**
	 * the AOEs of The Great Olm
	 */
	OLM_FALLING_CRYSTAL(1357, 3), // OLM_FALLING_CRYSTAL
	OLM_BURNING(1349, 1), // OLM_BURNING
	OLM_FALLING_CRYSTAL_TRAIL(1352, 1), // OLM_FALLING_CRYSTAL_TRAIL
	OLM_ACID_TRAIL(1354, 1), // OLM_ACID_TRAIL
	OLM_FIRE_LINE(1347, 1), // OLM_FIRE_LINE

	/**
	 * the AOE of the Wintertodt snow that falls
	 */
	WINTERTODT_SNOW_FALL(1310, 3), // WINTERTODT_SNOW_FALL_AOE

	/**
	 * AOE of Xarpus throwing poison
	 */
	XARPUS_POISON_AOE(1555, 1), // XARPUS_ACID

	/**
	 * Aoe of Addy Drags
	 */
	ADDY_DRAG_POISON(1486, 1), // ADDY_DRAG_POISON

	/**
	 * the Breath of the Drake
	 */
	DRAKE_BREATH(1637, 1), // DRAKE_BREATH

	/**
	 * Cerbs fire
	 */
	CERB_FIRE(1247, 2), // CERB_FIRE

	/**
	 * Demonic gorilla
	 */
	DEMONIC_GORILLA_BOULDER(856, 1), // DEMONIC_GORILLA_BOULDER

	/**
	 * Marble gargoyle (Superior Gargoyle)
	 */
	MARBLE_GARGOYLE_AOE(1453, 1), // MARBLE_GARGOYLE_AOE


	/**
	 * Verzik
	 */
	VERZIK_PURPLE_SPAWN(1594, 3), // VERZIK_PURPLE_SPAWN
	VERZIK_P1_ROCKS(1435, 1); // DUSK_CEILING

	private static final Map<Integer, AoeProjectileInfo> map = new HashMap<>();

	static
	{
		for (AoeProjectileInfo aoe : values())
		{
			map.put(aoe.id, aoe);
		}
	}

	/**
	 * The id of the projectile to trigger this AoE warning
	 */
	private final int id;
	/**
	 * How long the indicator should last for this AoE warning This might
	 * need to be a bit longer than the projectile actually takes to land as
	 * there is a fade effect on the warning
	 */
	private final int aoeSize;

	AoeProjectileInfo(int id, int aoeSize)
	{
		this.id = id;
		this.aoeSize = aoeSize;
	}

	public static AoeProjectileInfo getById(int id)
	{
		return map.get(id);
	}

	public int getId()
	{
		return id;
	}

	public int getAoeSize()
	{
		return aoeSize;
	}
}
