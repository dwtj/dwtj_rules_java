load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_binary",
    "dwtj_java_test",
)

dwtj_java_binary(
    name = "binary_should_fail_unless_run_with_args",
    srcs = ["ExpectsArguments.java"],
    main_class = "ExpectsArguments",
)

dwtj_java_binary(
    name = "binary_should_pass",
    srcs = ["ExpectsArguments.java"],
    main_class = "ExpectsArguments",
    args = ["Hello", "World"],
)

dwtj_java_test(
    name = "test_should_fail_unless_run_with_test_args",
    srcs = ["ExpectsArguments.java"],
    main_class = "ExpectsArguments",
)

dwtj_java_test(
    name = "test_should_pass",
    srcs = ["ExpectsArguments.java"],
    main_class = "ExpectsArguments",
    args = ["Hello", "World"],
)
