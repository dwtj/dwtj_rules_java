'''This file was instantiated from a template with the following
substitutions:

- REPOSITORY_NAME: {REPOSITORY_NAME}
- JNI_MD_HEADER_DIR: {JNI_MD_HEADER_DIR}
'''

load("@rules_cc//cc:defs.bzl", "cc_library")

licenses(["restricted"])  # GPLv2, portions of GPLv2 with "Classpath" exception

cc_library(
    name = "headers",
    hdrs = ["@{REPOSITORY_NAME}//:include/jni.h"],
    deps = [":md_headers"],
    strip_include_prefix = "/include",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "md_headers",
    hdrs = ["@{REPOSITORY_NAME}//:{JNI_MD_HEADER_DIR}/jni_md.h"],
    strip_include_prefix = "/{JNI_MD_HEADER_DIR}",
)
