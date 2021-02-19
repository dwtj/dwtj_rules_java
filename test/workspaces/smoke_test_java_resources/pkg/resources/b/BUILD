load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_library",
    "dwtj_java_test",
)

dwtj_java_library(
    name = "b",
    srcs = ["LibB.java"],
    resources = {"b.txt": "pkg/resources/b/b.txt"},
    visibility = ["//visibility:public"],
)

dwtj_java_test(
    name = "test_b",
    srcs = ["TestB.java"],
    main_class = "pkg.resources.b.TestB",
    deps = ["b"],
)
