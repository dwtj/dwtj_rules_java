'''This file was instantiated from a template with the following
substitutions:

- REPOSITORY_NAME: {REPOSITORY_NAME}
- JNI_HEADER_LABEL: {JNI_HEADER_LABEL}        --  E.g., "//:include/jni.h"
- JNI_MD_HEADER_LABEL: {JNI_MD_HEADER_LABEL}  --  E.g., "//:include/linux/jni_md.h"
'''

load("@io_bazel_rules_rust//rust:rust.bzl", "rust_library")

_BINDGEN_CMD_BASH = ''' \
bindgen \
    --output "$(location jni.rs)" \
    "$(location {JNI_HEADER_LABEL})" \
    -- \
    -I`dirname "$(location {JNI_MD_HEADER_LABEL})"`
'''

genrule(
    name = "bindgen",
    srcs = [
        "{JNI_HEADER_LABEL}",
        "{JNI_MD_HEADER_LABEL}",
    ],
    outs = ["jni.rs"],
    cmd_bash = _BINDGEN_CMD_BASH,
    visibility = ["//visibility:public"],
)

rust_library(
    name = "jni",
    srcs = ["jni.rs"],
    visibility = ["//visibility:public"],
    rustc_flags = [
        "-A", "non-snake-case",
        "-A", "non-upper-case-globals",
        "-A", "non-camel-case-types",
    ],
)
