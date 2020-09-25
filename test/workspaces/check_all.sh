#!/bin/sh -
#
# This script expects to be run from the root of the `dwtj_rules_java`
# workspace.

set -e

ROOT_WORKSPACE="$PWD"

# All targets should pass except for `:MyBadLibrary`.
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_basic_java_rules"
bazel clean
bazel build //:MyBinary
bazel run //:MyBinary
bazel build //:MyLibrary
bazel build //:MyJar
bazel build //:MyImport
bazel build //:MyTest
bazel test //:MyTest
if bazel build //:MyBadLibrary > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_basic_java_rules//:MyBadLibrary` passed, but it should have failed.'
    exit 1
fi

# All of these commands should pass:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_use_legacy_java_rules"
bazel clean
bazel build //...
bazel test //...
bazel run //:MyBinary

# All of these commands should pass:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_java_agent_rule"
bazel clean
bazel build //...
bazel test //...

# `:WellFormatted` should pass, but `:BadlyFormatted` should fail:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_google_java_format_aspect"
bazel clean
bazel build //:WellFormatted
if bazel build //:BadlyFormatted > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_google_java_format//:BadlyFormatted` passed, but it should have failed.'
    exit 1
fi

# All of these commands should pass:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_use_rules_jvm_external"
bazel clean
bazel build //...
bazel test //...

# `:GoodJavadoc` should pass, but `:BadJavadoc` should fail:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_javadoc_aspect"
bazel clean
bazel build //:GoodJavadoc
if bazel build //:BadJavadoc > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_javadoc_aspect//:BadJavadoc` passed, but it should have failed.'
    exit 1
fi

# `:GoodJava` and ``:WarningJava` should pass, but `:ErrorJava` should fail:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_error_prone_aspect"
bazel clean
bazel build //:GoodJava
bazel build //:WarningJava
if bazel build //:ErrorJava > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_error_prone_aspect//:ErrorJava` passed, but it should have failed.'
    exit 1
fi

# `:GoodJava` and ``:WarningJava` should pass, but `:ErrorJava` should fail:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_checkstyle_aspect"
bazel clean
bazel build //:GoodJava
bazel build //:WarningJava
if bazel build //:ErrorJava > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_checkstyle_aspect//:ErrorJava` passed, but it should have failed.'
    exit 1
fi

# All of these should pass:
cd "$ROOT_WORKSPACE/test/workspaces/smoke_test_executable_arguments"
bazel clean
bazel build //...
bazel run //:binary_should_fail_unless_run_with_args -- Hello World
bazel run //:binary_should_pass
bazel test //:test_should_fail_unless_run_with_test_args --test_arg Hello --test_arg World
bazel test //:test_should_pass

echo
echo "SUCCESS: All test workspace checks passed."
