'''This is part of the public API for this project.
'''

load("//java:rules/common/CustomJavaInfo.bzl", _CustomJavaInfo = "CustomJavaInfo")

load("//java:rules/java_binary.bzl", "java_binary")

load("//java:rules/java_library.bzl", "java_library")

load("//java:rules/java_import.bzl", "java_import")

load("//java:rules/java_compiler_toolchain.bzl", "java_compiler_toolchain")

load("//java:rules/java_runtime_toolchain.bzl", "java_runtime_toolchain")

CustomJavaInfo = _CustomJavaInfo

dwtj_java_binary = java_binary

dwtj_java_library = java_library

dwtj_java_import = java_import

dwtj_java_compiler_toolchain = java_compiler_toolchain

dwtj_java_runtime_toolchain = java_runtime_toolchain
