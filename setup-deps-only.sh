#!/usr/bin/env bash
# setup-deps-only.sh (central-only + last-ditch seeding, no build)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$REPO_ROOT/build_logs"; mkdir -p "$LOG_DIR"
SUMMARY="$LOG_DIR/deps-summary.txt"
MODULES="${MODULES:-runelite-api,runelite-client}"
MVN_FLAGS="-q -DskipTests -Dmaven.wagon.http.retryHandler.count=5 -Dmaven.wagon.http.connectionManager.ttl=60 -Dmaven.wagon.http.pool=false"
# prefer IPv4 (some runners have flaky v6 egress for Java)
export MAVEN_OPTS="${MAVEN_OPTS:-} -Djava.net.preferIPv4Stack=true -Dsun.net.inetaddr.ttl=60 -Dhttps.protocols=TLSv1.2,TLSv1.3"

echo "== Toolchain =="; git --version; mvn -v | head -n1; java -version 2>&1 | head -n1

echo "== Writing minimal ~/.m2/settings.xml (Central + RuneLite + OpenOSRS; NO mirror) =="
mkdir -p ~/.m2
cat > ~/.m2/settings.xml <<'XML'
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
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

echo "== Maven smoke via Central only =="
# Force Central explicitly on the command to bypass any mirrors/policies
if ! mvn -s ~/.m2/settings.xml $MVN_FLAGS dependency:get \
    -DremoteRepositories=central::default::https://repo.maven.apache.org/maven2 \
    -Dartifact=com.google.inject:guice-bom:pom:4.1.0 >"$LOG_DIR/smoke-central.log" 2>&1; then
  echo "[central] fetch failed; will seed guice-bom locally. See $LOG_DIR/smoke-central.log"
  echo "== Seeding com.google.inject:guice-bom:4.1.0 into ~/.m2 =="
  mkdir -p /tmp/_seed && cd /tmp/_seed
  curl -fsSL -o guice-bom-4.1.0.pom \
    https://repo.maven.apache.org/maven2/com/google/inject/guice-bom/4.1.0/guice-bom-4.1.0.pom
  mvn -q install:install-file \
    -Dfile=guice-bom-4.1.0.pom \
    -DgroupId=com.google.inject -DartifactId=guice-bom -Dversion=4.1.0 -Dpackaging=pom \
    -DgeneratePom=false
  cd "$REPO_ROOT"
fi

echo "== dependency:go-offline (no build) =="
# Try warmup with only the modules you care about
if ! mvn -s ~/.m2/settings.xml $MVN_FLAGS -pl "$MODULES" -am dependency:go-offline \
    >"$LOG_DIR/deps-go-offline.log" 2>&1; then
  echo "Go-offline failed. See $LOG_DIR/deps-go-offline.log"
  grep -E "Could not transfer|Non-resolvable|Failure to find|Plugin .* not found|timed out|refused|unreachable" \
    "$LOG_DIR/deps-go-offline.log" | sort -u | tee "$SUMMARY" || true
  exit 3
fi

echo "== Done =="
echo "Dependencies/plugins cached in ~/.m2. No jars were built."
echo "Logs in $LOG_DIR"
