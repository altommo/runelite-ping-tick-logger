/*
 * Copyright (c) 2019, Slay to Stay <https://github.com/slaytostay>
 * All rights reserved.
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
package WeaponMap;

import java.util.HashMap;
import java.util.Map;

/**
 * OpenOSRS compatibility class for weapon mapping
 * This is a stub implementation for compatibility
 */
public class WeaponMap
{
	private static final Map<Integer, String> WEAPON_NAMES = new HashMap<>();
	private static final Map<String, Integer> WEAPON_STYLES = new HashMap<>();

	static {
		// Initialize some basic weapon mappings
		WEAPON_NAMES.put(1, "Fists");
		WEAPON_NAMES.put(2, "Sword");
		WEAPON_NAMES.put(3, "Bow");
		WEAPON_NAMES.put(4, "Staff");
		
		WEAPON_STYLES.put("accurate", 0);
		WEAPON_STYLES.put("aggressive", 1);
		WEAPON_STYLES.put("defensive", 2);
		WEAPON_STYLES.put("controlled", 3);
	}

	public static String getWeaponName(int weaponId)
	{
		return WEAPON_NAMES.getOrDefault(weaponId, "Unknown");
	}

	public static int getWeaponStyle(String styleName)
	{
		return WEAPON_STYLES.getOrDefault(styleName.toLowerCase(), 0);
	}

	public static boolean hasWeapon(int weaponId)
	{
		return WEAPON_NAMES.containsKey(weaponId);
	}
}
