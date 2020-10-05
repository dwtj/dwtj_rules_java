# TODO(dwtj): Analyze and document why these templates need to be exported.
exports_files([
    "aspects/google_java_format_aspect/TEMPLATE.run_google_java_format.sh",
    "aspects/javadoc_aspect/TEMPLATE.run_javadoc.sh",
    "aspects/error_prone_aspect/TEMPLATE.run_javac_with_error_prone.sh",
    "aspects/checkstyle_aspect/TEMPLATE.run_checkstyle.sh",
    "common/actions/TEMPLATE.compile_and_jar_java_sources.sh",
    "common/actions/TEMPLATE.java_run_script.sh",
])

exports_files(
    # NOTE(dwtj): We export all `bzl` files in this package so that the website
    #  can wrap these files in `bzl_library` targets and pass them to `stardoc`.
    #  We don't want to declare `bzl_library` targets and `stardoc` targets in
    #  this package, because then all users of these rules would also depend
    #  upon the `bazel-skylib` and `stardoc` external repositories (and thus
    #  need to configure their Bazel workspace to include these dependencies).
    glob([
        "**/*.bzl",
    ]),
    # TODO(dwtj): These files are probably only needed for the website. Can we
    #  make visibility narrower even though the website is in an external
    #  repository?
    visibility = ["//visibility:public"],
)

filegroup(
    name = "all_bzl_files_in_project",
    srcs = glob(["**/*.bzl"], exclude = ["**/TEMPLATE*.bzl"]),
    # TODO(dwtj): These files are probably only needed for the website. Can we
    #  make visibility narrower even though the website is in an external
    #  repository?
    visibility = ["//visibility:public"]
)

# TODO(dwtj): Consider exporting the toolchains for convenient use by the
#  website.
