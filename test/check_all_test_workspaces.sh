#!/bin/sh -
# 
# This script expects to be run from the root of the `dwtj_rules_java`
# workspace.

set -e

ROOT_WORKSPACE="$PWD"

# All of these commands should pass:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_basic_java_rules"
bazel clean
bazel build //...
bazel test //...
bazel run //:MyBinary

# `:WellFormatted` should pass, but `:BadlyFormatted` should fail:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_google_java_format_aspect"
bazel clean
bazel build //:WellFormatted
if bazel build //:BadlyFormatted > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_google_java_format//:BadlyFormatted` passed, but it should have failed.'
    exit 1
fi

echo "SUCCESS: All test workspace checks passed."
