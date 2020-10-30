load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_test")

dwtj_java_test(
    name = "test_default",
    main_class = "pkg.ExpectJvmProperties",
    srcs = ["ExpectJvmProperties.java"],
    args = [
        # Don't expect a particular vendor & version. Just use the default.
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
    java_runtime_toolchain = "@jdk_java_net_linux_jdk_14_0_2//java:_java_runtime_toolchain",
    java_compiler_toolchain = "@jdk_java_net_linux_jdk_14_0_2//java:_java_compiler_toolchain",
)

dwtj_java_test(
    name = "test_adoptopenjdk_upstream_jdk11",
    main_class = "pkg.ExpectJvmProperties",
    srcs = ["ExpectJvmProperties.java"],
    args = [
        "'Oracle Corporation'",
        "11.0.9",
    ],
    java_runtime_toolchain = "@adoptopenjdk_upstream_linux_jdk_11_0_9_11//java:_java_runtime_toolchain",
    java_compiler_toolchain = "@adoptopenjdk_upstream_linux_jdk_11_0_9_11//java:_java_compiler_toolchain",
)

dwtj_java_test(
    name = "test_adoptopenjdk_jdk11",
    main_class = "pkg.ExpectJvmProperties",
    srcs = ["ExpectJvmProperties.java"],
    args = [
        "AdoptOpenJDK",
        "11.0.9",
    ],
    java_runtime_toolchain = "@adoptopenjdk_linux_jdk_11_0_9_11//java:_java_runtime_toolchain",
    java_compiler_toolchain = "@adoptopenjdk_linux_jdk_11_0_9_11//java:_java_compiler_toolchain",
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
        "11.0.9",
    ],
    java_runtime_toolchain = "@amazon_corretto_linux_jdk_11_0_9_11_1//java:_java_runtime_toolchain",
    java_compiler_toolchain = "@amazon_corretto_linux_jdk_11_0_9_11_1//java:_java_compiler_toolchain",
)
