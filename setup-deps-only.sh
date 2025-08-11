#!/usr/bin/env bash
# setup-deps-only.sh
# Prepare toolchain and fetch Maven dependencies/plugins for the hybrid RuneLite project.
# Does NOT compile or build jars.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$REPO_ROOT/build_logs"
SUMMARY="$LOG_DIR/deps-summary.txt"
M2_IMPORT="${M2_IMPORT:-}"     # optional: path to an m2-cache.tgz to import
MVN_FLAGS_COMMON="-q -DskipTests"
MODULES="${MODULES:-runelite-api}"   # set to "runelite-api,runelite-client" if you want more

mkdir -p "$LOG_DIR"

echo "== Toolchain check =="
command -v git  >/dev/null || { echo "git not found";  exit 1; }
command -v mvn  >/dev/null || { echo "maven not found"; exit 1; }
command -v java >/dev/null || { echo "java not found";  exit 1; }
echo "Git:   $(git --version)"
echo "Maven: $(mvn -v | head -n1)"
echo "Java:  $(java -version 2>&1 | head -n1)"

# Optional: import a pre-warmed ~/.m2 cache tarball
if [[ -n "$M2_IMPORT" ]]; then
  echo "== Importing local Maven cache from: $M2_IMPORT =="
  mkdir -p ~/.m2
  tar -xzf "$M2_IMPORT" -C ~/.m2
fi

echo "== Detailed Repo Connectivity Check =="

check_repo() {
  local name="$1"
  local url="$2"
  local host
  host=$(echo "$url" | sed -e 's_https://\([^/]*\)/.*_\1_')
  local ok=1

  echo "--- Checking: $name ($url) ---"
  echo -n "  Resolving $host... "
  if getent hosts "$host" >/dev/null 2>&1 || nslookup "$host" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "FAILED"
    ok=0
  fi

  if [[ $ok -eq 1 ]]; then
    echo -n "  Connecting to $host... "
    if curl -sSf --head "$url" > /dev/null; then
      echo "OK"
    else
      echo "FAILED"
      ok=0
    fi
  fi

  if [[ $ok -eq 0 ]]; then
    echo "  $name is UNREACHABLE."
    return 1
  else
    echo "  $name is REACHABLE."
    return 0
  fi
}

CENTRAL_OK=0
RUNELITE_OK=0
OPENOSRS_OK=0

check_repo "Maven Central" "https://repo.maven.apache.org/maven2/" && CENTRAL_OK=1
check_repo "RuneLite repo" "https://repo.runelite.net/" && RUNELITE_OK=1
check_repo "OpenOSRS repo" "https://maven.openosrs.dev/" && OPENOSRS_OK=1

echo "----------------------------------------"

# Optional: write a settings.xml with a mirror or extra repo if you need to pin/override
# Create one only if $WRITE_SETTINGS=1
if [[ "${WRITE_SETTINGS:-0}" == "1" ]]; then
  echo "== Writing ~/.m2/settings.xml with RuneLite repo =="
  cat > ~/.m2/settings.xml <<'XML'
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <profiles>
    <profile>
      <id>with-runelite-repo</id>
      <repositories>
        <repository>
          <id>central</id>
          <name>Maven Central</name>
          <url>https://repo.maven.apache.org/maven2</url>
        </repository>
        <repository>
          <id>runelite</id>
          <name>RuneLite</name>
          <url>https://repo.runelite.net</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <id>central</id>
          <url>https://repo.maven.apache.org/maven2</url>
        </pluginRepository>
        <pluginRepository>
          <id>runelite</id>
          <url>https://repo.runelite.net</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </pluginRepository>
      </pluginRepositories>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>with-runelite-repo</activeProfile>
  </activeProfiles>
</settings>
XML
fi

# Hygiene: catch the common package-typo
if [ -d "$REPO_ROOT/runelite-api/src/main/java/net/runlite/api" ]; then
  echo "WARNING: Found typo package path: net/runlite/api" | tee -a "$SUMMARY"
  find "$REPO_ROOT/runelite-api/src/main/java/net/runlite/api" | tee -a "$SUMMARY"
fi

echo "== Maven dependency warm-up =="
# Try full go-offline for selected modules. This resolves both deps and plugins without building.
# Use offline (-o) only if both repos are unreachable.
MVN_NET_FLAGS=""
if [[ $CENTRAL_OK -eq 0 && $RUNELITE_OK -eq 0 && $OPENOSRS_OK -eq 0 ]]; then
  MVN_NET_FLAGS="-o"
  echo "All repos unreachable. Using offline mode with whatever is in ~/.m2"
fi

set +e
# Effective POM helps resolve plugin versions; ignore failures in offline mode
mvn $MVN_NET_FLAGS $MVN_FLAGS_COMMON help:effective-pom -Doutput=/dev/null >/dev/null 2>&1

# Pull transitive deps & plugins for the specified modules
mvn $MVN_NET_FLAGS $MVN_FLAGS_COMMON -pl "$MODULES" -am dependency:go-offline \
  > "$LOG_DIR/deps-go-offline.log" 2>&1
DEP_EXIT=$?
set -e

if [[ $DEP_EXIT -ne 0 ]]; then
  echo "Dependency warm-up had issues. See $LOG_DIR/deps-go-offline.log"
  # Summarise likely culprits
  grep -E "Could not transfer artifact|Non-resolvable|Unresolvable|Failed to collect dependencies|Plugin .* not found" \
    "$LOG_DIR/deps-go-offline.log" | sort -u | tee "$SUMMARY" || true
  exit $DEP_EXIT
fi

echo "== Done =="
echo "Dependencies/plugins should now be cached in ~/.m2."
echo "No jars were built. Logs in: $LOG_DIR"
