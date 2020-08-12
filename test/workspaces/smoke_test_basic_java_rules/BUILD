load(
    "@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_binary",
    "dwtj_java_import",
    "dwtj_java_library",
    "dwtj_java_test",
)

dwtj_java_binary(
    name = "MyBinary",
    srcs = ["mypkg/MyBinary.java"],
    main_class = "mypkg.MyBinary",
    deps = [
        ":MyImport",
        ":MyLibrary",
    ],
)

dwtj_java_library(
    name = "MyLibrary",
    srcs = ["mypkg/MyLibrary.java"],
)

# A copy of this target's output JAR was manually copied to the `lib` directory.
# This target isn't directly used as a "dep" of any other target. Rather,
# `MyImport` is used as a dep.
dwtj_java_library(
    name = "MyJar",
    srcs = ["mypkg/MyJar.java"],
)

dwtj_java_import(
    name = "MyImport",
    jars = [":lib/MyJar.jar"],
)

dwtj_java_test(
    name = "MyTest",
    srcs = ["mypkg/MyTest.java"],
    main_class = "mypkg.MyTest",
    deps = [":MyLibrary"],
)
