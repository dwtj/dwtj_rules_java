#!/bin/sh -
#
# This script expects to be run from the root of the `dwtj_rules_java`
# workspace.

set -e

ROOT_WORKSPACE="$PWD"

# All targets should pass except for `:MyBadLibrary`.
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_basic_java_rules"
echo $WORKSPACE
cd "$WORKSPACE"
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

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_remote_openjdk_repository"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

# All of these commands should pass:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_use_legacy_java_rules"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...
bazel run //:MyBinary

# All of these commands should pass:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_java_agent_rule"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

# `:WellFormatted` should pass, but `:BadlyFormatted` should fail:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_google_java_format_aspect"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //:WellFormatted
if bazel build //:BadlyFormatted > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_google_java_format//:BadlyFormatted` passed, but it should have failed.'
    exit 1
fi

# All of these commands should pass:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_use_rules_jvm_external"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

# `:GoodJavadoc` should pass, but `:BadJavadoc` should fail:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_javadoc_aspect"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //:GoodJavadoc
if bazel build //:BadJavadoc > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_javadoc_aspect//:BadJavadoc` passed, but it should have failed.'
    exit 1
fi

# `:GoodJava` and ``:WarningJava` should pass, but `:ErrorJava` should fail:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_error_prone_aspect"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //:GoodJava
bazel build //:WarningJava
if bazel build //:ErrorJava > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_error_prone_aspect//:ErrorJava` passed, but it should have failed.'
    exit 1
fi

# `:GoodJava` and ``:WarningJava` should pass, but `:ErrorJava` should fail:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_checkstyle_aspect"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //:GoodJava
bazel build //:WarningJava
if bazel build //:ErrorJava > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_checkstyle_aspect//:ErrorJava` passed, but it should have failed.'
    exit 1
fi

# All of these should pass:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_executable_arguments"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel run //:binary_should_fail_unless_run_with_args -- Hello World
bazel run //:binary_should_pass
bazel test //:test_should_fail_unless_run_with_test_args --test_arg Hello --test_arg World
bazel test //:test_should_pass

# This should pass:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_predeclared_outputs"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

# All of these should pass:
WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_java_rule_attributes"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel run //attrs/data:read_each_line
bazel run //attrs/jvm_args:check_system_property
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_jvm_native_interfaces"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_toolchain_overrides"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
# TODO(dwtj): Consider adding some actual tests to this workspace.
#bazel test //...

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_transitive_dependencies"
echo $WORKSPACE
cd "$WORKSPACE"
bazel test //st/simple:A
if bazel build //st/simple:ThisShouldFailToCompile > /dev/null 2> /dev/null ; then
    echo 'ERROR: `bazel build @smoke_test_transitive_dependencies//st/simple:ThisShouldFailToCompile` passed, but it should have failed.'
    exit 1
fi

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_known_openjdk_repository_macro"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_java_resources"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/smoke_test_annotation_processors"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/graalvm/smoke_test_graalvm_native_image_binary_rule"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/graalvm/smoke_test_remote_graalvm_repository"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

WORKSPACE="$ROOT_WORKSPACE/test/workspaces/graalvm/smoke_test_graalvm_native_image_resources"
echo $WORKSPACE
cd "$WORKSPACE"
bazel build //...
bazel test //...

echo
echo "SUCCESS: All test workspace checks passed."
echo
