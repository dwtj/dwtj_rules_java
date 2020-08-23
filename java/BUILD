load("@io_bazel_stardoc//stardoc:stardoc.bzl", "stardoc")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

exports_files([
    "aspects/google_java_format_aspect/TEMPLATE.run_google_java_format.sh",
    "aspects/javadoc_aspect/TEMPLATE.run_javadoc.sh",
    "aspects/error_prone_aspect/TEMPLATE.run_javac_with_error_prone.sh",
    "aspects/checkstyle_aspect/TEMPLATE.run_checkstyle.sh",
    "common/actions/TEMPLATE.compile_and_jar_java_sources.sh",
    "common/actions/TEMPLATE.java_run_script.sh",
])

stardoc(
    name = "defs_md",
    input = "defs.bzl",
    out = "defs.md",
    deps = ["all_bzl"],
)

stardoc(
    name = "providers_md",
    input = "providers.bzl",
    out = "providers.md",
    deps = ["all_bzl"],
)

stardoc(
    name = "aspects_md",
    input = "aspects.bzl",
    out = "aspects.md",
    deps = ["all_bzl"],
)

stardoc(
    name = "repository_rules_md",
    input = "repositories.bzl",
    out = "repository_rules.md",
    deps = ["all_bzl"],
)

stardoc(
    name = "toolchains_md",
    input = "toolchains.bzl",
    out = "toolchains.md",
    deps = [":toolchains_bzl"],
)

bzl_library(
    name = "all_bzl",
    deps = [
        ":rules_bzl",
        ":providers_bzl",
        ":common_bzl",
        ":aspects_bzl",
        ":repository_rules_bzl",
        ":toolchains_bzl",
    ]
)

bzl_library(
    name = "rules_bzl",
    srcs = glob(["rules/*.bzl"])
)

bzl_library(
    name = "providers_bzl",
    srcs = glob(["providers/*.bzl"])
)

bzl_library(
    name = "common_bzl",
    srcs = glob(["common/**/*.bzl"])
)

bzl_library(
    name = "aspects_bzl",
    srcs = glob(["aspects/*/*.bzl"])
)

bzl_library(
    name = "repository_rules_bzl",
    srcs = glob(["repository_rules/*/*.bzl"], exclude = ["**/TEMPLATE*.bzl"])
)

bzl_library(
    name = "toolchains_bzl",
    deps = [
        "//java/toolchains/checkstyle_toolchain:defs_bzl",
        "//java/toolchains/error_prone_toolchain:defs_bzl",
        "//java/toolchains/google_java_format_toolchain:defs_bzl",
        "//java/toolchains/java_compiler_toolchain:defs_bzl",
        "//java/toolchains/java_runtime_toolchain:defs_bzl",
        "//java/toolchains/javadoc_toolchain:defs_bzl",
    ]
)
