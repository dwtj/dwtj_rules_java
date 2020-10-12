'''This file was instantiated from a template with the following
substitutions:

- REPOSITORY_NAME: {REPOSITORY_NAME}
- JVMTI_HEADER_LABEL: {JVMTI_HEADER_LABEL}    --  E.g., "//:include/jvmti.h"
- JNI_HEADER_LABEL: {JNI_HEADER_LABEL}        --  E.g., "//:include/jni.h"
- JNI_MD_HEADER_LABEL: {JNI_MD_HEADER_LABEL}  --  E.g., "//:include/linux/jni_md.h"
'''

# TODO(dwtj): Also implement analogous rules for `jvmticmlr.h`.

load("@io_bazel_rules_rust//rust:rust.bzl", "rust_library")

_BINDGEN_CMD_BASH = ''' \
bindgen \
    --output "$(location jvmti.rs)" \
    "$(location {JVMTI_HEADER_LABEL})" \
    -- \
    -I`dirname "$(location {JNI_HEADER_LABEL})"` \
    -I`dirname "$(location {JNI_MD_HEADER_LABEL})"` \
'''

genrule(
    name = "bindgen",
    srcs = [
        "{JVMTI_HEADER_LABEL}",
        "{JNI_HEADER_LABEL}",
        "{JNI_MD_HEADER_LABEL}",
    ],
    outs = ["jvmti.rs"],
    cmd_bash = _BINDGEN_CMD_BASH,
    visibility = ["//visibility:public"],
)

rust_library(
    name = "jvmti",
    srcs = ["jvmti.rs"],
    visibility = ["//visibility:public"],
    rustc_flags = [
        "-A", "non-snake-case",
        "-A", "non-upper-case-globals",
        "-A", "non-camel-case-types",
    ],
)
