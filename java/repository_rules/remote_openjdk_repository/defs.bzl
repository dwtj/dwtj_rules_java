'''This file defines the `remote_openjdk_repository` repository rule. This rule
downloads a remote distribution of OpenJDK and wraps some files of its files in
appropriate Bazel targets. In particular, executables are wrapped in Bazel
toolchains.
'''

def _remote_openjdk_repository_impl(repository_ctx):
    # TODO(dwtj): Add support for `exec_compatible_with` attribute.
    if len(repository_ctx.attr.exec_compatible_with) > 0:
       fail("The `remote_openjdk_repository.exec_compatible_with` attribute is not yet supported.")

    repository_ctx.download_and_extract(
        url = repository_ctx.attr.url,
        sha256 = repository_ctx.attr.sha256,
        stripPrefix = repository_ctx.attr.strip_prefix,
        allow_fail = False,
    )

    repository_ctx.template(
        "BUILD",
        repository_ctx.attr._build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
            "{EXEC_COMPATIBLE_WITH}": "[]"
        },
        executable = False,
    )
    repository_ctx.template(
        "defs.bzl",
        repository_ctx.attr._defs_bzl_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
        },
        executable = False,
    )

    # TODO(dwtj): Consider what should be returned here to help reproducibility.
    return None

remote_openjdk_repository = repository_rule(
    implementation = _remote_openjdk_repository_impl,
    attrs = {
        "url": attr.string(
            mandatory = True,
        ),
        "sha256": attr.string(
            mandatory = True,
        ),
        "strip_prefix": attr.string(
            default = "",
        ),
        "exec_compatible_with": attr.label_list(
            default = list(),
        ),
        "_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_defs_bzl_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/remote_openjdk_repository/TEMPLATE.defs.bzl"),
            allow_single_file = True,
        ),
    }
)
