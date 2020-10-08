'''This file was instantiated from a template with the following
substitutions:

- REPOSITORY_NAME: {REPOSITORY_NAME}
- SHARED_LIBRARY_PATH: {SHARED_LIBRARY_PATH}
'''

load(
    "@rules_cc//cc:defs.bzl",
    "cc_import",
    "cc_library",
)

cc_import(
    name = "jvm_import",
    shared_library = "@{REPOSITORY_NAME}//:{SHARED_LIBRARY_PATH}",
)

cc_library(
    name = "jvm",
    deps = [
        ":jvm_import",
        "@{REPOSITORY_NAME}//cc/jni:headers",
    ],
    visibility = ["//visibility:public"],
)
