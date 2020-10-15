'''Defines a function which writes a Java run script.

This function is meant to be used by different kinds of Java rules.
'''

load("//java:providers/JavaAgentInfo.bzl", "JavaAgentInfo")
load("//java:providers/JavaDependencyInfo.bzl", "JavaDependencyInfo")
load("//java:providers/JavaExecutionInfo.bzl", "JavaExecutionInfo")

load("//java:common/actions/write_class_path_args_file.bzl", "write_run_time_class_path_args_file")

load("//java:common/extract/toolchain_info.bzl", "extract_java_runtime_toolchain_info", "extract_java_executable")

def _java_agent_and_options_to_flag(java_agent_and_options):
    '''Convert a 2-tuple to a java flag.

    Args:
      java_agent_and_options: A 2-tuple. First is a target providing a
        `JavaAgentInfo`; second is an options string to be passed to the java
        agent.

    Returns:
      A string of the form `-javaagent:<java_agent_jar>=<options>`.
    '''
    java_agent, options = java_agent_and_options

    return "-javaagent:{}={}".format(
        java_agent[JavaAgentInfo].java_agent_jar.short_path,
        options,
    )

def _java_agents_dict_as_list_of_pairs(java_agents_dict):
    return java_agents_dict.items()

def write_java_run_script_from_ctx(ctx, java_dependency_info):
    '''Unpacks a target `ctx` by convention and calls `write_java_run_script()`.

    Args:
      ctx: The [`ctx`][1] of the Java target for which this function is building
          a run script.
      java_dependency_info: The `JavaDependencyInfo` of *this* target.

    Returns:
      A 4-tuple: (info: JavaExecutionInfo, java_run_script: File, class_path_args_file: File, run_time_jars: depset of File)

    [1]: https://docs.bazel.build/versions/3.4.0/skylark/lib/ctx.html
    '''
    java_runtime_toolchain_info = extract_java_runtime_toolchain_info(ctx)

    java_execution_info = JavaExecutionInfo(
        java_dependency_info = java_dependency_info,
        deps = ctx.attr.deps,
        main_class = ctx.attr.main_class,
        java_agents = _java_agents_dict_as_list_of_pairs(ctx.attr.java_agents),
        java_runtime_toolchain_info = java_runtime_toolchain_info,
        jvm_flags = ctx.attr.jvm_flags,
    )

    run_script, cp_args_file, jvm_flags_args_file, run_time_jars = write_java_run_script(
        java_execution_info,
        ctx.actions,
        ctx.attr.name,
    )

    return java_execution_info, run_script, cp_args_file, jvm_flags_args_file, run_time_jars

def write_java_run_script(java_execution_info, actions, temp_file_prefix):
    '''Declares/writes the script to run Java according to the given argument.

    Args:
      java_execution_info: A `JavaExecutionInfo`.
      actions: The `actions` instance from which actions are emitted.
      temp_file_prefix: A string to prefix to the name of temporary files. This
        is conventionally the name of the target calling this function.

    Returns:
      A 3-tuple: `(java_run_script: File, class_path_args_file: File, run_time_jars: depset of File)`

    [1]: https://docs.bazel.build/versions/3.4.0/skylark/lib/File.html
    '''
    # We include run time jars from three kinds of targets: this target, this
    # target's declared deps, and this target's declared java agents.
    java_dependencies = [d for d in java_execution_info.deps]
    java_dependencies.extend([pair[0] for pair in java_execution_info.java_agents])
    java_dependency_infos = [java_execution_info.java_dependency_info]
    java_dependency_infos.extend([dep[JavaDependencyInfo] for dep in java_dependencies])

    # Merge all of these depsets together into one:
    run_time_jars = depset(
        transitive = [info.run_time_class_path_jars for info in java_dependency_infos],
    )

    # Abbreviate this:
    rt_info = java_execution_info.java_runtime_toolchain_info

    # Create a class path args file:
    class_path_args_file = write_run_time_class_path_args_file(
        name = temp_file_prefix + ".run_time_class_path.args",
        jars = run_time_jars,
        actions = actions,
        class_path_separator = rt_info.class_path_separator,
    )

    # Create a sequence of command line flags to pass to the `java` command:
    jvm_flags = actions.args()
    jvm_flags.add_all(
        java_execution_info.jvm_flags,
    )
    jvm_flags.add_all(
        java_execution_info.java_agents,
        map_each = _java_agent_and_options_to_flag,
    )
    jvm_flags.set_param_file_format("shell")
    jvm_flags_args_file = actions.declare_file(temp_file_prefix + ".jvm_flags.args")
    actions.write(
        output = jvm_flags_args_file,
        content = jvm_flags,
        is_executable = False,
    )

    # TODO(dwtj): Currently, we list a Java agent JAR as part of both a
    #  `-javaagent` argument and as part of the `--class-path`. Figure out if
    #  this can cause problems.
    java_run_script = actions.declare_file(temp_file_prefix + ".java_run_script.sh")
    actions.expand_template(
        template = rt_info.java_run_script_template,
        output = java_run_script,
        substitutions = {
            "{JAVA_EXECUTABLE}": rt_info.java_executable.short_path,
            "{CLASS_PATH_ARGS_FILE}": class_path_args_file.short_path,
            "{JVM_FLAGS_ARGS_FILE}": jvm_flags_args_file.short_path,
            "{MAIN_CLASS}": java_execution_info.main_class,
        },
        is_executable = True,
    )

    return java_run_script, class_path_args_file, jvm_flags_args_file, run_time_jars
