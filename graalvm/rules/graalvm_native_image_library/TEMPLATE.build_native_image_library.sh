#!/bin/sh -
# This script was instantiated from a template with the following substitutions:
#
# - TARGET_NAME: {TARGET_NAME}
# - TARGET_PACKAGE_PATH: {TARGET_NAME}
# - IMAGE_NAME: {IMAGE_NAME}
# - MAIN_CLASS: {MAIN_CLASS}
# - NATIVE_IMAGE_EXECUTABLE: {NATIVE_IMAGE_EXECUTABLE}
# - CLASS_PATH: {CLASS_PATH}
# - LIBRARY_OUTPUT: {LIBRARY_OUTPUT}
# - SHARED_LIBRARY_FILE_EXTENSION: {SHARED_LIBRARY_FILE_EXTENSION}
# - HEADER_OUTPUT: {HEADER_OUTPUT}
# - DYNAMIC_HEADER_OUTPUT: {DYNAMIC_HEADER_OUTPUT}
# - GRAAL_ISOLATE_HEADER_OUTPUT: {GRAAL_ISOLATE_HEADER_OUTPUT}
# - GRAAL_ISOLATE_DYNAMIC_HEADER_OUTPUT: {GRAAL_ISOLATE_DYNAMIC_HEADER_OUTPUT}

set -e

if [ -z "{TARGET_PACKAGE_PATH}" ]
then TEMP_OUTPUT_DIR="{TARGET_NAME}.native_image.temp"
else TEMP_OUTPUT_DIR='{TARGET_PACKAGE_PATH}/{TARGET_NAME}.native_image.temp'
fi

mkdir -p "$TEMP_OUTPUT_DIR"

# This invocation of `native-image` should create five files: two graal isolate
#  headers, two image headers, and the native library itself. Below, we move
#  each of these five files to its respective output path.
if [ -z "{MAIN_CLASS}" ]
then
    # No main class given. Use methods annotated with `@CEntryPoint` as entry
    # points.
    "./{NATIVE_IMAGE_EXECUTABLE}" \
        --shared \
        --class-path "{CLASS_PATH}" \
        "-H:Name={IMAGE_NAME}" \
        "-H:Path=${TEMP_OUTPUT_DIR}" \
        "$@"
else
    # A main class is given. Use that class's main method as the entry point.
    "./{NATIVE_IMAGE_EXECUTABLE}" \
        --shared \
        --class-path "{CLASS_PATH}" \
        "-H:Name={IMAGE_NAME}" \
        "-H:Class={MAIN_CLASS}" \
        "-H:Path=${TEMP_OUTPUT_DIR}" \
        "$@"
fi

LIBRARY="${TEMP_OUTPUT_DIR}/{IMAGE_NAME}.{SHARED_LIBRARY_FILE_EXTENSION}"
mv "$LIBRARY" "{LIBRARY_OUTPUT}"

HEADER="${TEMP_OUTPUT_DIR}/{IMAGE_NAME}.h"
mv "$HEADER" "{HEADER_OUTPUT}"

DYNAMIC_HEADER="${TEMP_OUTPUT_DIR}/{IMAGE_NAME}_dynamic.h"
mv "$DYNAMIC_HEADER" "{DYNAMIC_HEADER_OUTPUT}"

GRAAL_ISOLATE_HEADER="${TEMP_OUTPUT_DIR}/graal_isolate.h"
mv "$GRAAL_ISOLATE_HEADER" "{GRAAL_ISOLATE_HEADER_OUTPUT}"

GRAAL_ISOLATE_DYNAMIC_HEADER="${TEMP_OUTPUT_DIR}/graal_isolate_dynamic.h"
mv "$GRAAL_ISOLATE_DYNAMIC_HEADER" "{GRAAL_ISOLATE_DYNAMIC_HEADER_OUTPUT}"
