#!/bin/sh -

set -e

ROOT_WORKSPACE="$PWD"

WORKSPACE="$ROOT_WORKSPACE/experimental/test/workspaces/smoke_test_openjdk_source_repositories"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/experimental/test/workspaces/graalvm/smoke_test_graalvm_native_image_library_rule"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/experimental/test/workspaces/graalvm/smoke_test_graalvm_native_image_cc_library_macro"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

echo
echo "SUCCESS: All experimental test workspace checks passed."
echo
