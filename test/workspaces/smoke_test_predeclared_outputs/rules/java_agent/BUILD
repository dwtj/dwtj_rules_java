load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_agent")

dwtj_java_agent(
    name = "MyAgent",
    srcs = ["MyAgent.java"],
    premain_class = "MyAgent",
    output_jar = "MyAgent.jar",
)

sh_test(
    name = "output_jar_test",
    srcs = ["//:file_exists_test.sh"],
    args = ["$(location :MyAgent.jar)"],
    data = [":MyAgent.jar"]
)
