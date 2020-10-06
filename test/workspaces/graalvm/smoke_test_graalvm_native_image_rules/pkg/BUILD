load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_library")
load(
    "@dwtj_rules_java//graalvm:defs.bzl",
    "graalvm_native_image_binary",
    "graalvm_native_image_library",
)

dwtj_java_library(
    name = "hello_java_library",
    srcs = ["Hello.java"],
)

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

graalvm_native_image_library(
    name = "hello_native_library",
    main_class = "pkg.Hello",
    deps = [":hello_java_library"],
    shared_library_output = "hello.so",
    header_output = "hello.h",
    dynamic_header_output = "hello_dynamic.h",
    graal_isolate_header_output = "graal_isolate.h",
    graal_isolate_dynamic_header_output = "graal_isolate_dynamic.h",
)
