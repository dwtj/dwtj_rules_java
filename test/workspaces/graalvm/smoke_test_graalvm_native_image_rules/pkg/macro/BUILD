# USE THE MACRO TO CREATE A `native-image` WRAPPED IN A `cc_library` ##########

load("@dwtj_rules_java//graalvm:defs.bzl", "graalvm_native_image_cc_library")
load("@rules_cc//cc:defs.bzl", "cc_binary")

graalvm_native_image_cc_library(
    name = "hello",
    main_class = "pkg.Hello",
    deps = ["//pkg:hello_java_library"],
)

cc_binary(
    name = "cc_binary_calling_hello",
    srcs = ["hello_test.cc"],
    deps = [":hello"],
)

sh_test(
    name = "test",
    srcs = ["//pkg:hello_test.sh"],
    data = [":cc_binary_calling_hello"],
    args = ["$(location :cc_binary_calling_hello)"],
)
