load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_library",
    "dwtj_java_test",
)

dwtj_java_library(
    name = "MustBeCompiledWithGraal",
    srcs = ["MustBeCompiledWithGraal.java"],
    java_compiler_toolchain = "@remote_graalvm_linux_x64//:_java_compiler_toolchain",
)

dwtj_java_test(
    name = "MustBeRunWithGraal",
    main_class = "st.MustBeRunWithGraal",
    srcs = ["MustBeRunWithGraal.java"],
    java_runtime_toolchain = "@remote_graalvm_linux_x64//:_java_runtime_toolchain",
)

dwtj_java_test(
    name = "MustUseOpenJdk",
    main_class = "st.MustUseOpenJdk",
    srcs = ["MustUseOpenJdk.java"],
)
