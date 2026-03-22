#!/usr/bin/env bash
set -euo pipefail

# Regenerates missing Gradle wrapper binary artifacts (gradle-wrapper.jar)
# for environments where committing binaries is blocked.

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_GRADLE="$PROJECT_ROOT/.tools/gradle-8.14.3/bin/gradle"

if command -v gradle >/dev/null 2>&1; then
  GRADLE_CMD="gradle"
elif [[ -x "$LOCAL_GRADLE" ]]; then
  GRADLE_CMD="$LOCAL_GRADLE"
else
  echo "Gradle not found. Installing project-local Gradle..."
  "$PROJECT_ROOT/scripts/install-gradle.sh" 8.14.3
  GRADLE_CMD="$LOCAL_GRADLE"
fi

if [[ -z "${JAVA_HOME:-}" ]]; then
  echo "Warning: JAVA_HOME is not set. Gradle may fail if Java is misconfigured." >&2
fi

"$GRADLE_CMD" wrapper --no-validate-url

echo "Gradle wrapper generated. You should now have:"
echo "  - gradle/wrapper/gradle-wrapper.jar"
