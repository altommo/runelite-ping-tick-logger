/*
 * Copyright (c) 2019, OpenOSRS <https://openosrs.com>
 * All rights reserved.
 *
 * RSClient interface for injection targeting
 */
package net.runelite.rs.api;

import net.runelite.api.Client;

/**
 * Internal RuneScape client interface that extends the public Client API
 * This is the target for mixin injection
 */
public interface RSClient extends Client
{
    // This interface represents the actual OSRS client that gets injected
    // The mixins inject methods into the implementation of this interface
}