#!/bin/sh -
#
# This script was generated from a template with the following substitutions:
# 
# - JAVADOC_EXECUTABLE: {JAVADOC_EXECUTABLE}
# - CLASS_PATH_ARGS_FILE: {CLASS_PATH_ARGS_FILE}
# - JAVA_SOURCE_ARGS_FILE: {JAVA_SOURCE_ARGS_FILE}
# - HTML_TEMP_DIRECTORY: {HTML_TEMP_DIRECTORY}
# - HTML_ARCHIVE_FILE (expected to be a `.tar.gz` file): {HTML_ARCHIVE_FILE}
# - JAVADOC_LINT_LOG_FILE: {JAVADOC_LINT_LOG_FILE}

set -e

mkdir -p "{HTML_TEMP_DIRECTORY}/javadoc"

{
    "{JAVADOC_EXECUTABLE}" \
        "@{CLASS_PATH_ARGS_FILE}" \
        -Xdoclint:all \
        -private \
        -d "{HTML_TEMP_DIRECTORY}/javadoc" \
        "@{JAVA_SOURCE_ARGS_FILE}"

    # TODO(dwtj): Consider making the TAR file creation process more robust
    #  (e.g. consider how the `tar` executable ought to be found).
    tar --create \
        --gzip \
        --file "{HTML_ARCHIVE_FILE}" \
        --directory="{HTML_TEMP_DIRECTORY}" \
        "javadoc"
} > "{JAVADOC_LINT_LOG_FILE}" 2>&1
