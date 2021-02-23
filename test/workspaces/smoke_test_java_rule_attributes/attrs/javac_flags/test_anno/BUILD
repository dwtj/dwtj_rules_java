load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_library",
)

alias(
    name = "proc_services_file",
    actual = "META-INF_services_javax.annotation.processing.Processor",
)

dwtj_java_library(
    name = "test_anno",
    srcs = [
        "TestAnno.java",
        "TestAnnoProc.java",
    ],
    resources = {
        ":proc_services_file": "META-INF/services/javax.annotation.processing.Processor",
    },
    visibility = ["//visibility:public"],
)
