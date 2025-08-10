/*
 * Copyright (c) 2018, OpenOSRS
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
 * WeaponMap compatibility class for OpenOSRS plugins
 */
public class StyleMap
{
    private static final Map<Integer, Integer> weaponStyleMap = new HashMap<>();
    
    static
    {
        // Initialize with basic weapon style mappings
        // These are placeholder values - should be updated with actual weapon IDs
        
        // Magic weapons (style 0)
        weaponStyleMap.put(1379, 0); // Staff of fire
        weaponStyleMap.put(1381, 0); // Staff of water
        weaponStyleMap.put(1383, 0); // Staff of earth
        weaponStyleMap.put(1385, 0); // Staff of air
        
        // Melee weapons (style 1)
        weaponStyleMap.put(1277, 1); // Dragon sword
        weaponStyleMap.put(1333, 1); // Rune scimitar
        weaponStyleMap.put(1291, 1); // Dragon longsword
        
        // Ranged weapons (style 2)
        weaponStyleMap.put(861, 2); // Magic shortbow
        weaponStyleMap.put(11235, 2); // Dark bow
        weaponStyleMap.put(4827, 2); // Crossbow
    }
    
    /**
     * Gets the weapon style for a given weapon ID
     * @param weaponId the weapon ID
     * @return the weapon style (0=magic, 1=melee, 2=ranged) or -1 if unknown
     */
    public static int get(int weaponId)
    {
        return weaponStyleMap.getOrDefault(weaponId, -1);
    }
    
    /**
     * Puts a weapon style mapping
     * @param weaponId the weapon ID
     * @param style the weapon style
     */
    public static void put(int weaponId, int style)
    {
        weaponStyleMap.put(weaponId, style);
    }
}
