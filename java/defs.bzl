'''This is part of the public API for this project.
'''

load("//java:providers/JavaAgentInfo.bzl", _JavaAgentInfo = "JavaAgentInfo")

load("//java:providers/JavaCompilationInfo.bzl", _JavaCompilationInfo = "JavaCompilationInfo")

load("//java:providers/JavaDependencyInfo.bzl", _JavaDependencyInfo = "JavaDependencyInfo")

load("//java:providers/JavaExecutionInfo.bzl", _JavaExecutionInfo = "JavaExecutionInfo")

load("//java:rules/java_binary.bzl", "java_binary")

load("//java:rules/java_library.bzl", "java_library")

load("//java:rules/java_import.bzl", "java_import")

load("//java:rules/java_test.bzl", "java_test")

load("//java:rules/legacy_java_import.bzl", "legacy_java_import")

load("//java:rules/java_agent.bzl", "java_agent")

load("//java:rules/java_compiler_toolchain.bzl", "java_compiler_toolchain")

load("//java:rules/java_runtime_toolchain.bzl", "java_runtime_toolchain")

load(
    "//java:aspects/google_java_format_aspect/defs.bzl",
    _google_java_format_aspect = "google_java_format_aspect"
)

load(
    "//java:rules/google_java_format_toolchain.bzl",
    _google_java_format_toolchain = "google_java_format_toolchain"
)

load("//java:aspects/javadoc_aspect/defs.bzl", _javadoc_aspect = "javadoc_aspect")

load("//java:rules/javadoc_toolchain.bzl", _javadoc_toolchain = "javadoc_toolchain")

JavaAgentInfo = _JavaAgentInfo

JavaCompilationInfo = _JavaCompilationInfo

JavaDependencyInfo = _JavaDependencyInfo

JavaExecutionInfo = _JavaExecutionInfo

dwtj_java_binary = java_binary

dwtj_java_library = java_library

dwtj_java_import = java_import

dwtj_java_test = java_test

dwtj_legacy_java_import = legacy_java_import

dwtj_java_agent = java_agent

dwtj_java_compiler_toolchain = java_compiler_toolchain

dwtj_java_runtime_toolchain = java_runtime_toolchain

google_java_format_aspect = _google_java_format_aspect

google_java_format_toolchain = _google_java_format_toolchain

javadoc_aspect = _javadoc_aspect

javadoc_toolchain = _javadoc_toolchain
