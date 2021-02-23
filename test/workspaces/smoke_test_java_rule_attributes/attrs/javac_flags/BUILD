load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_test")

dwtj_java_test(
    name = "test_annotation_processor_can_read_flag",
    srcs = ["Test.java"],
    main_class = "attrs.javac_flags.Test",
    deps = ["//attrs/javac_flags/test_anno"],
    javac_flags = ['-Aattrs.javac_flags.test_anno.TestOption="Hello, world!"'],
)
