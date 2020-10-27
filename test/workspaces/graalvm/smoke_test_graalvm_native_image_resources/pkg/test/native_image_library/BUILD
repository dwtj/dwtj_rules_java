load("@dwtj_rules_java//graalvm:defs.bzl", "graalvm_native_image_library")

graalvm_native_image_library(
    name = "native_image_library",
    deps = ["//pkg/test:test_library"],
    main_class = "pkg.test.TestApp",
    native_image_options = ["-H:IncludeResources=.*"],
    library_output = "libtest.so",
    header_output = "test.h",
    dynamic_header_output = "test_dynamic.h",
    graal_isolate_header_output = "graal_isolate.h",
    graal_isolate_dynamic_header_output = "graal_isolate_dynamic.h",
)

cc_library(
    name = "graal_isolate_headers",
    hdrs = ["graal_isolate.h"],
    strip_include_prefix = "/pkg/test/native_image_library",
)

cc_import(
    name = "native_image_cc_import",
    shared_library = "libtest.so",
    hdrs =  ["test.h"],
)

cc_test(
    name = "test",
    srcs = ["test.cc"],
    deps = [
        "native_image_cc_import",
        "graal_isolate_headers",
    ],
)
