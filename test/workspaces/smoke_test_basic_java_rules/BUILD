load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_binary",
    "dwtj_java_library",
)

dwtj_java_binary(
    name = "MyApp",
    srcs = ["MyApp.java"],
    main_class = "MyApp",
    deps = [":MyDep"],
)

dwtj_java_library(
    name = "MyDep",
    srcs = ["MyDep.java"],
)