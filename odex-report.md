# RuneLite Hybrid Codebase Assessment

## Build status
- `mvn -q -DskipTests clean compile` in `runelite-api` failed resolving `net.runelite:runelite-maven-plugin:1.11.14-SNAPSHOT` from `https://repo.runelite.net`.
- The module cannot compile until the plugin artifact is installed locally or the repository becomes reachable.

## API/ABI issues addressed
- **Client.java** contained duplicate `setVar(int, String)` declarations. Consolidated into a single method and marked as a legacy shim.
- **RuneLiteObject.java** exposed duplicate `getWorldView()` and `setZ(int)` methods. These are now singular deprecated wrappers delegating to the controller.

## Remaining blockers
- Missing `runelite-maven-plugin` prevents compilation of `runelite-api` and full reactor.

## Suggested patches
```diff
--- a/runelite-api/src/main/java/net/runelite/api/Client.java
+++ b/runelite-api/src/main/java/net/runelite/api/Client.java
@@
-       /**
-        * Sets a VarClientString to the passed value
-        *
-        * @param var the {@link net.runelite.api.gameval.VarClientID}
-        * @param value the new value
-        */
-       void setVar(int var1, String var2);
+       /** Backport shim for legacy plugins. */
+       @Deprecated
+       void setVar(int var1, String var2);
@@
-       /**
-        * Sets a var value
-        * @param varIndex the var index
-        * @param value the value to set
-        */
-       void setVar(int varIndex, String value);
```
```diff
--- a/runelite-api/src/main/java/net/runelite/api/RuneLiteObject.java
+++ b/runelite-api/src/main/java/net/runelite/api/RuneLiteObject.java
@@
-       @Deprecated
-       public WorldView getWorldView()
-       {
-               return super.getWorldView();
-       }
-
-       @Deprecated
-       public void setZ(int z)
-       {
-               super.setZ(z);
-       }
-
-       public void setZ(int z)
-       {
-               super.setZ(z);
-       }
-
-       public WorldView getWorldView()
-       {
-               return super.getWorldView();
-       }
+       /** Backport shim for legacy plugins. */
+       @Deprecated
+       public WorldView getWorldView()
+       {
+               return super.getWorldView();
+       }
+
+       /** Backport shim for legacy plugins. */
+       @Deprecated
+       public void setZ(int z)
+       {
+               super.setZ(z);
+       }
```

## Checklist
- [ ] Provide or build `net.runelite:runelite-maven-plugin:1.11.14-SNAPSHOT` locally.
- [ ] Re-run `mvn -q -pl runelite-api -DskipTests clean compile`.
- [ ] Once green, run full reactor: `mvn -q -DskipTests clean install`.
- [ ] Address any subsequent compile errors per module.

