#!/bin/sh -
#
# This script was generated from a template with the following substitutions:
# 
# - JAVA_EXECUTABLE: {JAVA_EXECUTABLE}
# - GOOGLE_JAVA_FORMAT_DEPLOY_JAR: {GOOGLE_JAVA_FORMAT_DEPLOY_JAR}
# - JAVA_SOURCES_ARGS_FILE: {JAVA_SOURCES_ARGS_FILE}
# - OUTPUT_FILE: {OUTPUT_FILE}

set -e

"{JAVA_EXECUTABLE}" \
    -jar "{GOOGLE_JAVA_FORMAT_DEPLOY_JAR}" \
    --set-exit-if-changed \
    "@{JAVA_SOURCES_ARGS_FILE}" > "{OUTPUT_FILE}"
