#!/usr/bin/env bash
# setup-hybrid-runelite.sh
# Prepares, verifies, and builds hybrid RuneLite API + full project
# Outputs logs to ./build_logs and a summary file

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$REPO_ROOT/build_logs"
LOG_API="$LOG_DIR/api-compile.log"
LOG_FULL="$LOG_DIR/full-build.log"
SUMMARY="$LOG_DIR/summary.txt"

mkdir -p "$LOG_DIR"

echo "== Checking toolchain =="
command -v git >/dev/null || { echo "git not found"; exit 1; }
command -v mvn >/dev/null || { echo "maven not found"; exit 1; }
command -v java >/dev/null || { echo "java not found"; exit 1; }

echo "Git:   $(git --version)"
echo "Maven: $(mvn -v | head -n1)"
echo "Java:  $(java -version 2>&1 | head -n1)"

# Check Java version >= 17
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
JAVA_MAJOR=$(echo "$JAVA_VER" | cut -d. -f1)
if [ "$JAVA_MAJOR" -lt 17 ]; then
  echo "WARNING: Detected Java $JAVA_VER. RuneLite requires Java 17+."
fi

echo "== Cleaning workspace =="
mvn -q clean

# Detect wrong package path
if [ -d "$REPO_ROOT/runelite-api/src/main/java/net/runlite/api" ]; then
  echo "WARNING: Found typo package path: net/runlite/api"
  find "$REPO_ROOT/runelite-api/src/main/java/net/runlite/api"
fi

echo "== Compiling runelite-api module only =="
set +e
mvn -q -pl runelite-api -am -DskipTests compile >"$LOG_API" 2>&1
API_EXIT=$?
set -e

if [ "$API_EXIT" -ne 0 ]; then
  echo "API compile failed. See $LOG_API"
  echo "---- API first errors ----" >"$SUMMARY"
  grep -E "^\[ERROR\]|Compilation failure|cannot find symbol|incompatible types|already defined|constructor .* cannot be applied" "$LOG_API" >>"$SUMMARY" || true
  cat "$SUMMARY"
  exit $API_EXIT
else
  echo "API compile passed."
fi

echo "== Compiling full project =="
set +e
mvn -q -DskipTests install >"$LOG_FULL" 2>&1
FULL_EXIT=$?
set -e

if [ "$FULL_EXIT" -ne 0 ]; then
  echo "Full build failed. See $LOG_FULL"
  echo "---- Full build first errors ----" >"$SUMMARY"
  grep -E "^\[ERROR\]|Compilation failure|cannot find symbol|incompatible types|already defined|constructor .* cannot be applied" "$LOG_FULL" >>"$SUMMARY" || true
  cat "$SUMMARY"
  exit $FULL_EXIT
else
  echo "Full build succeeded."
fi

echo "Logs are in: $LOG_DIR"
