load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_test")

dwtj_java_test(
    name = "MyTest",
    main_class = "rules.java_test.MyTest",
    srcs = ["MyTest.java"],
    output_jar = "MyTest.jar",
)

sh_test(
    name = "output_jar_test",
    srcs = ["//:file_exists_test.sh"],
    args = ["$(location :MyTest.jar)"],
    data = [":MyTest.jar",],
)
