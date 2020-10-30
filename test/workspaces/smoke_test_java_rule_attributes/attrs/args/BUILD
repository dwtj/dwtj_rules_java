load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_test")

dwtj_java_test(
    name = "expect_zero_args",
    main_class = "attrs.args.ExpectNumArgs",
    srcs = ["ExpectNumArgs.java"],
    args = [],
)

dwtj_java_test(
    name = "expect_one_arg",
    main_class = "attrs.args.ExpectNumArgs",
    srcs = ["ExpectNumArgs.java"],
    args = ["1"],
)

dwtj_java_test(
    name = "expect_five_args",
    main_class = "attrs.args.ExpectNumArgs",
    srcs = ["ExpectNumArgs.java"],
    args = [
        "5",
        "a",
        "b",
        "c",
        "d",
    ],
)
