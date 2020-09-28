load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_library")

dwtj_java_library(
    name = "MyLib",
    srcs = ["MyLib.java"],
    output_jar = "MyLib.jar",
)

sh_test(
    name = "output_jar_test",
    srcs = ["//:file_exists_test.sh"],
    args = ["$(location :MyLib.jar)"],
    data = [":MyLib.jar",],
)
