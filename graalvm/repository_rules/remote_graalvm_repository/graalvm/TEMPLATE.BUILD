# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}
# - SHARED_LIBRARY_FILE_EXTENSION: {SHARED_LIBRARY_FILE_EXTENSION}  --  e.g. "so", "dylib", "dll"
# - EXEC_COMPATIBLE_WITH: {EXEC_COMPATIBLE_WITH}  --  e.g. `["@platforms//os:linux", "@platforms//cpu:x86_64"]`

'''Defines the Graal toolchains provided by this repository,
`@{REPOSITORY_NAME}`.
'''

load("@dwtj_rules_java//graalvm:toolchains.bzl", "graalvm_native_image_toolchain")

package(
    default_visibility = ["//visibility:public"],
)

graalvm_native_image_toolchain(
    name = "_graalvm_native_image_toolchain",
    native_image_exec = "//jdk:bin/native-image",
    class_path_separator = ":",
    shared_library_file_extension = "{SHARED_LIBRARY_FILE_EXTENSION}",
)

toolchain(
    name = "graalvm_native_image_toolchain",
    toolchain = ":_graalvm_native_image_toolchain",
    toolchain_type = "@dwtj_rules_java//graalvm/toolchains/graalvm_native_image_toolchain:toolchain_type",
    exec_compatible_with = {EXEC_COMPATIBLE_WITH},
)
