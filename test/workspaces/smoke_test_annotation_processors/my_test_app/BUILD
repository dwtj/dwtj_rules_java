load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_test")

dwtj_java_test(
    name = "my_test_app",
    srcs = ["MyTestApp.java"],
    main_class = "my_test_app.MyTestApp",
    deps = [
        "//my_anno",
        "//my_anno_proc",
    ],
)
