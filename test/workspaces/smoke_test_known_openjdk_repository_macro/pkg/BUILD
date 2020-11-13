load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_test")

alias(
    name = "linux_x64",
    actual = "@bazel_tools//src/conditions:linux_x86_64",
)

alias(
    name = "macos_x64",
    actual = "@bazel_tools//src/conditions:darwin",
)

dwtj_java_test(
    name = "test_default",
    main_class = "pkg.ExpectJvmProperties",
    srcs = ["ExpectJvmProperties.java"],
    args = [
        # Don't expect any particular vendor & version. Just use the default.
    ],
)

dwtj_java_test(
    name = "test_jdk14",
    main_class = "pkg.ExpectJvmProperties",
    srcs = ["ExpectJvmProperties.java"],
    args = [
        "'Oracle Corporation'",
        "14.0.2"
    ],
    java_runtime_toolchain = select({
        "linux_x64": "@jdk_java_net_linux_jdk_14_0_2//java:_java_runtime_toolchain",
        "macos_x64": "@jdk_java_net_macos_jdk_14_0_2//java:_java_runtime_toolchain",
    }),
    java_compiler_toolchain = select({
        "linux_x64": "@jdk_java_net_linux_jdk_14_0_2//java:_java_compiler_toolchain",
        "macos_x64": "@jdk_java_net_macos_jdk_14_0_2//java:_java_compiler_toolchain",
    }),
)

# NOTE(dwtj) AdoptOpenJDK Upstream doesn't offer any macOS builds, so when we
#  this test on macOS, we just run it with run
#  use the default toolchains.
dwtj_java_test(
    name = "test_adoptopenjdk_upstream_jdk11",
    main_class = "pkg.ExpectJvmProperties",
    srcs = ["ExpectJvmProperties.java"],
    args = select({
        ":linux_x64": [
            "'Oracle Corporation'",
            "11.0.9",
        ],
        ":macos_x64": [
            # Don't expect any particular vendor & version. Just use the default.
        ],
    }),
    java_runtime_toolchain = select({
        ":linux_x64": "@adoptopenjdk_upstream_linux_jdk_11_0_9_11//java:_java_runtime_toolchain",
        ":macos_x64": None,
    }),
    java_compiler_toolchain = select({
        ":linux_x64": "@adoptopenjdk_upstream_linux_jdk_11_0_9_11//java:_java_compiler_toolchain",
        ":macos_x64": None,
    }),
)

dwtj_java_test(
    name = "test_adoptopenjdk_jdk11",
    main_class = "pkg.ExpectJvmProperties",
    srcs = ["ExpectJvmProperties.java"],
    args = [
        "AdoptOpenJDK",
        "11.0.9",
    ],
    java_runtime_toolchain = select({
        ":linux_x64": "@adoptopenjdk_linux_jdk_11_0_9_11//java:_java_runtime_toolchain",
        ":macos_x64": "@adoptopenjdk_macos_jdk_11_0_9_11//java:_java_runtime_toolchain",
    }),
    java_compiler_toolchain = select({
        ":linux_x64": "@adoptopenjdk_linux_jdk_11_0_9_11//java:_java_compiler_toolchain",
        ":macos_x64": "@adoptopenjdk_macos_jdk_11_0_9_11//java:_java_compiler_toolchain",
    })
)

# TODO(dwtj): Figure out why this crashes.
# dwtj_java_test(
#     name = "test_adoptopenjdk_jdk11_openj9",
#     main_class = "pkg.ExpectJvmProperties",
#     srcs = ["ExpectJvmProperties.java"],
#     args = [
#         "'Oracle Corporation'",
#         "11.0.9",
#     ],
#     java_runtime_toolchain = "@adoptopenjdk_linux_jdk_11_0_9_11_openj9_0_23_0//java:_java_runtime_toolchain",
#     java_compiler_toolchain = "@adoptopenjdk_linux_jdk_11_0_9_11_openj9_0_23_0//java:_java_compiler_toolchain",
# )

# TODO(dwtj): Figure out why this crashes. Looks like the interface to the `jar`
#  command is slightly different.
#dwtj_java_test(
#    name = "test_amazon_corretto_jdk8",
#    main_class = "pkg.ExpectJvmProperties",
#    srcs = ["ExpectJvmProperties.java"],
#    args = [
#        # TODO(dwtj): These values are just guesses.
#        "'Amazon Corretto'",
#        "8.272.10",
#    ],
#    java_runtime_toolchain = "@amazon_corretto_linux_jdk_8_272_10_3//java:_java_runtime_toolchain",
#    java_compiler_toolchain = "@amazon_corretto_linux_jdk_8_272_10_3//java:_java_compiler_toolchain",
#)

dwtj_java_test(
    name = "test_amazon_corretto_jdk11",
    main_class = "pkg.ExpectJvmProperties",
    srcs = ["ExpectJvmProperties.java"],
    args = [
        "'Amazon.com Inc.'",
        "11.0.9.1",
    ],
    java_runtime_toolchain = select({
        ":linux_x64": "@amazon_corretto_linux_jdk_11_0_9_12_1//java:_java_runtime_toolchain",
        ":macos_x64": "@amazon_corretto_macos_jdk_11_0_9_12_1//java:_java_runtime_toolchain",
    }),
    java_compiler_toolchain = select({
        ":linux_x64": "@amazon_corretto_linux_jdk_11_0_9_12_1//java:_java_compiler_toolchain",
        ":macos_x64": "@amazon_corretto_macos_jdk_11_0_9_12_1//java:_java_compiler_toolchain",
    }),
)
