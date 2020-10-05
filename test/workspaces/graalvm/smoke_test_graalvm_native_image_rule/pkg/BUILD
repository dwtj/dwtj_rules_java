load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_library")
load("@dwtj_rules_java//graalvm:defs.bzl", "graalvm_native_image")

dwtj_java_library(
    name = "hello_java_library",
    srcs = ["Hello.java"],
)

graalvm_native_image(
    name = "hello_native_exec",
    main_class = "pkg.Hello",
    deps = [":hello_java_library"],
    output_image = "hello",
)

sh_test(
    name = "hello_world_test",
    srcs = [":hello_test.sh"],
    data = [":hello"],
    args = ["$(location :hello)"],
)
