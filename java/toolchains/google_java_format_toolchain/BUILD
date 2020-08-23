'''Declares the `google-java-format` toolchain type.

All `google-java-format` toolchain instances "implement" this `toolchain_type`.
Some background on the role of `toolchain_type` within the Bazel toolchain
framework is provided [here][1].

[1]: https://docs.bazel.build/versions/3.3.0/toolchains.html#writing-rules-that-use-toolchains
'''

load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "defs_bzl",
    srcs = ["defs.bzl"],
    visibility = ["//visibility:public"],
)
