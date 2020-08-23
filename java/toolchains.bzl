'''Exports all toolchain rules.

These can help users define their own toolchain instances. Most users shouldn't
need to use these rules directly: most users will find it simpler to use
repository rules to automatically synthesize toolchain instances. These rules
should be used if the repository rule toolchains are unsuitable for some reason.
'''

load("//java/toolchains/java_compiler_toolchain:defs.bzl", "java_compiler_toolchain")

load("//java/toolchains/java_runtime_toolchain:defs.bzl", "java_runtime_toolchain")

load("//java/toolchains/google_java_format_toolchain:defs.bzl", _google_java_format_toolchain = "google_java_format_toolchain")

load("//java/toolchains/javadoc_toolchain:defs.bzl", _javadoc_toolchain = "javadoc_toolchain")

load("//java/toolchains/error_prone_toolchain:defs.bzl", _error_prone_toolchain = "error_prone_toolchain")

load("//java/toolchains/checkstyle_toolchain:defs.bzl", _checkstyle_toolchain = "checkstyle_toolchain")

dwtj_java_compiler_toolchain = java_compiler_toolchain

dwtj_java_runtime_toolchain = java_runtime_toolchain

google_java_format_toolchain = _google_java_format_toolchain

javadoc_toolchain = _javadoc_toolchain

error_prone_toolchain = _error_prone_toolchain

checkstyle_toolchain = _checkstyle_toolchain
