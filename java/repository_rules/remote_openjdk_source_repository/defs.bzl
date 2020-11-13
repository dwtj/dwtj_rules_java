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
def _guess_built_jdk_dist_dir(repository_ctx):
    return "jdk_source_archive/build/{}/images/jdk".format(repository_ctx.attr.build_configuration_name)

def _execute_mv_command(repository_ctx, source, dest):
    res = repository_ctx.execute(["mv", source, dest])
    if res.return_code != 0:
        fail("Move command failed: `mv '{}' '{}'`".format(source, dest))

def _execute_rmdir_command(repository_ctx, dir):
    res = repository_ctx.execute(["rmdir", dir])
    if res.return_code != 0:
        fail("Remove directory failed: `rmdir '{}'`")

def _build_jdk_dist_from_source_archive(repository_ctx):
    configure_cmd = ["bash", "configure"]
    configure_cmd.extend(repository_ctx.attr.configure_args)
    res = repository_ctx.execute(
        configure_cmd,
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

def _remote_openjdk_source_repository_impl(repository_ctx):
    if repository_ctx.os.name != "linux":
        fail("Use of the `remote_openjdk_source_repository` is only supported on linux, but `repository_ctx.os.name` is `{}`".format(repository_ctx.os.name))

    expand_all_standard_openjdk_templates(repository_ctx)

    _execute_mv_command(repository_ctx, "jdk/BUILD", "jdk.BUILD")
    _execute_rmdir_command(repository_ctx, "jdk")

    _download_openjdk_source_archive(repository_ctx)
    _build_jdk_dist_from_source_archive(repository_ctx)

    _execute_mv_command(repository_ctx, _guess_built_jdk_dist_dir(repository_ctx), "jdk")
    _execute_mv_command(repository_ctx, "jdk.BUILD", "jdk/BUILD")

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
        "configure_args": attr.string_list(
            doc = """A list of strings, where each string is passed as an argument to the `configure` script. E.g., `["--with-toolchain-type=clang"]`.""",
            default = [],
        ),
        # TODO(dwtj): Redesign this to help make portable targets. (Currently,
        #  a user should be able to use a `select()` expression.)
        "build_configuration_name": attr.string(
            mandatory = True,
            doc = 'E.g., "linux-x86_64-server-release"',
        ),
        # TODO(dwtj): Consider removing this.
        "os": attr.string(
            values = ["linux"],
            default = "linux",
        ),
        # TODO(dwtj): Consider removing this.
        "cpu": attr.string(
            values = ["x64"],
            default = "x64",
        ),
        "_root_build_file_template": attr.label(
            default = Label("//java/repository_rules/remote_openjdk_source_repository/TEMPLATE.BUILD")
        ),
        "_root_defs_bzl_file_template": attr.label(
            default = Label("//java/repository_rules/remote_openjdk_source_repository/TEMPLATE.defs.bzl")
        ),
    }
)
