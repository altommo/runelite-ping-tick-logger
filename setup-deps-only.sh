#!/usr/bin/env bash
# seed-m2-all.sh
# Pure cURL seeding of ~/.m2 for your hybrid RuneLite repo.
# No Maven goals, no builds. Populates POMs/JARs + _remote.repositories hints.

set -euo pipefail
export LC_ALL=C
export MAVEN_OPTS="${MAVEN_OPTS:-} -Djava.net.preferIPv4Stack=true -Dsun.net.inetaddr.ttl=60"

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
M2="$HOME/.m2/repository"
mkdir -p "$M2"

CENTRAL="https://repo.maven.apache.org/maven2"
MIRROR="https://repo1.maven.org/maven2"

# --- helpers ---------------------------------------------------------------

path_for() { # groupId:artifactId:version -> path
  local g="$1" a="$2" v="$3"
  echo "$M2/${g//.//}/$a/$v"
}

fname() { # artifactId version ext [classifier]
  local a="$1" v="$2" ext="$3" c="${4:-}"
  if [[ -n "$c" ]]; then echo "$a-$v-$c.$ext"; else echo "$a-$v.$ext"; fi
}

curl_one() { # url dest
  local url="$1" dest="$2"
  if curl -fsSL "$url" -o "$dest"; then return 0; fi
  return 1
}

fetch_artifact() { # groupId:artifactId:version:packaging[:classifier]
  local GAV="$1"
  local g a v p c
  IFS=: read -r g a v p c <<<"$GAV"

  local base_path; base_path="$(path_for "$g" "$a" "$v")"
  mkdir -p "$base_path"

  # determine filenames/urls
  local mainfile url1 url2
  if [[ "$p" == "pom" ]]; then
    mainfile="$(fname "$a" "$v" "pom" "${c:-}")"
    url1="$CENTRAL/${g//.//}/$a/$v/$mainfile"
    url2="$MIRROR/${g//.//}/$a/$v/$mainfile"
  else
    mainfile="$(fname "$a" "$v" "$p" "${c:-}")"
    url1="$CENTRAL/${g//.//}/$a/$v/$mainfile"
    url2="$MIRROR/${g//.//}/$a/$v/$mainfile"
  fi

  local target="$base_path/$mainfile"
  if [[ -f "$target" ]]; then
    echo "[cache] $GAV already present"
  else
    if curl_one "$url1" "$target" || curl_one "$url2" "$target"; then
      echo "[ok] $GAV -> $target"
    else
      echo "[ERR] failed to fetch $GAV ($url1 | $url2)" >&2
      return 1
    fi
  fi

  # For JARs, also fetch matching POM if it exists (helps Maven resolution)
  if [[ "$p" != "pom" ]]; then
    local pomfile="$(fname "$a" "$v" "pom")"
    local pomurl1="$CENTRAL/${g//.//}/$a/$v/$pomfile"
    local pomurl2="$MIRROR/${g//.//}/$a/$v/$pomfile"
    if [[ ! -f "$base_path/$pomfile" ]]; then
      curl_one "$pomurl1" "$base_path/$pomfile" || curl_one "$pomurl2" "$base_path/$pomfile" || true
    fi
  fi

  # write _remote.repositories so Maven treats it as resolved
  {
    echo "$mainfile>central="
    # if we got the pom too, mark it
    if [[ -f "$base_path/$(fname "$a" "$v" "pom")" ]]; then
      echo "$(fname "$a" "$v" "pom")>central="
    fi
  } > "$base_path/_remote.repositories"
}

seed_all() {
  local -a ART=()

  # --- Dependencies from <dependencyManagement> (POM) ---------------------
  # (versions/coords from your parent POM) :contentReference[oaicite:5]{index=5}
  ART+=(
    "com.google.inject:guice-bom:4.1.0:pom"
    "com.google.guava:guava:23.2-jre:jar"
    "com.google.code.gson:gson:2.8.5:jar"
    "com.google.code.findbugs:jsr305:3.0.2:jar"
    "ch.qos.logback:logback-classic:1.2.9:jar"
    "ch.qos.logback:logback-core:1.2.9:jar"
    "org.slf4j:slf4j-api:1.7.25:jar"
    "org.slf4j:slf4j-simple:1.7.25:jar"
  )

  # --- Plugin dependencies referenced by plugin config --------------------
  # checkstyle & PMD versions from your POM/plugin sections :contentReference[oaicite:6]{index=6} :contentReference[oaicite:7]{index=7}
  ART+=(
    "com.puppycrawl.tools:checkstyle:8.3:jar"
    "net.sourceforge.pmd:pmd-core:7.2.0:jar"
    "net.sourceforge.pmd:pmd-java:7.2.0:jar"
  )

  # --- Maven core plugin artifacts (POM + JAR) used by your build --------
  # Even though we are NOT building, pre-seeding helps later CI.
  # Versions from <build>/<plugins> and <pluginManagement>. :contentReference[oaicite:8]{index=8} :contentReference[oaicite:9]{index=9}
  local -a PLUGINS=(
    "org.apache.maven.plugins:maven-compiler-plugin:3.6.1"
    "org.apache.maven.plugins:maven-surefire-plugin:2.22.2"
    "org.apache.maven.plugins:maven-release-plugin:2.5.3"
    "org.projectlombok:lombok-maven-plugin:1.18.20.0"
    "org.apache.maven.plugins:maven-javadoc-plugin:3.5.0"
    "org.apache.maven.plugins:maven-assembly-plugin:3.2.0"
    "org.apache.maven.plugins:maven-jar-plugin:3.2.0"
    "org.apache.maven.plugins:maven-deploy-plugin:2.8.2"
    "org.apache.maven.plugins:maven-plugin-plugin:3.6.0"
    "org.apache.maven.plugins:maven-pmd-plugin:3.22.0"
  )

  # Seed deps
  for gav in "${ART[@]}"; do
    fetch_artifact "$gav"
  done

  # Seed plugins (POM + JAR for each)
  for plug in "${PLUGINS[@]}"; do
    IFS=: read -r pg pa pv <<<"$plug"
    # POM
    fetch_artifact "$pg:$pa:$pv:pom" || true
    # JAR
    fetch_artifact "$pg:$pa:$pv:jar" || true
  done
}

# --- settings.xml (so later Maven runs know about RuneLite/OpenOSRS) ------
mkdir -p "$HOME/.m2"
cat > "$HOME/.m2/settings.xml" <<'XML'
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

# --- run -------------------------------------------------------------------
echo "== Seeding ~/.m2 from Central (fallback to repo1) =="
seed_all
echo "== Done. Seeded local cache at: $M2 =="
echo "No jars were built. You can now run Maven in offline mode (-o) if needed."
