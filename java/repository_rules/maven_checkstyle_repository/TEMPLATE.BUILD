# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines a Checkstyle toolchain within this repo, "@{REPOSITORY_NAME}".
'''

load("@dwtj_rules_java//java:toolchains.bzl", "checkstyle_toolchain")

checkstyle_toolchain(
    name = "_checkstyle_toolchain",
    checkstyle = "@maven_checkstyle//:com_puppycrawl_tools_checkstyle",
)

toolchain(
    name = "checkstyle_toolchain",
    toolchain = "_checkstyle_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/checkstyle_toolchain:toolchain_type",
    visibility = ["//visibility:public"],
)