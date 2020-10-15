# This file was generated from a template with the following substitutions:
#
# - REPOSITORY_NAME: {REPOSITORY_NAME}
# - EXEC_COMPATIBLE_WITH: {EXEC_COMPATIBLE_WITH}

'''Defines the Java toolchains provided by this repository, "@{REPOSITORY_NAME}".
'''

load(
    "@dwtj_rules_java//java:toolchains.bzl",
    "dwtj_java_compiler_toolchain",
    "dwtj_java_runtime_toolchain",
    "javadoc_toolchain",
)

package(
    default_visibility = ["//visibility:public"],
)

# TODO(dwtj): Consider exporting a much more narrow the set of files.
exports_files(
    glob(["**/*"]),
)

dwtj_java_compiler_toolchain(
    name = "_java_compiler_toolchain",
    javac_executable = ":bin/javac",
    jar_executable = ":bin/jar",
)

toolchain(
    name = "java_compiler_toolchain",
    toolchain = ":_java_compiler_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/java_compiler_toolchain:toolchain_type",
    exec_compatible_with = {EXEC_COMPATIBLE_WITH},
)

dwtj_java_runtime_toolchain(
    name = "_java_runtime_toolchain",
    java_executable = ":bin/java",
)

toolchain(
    name = "java_runtime_toolchain",
    toolchain = ":_java_runtime_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type",
    exec_compatible_with = {EXEC_COMPATIBLE_WITH},
)

javadoc_toolchain(
    name = "_javadoc_toolchain",
    javadoc_executable = ":bin/javadoc"
)

toolchain(
    name = "javadoc_toolchain",
    toolchain = ":_javadoc_toolchain",
    toolchain_type = "@dwtj_rules_java//java/toolchains/javadoc_toolchain:toolchain_type",
    exec_compatible_with = {EXEC_COMPATIBLE_WITH},
)
