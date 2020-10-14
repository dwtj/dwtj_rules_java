'''Defines the `local_graalvm_repository` repository rule.
'''

def _template_label(template_path):
    return Label("@dwtj_rules_java//graalvm:repository_rules/local_graalvm_repository/" + template_path)

def _symlink_which_executable_else_fail(repository_ctx, exec_name):
    exec = repository_ctx.which(exec_name)
    if exec != None:
        repository_ctx.symlink(exec, "bin/" + exec_name)
    else:
        fail("Could not find a required executable on the system path: `{}`".format(exec_name))

def _local_graalvm_repository_impl(repository_ctx):
    _symlink_which_executable_else_fail(repository_ctx, "native-image")

    # Make BUILD file in package `//bin` such that we can refer to the
    #  `native-image` executable (symlink) with the label `//bin:native-image`.
    repository_ctx.file(
        "bin/BUILD",
        content = 'exports_files(["native-image"], visibility = ["//visibility:public"])',
        executable = False,
    )

    repository_ctx.template(
        "graalvm/BUILD",
        _template_label("graalvm/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name,
        },
        executable = False,
    )

    repository_ctx.template(
        "graalvm/defs.bzl",
        _template_label("graalvm/TEMPLATE.defs.bzl"),
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
)
