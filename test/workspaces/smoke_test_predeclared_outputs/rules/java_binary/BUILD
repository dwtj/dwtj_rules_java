load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")

dwtj_java_binary(
    name = "MyBin",
    main_class = "rules.java_binary.MyBin",
    srcs = ["MyBin.java"],
    output_jar = "MyBin.jar",
)

sh_test(
    name = "output_jar_test",
    srcs = ["//:file_exists_test.sh"],
    args = ["$(location :MyBin.jar)"],
    data = [":MyBin.jar",],
)
