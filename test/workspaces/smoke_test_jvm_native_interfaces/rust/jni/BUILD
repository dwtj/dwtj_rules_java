load("@rules_rust//rust:rust.bzl", "rust_library")
load("@dwtj_rules_java//java:defs.bzl", "dwtj_java_binary")
load("//bazel/util/rust:rename_cdylib.bzl", "rename_cdylib")

rust_library(
    name = "my_lib_rust_cdylib",
    srcs = ["MyLib.rs"],
    crate_type = "cdylib",
    edition = "2018",
    deps = ["//third_party/openjdk/rust:jni"],
)

dwtj_java_binary(
    name = "my_lib_java_binary",
    srcs = ["MyLib.java"],
    main_class = "rust.jni.MyLib",
    output_jar = "MyLib.jar",
)

rename_cdylib(
  name = "libmyjni_so",
  src = "my_lib_rust_cdylib",
  out = "libmyjni.so",
)

rename_cdylib(
  name = "libmyjni_dylib",
  src = "my_lib_rust_cdylib",
  out = "libmyjni.dylib",
)

sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = [
        # TODO(dwtj): Consider making this cleaner by only add one of these.
        ":libmyjni_so",
        ":libmyjni_dylib",
        ":MyLib.jar",
    ],
    args = [
        "$(rootpath :libmyjni_so)",
        "$(rootpath :MyLib.jar)",
    ],
)
