load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_library")
load("@dwtj_rules_java//graalvm:defs.bzl", "graalvm_native_image_binary")

# MAKE A JAVA LIBRARY WITH A MAIN METHOD ######################################

dwtj_java_library(
    name = "hello_java_library",
    srcs = ["Hello.java"],
    visibility = ["//pkg:__subpackages__"],
)

# COMPILE JAVA LIBRARY INTO A BINARY EXECUTABLE WITH SHARED DEPENDENCIES ######

graalvm_native_image_binary(
    name = "hello_native_shared_binary",
    main_class = "pkg.Hello",
    deps = [":hello_java_library"],
    output = "hello_shared",
    linkage = "shared",
)

sh_test(
    name = "hello_native_shared_binary_test",
    srcs = [":hello_test.sh"],
    data = [":hello_shared"],
    args = ["$(location :hello_shared)"],
)

# COMPILE JAVA LIBRARY INTO A BINARY EXECUTABLE WITH STATIC DEPENDENCIES ######

graalvm_native_image_binary(
    name = "hello_native_static_binary",
    main_class = "pkg.Hello",
    deps = [":hello_java_library"],
    output = "hello_static",
    linkage = "static",
)

sh_test(
    name = "hello_native_static_binary_test",
    srcs = [":hello_test.sh"],
    data = [":hello_static"],
    args = ["$(location :hello_static)"],
)
