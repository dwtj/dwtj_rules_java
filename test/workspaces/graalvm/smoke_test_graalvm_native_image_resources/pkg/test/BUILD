load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_test",
    "dwtj_java_library",
)

dwtj_java_library(
    name = "test_library",
    srcs = ["TestApp.java"],
    deps = ["//pkg/a"],
    visibility = ["//visibility:public"],
)

dwtj_java_test(
    name = "test",
    main_class = "pkg.test.TestApp",
    srcs = ["TestApp.java"],
    deps = ["//pkg/a"],
)
