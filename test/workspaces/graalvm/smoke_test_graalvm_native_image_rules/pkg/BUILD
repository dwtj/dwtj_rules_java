load(
    "@rules_cc//cc:defs.bzl",
    "cc_import",
    "cc_library",
    "cc_binary",
)
load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_library")
load(
    "@dwtj_rules_java//graalvm:defs.bzl",
    "graalvm_native_image_binary",
    "graalvm_native_image_library",
)

exports_files(
    ["hello_test.sh"],
    visibility = ["//pkg:__subpackages__"],
)

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

# MAKE JAVA LIBRARY INTO A NATIVE LIBRARY #####################################

graalvm_native_image_library(
    name = "hello_native_library",
    main_class = "pkg.Hello",
    deps = [":hello_java_library"],
    library_output = "hello.so",
    header_output = "hello.h",
    dynamic_header_output = "hello_dynamic.h",
    graal_isolate_header_output = "graal_isolate.h",
    graal_isolate_dynamic_header_output = "graal_isolate_dynamic.h",
)

# WRAP THIS NATIVE LIBRARY'S FOUR GENERATED HEADER FILES IN CC RULES ##########

cc_library(
    name = "graal_isolate_header",
    hdrs = [":graal_isolate.h"],
    strip_include_prefix = "/pkg",
)

cc_library(
    name = "graal_isolate_dynamic_header",
    hdrs = [":graal_isolate_dynamic.h"],
    strip_include_prefix = "/pkg",
)

cc_import(
    name = "hello_native_cc_import",
    hdrs = [":hello.h"],
    shared_library = ":hello.so",
)

cc_import(
    name = "hello_native_dynamic_cc_import",
    hdrs = [":hello_dynamic.h"],
    shared_library = ":hello.so",
)

cc_library(
    name = "hello_native_cc_library",
    deps = [
        ":graal_isolate_header",
        ":hello_native_cc_import",
    ],
)

cc_library(
    name = "hello_native_dynamic_cc_library",
    deps = [
        ":graal_isolate_dynamic_header",
        ":hello_native_dynamic_cc_import",
    ],
)

# CREATE & TEST A NATIVE EXECUTABLE WHICH USES THIS LIBRARY'S STATIC HEADERS ##

cc_binary(
    name = "hello_native_cc_binary",
    srcs = ["hello_test.cc"],
    deps = [":hello_native_cc_library"],
)

sh_test(
    name = "hello_native_cc_binary_test",
    srcs = [":hello_test.sh"],
    data = [":hello_native_cc_binary"],
    args = ["$(location :hello_native_cc_binary)"],
)

# CREATE & TEST A NATIVE EXECUTABLE WHICH USES THIS LIBRARY'S DYNAMIC HEADERS #

cc_binary(
    name = "hello_native_dynamic_cc_binary",
    srcs = ["hello_dynamic_test.cc"],
    deps = [":hello_native_dynamic_cc_library"],
)

# TODO(dwtj): Figure out how to use the interface provided by the dynamic
#  headers, and then re-enable this.
#sh_test(
#    name = "hello_native_dynamic_cc_binary_test",
#    srcs = [":hello_test.sh"],
#    data = [":hello_native_dynamic_cc_binary"],
#    args = ["$(location :hello_native_dynamic_cc_binary)"],
#)
