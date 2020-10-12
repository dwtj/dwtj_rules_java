#!/bin/sh -

set -e

EXEC="$1"
CLASS_PATH="$2"
MAIN_CLASS="$3"

"./${EXEC}" "${CLASS_PATH}" "${MAIN_CLASS}" | tee test.log

grep 'Hello, world!' test.log
