'''Exports all GraalVM toolchain rules.

These can help users define their own toolchain instances. Most users shouldn't
need to use these rules directly. Instead, most users will find it simpler to
use repository rules to automatically synthesize toolchain instances. These
rules should be used if for some reason the user finds the toolchains from the
repository rules are not right for their needs.
'''


load("//graalvm:toolchain_rules/graalvm_native_image_toolchain.bzl", _graalvm_native_image_toolchain = "graalvm_native_image_toolchain")

graalvm_native_image_toolchain = _graalvm_native_image_toolchain
