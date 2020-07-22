# This file was instantiated from a template with the following substitutions:
#
# - GOOGLE_JAVA_FORMAT_DEPLOY_JAR: {GOOGLE_JAVA_FORMAT_DEPLOY_JAR}

load("@dwtj_rules_java//java:defs.bzl", "google_java_format_toolchain")

google_java_format_toolchain(
    name = "google_java_format_toolchain",
    google_java_format_deploy_jar = ":{GOOGLE_JAVA_FORMAT_DEPLOY_JAR}",
)

toolchain(
    name = "toolchain",
    # TODO(dwtj): Figure out how to say that this can be executed on the host.
    toolchain = ":google_java_format_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/google_java_format_toolchain:toolchain_type",
    visibility = ["//visibility:public"],
)