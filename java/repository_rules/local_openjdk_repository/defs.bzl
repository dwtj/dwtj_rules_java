'''Defines a repository rule which finds local `java` and `javac` executables on
the system path, symlinks them into the root of the repository, and synthesizes
some boilerplate to wrap these in Java toolchains. If the user has named a
repository `local_openjdk`, then they can register these toolchains via
`@local_openjdk//defs.bzl%register_java_toolchains`.
'''

def _symlink_which_executable_else_fail(repository_ctx, exec_name):
    exec = repository_ctx.which(exec_name)
    if exec != None:
        repository_ctx.symlink(exec, exec_name)
    else:
        fail("Could not find a `java` executable on the system path.")

def _local_openjdk_repository_impl(repository_ctx):
    _symlink_which_executable_else_fail(repository_ctx, "java")
    _symlink_which_executable_else_fail(repository_ctx, "jar")
    _symlink_which_executable_else_fail(repository_ctx, "javac")
    _symlink_which_executable_else_fail(repository_ctx, "javadoc")

    repository_ctx.template(
        "BUILD",
        repository_ctx.attr._build_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name
        },
        executable = False,
    )

    repository_ctx.template(
        "defs.bzl",
        repository_ctx.attr._defs_bzl_file_template,
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name
        },
        executable = False,
    )

    # TODO(dwtj): Fix this return value.
    return None

local_openjdk_repository = repository_rule(
    implementation = _local_openjdk_repository_impl,
    attrs = {
        "_build_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/local_openjdk_repository/TEMPLATE.BUILD"),
            allow_single_file = True,
        ),
        "_defs_bzl_file_template": attr.label(
            default = Label("@dwtj_rules_java//java:repository_rules/local_openjdk_repository/TEMPLATE.defs.bzl"),
            allow_single_file = True,
        ),
    }
    local = True,
    environ = [
        # NOTE(dwtj): This rule uses `which` to search the `PATH` for `java`.
        "PATH",
    ],
)
