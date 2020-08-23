#!/bin/sh -
#
# This script was generated from a template with the following substitutions:
#
# - JAVA_EXECUTABLE: {JAVA_EXECUTABLE}
# - CHECKSTYLE_CLASS_PATH_ARGS_FILE: {CHECKSTYLE_CLASS_PATH_ARGS_FILE}
# - JAVA_SOURCES_ARGS_FILE: {JAVA_SOURCES_ARGS_FILE}
# - CHECKSTYLE_CONFIG_FILE: {CHECKSTYLE_CONFIG_FILE}
# - CHECKSTYLE_LOG_FILE: {CHECKSTYLE_LOG_FILE}

# Interpret each line of `JAVA_SOURCES_ARGS_FILE` as a path to a `.java` file.
# For each of these sources.
# - Use `java` to run Checkstyle to check this source file.

set -e

while read src; do
    echo "Using Checkstyle to check Java source file: ${src}"
    "{JAVA_EXECUTABLE}" \
        --class-path "@{CHECKSTYLE_CLASS_PATH_ARGS_FILE}" \
        com.puppycrawl.tools.checkstyle.Main \
        -c "google_checks.xml" \
        "$src"
done < "{JAVA_SOURCES_ARGS_FILE}"

touch "{CHECKSTYLE_LOG_FILE}"
