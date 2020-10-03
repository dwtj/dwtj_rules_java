load(
    "@rules_cc//cc:defs.bzl",
    "cc_import",
    "cc_library",
)

licenses(["restricted"])  # GPLv2, portions of GPLv2 with "Classpath" exception

package(
    default_visibility = ["//visibility:public"],
)

cc_import(
    name = "libjvm",
    hdrs = ["@openjdk//:include/jni.h"],
    shared_library = "@openjdk//:lib/server/libjvm.so"
)

cc_library(
    name = "jni_headers",
    hdrs = ["@openjdk//:include/jni.h"],
    deps = [":jni_md_headers"],
    strip_include_prefix = "/external/openjdk/include",
)

cc_library(
    name = "jni_md_headers",
    hdrs = ["@openjdk//:include/linux/jni_md.h"],
    strip_include_prefix = "/external/openjdk/include/linux",
    visibility = ["//visibility:private"],
)

cc_library(
    name = "jvmti_headers",
    hdrs = [
        "@openjdk//:include/jvmti.h",
        "@openjdk//:include/jvmticmlr.h",
    ],
    strip_include_prefix = "/external/openjdk/include",
)
