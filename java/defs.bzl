'''This is part of the public API for this project.
'''

load("//java:providers/JavaCompilationInfo.bzl", _JavaCompilationInfo = "JavaCompilationInfo")

load("//java:providers/JavaDependencyInfo.bzl", _JavaDependencyInfo = "JavaDependencyInfo")

load("//java:rules/java_binary.bzl", "java_binary")

load("//java:rules/java_library.bzl", "java_library")

load("//java:rules/java_import.bzl", "java_import")

load("//java:rules/java_test.bzl", "java_test")

load("//java:rules/legacy_java_import.bzl", "legacy_java_import")

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

JavaCompilationInfo = _JavaCompilationInfo

JavaDependencyInfo = _JavaDependencyInfo

dwtj_java_binary = java_binary

dwtj_java_library = java_library

dwtj_java_import = java_import

dwtj_java_test = java_test

dwtj_legacy_java_import = legacy_java_import

dwtj_java_compiler_toolchain = java_compiler_toolchain

dwtj_java_runtime_toolchain = java_runtime_toolchain

google_java_format_aspect = _google_java_format_aspect

google_java_format_toolchain = _google_java_format_toolchain
