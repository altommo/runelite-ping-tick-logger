#!/usr/bin/env bash
# setup-deps-only.sh (hardened, no build)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$REPO_ROOT/build_logs"; mkdir -p "$LOG_DIR"
SUMMARY="$LOG_DIR/deps-summary.txt"
MODULES="${MODULES:-runelite-api,runelite-client}"
MVN_FLAGS="-q -DskipTests -Dmaven.wagon.http.retryHandler.count=5 -Dmaven.wagon.http.connectionManager.ttl=60 -Dmaven.wagon.http.pool=false"
export MAVEN_OPTS="${MAVEN_OPTS:-} -Djava.net.preferIPv4Stack=true -Dsun.net.inetaddr.ttl=60"

echo "== Toolchain =="; git --version; mvn -v | head -n1; java -version 2>&1 | head -n1

echo "== Writing ~/.m2/settings.xml with Central+mirror+RuneLite+OpenOSRS =="
mkdir -p ~/.m2
cat > ~/.m2/settings.xml <<'XML'
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>central-repo1</id>
      <name>Maven Central Mirror (repo1)</name>
      <url>https://repo1.maven.org/maven2</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
  <profiles>
    <profile>
      <id>extra-repos</id>
      <repositories>
        <repository>
          <id>central</id>
          <url>https://repo.maven.apache.org/maven2</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>false</enabled></snapshots>
        </repository>
        <repository>
          <id>central-repo1</id>
          <url>https://repo1.maven.org/maven2</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>false</enabled></snapshots>
        </repository>
        <repository>
          <id>runelite</id>
          <url>https://repo.runelite.net</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </repository>
        <repository>
          <id>openosrs</id>
          <url>https://maven.openosrs.dev</url>
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
          <id>central-repo1</id>
          <url>https://repo1.maven.org/maven2</url>
        </pluginRepository>
        <pluginRepository>
          <id>runelite</id>
          <url>https://repo.runelite.net</url>
        </pluginRepository>
        <pluginRepository>
          <id>openosrs</id>
          <url>https://maven.openosrs.dev</url>
        </pluginRepository>
      </pluginRepositories>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>extra-repos</activeProfile>
  </activeProfiles>
</settings>
XML

echo "== Connectivity smoke (curl GET) =="
for u in \
  https://repo.maven.apache.org/maven2/ \
  https://repo1.maven.org/maven2/ \
  https://repo.runelite.net/ \
  https://maven.openosrs.dev/ ; do
  echo -n "$u -> "; curl -sSL -o /dev/null -w "%{http_code}\n" "$u" || true
done

echo "== Maven smoke (small artifacts) =="
# 1) Mirror Central path (what was failing: guice-bom)
if ! mvn -s ~/.m2/settings.xml $MVN_FLAGS dependency:get -Dartifact=com.google.inject:guice-bom:pom:4.1.0 >"$LOG_DIR/smoke-central.log" 2>&1; then
  echo "[central] failed to fetch guice-bom. See $LOG_DIR/smoke-central.log"
  grep -E "Could not transfer|timed out|refused|unreachable|SSL|handshake" "$LOG_DIR/smoke-central.log" || true
  exit 2
fi
# 2) Quick plugin fetch (forces plugin repos to be used)
mvn -s ~/.m2/settings.xml $MVN_FLAGS help:effective-pom -Doutput=/dev/null >"$LOG_DIR/smoke-help.log" 2>&1 || true

echo "== dependency:go-offline (no build) =="
if ! mvn -s ~/.m2/settings.xml $MVN_FLAGS -pl "$MODULES" -am dependency:go-offline >"$LOG_DIR/deps-go-offline.log" 2>&1; then
  echo "Go-offline failed. See $LOG_DIR/deps-go-offline.log"
  grep -E "Could not transfer artifact|Non-resolvable|Plugin .* not found|Failure to find|timed out|refused" "$LOG_DIR/deps-go-offline.log" | sort -u | tee "$SUMMARY" || true
  exit 3
fi

echo "== Done =="
echo "Dependencies/plugins cached in ~/.m2. No jars built."
echo "Logs in $LOG_DIR"
