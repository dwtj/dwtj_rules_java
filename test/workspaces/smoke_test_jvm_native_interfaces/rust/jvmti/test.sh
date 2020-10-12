#!/bin/sh -

set -e

export AGENT_PATH="$1"
export EXECUTABLE_JAR="$2"

AGENT_PATH="${PWD}/${AGENT_PATH}"

java "-agentpath:${AGENT_PATH}" -jar "${EXECUTABLE_JAR}" | tee stdout.log

# NOTE(dwtj): These `grep` commands make sure that these strings appears
#  somewhere in the above command's standard output. If one of them doesn't,
#  then `grep` will a non-zero exit code, and because `set -e` was set above,
#  this will fail this Bazel test.
grep 'Hello, from `Agent_OnLoad()`, implemented in Rust.' stdout.log
grep 'Hello, from `rust.jvmti.MyApp`, written in Java.' stdout.log
