/*
 * Copyright (c) 2019, OpenOSRS <https://openosrs.com>
 * All rights reserved.
 *
 * Mixin annotation for field/method injection
 */
package net.runelite.api.mixins;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Marks a field or method for injection into the target class
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD, ElementType.METHOD})
public @interface Inject
{
}