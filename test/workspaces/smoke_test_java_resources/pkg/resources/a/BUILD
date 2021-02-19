load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_library",
    "dwtj_java_test",
)

dwtj_java_library(
    name = "a",
    srcs = ["LibA.java"],
    resources = {"a.txt": "pkg/resources/a/a.txt"},
    visibility = ["//visibility:public"],
)

dwtj_java_test(
    name = "test_a",
    srcs = ["TestA.java"],
    main_class = "pkg.resources.a.TestA",
    deps = ["a"],
)
