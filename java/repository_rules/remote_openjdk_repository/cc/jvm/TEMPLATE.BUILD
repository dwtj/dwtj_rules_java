'''This file was instantiated from a template with the following
substitutions:

- REPOSITORY_NAME: {REPOSITORY_NAME}
- JVM_SHARED_LIBRARY_FILE: {JVM_SHARED_LIBRARY_FILE}
'''

load(
    "@rules_cc//cc:defs.bzl",
    "cc_import",
    "cc_library",
)

cc_import(
    name = "jvm_import",
    shared_library = "@{REPOSITORY_NAME}//jdk:{JVM_SHARED_LIBRARY_FILE}",
)

cc_library(
    name = "jvm",
    deps = [
        ":jvm_import",
        "@{REPOSITORY_NAME}//cc/jni:headers",
    ],
    visibility = ["//visibility:public"],
)
