#!/bin/sh -

set -e

AGENT_RELATIVE_PATH="$1"
EXECUTABLE_JAR="$2"

java "-agentpath:${PWD}/${AGENT_RELATIVE_PATH}" -jar "${EXECUTABLE_JAR}" | tee stdout.log

# NOTE(dwtj): This `grep` command makes sure that the string "JVMTI" appears
#  somewhere in the above command's standard output. If it doesn't, then `grep`
#  returns a non-zero exit code, and because `set -e` was set above, this will
#  fail this Bazel test.
grep JVMTI stdout.log
