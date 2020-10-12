load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")
load("@io_bazel_rules_rust//rust:rust.bzl", "rust_library")

dwtj_java_binary(
    name = "MyApp",
    main_class = "rust.jvmti.MyApp",
    srcs = ["MyApp.java"],
)

rust_library(
    name = "my_agent",
    srcs = ["my_agent.rs"],
    crate_type = "cdylib",
    deps = ["@openjdk_linux_x64//rust/jvmti"],
    edition = "2018",
    rustc_flags = ["-A", "unused-variables"]
)

# TODO(dwtj): Add integration test.
