# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines an Error Prone toolchain within this repo, "@{REPOSITORY_NAME}".
'''

load("@dwtj_rules_java//java:toolchains.bzl", "error_prone_toolchain")

error_prone_toolchain(
    name = "_error_prone_toolchain",
    error_prone = "@maven_error_prone//:com_google_errorprone_error_prone_core"
)

toolchain(
    name = "error_prone_toolchain",
    toolchain = "_error_prone_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/error_prone_toolchain:toolchain_type",
    visibility = ["//visibility:public"],
)
