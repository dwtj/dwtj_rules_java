load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_library")

exports_files(
    ["hello_test.sh"],
    visibility = ["//pkg:__subpackages__"],
)

dwtj_java_library(
    name = "hello_java_library",
    srcs = ["Hello.java"],
    visibility = ["//pkg:__subpackages__"],
)
