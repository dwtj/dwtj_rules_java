'''Defines a repository rule which finds local `java` and `javac` executables on
the system path, symlinks them into the root of the repository, and synthesizes
some boilerplate to wrap these in Java toolchains. If a user uses this rule to
create a repository named `local_openjdk`, then they can register these
toolchains via `@local_openjdk//defs.bzl%register_java_toolchains`.
'''

def _template_label(template_path):
    return Label("@dwtj_rules_java//java:repository_rules/local_openjdk_repository/" + template_path)

def _symlink_which_executable_else_fail(repository_ctx, exec_name, symlink_path):
    exec = repository_ctx.which(exec_name)
    if exec != None:
        repository_ctx.symlink(exec, symlink_path)
    else:
        fail("Could not find a required executable on the system path: `{}`".format(exec_name))

def _local_openjdk_repository_impl(repository_ctx):
    _symlink_which_executable_else_fail(repository_ctx, "java", "jdk/bin/java")
    _symlink_which_executable_else_fail(repository_ctx, "jar", "jdk/bin/jar")
    _symlink_which_executable_else_fail(repository_ctx, "javac", "jdk/bin/javac")
    _symlink_which_executable_else_fail(repository_ctx, "javadoc", "jdk/bin/javadoc")

    repository_ctx.template(
        "jdk/BUILD",
        _template_label("jdk/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name
        },
        executable = False,
    )

    repository_ctx.template(
        "java/BUILD",
        _template_label("java/TEMPLATE.BUILD"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name
        },
        executable = False,
    )

    repository_ctx.template(
        "java/defs.bzl",
        _template_label("java/TEMPLATE.defs.bzl"),
        substitutions = {
            "{REPOSITORY_NAME}": repository_ctx.name
        },
        executable = False,
    )

    # TODO(dwtj): Fix this return value.
    return None

local_openjdk_repository = repository_rule(
    implementation = _local_openjdk_repository_impl,
    local = True,
    environ = [
        # NOTE(dwtj): This rule uses `which` to search the `PATH` for `java`.
        "PATH",
    ],
)
