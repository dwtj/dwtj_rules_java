'''Exports all toolchain rules.

These can help users define their own toolchain instances. Most users shouldn't
need to use these rules directly. Instead, most users will find it simpler to
use repository rules to automatically synthesize toolchain instances. These
rules should be used if for some reason the user finds the toolchains from the
repository rules are not right for their needs.
'''

load("//java:toolchain_rules/java_compiler_toolchain.bzl", "java_compiler_toolchain")

load("//java:toolchain_rules/java_runtime_toolchain.bzl", "java_runtime_toolchain")

load("//java:toolchain_rules/graalvm_native_image_toolchain.bzl", _graalvm_native_image_toolchain = "graalvm_native_image_toolchain")

load("//java:toolchain_rules/google_java_format_toolchain.bzl", _google_java_format_toolchain = "google_java_format_toolchain")

load("//java:toolchain_rules/javadoc_toolchain.bzl", _javadoc_toolchain = "javadoc_toolchain")

load("//java:toolchain_rules/error_prone_toolchain.bzl", _error_prone_toolchain = "error_prone_toolchain")

load("//java:toolchain_rules/checkstyle_toolchain.bzl", _checkstyle_toolchain = "checkstyle_toolchain")

dwtj_java_compiler_toolchain = java_compiler_toolchain

dwtj_java_runtime_toolchain = java_runtime_toolchain

graalvm_native_image_toolchain = _graalvm_native_image_toolchain

google_java_format_toolchain = _google_java_format_toolchain

javadoc_toolchain = _javadoc_toolchain

error_prone_toolchain = _error_prone_toolchain

checkstyle_toolchain = _checkstyle_toolchain
