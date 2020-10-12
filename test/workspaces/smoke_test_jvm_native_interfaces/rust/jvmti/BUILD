load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")
load("@io_bazel_rules_rust//rust:rust.bzl", "rust_library")
load("//bazel/util/rust:rename_cdylib.bzl", "rename_cdylib")

dwtj_java_binary(
    name = "MyApp",
    main_class = "rust.jvmti.MyApp",
    srcs = ["MyApp.java"],
    output_jar = "MyApp.jar",
)

rust_library(
    name = "my_agent_rust_cdylib",
    srcs = ["my_agent.rs"],
    crate_type = "cdylib",
    deps = ["@openjdk_linux_x64//rust/jvmti"],
    edition = "2018",
    rustc_flags = ["-A", "unused-variables"]
)

rename_cdylib(
  name = "rename",
  src = ":my_agent_rust_cdylib",
  out = "libptagent.so",
)

sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = [
        ":libptagent.so",
        ":MyApp.jar",
    ],
    args = [
        "$(location :libptagent.so)",
        "$(location :MyApp.jar)",
    ],
)
