load("@rules_java//java:defs.bzl",
    "java_library",
    "java_import",
)

load("@dwtj_rules_java//java:defs.bzl",
    "dwtj_java_library",
    "dwtj_legacy_java_import",
    "dwtj_java_binary",
    "dwtj_java_test",
)

java_library(
    name = "MyLegacyLibrary",
    srcs = ["src/MyLegacyLibrary.java"],
)

dwtj_legacy_java_import(
    name = "MyLegacyLibraryWrapper",
    imports = [":MyLegacyLibrary"],
)

dwtj_java_library(
    name = "MyLibrary",
    srcs = ["src/MyLibrary.java"],
    deps = [":MyLegacyLibraryWrapper"],
)

# A copy of this target's output JAR was manually copied to the `lib` directory.
# This target isn't directly used as a "dep" of any other target. Rather,
# `MyLegacyImport` is used as a dep.
java_library(
    name = "MyJar",
    srcs = ["src/MyJar.java"],
)
java_import(
    name = "MyJarLegacyImport",
    jars = ["lib/libMyJar.jar"],
)

dwtj_legacy_java_import(
    name = "MyJarLegacyImportWrapper",
    imports = [":MyJarLegacyImport"],
)

dwtj_java_binary(
    name = "MyBinary",
    main_class = "MyBinary",
    srcs = ["src/MyBinary.java"],
    deps = [
        ":MyLibrary",
        ":MyLegacyLibraryWrapper",
        ":MyJarLegacyImportWrapper",
    ],
)

dwtj_java_test(
    name = "MyTest",
    main_class = "MyTest",
    srcs = ["src/MyTest.java"],
    deps = [
        ":MyLibrary",
        ":MyLegacyLibraryWrapper",
        ":MyJarLegacyImportWrapper",
    ],
)