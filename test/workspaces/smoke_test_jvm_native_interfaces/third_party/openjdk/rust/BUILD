package(
    default_visibility = ["//visibility:public"],
)

alias(
    name = "jni",
    actual = select({
        "@bazel_tools//src/conditions:linux_x86_64": "@remote_openjdk_linux_x64//rust/jni",
        "@bazel_tools//src/conditions:darwin": "@remote_openjdk_macos_x64//rust/jni",
    }),
)

alias(
    name = "jvmti",
    actual = select({
        "@bazel_tools//src/conditions:linux_x86_64": "@remote_openjdk_linux_x64//rust/jvmti",
        "@bazel_tools//src/conditions:darwin": "@remote_openjdk_macos_x64//rust/jvmti",
    }),
)
