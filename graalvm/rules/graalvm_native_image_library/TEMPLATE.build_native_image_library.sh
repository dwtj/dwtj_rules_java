#!/bin/sh -
# This script was instantiated from a template with the following substitutions:
#
# - NATIVE_IMAGE_EXECUTABLE: {NATIVE_IMAGE_EXECUTABLE}
# - CLASS_PATH: {CLASS_PATH}
# - MAIN_CLASS: {MAIN_CLASS}
# - IMAGE_PATH: {IMAGE_PATH}
# - SHARED_LIBRARY_OUTPUT: {SHARED_LIBRARY_OUTPUT}
# - SHARED_LIBRARY_FILE_EXTENSION: {SHARED_LIBRARY_FILE_EXTENSION}
# - HEADER_OUTPUT: {HEADER_OUTPUT}
# - DYNAMIC_HEADER_OUTPUT: {DYNAMIC_HEADER_OUTPUT}
# - GRAAL_ISOLATE_HEADER_OUTPUT: {GRAAL_ISOLATE_HEADER_OUTPUT}
# - GRAAL_ISOLATE_DYNAMIC_HEADER_OUTPUT: {GRAAL_ISOLATE_DYNAMIC_HEADER_OUTPUT}

set -e

mkdir -p `dirname {IMAGE_PATH}`

# This invocation of `native-image` should create five files: two graal isolate
#  headers, two image headers, and the shared library itself. Below, we move
#  each of these files to its respective output path.
"./{NATIVE_IMAGE_EXECUTABLE}" \
    --shared \
    --class-path "{CLASS_PATH}" \
    "$@" \
    "{MAIN_CLASS}" \
    "{IMAGE_PATH}"

SHARED_LIBRARY="{IMAGE_PATH}.{SHARED_LIBRARY_FILE_EXTENSION}"
mv "$SHARED_LIBRARY" "{SHARED_LIBRARY_OUTPUT}"

HEADER="{IMAGE_PATH}.h"
mv "$HEADER" "{HEADER_OUTPUT}"

DYNAMIC_HEADER="{IMAGE_PATH}_dynamic.h"
mv "$DYNAMIC_HEADER" "{DYNAMIC_HEADER_OUTPUT}"

GRAAL_ISOLATE_HEADER="graal_isolate.h"
mv "$GRAAL_ISOLATE_HEADER" "{GRAAL_ISOLATE_HEADER_OUTPUT}"

GRAAL_ISOLATE_DYNAMIC_HEADER="graal_isolate_dynamic.h"
mv "$GRAAL_ISOLATE_DYNAMIC_HEADER" "{GRAAL_ISOLATE_DYNAMIC_HEADER_OUTPUT}"
