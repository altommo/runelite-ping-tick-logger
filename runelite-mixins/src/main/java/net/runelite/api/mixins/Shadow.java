/*
 * Copyright (c) 2019, OpenOSRS <https://openosrs.com>
 * All rights reserved.
 *
 * Shadow annotation for accessing existing fields/methods
 */
package net.runelite.api.mixins;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Marks a field or method as a shadow of an existing field/method in the target class
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD, ElementType.METHOD})
public @interface Shadow
{
    /**
     * The name of the field/method to shadow
     * @return the field/method name
     */
    String value() default "";
}