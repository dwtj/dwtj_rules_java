'''This file was instantiated from a template with the following
substitutions:

- REPOSITORY_NAME: {REPOSITORY_NAME}
- JNI_HEADER_LABEL: {JNI_HEADER_LABEL}        --  E.g., "//jdk:include/jni.h"
- JNI_MD_HEADER_LABEL: {JNI_MD_HEADER_LABEL}  --  E.g., "//jdk:include/linux/jni_md.h"
'''

load("@rules_rust//rust:rust.bzl", "rust_library")

_BINDGEN_CMD_BASH = ''' \
bindgen \
    --output "$(location jni.rs)" \
    "$(execpath {JNI_HEADER_LABEL})" \
    -- \
    -I`dirname "$(execpath {JNI_MD_HEADER_LABEL})"`
'''

# TODO(dwtj): Consider using a proper `rust_bindgen` rule. (I tried it once, but
#  I ran into a problem. I can't remember the problem any more.)
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
