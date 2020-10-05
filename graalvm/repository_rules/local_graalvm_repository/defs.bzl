'''Defines the `local_graalvm_repository` repository rule.
'''

def _symlink_which_executable_else_fail(repository_ctx, exec_name):
    exec = repository_ctx.which(exec_name)
    if exec != None:
        repository_ctx.symlink(exec, exec_name)
    else:
        fail("Could not find a required executable on the system path: `{}`".format(exec_name))

def _local_graalvm_repository_impl(repository_ctx):
    _symlink_which_executable_else_fail(repository_ctx, "native-image")

    repository_ctx.template(
        "BUILD",
        repository_ctx.attr._build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
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



local_graalvm_repository = repository_rule(
    implementation = _local_graalvm_repository_impl,
    local = True,
    environ = ["PATH"],  # NOTE(dwtj): The `PATH` environment variable is
                         #  searched by `repository_ctx.which() `to find a
                         #  `native-image` executable.
    attrs = {
        "_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//graalvm:repository_rules/local_graalvm_repository/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_defs_bzl_file_template": attr.label(
            default = Label("@dwtj_rules_java//graalvm:repository_rules/local_graalvm_repository/TEMPLATE.defs.bzl"),
            allow_single_file = True,
        ),
    }
)
