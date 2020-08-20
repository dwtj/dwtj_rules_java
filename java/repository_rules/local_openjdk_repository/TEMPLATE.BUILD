# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}

'''Defines the Java toolchains provided by this repository, "@{REPOSITORY_NAME}".
'''

load(
    "@dwtj_rules_java//java:toolchains.bzl",
    "dwtj_java_compiler_toolchain",
    "dwtj_java_runtime_toolchain",
    "javadoc_toolchain",
)

dwtj_java_compiler_toolchain(
    name = "_java_compiler_toolchain",
    javac_executable = ":javac",
    jar_executable = ":jar",
)

toolchain(
    name = "java_compiler_toolchain",
    toolchain = ":_java_compiler_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
    visibility = ["//visibility:public"],
)

dwtj_java_runtime_toolchain(
    name = "_java_runtime_toolchain",
    java_executable = ":java",
)

toolchain(
    name = "java_runtime_toolchain",
    toolchain = ":_java_runtime_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type",
    visibility = ["//visibility:public"],
)

javadoc_toolchain(
    name = "_javadoc_toolchain",
    javadoc_executable = ":javadoc"
)

toolchain(
    name = "javadoc_toolchain",
    toolchain = ":_javadoc_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/javadoc_toolchain:toolchain_type",
    visibility = ["//visibility:public"],
)
