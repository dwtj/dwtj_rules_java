#!/bin/sh -

set -e

HELLO_EXEC="$1"

./"$HELLO_EXEC" | tee hello.log

# NOTE(dwtj): Because `set -e` is set, this will fail the test if `grep` does
#  not find this string in this log file.
grep 'Hello, world!' hello.log
