load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_library")

dwtj_java_library(
    name = "MustBeCompiledWithGraal",
    srcs = ["MustBeCompiledWithGraal.java"],
    java_compiler_toolchain = "@remote_graalvm_linux_x64//:_java_compiler_toolchain",
)
