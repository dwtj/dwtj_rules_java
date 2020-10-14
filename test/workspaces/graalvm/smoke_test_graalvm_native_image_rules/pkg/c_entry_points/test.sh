#!/bin/sh -

set -e

NATIVE_IMAGE_OUTPUT_FILE="$1"

# Here we check that these entry points appear as names in the `native-image`
# output. If either name isn't in the file, then `grep` will return non-zero,
# and thus fail this test script.
nm "${NATIVE_IMAGE_OUTPUT_FILE}" | grep "Java_pkg_c_entry_points_Hello_myEntryPoint"
nm "${NATIVE_IMAGE_OUTPUT_FILE}" | grep "run_main"
