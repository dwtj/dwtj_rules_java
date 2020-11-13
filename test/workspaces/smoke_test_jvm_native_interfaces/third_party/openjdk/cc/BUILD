package(
    default_visibility = ["//visibility:public"],
)

alias(
    name = "jni_headers",
    actual = select({
        "@bazel_tools//src/conditions:linux_x86_64": "@remote_openjdk_linux_x64//cc/jni:headers",
        "@bazel_tools//src/conditions:darwin": "@remote_openjdk_macos_x64//cc/jni:headers",
    }),
)

alias(
    name = "jvmti_headers",
    actual = select({
        "@bazel_tools//src/conditions:linux_x86_64": "@remote_openjdk_linux_x64//cc/jvmti:headers",
        "@bazel_tools//src/conditions:darwin": "@remote_openjdk_macos_x64//cc/jvmti:headers",
    }),
)

alias(
    name = "jvm",
    actual = select({
        "@bazel_tools//src/conditions:linux_x86_64": "@remote_openjdk_linux_x64//cc/jvm",
        "@bazel_tools//src/conditions:darwin": "@remote_openjdk_macos_x64//cc/jvm",
    }),
)
