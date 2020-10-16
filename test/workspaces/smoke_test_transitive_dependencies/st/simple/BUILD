load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_library",
    "dwtj_java_test",
)

dwtj_java_test(
    name = "ThisShouldFailToCompile",
    main_class = "st.simple.A",
    srcs = ["A.java"],
    deps = ["B"],
)

dwtj_java_test(
    name = "A",
    main_class = "st.simple.A",
    srcs = ["A.java"],
    deps = [
        "B",
        "C",
    ],
)

dwtj_java_library(
    name = "B",
    srcs = ["B.java"],
    deps = ["C"],
)

dwtj_java_library(
    name = "C",
    srcs = ["C.java"],
    deps = ["D"],
)

dwtj_java_library(
    name = "D",
    srcs = ["D.java"],
)
