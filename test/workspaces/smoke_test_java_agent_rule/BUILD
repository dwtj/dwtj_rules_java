load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_agent",
    "dwtj_java_test",
)

dwtj_java_agent(
    name = "MyJavaAgent",
    srcs = ["mypkg/MyJavaAgent.java"],
    premain_class = "mypkg.MyJavaAgent",
)

dwtj_java_test(
    name = "MyJavaTest",
    srcs = ["mypkg/MyJavaTest.java"],
    java_agents = [":MyJavaAgent"],
    main_class = "mypkg.MyJavaTest",
)