load("@io_bazel_rules_rust//rust:rust.bzl", "rust_library")
load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")
load("//bazel/util/rust:rename_cdylib.bzl", "rename_cdylib")

rust_library(
    name = "my_lib_rust_cdylib",
    srcs = ["MyLib.rs"],
    crate_type = "cdylib",
    edition = "2018",
    deps = ["@openjdk_linux_x64//rust/jni"],
)

dwtj_java_binary(
    name = "my_lib_java_binary",
    srcs = ["MyLib.java"],
    main_class = "rust.jni.MyLib",
    output_jar = "MyLib.jar",
)

rename_cdylib(
  name = "rename",
  src = "my_lib_rust_cdylib",
  out = "libmyjni.so",
)

sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = [
        ":libmyjni.so",
        ":MyLib.jar",
    ],
    args = [
        "$(location :libmyjni.so)",
        "$(location :MyLib.jar)",
    ],
)
