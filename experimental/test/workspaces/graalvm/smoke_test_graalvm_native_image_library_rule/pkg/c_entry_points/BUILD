load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_binary",
    "dwtj_java_library",
)
load("@dwtj_rules_java//experimental/graalvm:defs.bzl", "graalvm_native_image_library")

dwtj_java_binary(
    name = "hello_java",
    main_class = "pkg.c_entry_points.Hello",
    srcs = ["Hello.java"],
    deps = [":goodbye_java"],
)

dwtj_java_library(
    name = "goodbye_java",
    srcs = ["Goodbye.java"],
)

graalvm_native_image_library(
    name = "hello_native_image",
    image_name = "hello",
    main_class = "pkg.c_entry_points.Hello",
    deps = [
        ":hello_java",
        ":goodbye_java",
    ],
    library_output = "libhello.so",
    header_output = "hello.h",
    dynamic_header_output = "hello_dynamic.h",
    graal_isolate_header_output = "graal_isolate.h",
    graal_isolate_dynamic_header_output = "graal_isolate_dynamic.h",
)

sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = ["libhello.so"],
    args = ["$(location :libhello.so)"],
)
