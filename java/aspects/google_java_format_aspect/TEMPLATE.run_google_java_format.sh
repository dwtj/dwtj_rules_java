#!/bin/sh -
#
# This script was generated from a template with the following substitutions:
# 
# - JAVA_EXECUTABLE: {JAVA_EXECUTABLE}
# - GOOGLE_JAVA_FORMAT_DEPLOY_JAR: {GOOGLE_JAVA_FORMAT_DEPLOY_JAR}
# - JAVA_SOURCES_ARGS_FILE: {JAVA_SOURCES_ARGS_FILE}
# - OUTPUT_FILE: {OUTPUT_FILE}
# - COLORDIFF_EXECUTABLE: {COLORDIFF_EXECUTABLE}

FORMATTED_SUFFIX="fmtd"

# Interpret each line of the `JAVA_SOURCES_ARGS_FILE` as a Java source file.
# For each source:
# - Run `google-java-format` on it.
# - Save the formatted version to a sibling file with a similar name except with
#   a suffix.
# - If any formatting was performed:
#     - Print the diff to `stdout`.
#     - Write the diff to `OUTPUT_FILE`.
#     - Exit with an error (ignoring any not-yet processed Java source files.).
# If there were no formats performed, then make an empty `OUTPUT_FILE` and exit
# without an error.
while read src; do
    fmtd="${src}.${FORMATTED_SUFFIX}"

    "{JAVA_EXECUTABLE}" \
        -jar "{GOOGLE_JAVA_FORMAT_DEPLOY_JAR}" \
        --set-exit-if-changed \
        "$src" > "${fmtd}"
    RETURN_CODE=$?

    if [ $RETURN_CODE -ne 0 ]; then
        echo "ERROR: Formatting error in Java source file: ${src}"
        "{COLORDIFF_EXECUTABLE}" --color=yes "$src" "$fmtd"
        "{COLORDIFF_EXECUTABLE}" --color=no "$src" "$fmtd" > "{OUTPUT_FILE}"
        exit $RETURN_CODE
    fi
done < "{JAVA_SOURCES_ARGS_FILE}"

touch "{OUTPUT_FILE}"
