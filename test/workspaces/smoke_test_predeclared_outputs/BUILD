load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_agent")

dwtj_java_agent(
    name = "my_agent",
    srcs = ["MyAgent.java"],
    premain_class = "MyAgent",
    output_jar = "my_custom_agent.jar",
)

sh_test(
    name = "my_test",
    srcs = ["my_test.sh"],
    args = ["$(location :my_custom_agent.jar)"],
    data = [":my_custom_agent.jar"]
)
