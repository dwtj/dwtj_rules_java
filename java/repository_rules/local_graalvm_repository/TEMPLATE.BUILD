# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines the Java toolchains provided by this repository, "@{REPOSITORY_NAME}".
'''

load("@dwtj_rules_java//java:toolchains.bzl", "graalvm_native_image_toolchain")

graalvm_native_image_toolchain(
    name = "_graalvm_native_image_toolchain",
    native_image_exec = ":native-image",
)

toolchain(
    name = "graalvm_native_image_toolchain",
    toolchain = ":_graalvm_native_image_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/graalvm_native_image_toolchain:toolchain_type",
    visibility = ["//visibility:public"],
)
