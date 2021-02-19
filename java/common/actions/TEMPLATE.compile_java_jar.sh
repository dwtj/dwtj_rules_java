#!/bin/sh -
#
# This script was generated from a template with the following substitutions:
#
# - JAVAC_EXECUTABLE: {JAVAC_EXECUTABLE}
# - JAVAC_BUILD_DIR: {JAVAC_BUILD_DIR}
# - RESOURCES_DIR: {RESOURCES_DIR}
# - CLASS_PATH_ARGS_FILE: {CLASS_PATH_ARGS_FILE}
# - JAVA_SRCS_ARGS_FILE: {JAVA_SRCS_ARGS_FILE}
# - JAR_EXECUTABLE: {JAR_EXECUTABLE}
# - JAR_MANIFEST_FILE: {JAR_MANIFEST_FILE}
# - OUTPUT_JAR: {OUTPUT_JAR}

set -e

mkdir -p "{JAVAC_BUILD_DIR}"
mkdir -p "{RESOURCES_DIR}"

# Compile the sources using the given class-path and put the resulting class
# files into the JAR build root.
"{JAVAC_EXECUTABLE}" -d "{JAVAC_BUILD_DIR}" "@{CLASS_PATH_ARGS_FILE}" "@{JAVA_SRCS_ARGS_FILE}"

# Create a JAR file which includes all of the files inside the JAR build root.
"{JAR_EXECUTABLE}" --create "--file={OUTPUT_JAR}" "--manifest={JAR_MANIFEST_FILE}" -C "{JAVAC_BUILD_DIR}" .

# Add all Java resources files to the OUTPUT_JAR.
"{JAR_EXECUTABLE}" --update "--file={OUTPUT_JAR}" -C "{RESOURCES_DIR}" .
