load("@dwtj_rules_java//graalvm:defs.bzl", "graalvm_native_image_binary")

graalvm_native_image_binary(
    name = "native_image_binary",
    deps = ["//pkg/test:test_library"],
    main_class = "pkg.test.TestApp",
    output = "test_binary",
    native_image_options = ["-H:IncludeResources=.*"],
)

sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = ["test_binary"],
    args = ["$(rootpath :test_binary)"],
)
