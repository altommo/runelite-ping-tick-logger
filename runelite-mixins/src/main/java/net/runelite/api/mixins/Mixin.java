/*
 * Copyright (c) 2019, OpenOSRS <https://openosrs.com>
 * All rights reserved.
 *
 * Mixin annotation for class targeting
 */
package net.runelite.api.mixins;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Marks a class as a mixin for injection into the specified target class
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Mixin
{
    /**
     * The target class to inject into
     * @return the target class
     */
    Class<?> value();
}