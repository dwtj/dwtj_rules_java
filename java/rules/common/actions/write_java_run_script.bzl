'''Defines a function which writes a Java run script.

This function is meant to be used by different kinds of Java rules.
'''

load("@dwtj_rules_java//java:rules/common/actions/write_class_path_arguments_file.bzl", "write_run_time_class_path_arguments_file")

_JAVA_RUNTIME_TOOLCHAIN_TYPE = "@dwtj_rules_java//java/toolchains/java_runtime_toolchain:toolchain_type"

def write_java_run_script(ctx, run_time_jars):
    '''Declares/writes the script to be run when this `ctx`'s target is run.

    Args:
      ctx: The [`ctx`][1] of the Java target for which this function is building
          a run script.
      run_time_jars: A list of `file`s. Each `file` should be a JAR to be
          included on the runtime class path.

    Returns:
      A two-tuple of `file` handles: `(java_run_script, class_path_args_file)`

    NOTE(dwtj): Use of `ctx` here is a bit of a hack. See the
    `build_jar_from_sources` helper function for some notes.

    TODO(dwtj): Consider tidying up this hack.

    [1]: https://docs.bazel.build/versions/3.4.0/skylark/lib/ctx.html
    [2]: https://docs.bazel.build/versions/3.4.0/skylark/lib/File.html
    '''

    toolchain_info = ctx.toolchains[_JAVA_RUNTIME_TOOLCHAIN_TYPE].java_runtime_toolchain_info

    class_path_args_file = write_run_time_class_path_arguments_file(
        name = ctx.attr.name + ".run_time_class_path.args",
        jars = run_time_jars,
        actions = ctx.actions,
        class_path_separator = toolchain_info.class_path_separator,
    )

    java_run_script = ctx.actions.declare_file(ctx.attr.name + ".java_run_script.sh")
    ctx.actions.expand_template(
        template = toolchain_info.java_run_script_template,
        output = java_run_script,
        substitutions = {
            "{JAVA_EXECUTABLE}": toolchain_info.java_executable.short_path,
            "{CLASS_PATH_ARGUMENTS_FILE}": class_path_args_file.short_path,
            "{MAIN_CLASS}": ctx.attr.main_class,
        },
        is_executable = True,
    )

    return java_run_script, class_path_args_file
