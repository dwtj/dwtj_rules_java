#!/bin/sh -

set -e

export JNI_LIBRARY_PATH="$1"
export EXECUTABLE_JAR="$2"

java "-Djava.library.path=`dirname ${JNI_LIBRARY_PATH}`" -jar "${EXECUTABLE_JAR}" | tee stdout.log

# NOTE(dwtj): This `grep` command makes sure that this string appears somewhere
#  in the above command's standard output. If it doesn't, then `grep` returns a
#  non-zero exit code, and because `set -e` was set above, this will fail this
#  Bazel test.
grep 'rust.jni.MyLib#myMethod' stdout.log
