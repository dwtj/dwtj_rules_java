load("@dwtj_rules_java//graalvm:defs.bzl", "graalvm_native_image_binary")

graalvm_native_image_binary(
    name = "native_image_binary",
    main_class = "st.java.MyTestBin",
    deps = ["//st/java:MyTestBin"],
    output = "mytest",
)

sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = [":mytest"],
    args = ["$(rootpath :mytest)"],
)
