load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_binary",
    "dwtj_java_test",
)

dwtj_java_binary(
    name = "check_system_property",
    main_class = "attrs.jvm_args.CheckSystemProperty",
    srcs = ["CheckSystemProperty.java"],
    args = ["attrs.data.Hello", "World"],
    jvm_flags = ["-Dattrs.data.Hello"],
)

dwtj_java_test(
    name = "check_system_property_test",
    main_class = "attrs.jvm_args.CheckSystemProperty",
    srcs = ["CheckSystemProperty.java"],
    args = ["attrs.data.Hello", "World"],
    jvm_flags = ["-Dattrs.data.Hello"],
)
