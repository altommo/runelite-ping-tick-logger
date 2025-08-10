/*
 * Copyright (c) 2025, RuneLite Compatibility Team
 * All rights reserved.
 *
 * Mock implementation of missing Client methods for compatibility testing.
 * This provides stub implementations that return sensible defaults.
 */
package net.runelite.client.rs;

/**
 * Compatibility stubs for missing Client API methods
 * These methods are typically injected into the OSRS client at runtime
 */
public class ClientCompatibilityStubs
{
    // Spell-related methods
    public static void setSelectedSpellWidget(int widgetID)
    {
        // Stub: In real implementation, this would set the selected spell widget
        // For now, this is a no-op that allows compilation
    }
    
    public static int getSelectedSpellWidget()
    {
        // Stub: Return a default widget ID
        return 0;
    }
    
    public static int getSelectedSpellChildIndex()
    {
        // Stub: Return default child index
        return 0;
    }
    
    public static void setSelectedSpellChildIndex(int index)
    {
        // Stub: In real implementation, this would set the child index
    }
    
    // Menu-related methods
    public static int getMenuOptionCount()
    {
        // Stub: Return default menu option count
        return 0;
    }
    
    // PvP-related methods
    public static void setHideFriendAttackOptions(boolean hide)
    {
        // Stub: In real implementation, this would hide/show friend attack options
    }
    
    public static void setHidePlayerAttackOptions(boolean hide)
    {
        // Stub: In real implementation, this would hide/show player attack options
    }
    
    public static void setHideClanmateAttackOptions(boolean hide)
    {
        // Stub: In real implementation, this would hide/show clanmate attack options
    }
    
    // Scene tile methods
    public static void setSelectedSceneTileX(int x)
    {
        // Stub: In real implementation, this would set the selected tile X coordinate
    }
    
    public static void setSelectedSceneTileY(int y)
    {
        // Stub: In real implementation, this would set the selected tile Y coordinate
    }
}