'''Defines the `remote_openjdk_source_repository` repository rule.
'''

load("//java:repository_rules/remote_openjdk_repository/defs.bzl", "expand_all_standard_openjdk_templates")

def _download_openjdk_source_archive(repository_ctx):
    repository_ctx.download_and_extract(
        output = "jdk_source_archive",
        url = repository_ctx.attr.url,
        sha256 = repository_ctx.attr.sha256,
        stripPrefix = repository_ctx.attr.strip_prefix,
        allow_fail = False,
    )

# TODO(dwtj): Learn more about JDK builds to make this more robust and general.
def _guess_built_jdk_dist_dir(_repository_ctx):
    return "jdk_source_archive/build/linux-x86_64-server-release/images/jdk"

def _build_jdk_dist_from_source_archive(repository_ctx):
    res = repository_ctx.execute(
        [
            "bash",
            "configure",
        ],
        working_directory = "jdk_source_archive",
        quiet = False,
    )
    if res.return_code != 0:
        fail("The JDK `configure` script failed.")

    res = repository_ctx.execute(
        [
            "make",
            "images",
        ],
        working_directory = "jdk_source_archive",
        quiet = False,
    )
    if res.return_code != 0:
        fail("The JDK build failed.")

    res = repository_ctx.execute(
        [
            "mv",
            _guess_built_jdk_dist_dir(repository_ctx),
            "jdk",
        ],
    )
    if res.return_code != 0:
        fail("Failed to move the JDK build output into place.")

def _remote_openjdk_source_repository_impl(repository_ctx):
    if repository_ctx.os.name != "linux":
        fail("Use of the `remote_openjdk_source_repository` is only supported on linux, but `repository_ctx.os.name` is `{}`".format(repository_ctx.os.name))

    _download_openjdk_source_archive(repository_ctx)
    _build_jdk_dist_from_source_archive(repository_ctx)
    expand_all_standard_openjdk_templates(repository_ctx)

remote_openjdk_source_repository = repository_rule(
    implementation = _remote_openjdk_source_repository_impl,
    attrs = {
        "url": attr.string(
            mandatory = True,
        ),
        "sha256": attr.string(
            mandatory = True,
        ),
        "strip_prefix": attr.string(
            mandatory = True,
        ),
        "_root_build_file_template": attr.label(
            default = Label("//java/repository_rules/remote_openjdk_source_repository/TEMPLATE.BUILD")
        ),
        "_root_defs_bzl_file_template": attr.label(
            default = Label("//java/repository_rules/remote_openjdk_source_repository/TEMPLATE.defs.bzl")
        ),
    }
)
