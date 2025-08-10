package net.runelite.api.anim;

import java.util.function.Consumer;

/** Minimal backport surface for legacy calls. */
 @Deprecated
public interface AnimationController {
    Object getAnimation();
    int getFrame();
    void setOnFinished(Consumer<AnimationController> onFinished);

    static void loop(AnimationController ac) { /* no-op */ }
}
