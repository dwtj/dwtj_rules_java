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

def _guess_os_name(repository_ctx):
    os_map = {
        "linux": "linux",
    }
    os_key = repository_ctx.attr.os
    os = os_map[os_key]
    if os == None:
        fail("Unexpected `os` attribute value: " + os_key)
    return os

def _guess_cpu_arch(repository_ctx):
    if (repository_ctx.attr.cpu == "x64"):
        return "x86_64"
    else:
        fail("Unexpected value for `cpu` attribute.")

def _guess_build_configuration_name(repository_ctx):
    return "{}-{}-{}-{}".format(
        _guess_os_name(repository_ctx),
        _guess_cpu_arch(repository_ctx),
        repository_ctx.attr._jvm_variant,
        repository_ctx.attr._debug_level,
    )

# TODO(dwtj): Learn more about JDK builds to make this more robust and general.
def _guess_built_jdk_dist_dir(repository_ctx):
    return "jdk_source_archive/build/{}/images/jdk".format(
        _guess_build_configuration_name(repository_ctx),
    )

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
    if repository_ctx.attr.quiet_configure:
        configure_cmd.append("--quiet")
    if repository_ctx.attr.disable_warnings_as_errors:
        configure_cmd.append("--disable-warnings-as-errors")
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
        fail("Use of the `remote_openjdk_source_repository` is only supported on Linux hosts, but `repository_ctx.os.name` is `{}`".format(repository_ctx.os.name))

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
        "os": attr.string(
            values = [
                "linux",
                # TODO(dwtj): Consider supporting this too.
                # "macos",
            ],
            default = "linux",
        ),
        "cpu": attr.string(
            values = ["x64"],
            default = "x64",
        ),
        # NOTE(dwtj): This attribute is experimental.
        "_jvm_variant": attr.string(
            values = [
                "server",
                # TODO(dwtj): Consider supporting these:
                # "client",
                # "minimal",
                # "core",
                # "zero",
                # "custom",
            ],
            default = "server",
        ),
        # NOTE(dwtj): This attribute is experimental.
        "_debug_level": attr.string(
            values = [
                "release",
                # TODO(dwtj): Consider supporting these:
                # "fastdebug",
                # "slowdebug",
                # "optimized",
            ],
            default = "release",
        ),
        "disable_warnings_as_errors": attr.bool(
            default = True,
        ),
        "quiet_configure": attr.bool(
            default = True,
        ),
        "_root_build_file_template": attr.label(
            default = Label("//java/repository_rules/remote_openjdk_source_repository/TEMPLATE.BUILD")
        ),
        "_root_defs_bzl_file_template": attr.label(
            default = Label("//java/repository_rules/remote_openjdk_source_repository/TEMPLATE.defs.bzl")
        ),
    }
)
