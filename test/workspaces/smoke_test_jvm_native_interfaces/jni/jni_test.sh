#!/bin/sh -

set -e

export JAVA_LIBRARY_PATH="$1"
export EXECUTABLE_JAR="$2"

java "-Djava.library.path=${JAVA_LIBRARY_PATH}" -jar "${EXECUTABLE_JAR}" | tee stdout.log

# NOTE(dwtj): This `grep` command makes sure that the string "JNI" appears
#  somewhere in the above command's standard output. If it doesn't, then `grep`
#  returns a non-zero exit code, and because `set -e` was set above, this will
#  fail this Bazel test.
grep JNI stdout.log
