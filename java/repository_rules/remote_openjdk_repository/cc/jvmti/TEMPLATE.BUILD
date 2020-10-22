'''This file was instantiated from a template with the following
substitutions:

- REPOSITORY_NAME: {REPOSITORY_NAME}
'''

load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "headers",
    hdrs = [
        "@{REPOSITORY_NAME}//jdk:include/jvmti.h",
        "@{REPOSITORY_NAME}//jdk:include/jvmticmlr.h",
    ],
    strip_include_prefix = "/jdk/include",
    visibility = ["//visibility:public"],
)
