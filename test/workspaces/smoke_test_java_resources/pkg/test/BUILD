load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_test")

dwtj_java_test(
    name = "app",
    srcs = ["TestApp.java"],
    main_class = "pkg.test.TestApp",
    deps = [
        "//pkg/resources/a",
        "//pkg/resources/b",
    ],
)
